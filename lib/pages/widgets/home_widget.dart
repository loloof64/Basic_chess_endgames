import 'dart:async';
import 'dart:isolate';
import 'dart:io';

import 'package:basicchessendgamestrainer/commons.dart';
import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/script_text_interpretation.dart';
import 'package:basicchessendgamestrainer/models/isolate_intermediate_message.dart';
import 'package:basicchessendgamestrainer/pages/script_editor_page.dart';
import 'package:basicchessendgamestrainer/pages/sample_game_chooser_page.dart';
import 'package:basicchessendgamestrainer/pages/widgets/random_testing_parameters_dialog.dart';
import 'package:basicchessendgamestrainer/pages/random_testing_page.dart';
import 'package:chess/chess.dart' as chess;
import 'package:basicchessendgamestrainer/data/asset_games.dart';
import 'package:basicchessendgamestrainer/models/providers/game_session_provider.dart';
import 'package:basicchessendgamestrainer/pages/game_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import 'package:open_save_file_dialogs/open_save_file_dialogs.dart';
import 'package:file_picker/file_picker.dart';

final _openSaveFileDialogsPlugin = OpenSaveFileDialogs();

class HomeWidget extends HookConsumerWidget {
  const HomeWidget({super.key});

  void initState() {
    FlutterNativeSplash.remove();
  }

  void dispose({
    required ValueNotifier<Isolate?> positionGenerationIsolate,
  }) {
    positionGenerationIsolate.value?.kill(
      priority: Isolate.immediate,
    );
  }

  Future<InitialScriptsSet> _getInitialScriptSetFor(
      String wholeScriptContent) async {
    return _getInitialScriptSetFromScriptString(wholeScriptContent);
  }

  Future<InitialScriptsSet> _getInitialScriptSetFromAssetScript(
      String assetPath) async {
    final gameScript = await rootBundle.loadString(assetPath);
    return _getInitialScriptSetFromScriptString(gameScript);
  }

  InitialScriptsSet _getInitialScriptSetFromScriptString(String script) {
    String playerKingConstraint = "";
    String computerKingConstraint = "";
    String kingsMutualConstraint = "";
    String otherPiecesCount = "";
    String otherPiecesGlobalConstaints = "";
    String otherPiecesMutualConstaints = "";
    String otherPiecesIndexedConstaints = "";
    bool winningGoal = true;

    final parts = script.trim().split(scriptsSeparator);
    for (final currentScript in parts) {
      final lines = currentScript.trim().split('\n');
      final typeString = lines.first.trim();
      final lastLine = lines.last;
      final content = lines.sublist(1).join('\n');

      switch (typeString) {
        case '# player king constraints':
          playerKingConstraint = content;
          break;
        case '# computer king constraints':
          computerKingConstraint = content;
          break;
        case '# kings mutual constraints':
          kingsMutualConstraint = content;
          break;
        case '# other pieces counts':
          otherPiecesCount = content;
          break;
        case '# other pieces global constraints':
          otherPiecesGlobalConstaints = content;
          break;
        case '# other pieces mutual constraints':
          otherPiecesMutualConstaints = content;
          break;
        case '# other pieces indexed constraints':
          otherPiecesIndexedConstaints = content;
          break;
        case '# goal':
          winningGoal = (lastLine == winningString);
          break;
      }
    }
    return InitialScriptsSet(
      playerKingConstraints: playerKingConstraint,
      computerKingConstraints: computerKingConstraint,
      kingsMutualConstraints: kingsMutualConstraint,
      otherPiecesCountConstraints: otherPiecesCount,
      otherPiecesGlobalConstaints: otherPiecesGlobalConstaints,
      otherPiecesMutualConstaints: otherPiecesMutualConstaints,
      otherPiecesIndexedConstaints: otherPiecesIndexedConstaints,
      winningGoal: winningGoal,
    );
  }

  Future<void> _tryGeneratingAndPlayingPositionFromSample({
    required AssetGame game,
    required ValueNotifier<bool> isBusy,
    required ValueNotifier<Isolate?> positionGenerationIsolate,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final assetPath = game.assetPath;
    final gameScript = await rootBundle.loadString(assetPath);
    if (!context.mounted) return;

    await _tryGeneratingAndPlayingPositionFromString(
      ref: ref,
      script: gameScript,
      context: context,
      isBusy: isBusy,
      positionGenerationIsolate: positionGenerationIsolate,
    );
  }

  Future<void> _tryGeneratingAndPlayingPositionFromString({
    required String script,
    required BuildContext context,
    required WidgetRef ref,
    required ValueNotifier<bool> isBusy,
    required ValueNotifier<Isolate?> positionGenerationIsolate,
  }) async {
    final newPositionGenerationStream = await _tryGeneratingPositionsFromScript(
      script: script,
      positionsCount: 1,
      addIntermediatesPositions: IntermediatePositionsLevel.none,
      context: context,
      isBusy: isBusy,
      positionGenerationIsolate: positionGenerationIsolate,
    );
    final goalString = script.trim().split("\n").last;
    final gameGoal = goalString == winningString ? Goal.win : Goal.draw;
    newPositionGenerationStream.onData((message) async {
      if (message is GenerationResultReady) {
        isBusy.value = false;
        newPositionGenerationStream.cancel();
        final (generatedPositions, rejectedFinalizedPositions, errorsList) =
            message;
        final noError = errorsList.isEmpty && generatedPositions.isNotEmpty;
        if (noError) {
          final newPosition = generatedPositions.first;
          if (!context.mounted) return;
          _tryPlayingGeneratedPosition(
            position: newPosition,
            goal: gameGoal,
            context: context,
            ref: ref,
          );
        } else {
          final errors = errorsList
              .map(
                (e) => PositionGenerationError.fromJson(e),
              )
              .toList();

          if (!context.mounted) return;
          showGenerationErrorsPopup(
            errors: errors,
            context: context,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                t.home.failed_generating_position,
              ),
            ),
          );
        }
      } else if (message is CreateGeneratorIsolate) {
        positionGenerationIsolate.value = await Isolate.spawn(
            message.generatePosition, message.generationParameters);
      } else if (message is ExitBusyStatus) {
        isBusy.value = false;
      } else if (message is KillPositionGeneratorIsolate) {
        positionGenerationIsolate.value?.kill(
          priority: Isolate.immediate,
        );
      }
    });
  }

  Future<StreamSubscription<dynamic>> _tryGeneratingPositionsFromScript({
    required String script,
    required int positionsCount,
    required IntermediatePositionsLevel addIntermediatesPositions,
    required BuildContext context,
    required ValueNotifier<bool> isBusy,
    required ValueNotifier<Isolate?> positionGenerationIsolate,
  }) async {
    final receivePort = ReceivePort();

    receivePort.sendPort.send(ExitBusyStatus());

    receivePort.sendPort.send(CreateGeneratorIsolate(
      generatePosition: generatePositionsFromScript,
      generationParameters: SampleScriptGenerationParameters(
        gameScript: script,
        translations: getTranslations(context),
        sendPort: receivePort.sendPort,
        positionsCount: positionsCount,
        addIntermediatesPositions: addIntermediatesPositions,
      ),
    ));

    receivePort.handleError((error) async {
      isBusy.value = false;
      Logger().e(error);
      receivePort.close();
      positionGenerationIsolate.value?.kill(
        priority: Isolate.immediate,
      );

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                t.home.misc_generating_error,
              ),
            );
          });
    });

    return receivePort.listen((message) async {
      if (message is CreateGeneratorIsolate) {
        positionGenerationIsolate.value = await Isolate.spawn(
            message.generatePosition, message.generationParameters);
      }
      if (message is ExitBusyStatus) {
        isBusy.value = false;
      } else if (message is KillPositionGeneratorIsolate) {
        positionGenerationIsolate.value?.kill(
          priority: Isolate.immediate,
        );
      } else if (message is GenerationResultReady) {
        final (newPositions, rejectedPositions, errorsJson) = message;

        if (newPositions.isEmpty) {
          receivePort.close();
          final errors = errorsJson
              .map(
                (e) => PositionGenerationError.fromJson(e),
              )
              .toList();
          if (!context.mounted) return;
          await showGenerationErrorsPopup(
            errors: errors,
            context: context,
          );
          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                t.home.failed_generating_position,
              ),
            ),
          );
        } else {
          receivePort.sendPort.send((newPositions, rejectedPositions, []));
          receivePort.close();
        }
      }
    });
  }

  void _tryPlayingGeneratedPosition({
    required String position,
    required Goal goal,
    required BuildContext context,
    required WidgetRef ref,
  }) {
    final validPositionStatus = chess.Chess.validate_fen(position);
    if (!validPositionStatus['valid']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            t.home.failed_loading_exercise,
          ),
        ),
      );
      return;
    }

    final playerHasWhite = position.split(' ')[1] != 'b';

    final gameNotifier = ref.read(gameSessionProvider.notifier);
    gameNotifier.updateStartPosition(position);
    gameNotifier.updateGoal(goal);
    gameNotifier.updatePlayerHasWhite(playerHasWhite);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx2) {
        return const GamePage();
      }),
    );
  }

  void _readSampleCodeInEditor({
    required AssetGame game,
    required BuildContext context,
  }) async {
    final assetPath = game.assetPath;
    final initialScriptsSet =
        await _getInitialScriptSetFromAssetScript(assetPath);
    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ScriptEditorPage(
            readOnly: true,
            originalFileName: null,
            initialScriptsSet: initialScriptsSet,
          );
        },
      ),
    );
  }

  void _purposeLoadSample({
    required BuildContext context,
    required WidgetRef ref,
    required ValueNotifier<bool> isBusy,
    required ValueNotifier<Isolate?> positionGenerationIsolate,
  }) async {
    final selectedSample = await Navigator.push<AssetGame?>(
      context,
      MaterialPageRoute(
        builder: (ctx) {
          return const SampleGameChooserPage();
        },
      ),
    );
    if (selectedSample == null) return;

    try {
      if (!context.mounted) return;
      _tryGeneratingAndPlayingPositionFromSample(
        context: context,
        game: selectedSample,
        isBusy: isBusy,
        positionGenerationIsolate: positionGenerationIsolate,
        ref: ref,
      );
    } on Exception catch (ex) {
      debugPrint(ex.toString());
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            t.home.failed_loading_exercise,
          ),
        ),
      );
    }
  }

  void _purposeLoadScript({
    required BuildContext context,
    required WidgetRef ref,
    required ValueNotifier<bool> isBusy,
    required ValueNotifier<Isolate?> positionGenerationIsolate,
  }) async {
    String? script = await _getScriptFromUser(
      context: context,
    );
    if (script == null) return;

    if (!context.mounted) return;
    await _tryGeneratingAndPlayingPositionFromString(
      context: context,
      script: script,
      ref: ref,
      isBusy: isBusy,
      positionGenerationIsolate: positionGenerationIsolate,
    );
  }

  Future<String?> _getScriptFromUser({
    required BuildContext context,
  }) async {
    String script;

    if (Platform.isAndroid) {
      final loadedScript = await _openSaveFileDialogsPlugin.openFileDialog();
      if (loadedScript == null) {
        debugPrint("File loading cancellation.");
        return null;
      }
      script = loadedScript;
    } else {
      final loadedPath = await FilePicker.platform.pickFiles(
        dialogTitle: t.pickers.open_script_title,
        allowMultiple: false,
      );
      if (loadedPath == null) {
        debugPrint("File loading cancellation.");
        return null;
      }

      try {
        File file = File(loadedPath.files.single.path!);
        script = await file.readAsString();
      } on FileSystemException {
        if (!context.mounted) return null;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              t.home.failed_loading_exercise,
            ),
          ),
        );
        return null;
      }
    }

    return Future.value(script);
  }

  void _purposeEditScript({
    required BuildContext context,
  }) async {
    String? script = await _getScriptFromUser(context: context);
    if (script == null) return;

    final initialScriptSet = await _getInitialScriptSetFor(script);
    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return ScriptEditorPage(
            initialScriptsSet: initialScriptSet,
          );
        },
      ),
    );
  }

  void _openNewScriptEditor(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return const ScriptEditorPage(
            initialScriptsSet: InitialScriptsSet.empty(),
          );
        },
      ),
    );
  }

  void _purposeShowSampleCode({
    required BuildContext context,
  }) async {
    final selectedSample = await Navigator.push<AssetGame?>(
      context,
      MaterialPageRoute(
        builder: (ctx) {
          return const SampleGameChooserPage();
        },
      ),
    );
    if (selectedSample == null) return;

    if (!context.mounted) return;
    _readSampleCodeInEditor(game: selectedSample, context: context);
  }

  void _purposeCloneSampleCode(BuildContext context) async {
    final selectedSample = await Navigator.push<AssetGame?>(
      context,
      MaterialPageRoute(
        builder: (ctx) {
          return const SampleGameChooserPage();
        },
      ),
    );
    if (selectedSample == null) return;

    final gameScript = await rootBundle.loadString(selectedSample.assetPath);
    if (Platform.isAndroid) {
      final savedScript =
          await _openSaveFileDialogsPlugin.saveFileDialog(content: gameScript);
      if (!context.mounted) return;
      if (savedScript == null) {
        debugPrint("File saving cancellation.");
        return;
      }
    } else {
      final savedPath = await FilePicker.platform.saveFile(
        dialogTitle: t.pickers.save_file_title,
      );
      if (!context.mounted) return;
      if (savedPath == null) {
        debugPrint("File saving cancellation.");
        return;
      }

      try {
        File file = File(savedPath);
        await file.writeAsString(gameScript);
      } on FileSystemException {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              t.home.failed_saving_exercise,
            ),
          ),
        );
        return;
      }
    }

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          t.home.success_saving_exercice,
        ),
      ),
    );
  }

  Future<void> _generateRandomTesting({
    required BuildContext context,
    required ValueNotifier<bool> isBusy,
    required ValueNotifier<Isolate?> positionGenerationIsolate,
  }) async {
    String? script = await _getScriptFromUser(context: context);
    if (script == null) return;

    if (!context.mounted) return;
    final parameters = await showDialog<RandomTestingParameters>(
        context: context,
        builder: (context) {
          return RandomTestingParametersDialog();
        });

    if (parameters == null) return;

    if (!context.mounted) return;

    final newPositionsGenerationStream =
        await _tryGeneratingPositionsFromScript(
      script: script,
      positionsCount: parameters.imagesCount,
      addIntermediatesPositions: parameters.intermediatePositionsLevel,
      context: context,
      isBusy: isBusy,
      positionGenerationIsolate: positionGenerationIsolate,
    );
    newPositionsGenerationStream.onData((message) async {
      if (message is ExitBusyStatus) {
        isBusy.value = false;
      } else if (message is KillPositionGeneratorIsolate) {
        positionGenerationIsolate.value?.kill(priority: Isolate.immediate);
      } else if (message is CreateGeneratorIsolate) {
        positionGenerationIsolate.value = await Isolate.spawn(
          message.generatePosition,
          message.generationParameters,
        );
      } else if (message is GenerationResultReady) {
        newPositionsGenerationStream.cancel();

        final (newPositions, rejectedFinalizedPositions, errorsList) = message;
        final noError = errorsList.isEmpty && newPositions.isNotEmpty;

        if (!context.mounted) return;
        if (noError) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return RandomTestingPage(
                  generatedPositions: newPositions,
                  rejectedFinalizedPositions: rejectedFinalizedPositions,
                );
              },
            ),
          );
        } else if (rejectedFinalizedPositions.isNotEmpty) {
          if (!context.mounted) return;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return RandomTestingPage(
                  generatedPositions: [],
                  rejectedFinalizedPositions: rejectedFinalizedPositions,
                );
              },
            ),
          );
        } else {
          final errors = errorsList
              .map(
                (e) => PositionGenerationError.fromJson(e),
              )
              .toList();

          if (!context.mounted) return;
          showGenerationErrorsPopup(
            errors: errors,
            context: context,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                t.home.failed_generating_position,
              ),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBusy = useState(false);
    final positionGenerationIsolate = useState<Isolate?>(null);

    useEffect(() {
      initState();
      return null;
    });

    final progressBarSize = MediaQuery.of(context).size.shortestSide * 0.80;
    const fontSize = 10.0;
    final buttons = [
      ElevatedButton(
        onPressed: () => _purposeLoadSample(
          context: context,
          isBusy: isBusy,
          positionGenerationIsolate: positionGenerationIsolate,
          ref: ref,
        ),
        child: Text(
          t.home.menu_buttons.samples,
          style: const TextStyle(fontSize: fontSize),
        ),
      ),
      ElevatedButton(
        onPressed: () => _purposeShowSampleCode(context: context),
        child: Text(
          t.home.menu_buttons.show_sample_code,
          style: const TextStyle(fontSize: fontSize),
        ),
      ),
      ElevatedButton(
        onPressed: () => _purposeCloneSampleCode(context),
        child: Text(
          t.home.menu_buttons.clone_sample,
          style: const TextStyle(fontSize: fontSize),
        ),
      ),
      ElevatedButton(
        onPressed: () => _purposeLoadScript(
          context: context,
          isBusy: isBusy,
          ref: ref,
          positionGenerationIsolate: positionGenerationIsolate,
        ),
        child: Text(
          t.home.menu_buttons.load_script,
          style: const TextStyle(fontSize: fontSize),
        ),
      ),
      ElevatedButton(
        onPressed: () => _purposeEditScript(context: context),
        child: Text(
          t.home.menu_buttons.edit_script,
          style: const TextStyle(fontSize: fontSize),
        ),
      ),
      ElevatedButton(
        onPressed: () => _openNewScriptEditor(context),
        child: Text(
          t.home.menu_buttons.new_script,
          style: const TextStyle(fontSize: fontSize),
        ),
      ),
      ElevatedButton(
        onPressed: () => _generateRandomTesting(
          context: context,
          isBusy: isBusy,
          positionGenerationIsolate: positionGenerationIsolate,
        ),
        child: Text(
          t.home.menu_buttons.generate_random_testing,
          style: const TextStyle(fontSize: fontSize),
        ),
      ),
    ];
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        dispose(positionGenerationIsolate: positionGenerationIsolate);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(t.home.title),
        ),
        body: isBusy.value
            ? Center(
                child: SizedBox(
                  width: progressBarSize,
                  height: progressBarSize,
                  child: const CircularProgressIndicator(),
                ),
              )
            : Center(
                child: ListView(
                  shrinkWrap: false,
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    for (final currentButton in buttons)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: SizedBox(
                            width: 220.0,
                            height: 50.0,
                            child: currentButton,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
