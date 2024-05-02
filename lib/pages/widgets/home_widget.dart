import 'dart:isolate';
import 'dart:io';

import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:basicchessendgamestrainer/logic/utils.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/script_text_interpretation.dart';
import 'package:basicchessendgamestrainer/pages/script_editor_page.dart';
import 'package:basicchessendgamestrainer/pages/widgets/home_page_widget.dart';
import 'package:basicchessendgamestrainer/pages/widgets/explorer_widgets.dart';
import 'package:chess/chess.dart' as chess;
import 'package:basicchessendgamestrainer/components/rgpd_modal_bottom_sheet_content.dart';
import 'package:basicchessendgamestrainer/data/asset_games.dart';
import 'package:basicchessendgamestrainer/models/providers/game_provider.dart';
import 'package:basicchessendgamestrainer/pages/game_page.dart';
import 'package:basicchessendgamestrainer/components/file_chooser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:external_path/external_path.dart';

const mainListItemsGap = 8.0;
const rgpdWarningHeight = 200.0;

class HomeWidget extends ConsumerStatefulWidget {
  const HomeWidget({super.key});

  @override
  ConsumerState<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends ConsumerState<HomeWidget> {
  Isolate? _positionGenerationIsolate;
  bool _isGeneratingPosition = false;
  bool _failedLoadingCustomExercises = false;
  int _selectedTabIndex = 0;
  Directory? _savingScriptPath;
  Directory? _rootDirectory;
  Directory? _currentAddedExercisesDirectory;
  List<FolderItem>? _customExercisesItems;
  final TextEditingController _renameCustomFileController =
      TextEditingController();
  final TextEditingController _newFolderNameTextController =
      TextEditingController();
  List<FolderItem> _sampleGames = [];

  @override
  void initState() {
    FlutterNativeSplash.remove();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showRgpdWarning());
    _sampleGames = getAssetGames(context).toFolderItemsList();
    _computeSampleExercisesLeadingIcons().then((value) => null);
    getApplicationDocumentsDirectory().then((directory) async {
      _rootDirectory = directory;
      _currentAddedExercisesDirectory = directory;
      _customExercisesItems = await _getAddedExercisesFolderItems();
      _computeCustomExercisesLeadingIcons().then((value) => null);
      /* TODO remove */
      if (Platform.isLinux | Platform.isWindows) {
        setState(() {
          _savingScriptPath = directory;
        });
      }
      /* end of todo */
      setState(() {});
    }).catchError((error) {
      setState(() {
        _failedLoadingCustomExercises = true;
      });
    });
    if (Platform.isAndroid) {
      ExternalPath.getExternalStoragePublicDirectory(
              ExternalPath.DIRECTORY_DOCUMENTS)
          .then((path) {
        setState(() {
          _savingScriptPath = Directory(path);
        });
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    _positionGenerationIsolate?.kill(
      priority: Isolate.immediate,
    );
    _newFolderNameTextController.dispose();
    _renameCustomFileController.dispose();
    super.dispose();
  }

  bool? _getWinningGoalFromScript(String script) {
    final lastLine = script.trim().split('\n').last;
    return lastLine == winningString
        ? true
        : lastLine == drawingString
            ? false
            : null;
  }

  Future<void> _computeSampleExercisesLeadingIcons() async {
    for (var item in _sampleGames) {
      final assetPath = item.path!;
      final script = await rootBundle.loadString(assetPath);
      item.hasWinningGoal = _getWinningGoalFromScript(script);
    }
    setState(() {});
  }

  Future<void> _computeCustomExercisesLeadingIcons() async {
    if (_currentAddedExercisesDirectory == null) return;
    if (_customExercisesItems == null) return;
    for (var item in _customExercisesItems!) {
      if (item.isFolder) {
        continue;
      }
      try {
        final exercisePath =
            "${_currentAddedExercisesDirectory!.path}${p.separator}${item.name}";
        final exerciseFile = File(exercisePath);
        final script = await exerciseFile.readAsString();
        item.hasWinningGoal = _getWinningGoalFromScript(script);
      } on FileSystemException {
        continue;
      }
    }
    setState(() {
      _customExercisesItems = [..._customExercisesItems!];
    });
  }

  Future<List<FolderItem>?> _getAddedExercisesFolderItems() async {
    final items = _currentAddedExercisesDirectory?.list(recursive: false);
    final result = await items?.toList();
    await result?.order();
    return result?.toFolderItemsList();
  }

  void _showHomePageHelpDialog() {
    showDialog(
        context: context,
        builder: (ctx2) {
          return AlertDialog(
            content: Text(
              _selectedTabIndex == 0
                  ? t.home.samples_help_message
                  : t.home.custom_scripts_help_message,
            ),
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

  Future<bool> _folderAlreadyExists(String name) async {
    if (_currentAddedExercisesDirectory == null) {
      throw "custom exercises folder is not ready";
    }

    final currentPath = _currentAddedExercisesDirectory!.path;
    final directoryInstance = Directory("$currentPath${p.separator}$name");

    return await directoryInstance.exists();
  }

  void _createFolder(String name) async {
    if (_currentAddedExercisesDirectory == null) {
      throw "custom exercises folder is not ready";
    }

    final currentPath = _currentAddedExercisesDirectory!.path;
    final directoryInstance = Directory("$currentPath${p.separator}$name");

    await directoryInstance.create(recursive: false);
    _reloadCurrentFolder();
  }

  void _purposeCreateFolder() {
    setState(() {
      _newFolderNameTextController.text = "";
    });
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(t.home.new_folder_prompt),
              Expanded(
                  child: TextField(controller: _newFolderNameTextController)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (await _folderAlreadyExists(
                    _newFolderNameTextController.text)) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        t.home.file_name_already_taken,
                      ),
                    ),
                  );
                  return;
                }
                if (!context.mounted) return;
                Navigator.of(context).pop();
                _createFolder(_newFolderNameTextController.text);
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

  void _renameFolder(
      {required String oldFolderName, required String newFolderName}) async {
    if (_currentAddedExercisesDirectory == null) {
      throw "custom exercises folder is not ready";
    }

    final currentDirectoryPath = _currentAddedExercisesDirectory!.path;
    final folderInstance =
        Directory("$currentDirectoryPath${p.separator}$oldFolderName");
    if (!await folderInstance.exists()) return;

    final newFolderPath = "$currentDirectoryPath${p.separator}$newFolderName";
    await folderInstance.rename(newFolderPath);
    _reloadCurrentFolder();
  }

  Future<InitialScriptsSet> _getInitialScriptSetFor(String fileName) async {
    if (_currentAddedExercisesDirectory == null) {
      throw "custom exercises folder is not ready";
    }

    final currentPath = _currentAddedExercisesDirectory!.path;
    final fileInstance = File("$currentPath${p.separator}$fileName");
    final script = await fileInstance.readAsString();

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
      FolderItem game) async {
    final assetPath = game.path!;
    final gameScript = await rootBundle.loadString(assetPath);
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

  void _handleCustomFileClic({required FolderItem fileItem}) async {
    if (_currentAddedExercisesDirectory == null) {
      throw "custom exercises folder is not ready";
    }

    final currentPath = _currentAddedExercisesDirectory!.path;
    final fileInstance = File("$currentPath${p.separator}${fileItem.name}");
    final script = await fileInstance.readAsString();
    _tryGeneratingAndPlayingPositionFromString(script);
  }

  void _handleCustomFileLongClic({required FolderItem fileItem}) async {
    if (_currentAddedExercisesDirectory == null) {
      throw "custom exercises folder is not ready";
    }

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
                  onPressed: () async {
                    Navigator.of(context).pop();
                    final initialScriptsSet =
                        await _getInitialScriptSetFor(fileItem.name);
                    if (!context.mounted) return;
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ScriptEditorPage(
                            originalFileName: fileItem.name,
                            initialScriptsSet: initialScriptsSet,
                            currentDirectory: _currentAddedExercisesDirectory!,
                          );
                        },
                      ),
                    );
                    if (result is FolderNeedsReload) {
                      _reloadCurrentFolder();
                    }
                  },
                  child: Text(t.home.contextual_menu_file_edit),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showRenameCustomFileDialog(fileItem.name);
                  },
                  child: Text(
                    t.home.contextual_menu_file_rename,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showConfirmDeleteCustomFile(fileItem.name);
                  },
                  child: Text(
                    t.home.contextual_menu_file_delete,
                  ),
                ),
                /*TODO uncomment
                 if (Platform.isAndroid)
                 */
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _doExportCustomFile(fileItem.name);
                  },
                  child: Text(t.home.contextual_menu_file_export),
                )
              ],
            ),
          );
        });
  }

  void _handleCustomFolderClic({required FolderItem folderItem}) async {
    if (_currentAddedExercisesDirectory == null) {
      throw "custom exercises folder is not ready";
    }

    if (folderItem.name == '..') {
      setState(() {
        _currentAddedExercisesDirectory =
            _currentAddedExercisesDirectory?.parent;
      });
      _reloadCurrentFolder();
      return;
    }

    final currentPath = _currentAddedExercisesDirectory!.path;
    final folderInstance =
        Directory("$currentPath${p.separator}${folderItem.name}");
    if (!await folderInstance.exists()) return;

    setState(() {
      _currentAddedExercisesDirectory = folderInstance;
    });
    _reloadCurrentFolder();
  }

  void _handleCustomFolderLongClic({required FolderItem folderItem}) {
    if (_currentAddedExercisesDirectory == null) {
      throw "custom exercises folder is not ready";
    }

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
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _purposeRenameCustomFolder(folderName: folderItem.name);
                },
                child: Text(
                  t.home.contextual_menu_file_rename,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _purposeDeleteCustomFolder(folderName: folderItem.name);
                },
                child: Text(
                  t.home.contextual_menu_folder_delete,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _purposeRenameCustomFolder({required String folderName}) {
    setState(() {
      _newFolderNameTextController.text = folderName;
    });

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(t.home.rename_folder_prompt),
              Expanded(
                child: TextField(
                  controller: _newFolderNameTextController,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                if (await _folderAlreadyExists(
                    _newFolderNameTextController.text)) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        t.home.file_name_already_taken,
                      ),
                    ),
                  );
                  return;
                }

                _renameFolder(
                  newFolderName: _newFolderNameTextController.text,
                  oldFolderName: folderName,
                );
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

  void _purposeDeleteCustomFolder({required String folderName}) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text(t.home.confirm_delete_folder_title),
          content: Text(t.home.confirm_delete_folder_msg(Name: folderName)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteCustomFolder(folderName);
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

  void _deleteCustomFolder(String folderName) async {
    if (_currentAddedExercisesDirectory == null) {
      throw "custom exercises folder is not ready";
    }

    final currentPath = _currentAddedExercisesDirectory!.path;
    final folderInstance = File("$currentPath${p.separator}$folderName");

    await folderInstance.delete(recursive: true);
    _reloadCurrentFolder();
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
    if (_currentAddedExercisesDirectory == null) {
      throw "custom exercises folder is not ready";
    }

    final currentPath = _currentAddedExercisesDirectory!.path;
    final fileInstance = File("$currentPath${p.separator}$fileName");
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
                    "$currentPath${p.separator}${_renameCustomFileController.text}";
                if (!newPath.endsWith('.txt')) newPath += '.txt';
                final alreadyExists = await File(newPath).exists();

                if (!alreadyExists) {
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                  await fileInstance.rename(newPath);
                  _reloadCurrentFolder();
                } else {
                  if (!context.mounted) return;
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

  void _doExportCustomFile(String fileName) async {
    if (_currentAddedExercisesDirectory == null) {
      throw "custom exercises folder is not ready";
    }
    /* TODO uncomment
    if (!Platform.isAndroid) {
      throw "exporting is only supported on Android";
    }
    */
    if (_savingScriptPath == null) {
      throw "current value of _savingScriptPath is null";
    }
    if (_rootDirectory == null) {
      throw "current value _rootDirectory is null";
    }

    final currentPath = _currentAddedExercisesDirectory!.path;
    final fileInstance = File("$currentPath${p.separator}$fileName");
    final script = await fileInstance.readAsString();

    if (!mounted) return;
    final String? fileLocation = await showDialog(
        context: context,
        builder: (context) {
          return FileChooser(
            mode: FileChooserMode.save,
            topDirectory: _rootDirectory!,
            startDirectory: _currentAddedExercisesDirectory!,
          );
        });
    if (fileLocation == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            t.home.failed_exporting_script,
          ),
        ),
      );
      return;
    }
    final path =
        !fileLocation.endsWith('.txt') ? '$fileLocation.txt' : fileLocation;
    final fileToSave = File(path);

    try {
      await fileToSave.create();
      await fileToSave.writeAsString(script);
      final savedFileName = path.split('/').last;
      setState(() {
        _savingScriptPath = Directory(path);
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            t.home.script_exported_to(Name: savedFileName),
          ),
        ),
      );
    } on Exception catch (ex) {
      Logger().e(ex);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            t.home.failed_exporting_script,
          ),
        ),
      );
      return;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          t.home.script_exported,
        ),
      ),
    );
  }

  void _deleteCustomFile(String fileName) async {
    if (_currentAddedExercisesDirectory == null) {
      throw "custom exercises folder is not ready";
    }

    final currentPath = _currentAddedExercisesDirectory!.path;
    final fileInstance = File("$currentPath${p.separator}$fileName");
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
      final isBelowRootLevel =
          _currentAddedExercisesDirectory?.path != _rootDirectory?.path;
      if (isBelowRootLevel && _customExercisesItems != null) {
        _customExercisesItems = [
          FolderItem(name: '..', isFolder: true),
          ..._customExercisesItems!
        ];
      }
      setState(() {});
      _computeCustomExercisesLeadingIcons().then((value) => null);
    } catch (ex) {
      setState(() {
        _failedLoadingCustomExercises = true;
      });
    }
  }

  void _readSampleCodeInEditor(FolderItem game) async {
    final assetPath = game.path!;
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

  void _cloneSampleCodeInCurrentCustomFolder(FolderItem game) async {
    if (_currentAddedExercisesDirectory == null) {
      throw "custom exercises folder is not ready";
    }
    final gameScript = await rootBundle.loadString(game.path!);
    final fileName =
        await getTempFileNameInDirectory(_currentAddedExercisesDirectory!);

    final newFilePath =
        "${_currentAddedExercisesDirectory!.path}${p.separator}$fileName";
    final newFile = File(newFilePath);
    await newFile.create(recursive: false);
    await newFile.writeAsString(gameScript);

    _reloadCurrentFolder();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          t.home.cloned_sample_exercise(Name: fileName),
        ),
      ),
    );
  }

  void _showSampleScriptContextualMenu(FolderItem game) {
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
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _readSampleCodeInEditor(game);
                },
                child: Text(
                  t.home.contextual_menu_see_sample_code,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _cloneSampleCodeInCurrentCustomFolder(game);
                },
                child: Text(
                  t.home.contextual_menu_clone_sample_code,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _purposeImportElement() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
              content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: _showImportFileExplorer,
                child: Text(
                  t.home.import_file_menu,
                ),
              ),
              TextButton(
                onPressed: _showImportFolderExplorer,
                child: Text(
                  t.home.import_folder_menu,
                ),
              ),
            ],
          ));
        });
  }

  void _showImportFileExplorer() async {
    //TODO
  }

  void _showImportFolderExplorer() async {
    //TODO
  }

  @override
  Widget build(BuildContext context) {
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
              icon: FaIcon(
                _selectedTabIndex == 0
                    ? FontAwesomeIcons.question
                    : FontAwesomeIcons.circleQuestion,
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
              physics: const NeverScrollableScrollPhysics(),
              children: [
                IntegratedExercisesWidget(
                  games: _sampleGames,
                  onGameSelected: _tryGeneratingAndPlayingPositionFromSample,
                  onGameLongClick: _showSampleScriptContextualMenu,
                ),
                AddedExercisesWidget(
                  rootDirectory: _rootDirectory,
                  currentDirectory: _currentAddedExercisesDirectory,
                  failedLoadingContent: _failedLoadingCustomExercises,
                  folderItems: _customExercisesItems,
                  onFileClic: _handleCustomFileClic,
                  onFileLongClic: _handleCustomFileLongClic,
                  onFolderClic: _handleCustomFolderClic,
                  onFolderLongClic: _handleCustomFolderLongClic,
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
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: _selectedTabIndex == 1
            ? ExpandableFab(
                children: [
                  FloatingActionButton.small(
                    heroTag: null,
                    onPressed: () async {
                      if (_currentAddedExercisesDirectory != null) {
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return ScriptEditorPage(
                                initialScriptsSet:
                                    const InitialScriptsSet.empty(),
                                currentDirectory:
                                    _currentAddedExercisesDirectory!,
                              );
                            },
                          ),
                        );
                        if (result is FolderNeedsReload) {
                          _reloadCurrentFolder();
                        }
                      }
                    },
                    child: const FaIcon(FontAwesomeIcons.fileLines),
                  ),
                  FloatingActionButton.small(
                    heroTag: null,
                    onPressed: _purposeCreateFolder,
                    child: const FaIcon(FontAwesomeIcons.solidFolder),
                  ),
                  FloatingActionButton.small(
                    heroTag: null,
                    onPressed: _purposeImportElement,
                    child: const FaIcon(FontAwesomeIcons.arrowUp),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
