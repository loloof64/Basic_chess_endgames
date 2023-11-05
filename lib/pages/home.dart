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
  bool _failedLoadingCustomExercises = false;
  int _selectedTabIndex = 0;
  Directory? _currentAddedExercisesDirectory;
  List<FileSystemEntity>? _customExercisesItems;
  final TextEditingController _renameCustomFileController =
      TextEditingController();

  @override
  void initState() {
    FlutterNativeSplash.remove();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showRgpdWarning());
    getApplicationDocumentsDirectory().then((directory) async {
      _currentAddedExercisesDirectory = directory;
      _customExercisesItems = await _getAddedExercisesFolderItems();
      setState(() {});
    }).catchError((error) {
      setState(() {
        _failedLoadingCustomExercises = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _positionGenerationIsolate?.kill(
      priority: Isolate.immediate,
    );
    _renameCustomFileController.dispose();
    super.dispose();
  }

  Future<List<FileSystemEntity>?> _getAddedExercisesFolderItems() async {
    final items = _currentAddedExercisesDirectory?.list(recursive: false);
    return await items?.toList();
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
    await _tryGeneratingAndPlayingPositionFromString(gameScript);
  }

  Future<void> _tryGeneratingAndPlayingPositionFromString(String script) async {
    final receivePort = ReceivePort();

    if (!mounted) return;

    setState(() {
      _isGeneratingPosition = true;
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
        final goalString = script.trim().split("\n").last;
        final gameGoal = goalString == winningString ? Goal.win : Goal.draw;
        _tryPlayingGeneratedPosition(newPosition, gameGoal);
      }
    });
  }

  void _handleCustomFileClic({required String fileName}) async {
    if (_currentAddedExercisesDirectory == null) return;

    final currentPath = _currentAddedExercisesDirectory!.path;
    final fileInstance = File("$currentPath/$fileName");
    final script = await fileInstance.readAsString();
    _tryGeneratingAndPlayingPositionFromString(script);
  }

  void _handleCustomFileLongClic({required String fileName}) async {
    if (_currentAddedExercisesDirectory == null) return;

    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showConfirmDeleteCustomFile(fileName);
                  },
                  child: Text(
                    t.home.contextual_menu_file_delete,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showRenameCustomFileDialog(fileName);
                  },
                  child: Text(
                    t.home.contextual_menu_file_rename,
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _showConfirmDeleteCustomFile(String fileName) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text(t.home.confirm_delete_file_title),
          content: Text(t.home.confirm_delete_file_msg(Name: fileName)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteCustomFile(fileName);
              },
              child: Text(
                t.misc.button_ok,
                style: const TextStyle(
                  color: Colors.green,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                t.misc.button_cancel,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showRenameCustomFileDialog(String fileName) async {
    if (_currentAddedExercisesDirectory == null) return;

    final currentPath = _currentAddedExercisesDirectory!.path;
    final fileInstance = File("$currentPath/$fileName");
    String fileNameWithoutExtension;
    if (fileName.contains('.')) {
      final parts = fileName.split('.');
      fileNameWithoutExtension = parts.sublist(0, parts.length - 1).join('.');
    } else {
      fileNameWithoutExtension = fileName;
    }
    _renameCustomFileController.text = fileNameWithoutExtension;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _renameCustomFileController,
                    ),
                  ),
                  const Text('.txt'),
                ],
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String newPath =
                    "$currentPath/${_renameCustomFileController.text}";
                if (!newPath.endsWith('.txt')) newPath += '.txt';
                final alreadyExists = await File(newPath).exists();

                if (!alreadyExists) {
                  if (!mounted) return;
                  Navigator.of(context).pop();
                  await fileInstance.rename(newPath);
                  _reloadCurrentFolder();
                } else {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(t.home.file_name_already_taken),
                    ),
                  );
                }
              },
              child: Text(
                t.misc.button_ok,
                style: const TextStyle(
                  color: Colors.green,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                t.misc.button_cancel,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteCustomFile(String fileName) async {
    if (_currentAddedExercisesDirectory == null) return;

    final currentPath = _currentAddedExercisesDirectory!.path;
    final fileInstance = File("$currentPath/$fileName");
    await fileInstance.delete();
    _reloadCurrentFolder();
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

  void _reloadCurrentFolder() async {
    setState(() {
      _failedLoadingCustomExercises = false;
    });
    try {
      _customExercisesItems = await _getAddedExercisesFolderItems();
      setState(() {});
    } catch (ex) {
      setState(() {
        _failedLoadingCustomExercises = true;
      });
    }
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
                AddedExercisesWidget(
                  failedLoadingContent: _failedLoadingCustomExercises,
                  folderItems: _customExercisesItems,
                  onFileClic: _handleCustomFileClic,
                  onFileLongClic: _handleCustomFileLongClic,
                ),
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
                onPressed: () async {
                  if (_currentAddedExercisesDirectory != null) {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ScriptEditorPage(
                            currentDirectory: _currentAddedExercisesDirectory!,
                          );
                        },
                      ),
                    );
                    if (result is FolderNeedsReload) {
                      _reloadCurrentFolder();
                    }
                  }
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

class AddedExercisesWidget extends StatelessWidget {
  //true if and only if we failed to load content
  final bool failedLoadingContent;

  /*
  null if we have not yet loaded content, otherwise,
  it's the list of contents.
  */
  final List<FileSystemEntity>? folderItems;

  final void Function({required String fileName}) onFileClic;
  final void Function({required String fileName}) onFileLongClic;

  const AddedExercisesWidget({
    super.key,
    required this.failedLoadingContent,
    required this.folderItems,
    required this.onFileClic,
    required this.onFileLongClic,
  });

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

    return failedLoadingContent
        ? failedLoadingExerciseWidget
        : folderItems == null
            ? waitingWidget
            : folderItems!.isEmpty
                ? emptyFolderWidget
                : FolderContentWidget(
                    elements: folderItems!,
                    onFileClic: onFileClic,
                    onFileLongClic: onFileLongClic,
                  );
  }
}

class FolderContentWidget extends StatelessWidget {
  final void Function({required String fileName}) onFileClic;
  final void Function({required String fileName}) onFileLongClic;

  const FolderContentWidget({
    super.key,
    required this.elements,
    required this.onFileClic,
    required this.onFileLongClic,
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
            : FileItemWidget(
                name: name,
                onClic: onFileClic,
                onLongClic: onFileLongClic,
              );
      },
      itemCount: elements.length,
    );
  }
}

class FileItemWidget extends StatelessWidget {
  final void Function({required String fileName}) onClic;
  final void Function({required String fileName}) onLongClic;

  const FileItemWidget({
    super.key,
    required this.name,
    required this.onClic,
    required this.onLongClic,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onClic(fileName: name),
      onLongPress: () => onLongClic(fileName: name),
      child: Row(
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
      ),
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
