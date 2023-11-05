import 'dart:isolate';
import 'dart:io';

import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/script_text_interpretation.dart';
import 'package:basicchessendgamestrainer/pages/script_editor_page.dart';
import 'package:chess/chess.dart' as chess;
import 'package:basicchessendgamestrainer/components/rgpd_modal_bottom_sheet_content.dart';
import 'package:basicchessendgamestrainer/data/asset_games.dart';
import 'package:basicchessendgamestrainer/models/providers/game_provider.dart';
import 'package:basicchessendgamestrainer/pages/game_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:developer' as developer;

const mainListItemsGap = 8.0;
const leadingImagesSize = 60.0;
const titlesFontSize = 26.0;
const rgpdWarningHeight = 200.0;
const folderItemIconSize = 45.0;
const folderItemTextSize = 20.0;

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Isolate? _positionGenerationIsolate;
  bool _isGeneratingPosition = false;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    FlutterNativeSplash.remove();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showRgpdWarning());
    super.initState();
  }

  @override
  void dispose() {
    _positionGenerationIsolate?.kill(
      priority: Isolate.immediate,
    );
    super.dispose();
  }

  void _showHomePageHelpDialog() {
    showDialog(
        context: context,
        builder: (ctx2) {
          return AlertDialog(
            content: Text(t.home.help_message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx2).pop(),
                child: Text(t.misc.button_ok),
              ),
            ],
          );
        });
  }

  void _showRgpdWarning() {
    showModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        context: context,
        builder: (ctx2) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: RgpdModalBottomSheetContent(
                context: ctx2,
                height: rgpdWarningHeight,
              ),
            ),
          );
        });
  }

  Future<void> _tryGeneratingAndPlayingPositionFromSample(
      AssetGame game) async {
    final gameScript = await rootBundle.loadString(game.assetPath);
    final receivePort = ReceivePort();

    if (!mounted) return;

    setState(() {
      _isGeneratingPosition = true;
    });

    _positionGenerationIsolate = await Isolate.spawn(
      generatePositionFromScript,
      SampleScriptGenerationParameters(
        gameScript: gameScript,
        translations: TranslationsWrapper(
          miscErrorDialogTitle: t.script_parser.misc_error_dialog_title,
          missingScriptType: t.script_parser.missing_script_type,
          miscParseError: t.script_parser.misc_parse_error,
          maxGenerationAttemptsAchieved: t.home.max_generation_attempts_achieved,
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
        _isGeneratingPosition = false;
      });
    });

    receivePort.listen((message) async {
      receivePort.close();
      _positionGenerationIsolate?.kill(
        priority: Isolate.immediate,
      );

      setState(() {
        _isGeneratingPosition = false;
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
        _tryPlayingGeneratedPosition(newPosition, game.goal);
      }
    });
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

  @override
  Widget build(BuildContext context) {
    final sampleGames = getAssetGames(context);
    final progressBarSize = MediaQuery.of(context).size.shortestSide * 0.80;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(t.home.title),
          actions: [
            IconButton(
              onPressed: _showHomePageHelpDialog,
              icon: const Icon(
                Icons.question_mark_rounded,
              ),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                icon: const FaIcon(FontAwesomeIcons.gifts),
                text: t.home.tab_integrated,
              ),
              Tab(
                icon: const FaIcon(FontAwesomeIcons.compassDrafting),
                text: t.home.tab_added,
              ),
            ],
            onTap: (index) => setState(() {
              _selectedTabIndex = index;
            }),
          ),
        ),
        body: Stack(
          children: <Widget>[
            TabBarView(
              children: [
                IntegratedExercisesWidget(
                  games: sampleGames,
                  onGameSelected: _tryGeneratingAndPlayingPositionFromSample,
                ),
                const AddedExercisesWidget(),
              ],
            ),
            if (_isGeneratingPosition)
              Center(
                child: SizedBox(
                  width: progressBarSize,
                  height: progressBarSize,
                  child: const CircularProgressIndicator(),
                ),
              ),
          ],
        ),
        floatingActionButton: _selectedTabIndex == 1
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const ScriptEditorPage();
                      },
                    ),
                  );
                },
                child: const FaIcon(FontAwesomeIcons.plus),
              )
            : null,
      ),
    );
  }
}

class IntegratedExercisesWidget extends StatelessWidget {
  final List<AssetGame> games;
  final void Function(AssetGame game) onGameSelected;

  const IntegratedExercisesWidget({
    super.key,
    required this.games,
    required this.onGameSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(
          height: mainListItemsGap,
        ),
        Expanded(
          child: ListView.builder(
              itemCount: games.length,
              itemBuilder: (ctx2, index) {
                final game = games[index];

                final leadingImage = game.goal == Goal.draw
                    ? SvgPicture.asset(
                        'assets/images/handshake.svg',
                        fit: BoxFit.cover,
                        width: leadingImagesSize,
                        height: leadingImagesSize,
                      )
                    : SvgPicture.asset(
                        'assets/images/trophy.svg',
                        fit: BoxFit.cover,
                        width: leadingImagesSize,
                        height: leadingImagesSize,
                      );

                final title = Text(
                  game.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: titlesFontSize,
                  ),
                );

                return ListTile(
                  leading: leadingImage,
                  title: title,
                  onTap: () => onGameSelected(game),
                );
              }),
        ),
      ],
    );
  }
}

class AddedExercisesWidget extends StatefulWidget {
  const AddedExercisesWidget({super.key});

  @override
  State<AddedExercisesWidget> createState() => _AddedExercisesWidgetState();
}

class _AddedExercisesWidgetState extends State<AddedExercisesWidget> {
  final Future<Directory?> _currentDirectoryFuture =
      getApplicationDocumentsDirectory();

  Future<List<FileSystemEntity>?> _getDirectoryElementsList(
      Directory? directory) async {
    final elements = directory?.list(recursive: false);
    return await elements?.toList();
  }

  @override
  Widget build(BuildContext context) {
    final failedLoadingExerciseWidget = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const FaIcon(
          FontAwesomeIcons.xmark,
          color: Colors.red,
          size: 100.0,
        ),
        Text(t.home.failed_loading_added_exercises),
      ],
    );

    const waitingWidget = Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: CircularProgressIndicator(),
      ),
    );

    final emptyFolderWidget = Center(
      child: Text(
        t.home.no_game_yet,
      ),
    );

    return FutureBuilder<Directory?>(
        future: _currentDirectoryFuture,
        builder: (BuildContext context, AsyncSnapshot<Directory?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              developer.log(snapshot.error!.toString(), name: 'loloof64');
              return failedLoadingExerciseWidget;
            } else if (snapshot.hasData) {
              final directory = snapshot.data;
              return FutureBuilder(
                  future: _getDirectoryElementsList(directory),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<FileSystemEntity>?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        developer.log(snapshot.error!.toString(),
                            name: 'loloof64');
                        return failedLoadingExerciseWidget;
                      } else if (snapshot.hasData) {
                        final elements = snapshot.data;
                        if (elements == null) {
                          return failedLoadingExerciseWidget;
                        } else {
                          if (elements.isEmpty) {
                            return emptyFolderWidget;
                          } else {
                            return FolderContentWidget(elements: elements);
                          }
                        }
                      } else {
                        return failedLoadingExerciseWidget;
                      }
                    } else {
                      return waitingWidget;
                    }
                  });
            } else {
              return failedLoadingExerciseWidget;
            }
          } else {
            return waitingWidget;
          }
        });
  }
}

class FolderContentWidget extends StatelessWidget {
  const FolderContentWidget({
    super.key,
    required this.elements,
  });

  final List<FileSystemEntity> elements;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final item = elements[index];
        final isDirectory = FileSystemEntity.isDirectorySync(item.path);
        final name = File(item.absolute.path).uri.pathSegments.last;

        return isDirectory
            ? FolderItemWidget(name: name)
            : FileItemWidget(name: name);
      },
      itemCount: elements.length,
    );
  }
}

class FileItemWidget extends StatelessWidget {
  const FileItemWidget({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            width: folderItemIconSize,
            height: folderItemIconSize,
            child: FaIcon(
              FontAwesomeIcons.fileLines,
              color: Colors.black,
              size: folderItemIconSize,
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: folderItemTextSize,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FolderItemWidget extends StatelessWidget {
  const FolderItemWidget({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            width: folderItemIconSize,
            child: FaIcon(
              FontAwesomeIcons.solidFolder,
              color: Colors.yellow,
              size: folderItemIconSize,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: folderItemTextSize,
            ),
          ),
        ),
      ],
    );
  }
}
