import 'dart:io';
import 'dart:isolate';

import 'package:basicchessendgamestrainer/commons.dart';
import 'package:basicchessendgamestrainer/components/variable_insertor.dart';
import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/position_generation_constraints.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/script_text_interpretation.dart';
import 'package:basicchessendgamestrainer/pages/widgets/piece_count_widget.dart';
import 'package:basicchessendgamestrainer/pages/widgets/script_editor_common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';

import 'package:open_save_file_dialogs/open_save_file_dialogs.dart';
import 'package:file_picker/file_picker.dart';

final _openSaveFileDialogsPlugin = OpenSaveFileDialogs();

const winningString = "win";
const drawingString = "draw";

const playeKingTabIndex = 0;
const computerKingTabIndex = 1;
const kingsMutualTabIndex = 2;
const otherPieceGlobalTabIndex = 4;
const otherPiecesMutualTabIndex = 5;
const otherPiecesIndexedTabIndex = 6;

class InitialScriptsSet {
  final String playerKingConstraints;
  final String computerKingConstraints;
  final String kingsMutualConstraints;
  final String otherPiecesCountConstraints;
  final String otherPiecesGlobalConstaints;
  final String otherPiecesMutualConstaints;
  final String otherPiecesIndexedConstaints;
  final bool winningGoal;

  const InitialScriptsSet({
    required this.playerKingConstraints,
    required this.computerKingConstraints,
    required this.kingsMutualConstraints,
    required this.otherPiecesCountConstraints,
    required this.otherPiecesGlobalConstaints,
    required this.otherPiecesMutualConstaints,
    required this.otherPiecesIndexedConstaints,
    required this.winningGoal,
  });

  const InitialScriptsSet.empty()
      : playerKingConstraints = "",
        computerKingConstraints = "",
        kingsMutualConstraints = "",
        otherPiecesCountConstraints = "",
        otherPiecesGlobalConstaints = "",
        otherPiecesMutualConstaints = "",
        otherPiecesIndexedConstaints = "",
        winningGoal = true;
}

extension ScriptFiller on Map<PieceKind, TextEditingController> {
  void fillFrom(
      String sectionScripts, String otherPiecesCountConstraintsScript) {
    final otherPiecesKinds =
        convertScriptToPiecesCounts(otherPiecesCountConstraintsScript)
            .keys
            .toList();
    if (sectionScripts.isNotEmpty) {
      final content = sectionScripts.trim();
      final parts = content.split(otherPiecesSingleScriptSeparator);
      for (final pieceKindScript in parts) {
        if (pieceKindScript.isEmpty) continue;
        final pieceKindScriptContent = pieceKindScript.trim();
        final subScriptLines = pieceKindScriptContent.split("\n");
        final typeLine = subScriptLines.first.trim();
        final subScript = subScriptLines.sublist(1).join("\n");

        final pieceKind =
            PieceKind.from(typeLine.substring(1, typeLine.length - 1));
        this[pieceKind] = TextEditingController(text: subScript);
      }
    }
    // setting also TextEditingController for those "fields" which still miss one
    for (final kind in otherPiecesKinds) {
      if (this[kind] == null) {
        this[kind] = TextEditingController(text: "");
      }
    }
  }
}

class ScriptEditorPage extends StatefulWidget {
  final String? originalFileName;
  final bool readOnly;
  final InitialScriptsSet initialScriptsSet;

  const ScriptEditorPage({
    super.key,
    this.originalFileName,
    this.readOnly = false,
    required this.initialScriptsSet,
  });

  @override
  State<ScriptEditorPage> createState() => _ScriptEditorPageState();
}

class _ScriptEditorPageState extends State<ScriptEditorPage> {
  bool _isCheckingPosition = false;
  bool _isSavingFile = false;
  Isolate? _scriptCheckerIsolate;

  final TextEditingController _playerKingConstraintsScriptController =
      TextEditingController(text: "");
  final TextEditingController _computerKingConstraintsScriptController =
      TextEditingController(text: "");
  final TextEditingController _kingsMutualConstraintsScriptController =
      TextEditingController(text: "");
  final Map<PieceKind, TextEditingController>
      _otherPiecesGlobalConstraintsScripts =
      <PieceKind, TextEditingController>{};
  final Map<PieceKind, TextEditingController>
      _otherPiecesMutualConstraintsScripts =
      <PieceKind, TextEditingController>{};
  final Map<PieceKind, TextEditingController>
      _otherPiecesIndexedConstraintsScripts =
      <PieceKind, TextEditingController>{};
  String _otherPiecesCountConstraintsScript = "";
  String _goalScript = winningString;

  final FocusNode _otherPiecesGlobalConstraintsFocusNode = FocusNode();
  final FocusNode _otherPiecesIndexedConstraintsFocusNode = FocusNode();
  final FocusNode _otherPiecesMutualConstraintsFocusNode = FocusNode();

  PieceKind? _otherPiecesGlobalConstraintsSelectedPieceKind;
  PieceKind? _otherPiecesIndexedConstraintsSelectedPieceKind;
  PieceKind? _otherPiecesMutualConstraintsSelectedPieceKind;

  int _selectedTabIndex = playeKingTabIndex;

  @override
  void initState() {
    _playerKingConstraintsScriptController.text =
        widget.initialScriptsSet.playerKingConstraints;
    _computerKingConstraintsScriptController.text =
        widget.initialScriptsSet.computerKingConstraints;
    _kingsMutualConstraintsScriptController.text =
        widget.initialScriptsSet.kingsMutualConstraints;
    _otherPiecesCountConstraintsScript =
        widget.initialScriptsSet.otherPiecesCountConstraints;
    _otherPiecesGlobalConstraintsScripts.fillFrom(
        widget.initialScriptsSet.otherPiecesGlobalConstaints,
        _otherPiecesCountConstraintsScript);
    _otherPiecesMutualConstraintsScripts.fillFrom(
        widget.initialScriptsSet.otherPiecesMutualConstaints,
        _otherPiecesCountConstraintsScript);
    _otherPiecesIndexedConstraintsScripts.fillFrom(
        widget.initialScriptsSet.otherPiecesIndexedConstaints,
        _otherPiecesCountConstraintsScript);
    _goalScript =
        widget.initialScriptsSet.winningGoal ? winningString : drawingString;
    super.initState();
  }

  @override
  void dispose() {
    _scriptCheckerIsolate?.kill(
      priority: Isolate.immediate,
    );
    _otherPiecesGlobalConstraintsFocusNode.dispose();
    _otherPiecesIndexedConstraintsFocusNode.dispose();
    _otherPiecesMutualConstraintsFocusNode.dispose();
    _playerKingConstraintsScriptController.dispose();
    _computerKingConstraintsScriptController.dispose();
    _kingsMutualConstraintsScriptController.dispose();
    for (var controller in _otherPiecesGlobalConstraintsScripts.values) {
      controller.dispose();
    }
    for (var controller in _otherPiecesMutualConstraintsScripts.values) {
      controller.dispose();
    }
    for (var controller in _otherPiecesIndexedConstraintsScripts.values) {
      controller.dispose();
    }
    super.dispose();
  }

  List<List<String>> _getCommonVariablesData() {
    return <List<String>>[
      <String>[
        "FileA",
        t.variables_table.rows.file_a.description,
        t.variables_table.rows.file_a.type,
      ],
      <String>[
        "FileB",
        t.variables_table.rows.file_b.description,
        t.variables_table.rows.file_b.type,
      ],
      <String>[
        "FileC",
        t.variables_table.rows.file_c.description,
        t.variables_table.rows.file_c.type,
      ],
      <String>[
        "FileD",
        t.variables_table.rows.file_d.description,
        t.variables_table.rows.file_d.type,
      ],
      <String>[
        "FileE",
        t.variables_table.rows.file_e.description,
        t.variables_table.rows.file_e.type,
      ],
      <String>[
        "FileF",
        t.variables_table.rows.file_g.description,
        t.variables_table.rows.file_g.type,
      ],
      <String>[
        "FileG",
        t.variables_table.rows.file_h.description,
        t.variables_table.rows.file_h.type,
      ],
      <String>[
        "FileH",
        t.variables_table.rows.file_a.description,
        t.variables_table.rows.file_a.type,
      ],
      <String>[
        "Rank1",
        t.variables_table.rows.rank_1.description,
        t.variables_table.rows.rank_1.type,
      ],
      <String>[
        "Rank2",
        t.variables_table.rows.rank_2.description,
        t.variables_table.rows.rank_2.type,
      ],
      <String>[
        "Rank3",
        t.variables_table.rows.rank_3.description,
        t.variables_table.rows.rank_3.type,
      ],
      <String>[
        "Rank4",
        t.variables_table.rows.rank_4.description,
        t.variables_table.rows.rank_4.type,
      ],
      <String>[
        "Rank5",
        t.variables_table.rows.rank_5.description,
        t.variables_table.rows.rank_5.type,
      ],
      <String>[
        "Rank6",
        t.variables_table.rows.rank_6.description,
        t.variables_table.rows.rank_6.type,
      ],
      <String>[
        "Rank7",
        t.variables_table.rows.rank_7.description,
        t.variables_table.rows.rank_7.type,
      ],
      <String>[
        "Rank8",
        t.variables_table.rows.rank_8.description,
        t.variables_table.rows.rank_8.type,
      ],
    ];
  }

  List<List<String>> _getPlayerKingConstraintsVariablesData() {
    return <List<String>>[
      <String>[
        "file",
        t.variables_table.rows.king_file.description,
        t.variables_table.rows.king_file.type,
      ],
      <String>[
        "rank",
        t.variables_table.rows.king_rank.description,
        t.variables_table.rows.king_rank.type,
      ],
      <String>[
        "playerHasWhite",
        t.variables_table.rows.player_has_white.description,
        t.variables_table.rows.player_has_white.type,
      ],
    ];
  }

  List<List<String>> _getKingsMutualConstraintsVariablesData() {
    return <List<String>>[
      <String>[
        "playerKingFile",
        t.variables_table.rows.player_king_file.description,
        t.variables_table.rows.player_king_file.type,
      ],
      <String>[
        "playerKingRank",
        t.variables_table.rows.player_king_rank.description,
        t.variables_table.rows.player_king_rank.type,
      ],
      <String>[
        "computerKingFile",
        t.variables_table.rows.computer_king_file.description,
        t.variables_table.rows.computer_king_file.type,
      ],
      <String>[
        "computerKingRank",
        t.variables_table.rows.computer_king_rank.description,
        t.variables_table.rows.computer_king_rank.type,
      ],
    ];
  }

  List<List<String>> _getOtherPiecesGlobalConstraintsVariablesData() {
    return <List<String>>[
      <String>[
        "file",
        t.variables_table.rows.piece_file.description,
        t.variables_table.rows.piece_file.type,
      ],
      <String>[
        "rank",
        t.variables_table.rows.piece_file.description,
        t.variables_table.rows.piece_file.type,
      ],
      <String>[
        "playerKingFile",
        t.variables_table.rows.player_king_file.description,
        t.variables_table.rows.player_king_file.type,
      ],
      <String>[
        "playerKingRank",
        t.variables_table.rows.player_king_rank.description,
        t.variables_table.rows.player_king_rank.type,
      ],
      <String>[
        "computerKingFile",
        t.variables_table.rows.computer_king_file.description,
        t.variables_table.rows.computer_king_file.type,
      ],
      <String>[
        "computerKingRank",
        t.variables_table.rows.computer_king_rank.description,
        t.variables_table.rows.computer_king_rank.type,
      ],
      <String>[
        "playerHasWhite",
        t.variables_table.rows.player_has_white.description,
        t.variables_table.rows.player_has_white.type,
      ],
    ];
  }

  List<List<String>> _getOtherPiecesIndexedConstraintsVariablesData() {
    return <List<String>>[
      <String>[
        "file",
        t.variables_table.rows.piece_file.description,
        t.variables_table.rows.piece_file.type,
      ],
      <String>[
        "rank",
        t.variables_table.rows.piece_file.description,
        t.variables_table.rows.piece_file.type,
      ],
      <String>[
        "apparitionIndex",
        t.variables_table.rows.apparition_index.description,
        t.variables_table.rows.apparition_index.type,
      ],
      <String>[
        "playerHasWhite",
        t.variables_table.rows.player_has_white.description,
        t.variables_table.rows.player_has_white.type,
      ],
    ];
  }

  List<List<String>> _getOtherPiecesMutualConstraintsVariablesData() {
    return <List<String>>[
      <String>[
        "firstPieceFile",
        t.variables_table.rows.first_piece_file.description,
        t.variables_table.rows.first_piece_file.type,
      ],
      <String>[
        "firstPieceRank",
        t.variables_table.rows.first_piece_rank.description,
        t.variables_table.rows.first_piece_rank.type,
      ],
      <String>[
        "secondPieceFile",
        t.variables_table.rows.second_piece_file.description,
        t.variables_table.rows.second_piece_file.type,
      ],
      <String>[
        "secondPieceRank",
        t.variables_table.rows.second_piece_rank.description,
        t.variables_table.rows.second_piece_rank.type,
      ],
      <String>[
        "playerHasWhite",
        t.variables_table.rows.player_has_white.description,
        t.variables_table.rows.player_has_white.type,
      ],
    ];
  }

  void _processUserScript() async {
    if (_isCheckingPosition) return;
    if (_isSavingFile) return;

    final script = _getWholeScriptContent();
    final receivePort = ReceivePort();

    setState(() {
      _isCheckingPosition = true;
    });

    _scriptCheckerIsolate = await Isolate.spawn(
      generatePositionFromScript,
      SampleScriptGenerationParameters(
        inGameMode: false,
        gameScript: script,
        translations: getTranslations(context),
        sendPort: receivePort.sendPort,
      ),
    );
    setState(() {});

    receivePort.handleError((error) async {
      Logger().e(error);

      receivePort.close();
      _scriptCheckerIsolate?.kill(
        priority: Isolate.immediate,
      );

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                t.script_parser.misc_error_dialog_title,
              ),
              content: Text(
                t.script_parser.misc_checking_error,
              ),
            );
          });

      setState(() {
        _isCheckingPosition = false;
      });
    });

    receivePort.listen((message) async {
      receivePort.close();
      _scriptCheckerIsolate?.kill(
        priority: Isolate.immediate,
      );

      setState(() {
        _isCheckingPosition = false;
      });

      final (newPosition, errors) =
          message as (String?, List<PositionGenerationError>);

      if (newPosition == null) {
        await showGenerationErrorsPopup(errors: errors, context: context);
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              t.home.failed_generating_position,
            ),
          ),
        );
      } else {
        setState(() {
          _isSavingFile = true;
        });

        if (Platform.isAndroid) {
          final filePath =
              await _openSaveFileDialogsPlugin.saveFileDialog(content: script);
          if (filePath == null) {
            debugPrint("File saving cancellation.");
            setState(() {
              _isSavingFile = false;
            });

            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(t.script_editor_page.exercise_creation_success),
              ),
            );

            Navigator.of(context).pop();

            return;
          } else {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  t.script_editor_page.exercise_creation_success,
                ),
              ),
            );
            Navigator.of(context).pop();
            return;
          }
        } else {
          final filePath = await FilePicker.platform.saveFile(
            dialogTitle: t.pickers.save_file_title,
          );
          if (filePath == null) {
            debugPrint("File saving cancellation.");
            setState(() {
              _isSavingFile = false;
            });
            return;
          }

          try {
            final newFile = File(filePath);

            await newFile.writeAsString(
              script,
              mode: FileMode.writeOnly,
            );
            setState(() {
              _isSavingFile = false;
            });

            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(t.script_editor_page.exercise_creation_success),
              ),
            );

            Navigator.of(context).pop();

            return;
          } on FileSystemException {
            setState(() {
              _isSavingFile = false;
            });
            if (!mounted) return;
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      t.script_parser.misc_error_dialog_title,
                    ),
                    content: Text(
                      t.script_editor_page.exercise_creation_error,
                    ),
                  );
                });
          }
        }
      }
    });
  }

  String _getWholeScriptContent() {
    var result = "";

    if (_playerKingConstraintsScriptController.text.isNotEmpty) {
      result += "# player king constraints\n\n";
      result += _playerKingConstraintsScriptController.text;
      result += "\n\n$scriptsSeparator\n\n";
    }

    if (_computerKingConstraintsScriptController.text.isNotEmpty) {
      result += "# computer king constraints\n\n";
      result += _computerKingConstraintsScriptController.text;
      result += "\n\n$scriptsSeparator\n\n";
    }

    if (_kingsMutualConstraintsScriptController.text.isNotEmpty) {
      result += "# kings mutual constraints\n\n";
      result += _kingsMutualConstraintsScriptController.text;
      result += "\n\n$scriptsSeparator\n\n";
    }

    if (_otherPiecesCountConstraintsScript.isNotEmpty) {
      result += "# other pieces counts\n\n";
      result += _otherPiecesCountConstraintsScript;
      result += "\n\n$scriptsSeparator\n\n";
    }

    if (_otherPiecesGlobalConstraintsScripts.isNotEmpty) {
      var temp = "";
      for (var kind in _otherPiecesGlobalConstraintsScripts.keys) {
        if (_otherPiecesGlobalConstraintsScripts[kind]!.text.isEmpty) continue;
        temp += "[${kind.toEasyString()}]\n\n";
        temp += _otherPiecesGlobalConstraintsScripts[kind]!.text;
        temp += "\n\n$otherPiecesSingleScriptSeparator\n\n";
      }
      if (temp.isNotEmpty) {
        result += "# other pieces global constraints\n\n";
        result += temp;
        result += "\n\n$scriptsSeparator\n\n";
      }
    }

    if (_otherPiecesMutualConstraintsScripts.isNotEmpty) {
      var temp = "";
      for (var kind in _otherPiecesMutualConstraintsScripts.keys) {
        if (_otherPiecesMutualConstraintsScripts[kind]!.text.isEmpty) continue;
        temp += "[${kind.toEasyString()}]\n\n";
        temp += _otherPiecesMutualConstraintsScripts[kind]!.text;
        temp += "\n\n$otherPiecesSingleScriptSeparator\n\n";
      }
      if (temp.isNotEmpty) {
        result += "# other pieces mutual constraints\n\n";
        result += temp;
        result += "\n\n$scriptsSeparator\n\n";
      }
    }

    if (_otherPiecesIndexedConstraintsScripts.isNotEmpty) {
      var temp = "";
      for (var kind in _otherPiecesIndexedConstraintsScripts.keys) {
        if (_otherPiecesIndexedConstraintsScripts[kind]!.text.isEmpty) continue;
        temp += "[${kind.toEasyString()}]\n\n";
        temp += _otherPiecesIndexedConstraintsScripts[kind]!.text;
        temp += "\n\n$otherPiecesSingleScriptSeparator\n\n";
      }
      if (temp.isNotEmpty) {
        result += "# other pieces indexed constraints\n\n";
        result += temp;
        result += "\n\n$scriptsSeparator\n\n";
      }
    }

    result += "# goal\n\n";
    result += _goalScript;

    return result;
  }

  void _updateOtherPiecesCountConstraintsScript(Map<PieceKind, int> counts) {
    final script = [
      for (var entry in counts.entries)
        "${entry.key.toEasyString()} : ${entry.value}"
    ].join("\n");
    setState(() {
      _otherPiecesCountConstraintsScript = script;
    });
  }

  void _updateGoalScript(bool shouldWin) {
    setState(() {
      _goalScript = shouldWin ? winningString : drawingString;
    });
  }

  List<PieceKind> _getOtherPiecesKindsFromPiecesCountScript(String script) {
    return convertScriptToPiecesCounts(script).keys.toList();
  }

  void _handleExitPage(bool didPop) async {
    if (didPop) return;
    if (widget.readOnly) {
      Navigator.of(context).pop();
      return;
    }

    return await showDialog(
        context: context,
        builder: (ctx2) {
          return AlertDialog(
            title: Text(
              t.script_editor_page.before_exit_title,
            ),
            content: Text(
              t.script_editor_page.before_exit_message,
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.onTertiary,
                  ),
                ),
                child: Text(
                  t.misc.button_cancel,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                child: Text(
                  t.misc.button_ok,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ],
          );
        });
  }

  TextEditingController? _getControllerForCurrentScript() {
    TextEditingController? controller;

    if (_selectedTabIndex == playeKingTabIndex) {
      controller = _playerKingConstraintsScriptController;
    } else if (_selectedTabIndex == computerKingTabIndex) {
      controller = _computerKingConstraintsScriptController;
    } else if (_selectedTabIndex == kingsMutualTabIndex) {
      controller = _kingsMutualConstraintsScriptController;
    } else if (_selectedTabIndex == otherPieceGlobalTabIndex) {
      if (_otherPiecesGlobalConstraintsSelectedPieceKind == null) {
        return null;
      }
      controller = _otherPiecesGlobalConstraintsScripts[
          _otherPiecesGlobalConstraintsSelectedPieceKind];
    } else if (_selectedTabIndex == otherPiecesIndexedTabIndex) {
      if (_otherPiecesIndexedConstraintsSelectedPieceKind == null) {
        return null;
      }
      controller = _otherPiecesIndexedConstraintsScripts[
          _otherPiecesIndexedConstraintsSelectedPieceKind];
    } else if (_selectedTabIndex == otherPiecesMutualTabIndex) {
      if (_otherPiecesMutualConstraintsSelectedPieceKind == null) {
        return null;
      }
      controller = _otherPiecesMutualConstraintsScripts[
          _otherPiecesMutualConstraintsSelectedPieceKind];
    }

    return controller;
  }

  List<List<String>> _getInsertVariableForCurrentScript() {
    return switch (_selectedTabIndex) {
      playeKingTabIndex ||
      computerKingTabIndex =>
        _getPlayerKingConstraintsVariablesData(),
      kingsMutualTabIndex => _getKingsMutualConstraintsVariablesData(),
      otherPieceGlobalTabIndex =>
        _getOtherPiecesGlobalConstraintsVariablesData(),
      otherPiecesIndexedTabIndex =>
        _getOtherPiecesIndexedConstraintsVariablesData(),
      otherPiecesMutualTabIndex =>
        _getOtherPiecesMutualConstraintsVariablesData(),
      _ => throw Exception(
          "Cannot insert variable for this kind of selected tab index : $_selectedTabIndex")
    };
  }

  Future<void> _showInsertVariableDialog({
    required List<List<String>> data,
    required TextEditingController controller,
  }) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(t.script_editor_page.insert_variable_title),
            content: VariableInsertor(
              translations: getTranslations(context),
              data: data,
              controller: controller,
              onDone: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.onTertiary,
                  ),
                ),
                child: Text(
                  t.misc.button_cancel,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future<void> _purposeInsertCommonConstant() async {
    if (widget.readOnly) {
      return;
    }

    final isInPiecesCountTabOrInGoalTab =
        (_selectedTabIndex == 3) || (_selectedTabIndex == 7);
    if (isInPiecesCountTabOrInGoalTab) {
      return;
    }

    final controller = _getControllerForCurrentScript();
    final noTextFieldActive = controller == null;
    if (noTextFieldActive) {
      return;
    }

    final data = _getCommonVariablesData();
    return await _showInsertVariableDialog(
      data: data,
      controller: controller,
    );
  }

  Future<void> _purposeInsertScriptVariable() async {
    if (widget.readOnly) {
      return;
    }

    final isInPiecesCountTabOrInGoalTab =
        (_selectedTabIndex == 3) || (_selectedTabIndex == 7);
    if (isInPiecesCountTabOrInGoalTab) {
      return;
    }

    final controller = _getControllerForCurrentScript();
    final noTextFieldActive = controller == null;
    if (noTextFieldActive) {
      return;
    }

    final data = _getInsertVariableForCurrentScript();

    return await _showInsertVariableDialog(
      data: data,
      controller: controller,
    );
  }

  void _purposeInsertVariable() async {
    final noPieceKindSelected =
        (_selectedTabIndex == otherPieceGlobalTabIndex &&
                _otherPiecesGlobalConstraintsSelectedPieceKind == null) ||
            (_selectedTabIndex == otherPiecesMutualTabIndex &&
                _otherPiecesMutualConstraintsSelectedPieceKind == null) ||
            (_selectedTabIndex == otherPiecesIndexedTabIndex &&
                _otherPiecesIndexedConstraintsSelectedPieceKind == null);

    if (noPieceKindSelected) {
      return;
    }

    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text(
              t.script_editor_page.insert_variable_title,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _purposeInsertScriptVariable,
                    child: Text(
                      t.script_editor_page.choice_script_variables,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _purposeInsertCommonConstant,
                    child: Text(
                      t.script_editor_page.choice_common_constants,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final otherPiecesKinds = _getOtherPiecesKindsFromPiecesCountScript(
        _otherPiecesCountConstraintsScript);

    return PopScope(
      canPop: false,
      onPopInvoked: _handleExitPage,
      child: DefaultTabController(
        length: 8,
        child: Builder(builder: (context) {
          final TabController tabController = DefaultTabController.of(context);
          tabController.addListener(() {
            if (!tabController.indexIsChanging) {
              final index = tabController.index;
              setState(() {
                _selectedTabIndex = index;
              });
            }
          });
          return Scaffold(
            appBar: AppBar(
              title: Text(
                t.script_editor_page.title,
              ),
              actions: [
                if (!widget.readOnly)
                  IconButton(
                    onPressed: _purposeInsertVariable,
                    icon: const FaIcon(
                      FontAwesomeIcons.penToSquare,
                    ),
                  )
                /* TODO adapt
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return const SyntaxManualPage();
                        }),
                      );
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.book,
                    ),
                  )
                */
              ],
              bottom: const TabBar(
                tabs: [
                  Tab(icon: FaIcon(FontAwesomeIcons.chessKing)),
                  Tab(icon: FaIcon(FontAwesomeIcons.solidChessKing)),
                  Tab(icon: FaIcon(FontAwesomeIcons.arrowsUpDown)),
                  Tab(icon: FaIcon(FontAwesomeIcons.calculator)),
                  Tab(icon: FaIcon(FontAwesomeIcons.globe)),
                  Tab(icon: FaIcon(FontAwesomeIcons.arrowRightArrowLeft)),
                  Tab(icon: FaIcon(FontAwesomeIcons.arrowDown19)),
                  Tab(icon: FaIcon(FontAwesomeIcons.futbol)),
                ],
              ),
            ),
            body: Stack(children: [
              TabBarView(children: [
                PlayerKingConstraintsEditorWidget(
                  controller: _playerKingConstraintsScriptController,
                  readOnly: widget.readOnly,
                ),
                ComputerKingContraintsEditorWidget(
                  readOnly: widget.readOnly,
                  controller: _computerKingConstraintsScriptController,
                ),
                KingsMutualConstraintEditorWidget(
                  readOnly: widget.readOnly,
                  controller: _kingsMutualConstraintsScriptController,
                ),
                OtherPiecesCountConstraintsEditorWidget(
                  readOnly: widget.readOnly,
                  onScriptUpdate: (counts) {
                    _updateOtherPiecesCountConstraintsScript(counts);
                  },
                  onKindAdded: (kind) {
                    setState(() {
                      _otherPiecesGlobalConstraintsScripts[kind] =
                          TextEditingController();
                      _otherPiecesMutualConstraintsScripts[kind] =
                          TextEditingController();
                      _otherPiecesIndexedConstraintsScripts[kind] =
                          TextEditingController();
                    });
                  },
                  onKindRemoved: (kind) {
                    setState(() {
                      // Security cleaning
                      if (_otherPiecesGlobalConstraintsSelectedPieceKind ==
                          kind) {
                        _otherPiecesGlobalConstraintsSelectedPieceKind = null;
                      }
                      if (_otherPiecesIndexedConstraintsSelectedPieceKind ==
                          kind) {
                        _otherPiecesIndexedConstraintsSelectedPieceKind = null;
                      }
                      if (_otherPiecesMutualConstraintsSelectedPieceKind ==
                          kind) {
                        _otherPiecesMutualConstraintsSelectedPieceKind = null;
                      }

                      _otherPiecesGlobalConstraintsScripts.remove(kind);
                      _otherPiecesMutualConstraintsScripts.remove(kind);
                      _otherPiecesIndexedConstraintsScripts.remove(kind);
                    });
                  },
                  currentScript: _otherPiecesCountConstraintsScript,
                ),
                OtherPiecesGlobalConstraintEditorWidget(
                  readOnly: widget.readOnly,
                  availablePiecesKinds: otherPiecesKinds,
                  controllers: _otherPiecesGlobalConstraintsScripts,
                  focusNode: _otherPiecesGlobalConstraintsFocusNode,
                  selectedPieceKind:
                      _otherPiecesGlobalConstraintsSelectedPieceKind,
                  onPieceKindSelection: (kind) {
                    setState(() {
                      _otherPiecesGlobalConstraintsSelectedPieceKind = kind;
                    });
                  },
                ),
                OtherPiecesMutualConstraintEditorWidget(
                  readOnly: widget.readOnly,
                  availablePiecesKinds: otherPiecesKinds,
                  controllers: _otherPiecesMutualConstraintsScripts,
                  focusNode: _otherPiecesMutualConstraintsFocusNode,
                  selectedPieceKind:
                      _otherPiecesMutualConstraintsSelectedPieceKind,
                  onPieceKindSelection: (kind) {
                    setState(() {
                      _otherPiecesMutualConstraintsSelectedPieceKind = kind;
                    });
                  },
                ),
                OtherPiecesIndexedConstraintEditorWidget(
                  readOnly: widget.readOnly,
                  availablePiecesKinds: otherPiecesKinds,
                  controllers: _otherPiecesIndexedConstraintsScripts,
                  focusNode: _otherPiecesIndexedConstraintsFocusNode,
                  selectedType: _otherPiecesIndexedConstraintsSelectedPieceKind,
                  onPieceKindSelection: (kind) {
                    setState(() {
                      _otherPiecesIndexedConstraintsSelectedPieceKind = kind;
                    });
                  },
                ),
                GameGoalEditorWidget(
                    readOnly: widget.readOnly,
                    script: _goalScript,
                    onChanged: (newValue) {
                      _updateGoalScript(newValue);
                    }),
              ]),
              if (_isCheckingPosition || _isSavingFile)
                const Center(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(),
                  ),
                )
            ]),
            floatingActionButton: widget.readOnly
                ? null
                : FloatingActionButton(
                    onPressed: _processUserScript,
                    child: const FaIcon(FontAwesomeIcons.solidFloppyDisk),
                  ),
          );
        }),
      ),
    );
  }
}

class PlayerKingConstraintsEditorWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool readOnly;

  const PlayerKingConstraintsEditorWidget({
    super.key,
    required this.controller,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SectionHeader(
          title: t.script_editor_page.player_king_constraint,
        ),
        Flexible(
          child: EditorWidget(
            readOnly: readOnly,
            controller: controller,
          ),
        ),
      ],
    );
  }
}

class ComputerKingContraintsEditorWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool readOnly;

  const ComputerKingContraintsEditorWidget({
    super.key,
    required this.controller,
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SectionHeader(
          title: t.script_editor_page.computer_king_constraint,
        ),
        Flexible(
          child: EditorWidget(
            readOnly: readOnly,
            controller: controller,
          ),
        ),
      ],
    );
  }
}

class KingsMutualConstraintEditorWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool readOnly;

  const KingsMutualConstraintEditorWidget({
    super.key,
    required this.controller,
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SectionHeader(
          title: t.script_editor_page.kings_mutual_constraint,
        ),
        Flexible(
          child: EditorWidget(
            controller: controller,
            readOnly: readOnly,
          ),
        ),
      ],
    );
  }
}

class OtherPiecesCountConstraintsEditorWidget extends StatefulWidget {
  final String currentScript;
  final bool readOnly;
  final void Function(Map<PieceKind, int> counts) onScriptUpdate;
  final void Function(PieceKind kind) onKindAdded;
  final void Function(PieceKind kind) onKindRemoved;

  const OtherPiecesCountConstraintsEditorWidget({
    super.key,
    required this.readOnly,
    required this.onScriptUpdate,
    required this.onKindAdded,
    required this.onKindRemoved,
    this.currentScript = "",
  });

  @override
  State<OtherPiecesCountConstraintsEditorWidget> createState() =>
      _OtherPiecesCountConstraintsEditorWidgetState();
}

class _OtherPiecesCountConstraintsEditorWidgetState
    extends State<OtherPiecesCountConstraintsEditorWidget> {
  late Map<PieceKind, int> _content;
  PieceKind? _selectedType;
  List<PieceKind> _remainingTypes = [];

  @override
  void initState() {
    _content = convertScriptToPiecesCounts(widget.currentScript);
    _content.removeWhere((key, value) {
      final type = key.toEasyString();
      return type == 'player king' || type == 'computer king';
    });
    _updateAvailableTypes();
    super.initState();
  }

  void _updateAvailableTypes() {
    final storedTypes = _content.keys;
    final remainingTypes = allSelectableTypes
        .where((element) => !storedTypes.contains(element))
        .toList();
    setState(() {
      _remainingTypes = remainingTypes;
    });
  }

  void _addCurrentCount() {
    if (_selectedType == null) return;
    if (!_remainingTypes.contains(_selectedType)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.script_editor_page.type_already_added),
        ),
      );
      return;
    }
    setState(() {
      _content[_selectedType!] = 1;
    });
    _updateAvailableTypes();
    // Here the order of following lines is important !
    widget.onKindAdded(_selectedType!);
    widget.onScriptUpdate(_content);
  }

  @override
  Widget build(BuildContext context) {
    final countChildren = <Widget>[
      for (var entry in _content.entries)
        Padding(
          padding: const EdgeInsets.all(10),
          child: PieceCountWidget(
            readOnly: widget.readOnly,
            kind: entry.key,
            initialCount: entry.value,
            onChanged: (newValue) {
              setState(() {
                _content[entry.key] = newValue;
                widget.onScriptUpdate(_content);
              });
            },
            onRemove: (valueToRemove) {
              setState(() {
                _content.removeWhere((type, count) => type == valueToRemove);
              });
              _updateAvailableTypes();
              widget.onScriptUpdate(_content);
              widget.onKindRemoved(valueToRemove);
            },
          ),
        )
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        SectionHeader(
          title: t.script_editor_page.other_pieces_count_constraint,
        ),
        if (!widget.readOnly)
          PieceCountAdderWidget(
            selectedType: _selectedType,
            onSelectionChanged: (newValue) {
              if (newValue == null) return;
              setState(() {
                _selectedType = newValue;
              });
            },
            onValidate: _addCurrentCount,
          ),
        Expanded(
          flex: 6,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: countChildren,
            ),
          ),
        ),
      ],
    );
  }
}

class OtherPiecesGlobalConstraintEditorWidget extends StatelessWidget {
  final List<PieceKind> availablePiecesKinds;
  final Map<PieceKind, TextEditingController> controllers;
  final bool readOnly;
  final PieceKind? selectedPieceKind;
  final FocusNode focusNode;
  final void Function(PieceKind) onPieceKindSelection;

  const OtherPiecesGlobalConstraintEditorWidget({
    super.key,
    required this.availablePiecesKinds,
    required this.controllers,
    required this.readOnly,
    required this.selectedPieceKind,
    required this.focusNode,
    required this.onPieceKindSelection,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SectionHeader(
          title: t.script_editor_page.other_pieces_global_constraint,
        ),
        Flexible(
          child: ComplexEditorWidget(
            readOnly: readOnly,
            availablePiecesKinds: availablePiecesKinds,
            scriptsControllersByKinds: controllers,
            selectedType: selectedPieceKind,
            focusNode: focusNode,
            onPieceKindSelection: onPieceKindSelection,
          ),
        ),
      ],
    );
  }
}

class OtherPiecesMutualConstraintEditorWidget extends StatelessWidget {
  final List<PieceKind> availablePiecesKinds;
  final Map<PieceKind, TextEditingController> controllers;
  final bool readOnly;
  final PieceKind? selectedPieceKind;
  final FocusNode focusNode;
  final void Function(PieceKind) onPieceKindSelection;

  const OtherPiecesMutualConstraintEditorWidget({
    super.key,
    required this.availablePiecesKinds,
    required this.controllers,
    required this.readOnly,
    required this.selectedPieceKind,
    required this.focusNode,
    required this.onPieceKindSelection,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SectionHeader(
          title: t.script_editor_page.other_pieces_mutual_constraint,
        ),
        Flexible(
          child: ComplexEditorWidget(
            readOnly: readOnly,
            availablePiecesKinds: availablePiecesKinds,
            scriptsControllersByKinds: controllers,
            focusNode: focusNode,
            selectedType: selectedPieceKind,
            onPieceKindSelection: onPieceKindSelection,
          ),
        ),
      ],
    );
  }
}

class OtherPiecesIndexedConstraintEditorWidget extends StatelessWidget {
  final List<PieceKind> availablePiecesKinds;
  final Map<PieceKind, TextEditingController> controllers;
  final bool readOnly;
  final PieceKind? selectedType;
  final FocusNode focusNode;
  final void Function(PieceKind) onPieceKindSelection;

  const OtherPiecesIndexedConstraintEditorWidget({
    super.key,
    required this.availablePiecesKinds,
    required this.controllers,
    required this.readOnly,
    required this.selectedType,
    required this.focusNode,
    required this.onPieceKindSelection,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SectionHeader(
          title: t.script_editor_page.other_pieces_indexed_constraint,
        ),
        Flexible(
          child: ComplexEditorWidget(
            readOnly: readOnly,
            availablePiecesKinds: availablePiecesKinds,
            scriptsControllersByKinds: controllers,
            selectedType: selectedType,
            focusNode: focusNode,
            onPieceKindSelection: onPieceKindSelection,
          ),
        ),
      ],
    );
  }
}

class GameGoalEditorWidget extends StatefulWidget {
  final String script;
  final bool readOnly;
  final void Function(bool) onChanged;

  const GameGoalEditorWidget({
    super.key,
    required this.readOnly,
    required this.script,
    required this.onChanged,
  });

  @override
  State<GameGoalEditorWidget> createState() => _GameGoalEditorWidgetState();
}

class _GameGoalEditorWidgetState extends State<GameGoalEditorWidget> {
  bool _shouldWin = true;

  @override
  void initState() {
    _shouldWin = widget.script.trim() == winningString;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SectionHeader(
          title: t.script_editor_page.game_goal,
        ),
        widget.readOnly
            ? Flexible(
                flex: 1,
                child: Center(
                  child: Text(
                    _shouldWin
                        ? t.script_editor_page.should_win
                        : t.script_editor_page.should_draw,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 30.0),
                  ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(t.script_editor_page.should_win),
                    leading: Radio<bool>(
                      groupValue: _shouldWin,
                      value: true,
                      onChanged: (newValue) {
                        if (newValue == null) return;
                        setState(() {
                          _shouldWin = newValue;
                          widget.onChanged(newValue);
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(t.script_editor_page.should_draw),
                    leading: Radio<bool>(
                      groupValue: _shouldWin,
                      value: false,
                      onChanged: (newValue) {
                        if (newValue == null) return;
                        setState(() {
                          _shouldWin = newValue;
                          widget.onChanged(newValue);
                        });
                      },
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
