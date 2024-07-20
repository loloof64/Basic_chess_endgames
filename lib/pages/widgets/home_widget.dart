import 'dart:isolate';
import 'dart:io';

import 'package:basicchessendgamestrainer/commons.dart';
import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/script_text_interpretation.dart';
import 'package:basicchessendgamestrainer/pages/script_editor_page.dart';
import 'package:basicchessendgamestrainer/pages/widgets/sample_game_chooser.dart';
import 'package:chess/chess.dart' as chess;
import 'package:basicchessendgamestrainer/data/asset_games.dart';
import 'package:basicchessendgamestrainer/models/providers/game_provider.dart';
import 'package:basicchessendgamestrainer/pages/game_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:logger/logger.dart';

import 'package:open_save_file_dialogs/open_save_file_dialogs.dart';
import 'package:file_picker/file_picker.dart';

final _openSaveFileDialogsPlugin = OpenSaveFileDialogs();

class HomeWidget extends ConsumerStatefulWidget {
  const HomeWidget({super.key});

  @override
  ConsumerState<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends ConsumerState<HomeWidget> {
  Isolate? _positionGenerationIsolate;
  bool _isBusy = false;
  AssetGame? _selectedSample;

  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  void dispose() {
    _positionGenerationIsolate?.kill(
      priority: Isolate.immediate,
    );
    super.dispose();
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

  Future<void> _tryGeneratingAndPlayingPositionFromSample(
      AssetGame game) async {
    final assetPath = game.assetPath;
    final gameScript = await rootBundle.loadString(assetPath);
    await _tryGeneratingAndPlayingPositionFromString(gameScript);
  }

  Future<void> _tryGeneratingAndPlayingPositionFromString(String script) async {
    final receivePort = ReceivePort();

    if (!mounted) return;

    setState(() {
      _isBusy = true;
    });

    _positionGenerationIsolate = await Isolate.spawn(
      generatePositionFromScript,
      SampleScriptGenerationParameters(
        inGameMode: true,
        gameScript: script,
        translations: getTranslations(context),
        sendPort: receivePort.sendPort,
      ),
    );
    setState(() {});

    receivePort.handleError((error) async {
      Logger().e(error);
      receivePort.close();
      _positionGenerationIsolate?.kill(
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

      setState(() {
        _isBusy = false;
      });
    });

    receivePort.listen((message) async {
      receivePort.close();
      _positionGenerationIsolate?.kill(
        priority: Isolate.immediate,
      );

      setState(() {
        _isBusy = false;
      });

      final (newPosition, errors) =
          message as (String?, List<PositionGenerationError>);

      if (newPosition == null) {
        await showGenerationErrorsPopups(errors: errors, context: context);
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              t.home.failed_generating_position,
            ),
          ),
        );
      } else {
        final goalString = script.trim().split("\n").last;
        final gameGoal = goalString == winningString ? Goal.win : Goal.draw;
        _tryPlayingGeneratedPosition(newPosition, gameGoal);
      }
    });
  }

  void _loadExerciseScript({required File itemFile}) async {
    final script = await itemFile.readAsString();
    _tryGeneratingAndPlayingPositionFromString(script);
  }

  void _tryPlayingGeneratedPosition(String position, Goal goal) {
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

    final gameNotifier = ref.read(gameProvider.notifier);
    gameNotifier.updateStartPosition(position);
    gameNotifier.updateGoal(goal);
    gameNotifier.updatePlayerHasWhite(playerHasWhite);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx2) {
        return const GamePage();
      }),
    );
  }

  void _readSampleCodeInEditor(AssetGame game) async {
    final assetPath = game.assetPath;
    final initialScriptsSet =
        await _getInitialScriptSetFromAssetScript(assetPath);
    if (!mounted) return;
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

  void _doStartCustomExercice() {
    if (_selectedSample == null) return;
    try {
      _tryGeneratingAndPlayingPositionFromSample(_selectedSample!);
    } on Exception catch (ex) {
      debugPrint(ex.toString());
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.home.failed_loading_exercise)));
    }
  }

  void _purposeLoadSample() async {
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
      _tryGeneratingAndPlayingPositionFromSample(selectedSample);
    } on Exception catch (ex) {
      debugPrint(ex.toString());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            t.home.failed_loading_exercise,
          ),
        ),
      );
    }
  }

  void _purposeLoadScript() {}

  void _purposeEditScript() async {
    String script;

    if (Platform.isAndroid) {
      final loadedScript = await _openSaveFileDialogsPlugin.openFileDialog();
      if (!mounted) return;
      if (loadedScript == null) {
        debugPrint("File loading cancellation.");
        return;
      }
      script = loadedScript;
    } else {
      final loadedPath = await FilePicker.platform.pickFiles(
        dialogTitle: t.pickers.open_script_title,
        allowMultiple: false,
      );
      if (!mounted) return;
      if (loadedPath == null) {
        debugPrint("File loading cancellation.");
        return;
      }

      try {
        File file = File(loadedPath.files.single.path!);
        script = await file.readAsString();
      } on FileSystemException {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              t.home.failed_loading_exercise,
            ),
          ),
        );
        return;
      }
    }

    final initialScriptSet = await _getInitialScriptSetFor(script);
    if (!mounted) return;
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

  void _openNewScriptEditor() {
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

  @override
  Widget build(BuildContext context) {
    final progressBarSize = MediaQuery.of(context).size.shortestSide * 0.80;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(t.home.title),
        ),
        body: _isBusy
            ? Center(
                child: SizedBox(
                  width: progressBarSize,
                  height: progressBarSize,
                  child: const CircularProgressIndicator(),
                ),
              )
            : Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: _purposeLoadSample,
                        child: Text(t.home.menu_buttons.samples)),
                    ElevatedButton(
                        onPressed: _purposeLoadScript,
                        child: Text(t.home.menu_buttons.load_script)),
                    ElevatedButton(
                        onPressed: _purposeEditScript,
                        child: Text(t.home.menu_buttons.edit_script)),
                    ElevatedButton(
                        onPressed: _openNewScriptEditor,
                        child: Text(t.home.menu_buttons.new_script)),
                  ],
                ),
              ));
  }
}
