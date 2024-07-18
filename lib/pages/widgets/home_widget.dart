import 'dart:isolate';
import 'dart:io';

import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/script_text_interpretation.dart';
import 'package:basicchessendgamestrainer/pages/script_editor_page.dart';
import 'package:chess/chess.dart' as chess;
import 'package:basicchessendgamestrainer/data/asset_games.dart';
import 'package:basicchessendgamestrainer/models/providers/game_provider.dart';
import 'package:basicchessendgamestrainer/pages/game_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';

class HomeWidget extends ConsumerStatefulWidget {
  const HomeWidget({super.key});

  @override
  ConsumerState<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends ConsumerState<HomeWidget> {
  Isolate? _positionGenerationIsolate;
  bool _isBusy = false;

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

  Future<InitialScriptsSet> _getInitialScriptSetFor(File file) async {
    final script = await file.readAsString();
    return _getInitialScriptSetFromScriptString(script);
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
        translations: TranslationsWrapper(
          miscErrorDialogTitle: t.script_parser.misc_error_dialog_title,
          missingScriptType: t.script_parser.missing_script_type,
          miscParseError: t.script_parser.misc_parse_error,
          maxGenerationAttemptsAchieved:
              t.home.max_generation_attempts_achieved,
          failedGeneratingPosition: t.home.failed_generating_position,
          unrecognizedSymbol: t.script_parser.unrecognized_symbol,
          typeError: t.script_parser.type_error,
          noAntlr4Token: t.script_parser.no_antlr4_token,
          eof: t.script_parser.eof,
          variableNotAffected: t.script_parser.variable_not_affected,
          overridingPredefinedVariable:
              t.script_parser.overriding_predefined_variable,
          parseErrorDialogTitle: t.script_parser.parse_error_dialog_title,
          noViableAltException: t.script_parser.no_viable_alt_exception,
          inputMismatch: t.script_parser.input_mismatch,
          playerKingConstraint: t.script_type.player_king_constraint,
          computerKingConstraint: t.script_type.computer_king_constraint,
          kingsMutualConstraint: t.script_type.kings_mutual_constraint,
          otherPiecesCountConstraint: t.script_type.piece_kind_count_constraint,
          otherPiecesGlobalConstraint:
              t.script_type.other_pieces_global_constraint,
          otherPiecesIndexedConstraint:
              t.script_type.other_pieces_indexed_constraint,
          otherPiecesMutualConstraint:
              t.script_type.other_pieces_mutual_constraint,
          unrecognizedScriptType: t.script_parser.unrecognized_script_type,
        ),
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
            currentDirectory: null,
          );
        },
      ),
    );
  }

  void _doStartCustomExercice() {}

  void _purposeLoadSample() async {
    setState(() {
      _isBusy = true;
    });
    final games = getAssetGames(context);

    final fontSize = Platform.isAndroid ? 14.0 : 25.0;
    final iconSize = Platform.isAndroid ? 18.0 : 30.0;

    final dialogChoicesWidget = <Widget>[];
    for (final currentGame in games) {
      final widget = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 2.0),
            child: SvgPicture.asset(
              currentGame.hasWinningGoal
                  ? 'assets/images/trophy.svg'
                  : 'assets/images/handshake.svg',
              fit: BoxFit.cover,
              width: iconSize,
              height: iconSize,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4.0, left: 2.0),
            child: Text(
              currentGame.label,
              style: TextStyle(fontSize: fontSize),
            ),
          ),
        ],
      );
      dialogChoicesWidget.add(widget);
    }

    final titleDialog = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            t.home.goal_label,
            style: TextStyle(fontSize: fontSize),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 1.0, left: 8.0),
          child: SvgPicture.asset(
            'assets/images/trophy.svg',
            fit: BoxFit.cover,
            width: iconSize,
            height: iconSize,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            t.home.win_label,
            style: TextStyle(fontSize: fontSize),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 1.0),
          child: SvgPicture.asset(
            'assets/images/handshake.svg',
            fit: BoxFit.cover,
            width: iconSize,
            height: iconSize,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: Text(
            t.home.draw_label,
            style: TextStyle(fontSize: fontSize),
          ),
        ),
      ],
    );

    setState(() {
      _isBusy = false;
    });

    await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: titleDialog,
            content: SingleChildScrollView(
              child: Column(
                children: dialogChoicesWidget,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  t.misc.button_cancel,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _doStartCustomExercice();
                },
                child: Text(
                  t.misc.button_ok,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          );
        });
  }

  void _purposeLoadScript() {}

  void _openNewScriptEditor() {}

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
                        onPressed: _openNewScriptEditor,
                        child: Text(t.home.menu_buttons.new_script)),
                  ],
                ),
              ));
  }
}
