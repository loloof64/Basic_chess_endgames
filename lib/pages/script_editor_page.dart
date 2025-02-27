import 'dart:io';
import 'dart:isolate';

import 'package:basicchessendgamestrainer/commons.dart';
import 'package:basicchessendgamestrainer/components/variable_insertor.dart';
import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/position_generation_constraints.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/script_text_interpretation.dart';
import 'package:basicchessendgamestrainer/pages/widgets/piece_count_widget.dart';
import 'package:basicchessendgamestrainer/pages/widgets/script_editor_common_widgets.dart';
import 'package:basicchessendgamestrainer/pages/widgets/syntax_manual_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
const otherPiecesCountTabIndex = 3;
const otherPiecesGlobalTabIndex = 4;
const otherPiecesMutualTabIndex = 5;
const otherPiecesIndexedTabIndex = 6;
const goalTabIndex = 7;

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

extension ScriptFiller on ValueNotifier<Map<PieceKind, TextEditingController>> {
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
        value[pieceKind] = TextEditingController(text: subScript);
      }
    }
    // setting also TextEditingController for those "fields" which still miss one
    for (final kind in otherPiecesKinds) {
      if (value[kind] == null) {
        value[kind] = TextEditingController(text: "");
      }
    }
  }
}

class ScriptEditorPage extends HookWidget {
  final String? originalFileName;
  final bool readOnly;
  final InitialScriptsSet initialScriptsSet;

  const ScriptEditorPage({
    super.key,
    this.originalFileName,
    this.readOnly = false,
    required this.initialScriptsSet,
  });

  void initState({
    required ValueNotifier<Map<PieceKind, TextEditingController>>
        otherPiecesGlobalConstraintsScripts,
    required ValueNotifier<Map<PieceKind, TextEditingController>>
        otherPiecesMutualConstraintsScripts,
    required ValueNotifier<Map<PieceKind, TextEditingController>>
        otherPiecesIndexedConstraintsScripts,
    required String otherPiecesCountConstraintsScript,
  }) {
    otherPiecesGlobalConstraintsScripts.fillFrom(
      initialScriptsSet.otherPiecesGlobalConstaints,
      otherPiecesCountConstraintsScript,
    );
    otherPiecesMutualConstraintsScripts.fillFrom(
      initialScriptsSet.otherPiecesMutualConstaints,
      otherPiecesCountConstraintsScript,
    );
    otherPiecesIndexedConstraintsScripts.fillFrom(
      initialScriptsSet.otherPiecesIndexedConstaints,
      otherPiecesCountConstraintsScript,
    );
  }

  void dispose({
    required ValueNotifier<Isolate?> scriptCheckerIsolate,
    required FocusNode playerKingConstraintsFocusNode,
    required FocusNode computerKingConstraintsFocusNode,
    required FocusNode kingsMutualConstraintsFocusNode,
    required FocusNode otherPiecesGlobalConstraintsFocusNode,
    required FocusNode otherPiecesMutualConstraintsFocusNode,
    required FocusNode otherPiecesIndexedConstraintsFocusNode,
    required TextEditingController playerKingConstraintsScriptController,
    required TextEditingController computerKingConstraintsScriptController,
    required TextEditingController kingsMutualConstraintsScriptController,
    required ValueNotifier<Map<PieceKind, TextEditingController>>
        otherPiecesGlobalConstraintsScripts,
    required ValueNotifier<Map<PieceKind, TextEditingController>>
        otherPiecesMutualConstraintsScripts,
    required ValueNotifier<Map<PieceKind, TextEditingController>>
        otherPiecesIndexedConstraintsScripts,
  }) {
    scriptCheckerIsolate.value?.kill(
      priority: Isolate.immediate,
    );

    playerKingConstraintsFocusNode.dispose();
    computerKingConstraintsFocusNode.dispose();
    kingsMutualConstraintsFocusNode.dispose();

    otherPiecesGlobalConstraintsFocusNode.dispose();
    otherPiecesIndexedConstraintsFocusNode.dispose();
    otherPiecesMutualConstraintsFocusNode.dispose();

    playerKingConstraintsScriptController.dispose();
    computerKingConstraintsScriptController.dispose();
    kingsMutualConstraintsScriptController.dispose();
    for (var controller in otherPiecesGlobalConstraintsScripts.value.values) {
      controller.dispose();
    }
    for (var controller in otherPiecesMutualConstraintsScripts.value.values) {
      controller.dispose();
    }
    for (var controller in otherPiecesIndexedConstraintsScripts.value.values) {
      controller.dispose();
    }
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

  void _processUserScript({
    required BuildContext context,
    required ValueNotifier<bool> isCheckingPosition,
    required ValueNotifier<bool> isSavingFile,
    required ValueNotifier<Isolate?> scriptCheckerIsolate,
    required TextEditingController playerKingConstraintsScriptController,
    required TextEditingController computerKingConstraintsScriptController,
    required TextEditingController kingsMutualConstraintsScriptController,
    required ValueNotifier<String> otherPiecesCountConstraintsScript,
    required ValueNotifier<Map<PieceKind, TextEditingController>>
        otherPiecesGlobalConstraintsScripts,
    required ValueNotifier<Map<PieceKind, TextEditingController>>
        otherPiecesMutualConstraintsScripts,
    required ValueNotifier<Map<PieceKind, TextEditingController>>
        otherPiecesIndexedConstraintsScripts,
    required String goalScript,
  }) async {
    if (isCheckingPosition.value) return;
    if (isSavingFile.value) return;

    final script = _getWholeScriptContent(
      goalScript: goalScript,
      playerKingConstraintsScriptController:
          playerKingConstraintsScriptController,
      computerKingConstraintsScriptController:
          computerKingConstraintsScriptController,
      kingsMutualConstraintsScriptController:
          kingsMutualConstraintsScriptController,
      otherPiecesCountConstraintsScript: otherPiecesCountConstraintsScript,
      otherPiecesGlobalConstraintsScripts: otherPiecesGlobalConstraintsScripts,
      otherPiecesMutualConstraintsScripts: otherPiecesMutualConstraintsScripts,
      otherPiecesIndexedConstraintsScripts:
          otherPiecesIndexedConstraintsScripts,
    );
    final receivePort = ReceivePort();

    isCheckingPosition.value = true;

    scriptCheckerIsolate.value = await Isolate.spawn(
      checkScriptCorrectness,
      SampleScriptGenerationParameters(
        gameScript: script,
        translations: getTranslations(context),
        sendPort: receivePort.sendPort,
      ),
    );

    receivePort.handleError((error) async {
      Logger().e(error);

      receivePort.close();
      scriptCheckerIsolate.value?.kill(
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

      isCheckingPosition.value = false;
    });

    receivePort.listen((message) async {
      receivePort.close();
      scriptCheckerIsolate.value?.kill(
        priority: Isolate.immediate,
      );

      isCheckingPosition.value = false;

      final (success, errorsInJsonFormat) =
          message as (bool, List<Map<String, dynamic>>);

      if (!success) {
        final errors = errorsInJsonFormat
            .map(
              (e) => PositionGenerationError.fromJson(e),
            )
            .toList();
        await showGenerationErrorsPopup(errors: errors, context: context);
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              t.script_editor_page.invalid_script,
            ),
          ),
        );
      } else {
        isSavingFile.value = true;

        if (Platform.isAndroid) {
          final filePath =
              await _openSaveFileDialogsPlugin.saveFileDialog(content: script);
          if (filePath == null) {
            debugPrint("File saving cancellation.");

            isSavingFile.value = false;

            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(t.script_editor_page.exercise_creation_success),
              ),
            );

            Navigator.of(context).pop();

            return;
          } else {
            if (!context.mounted) return;
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

            isSavingFile.value = false;

            return;
          }

          try {
            final newFile = File(filePath);

            await newFile.writeAsString(
              script,
              mode: FileMode.writeOnly,
            );

            isSavingFile.value = false;

            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(t.script_editor_page.exercise_creation_success),
              ),
            );

            Navigator.of(context).pop();

            return;
          } on FileSystemException {
            isSavingFile.value = false;

            if (!context.mounted) return;
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

  String _getWholeScriptContent({
    required TextEditingController playerKingConstraintsScriptController,
    required TextEditingController computerKingConstraintsScriptController,
    required TextEditingController kingsMutualConstraintsScriptController,
    required ValueNotifier<String> otherPiecesCountConstraintsScript,
    required ValueNotifier<Map<PieceKind, TextEditingController>>
        otherPiecesGlobalConstraintsScripts,
    required ValueNotifier<Map<PieceKind, TextEditingController>>
        otherPiecesMutualConstraintsScripts,
    required ValueNotifier<Map<PieceKind, TextEditingController>>
        otherPiecesIndexedConstraintsScripts,
    required String goalScript,
  }) {
    var result = "";

    if (playerKingConstraintsScriptController.value.text.isNotEmpty) {
      result += "# player king constraints\n\n";
      result += playerKingConstraintsScriptController.value.text;
      result += "\n\n$scriptsSeparator\n\n";
    }

    if (computerKingConstraintsScriptController.value.text.isNotEmpty) {
      result += "# computer king constraints\n\n";
      result += computerKingConstraintsScriptController.value.text;
      result += "\n\n$scriptsSeparator\n\n";
    }

    if (kingsMutualConstraintsScriptController.value.text.isNotEmpty) {
      result += "# kings mutual constraints\n\n";
      result += kingsMutualConstraintsScriptController.value.text;
      result += "\n\n$scriptsSeparator\n\n";
    }

    if (otherPiecesCountConstraintsScript.value.isNotEmpty) {
      result += "# other pieces counts\n\n";
      result += otherPiecesCountConstraintsScript.value;
      result += "\n\n$scriptsSeparator\n\n";
    }

    if (otherPiecesGlobalConstraintsScripts.value.isNotEmpty) {
      var temp = "";
      for (var kind in otherPiecesGlobalConstraintsScripts.value.keys) {
        if (otherPiecesGlobalConstraintsScripts.value[kind]!.text.isEmpty) {
          continue;
        }
        temp += "[${kind.toEasyString()}]\n\n";
        temp += otherPiecesGlobalConstraintsScripts.value[kind]!.text;
        temp += "\n\n$otherPiecesSingleScriptSeparator\n\n";
      }
      if (temp.isNotEmpty) {
        result += "# other pieces global constraints\n\n";
        result += temp;
        result += "\n\n$scriptsSeparator\n\n";
      }
    }

    if (otherPiecesMutualConstraintsScripts.value.isNotEmpty) {
      var temp = "";
      for (var kind in otherPiecesMutualConstraintsScripts.value.keys) {
        if (otherPiecesMutualConstraintsScripts.value[kind]!.text.isEmpty) {
          continue;
        }
        temp += "[${kind.toEasyString()}]\n\n";
        temp += otherPiecesMutualConstraintsScripts.value[kind]!.text;
        temp += "\n\n$otherPiecesSingleScriptSeparator\n\n";
      }
      if (temp.isNotEmpty) {
        result += "# other pieces mutual constraints\n\n";
        result += temp;
        result += "\n\n$scriptsSeparator\n\n";
      }
    }

    if (otherPiecesIndexedConstraintsScripts.value.isNotEmpty) {
      var temp = "";
      for (var kind in otherPiecesIndexedConstraintsScripts.value.keys) {
        if (otherPiecesIndexedConstraintsScripts.value[kind]!.text.isEmpty) {
          continue;
        }
        temp += "[${kind.toEasyString()}]\n\n";
        temp += otherPiecesIndexedConstraintsScripts.value[kind]!.text;
        temp += "\n\n$otherPiecesSingleScriptSeparator\n\n";
      }
      if (temp.isNotEmpty) {
        result += "# other pieces indexed constraints\n\n";
        result += temp;
        result += "\n\n$scriptsSeparator\n\n";
      }
    }

    result += "# goal\n\n";
    result += goalScript;

    return result;
  }

  void _updateOtherPiecesCountConstraintsScript({
    required Map<PieceKind, int> counts,
    required ValueNotifier<String> otherPiecesCountConstraintsScript,
  }) {
    final script = [
      for (var entry in counts.entries)
        "${entry.key.toEasyString()} : ${entry.value}"
    ].join("\n");
    otherPiecesCountConstraintsScript.value = script;
  }

  void _updateGoalScript({
    required bool shouldWin,
    required ValueNotifier<String> goalScript,
  }) {
    goalScript.value = shouldWin ? winningString : drawingString;
  }

  List<PieceKind> _getOtherPiecesKindsFromPiecesCountScript(String script) {
    return convertScriptToPiecesCounts(script).keys.toList();
  }

  void _handleExitPage({
    required bool didPop,
    required BuildContext context,
  }) async {
    if (didPop) return;
    if (readOnly) {
      Navigator.of(context).pop();
      return;
    }

    await showDialog<bool>(
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

  void _focusEditor({
    required int selectedTabIndex,
    required FocusNode playerKingConstraintsFocusNode,
    required FocusNode computerKingConstraintsFocusNode,
    required FocusNode kingsMutualConstraintsFocusNode,
    required FocusNode otherPiecesGlobalConstraintsFocusNode,
    required FocusNode otherPiecesMutualConstraintsFocusNode,
    required FocusNode otherPiecesIndexedConstraintsFocusNode,
    required ValueNotifier<PieceKind?>
        otherPiecesGlobalConstraintsSelectedPieceKind,
    required ValueNotifier<PieceKind?>
        otherPiecesMutualConstraintsSelectedPieceKind,
    required ValueNotifier<PieceKind?>
        otherPiecesIndexedConstraintsSelectedPieceKind,
  }) {
    if (selectedTabIndex == playeKingTabIndex) {
      playerKingConstraintsFocusNode.requestFocus();
    } else if (selectedTabIndex == computerKingTabIndex) {
      computerKingConstraintsFocusNode.requestFocus();
    } else if (selectedTabIndex == kingsMutualTabIndex) {
      kingsMutualConstraintsFocusNode.requestFocus();
    } else if (selectedTabIndex == otherPiecesGlobalTabIndex) {
      if (otherPiecesGlobalConstraintsSelectedPieceKind.value == null) {
        return;
      }
      otherPiecesGlobalConstraintsFocusNode.requestFocus();
    } else if (selectedTabIndex == otherPiecesIndexedTabIndex) {
      if (otherPiecesIndexedConstraintsSelectedPieceKind.value == null) {
        return;
      }
      otherPiecesIndexedConstraintsFocusNode.requestFocus();
    } else if (selectedTabIndex == otherPiecesMutualTabIndex) {
      if (otherPiecesMutualConstraintsSelectedPieceKind.value == null) {
        return;
      }
      otherPiecesMutualConstraintsFocusNode.requestFocus();
    }
  }

  TextEditingController? _getControllerForCurrentScript({
    required int selectedTabIndex,
    required TextEditingController playerKingConstraintsScriptController,
    required TextEditingController computerKingConstraintsScriptController,
    required TextEditingController kingsMutualConstraintsScriptController,
    required PieceKind? otherPiecesGlobalConstraintsSelectedPieceKind,
    required PieceKind? otherPiecesMutualConstraintsSelectedPieceKind,
    required PieceKind? otherPiecesIndexedConstraintsSelectedPieceKind,
    required Map<PieceKind, TextEditingController>
        otherPiecesGlobalConstraintsScripts,
    required Map<PieceKind, TextEditingController>
        otherPiecesMutualConstraintsScripts,
    required Map<PieceKind, TextEditingController>
        otherPiecesIndexedConstraintsScripts,
  }) {
    TextEditingController? controller;

    if (selectedTabIndex == playeKingTabIndex) {
      controller = playerKingConstraintsScriptController;
    } else if (selectedTabIndex == computerKingTabIndex) {
      controller = computerKingConstraintsScriptController;
    } else if (selectedTabIndex == kingsMutualTabIndex) {
      controller = kingsMutualConstraintsScriptController;
    } else if (selectedTabIndex == otherPiecesGlobalTabIndex) {
      if (otherPiecesGlobalConstraintsSelectedPieceKind == null) {
        return null;
      }
      controller = otherPiecesGlobalConstraintsScripts[
          otherPiecesGlobalConstraintsSelectedPieceKind];
    } else if (selectedTabIndex == otherPiecesIndexedTabIndex) {
      if (otherPiecesIndexedConstraintsSelectedPieceKind == null) {
        return null;
      }
      controller = otherPiecesIndexedConstraintsScripts[
          otherPiecesIndexedConstraintsSelectedPieceKind];
    } else if (selectedTabIndex == otherPiecesMutualTabIndex) {
      if (otherPiecesMutualConstraintsSelectedPieceKind == null) {
        return null;
      }
      controller = otherPiecesMutualConstraintsScripts[
          otherPiecesMutualConstraintsSelectedPieceKind];
    }

    return controller;
  }

  List<List<String>> _getInsertVariableForCurrentScript(int selectedTabIndex) {
    return switch (selectedTabIndex) {
      playeKingTabIndex ||
      computerKingTabIndex =>
        _getPlayerKingConstraintsVariablesData(),
      kingsMutualTabIndex => _getKingsMutualConstraintsVariablesData(),
      otherPiecesGlobalTabIndex =>
        _getOtherPiecesGlobalConstraintsVariablesData(),
      otherPiecesIndexedTabIndex =>
        _getOtherPiecesIndexedConstraintsVariablesData(),
      otherPiecesMutualTabIndex =>
        _getOtherPiecesMutualConstraintsVariablesData(),
      _ => throw Exception(
          "Cannot insert variable for this kind of selected tab index : $selectedTabIndex")
    };
  }

  Future<void> _showInsertVariableDialog({
    required List<List<String>> data,
    required TextEditingController? controller,
    required BuildContext context,
    required int selectedTabIndex,
    required FocusNode playerKingConstraintsFocusNode,
    required FocusNode computerKingConstraintsFocusNode,
    required FocusNode kingsMutualConstraintsFocusNode,
    required FocusNode otherPiecesGlobalConstraintsFocusNode,
    required FocusNode otherPiecesMutualConstraintsFocusNode,
    required FocusNode otherPiecesIndexedConstraintsFocusNode,
    required ValueNotifier<PieceKind?>
        otherPiecesGlobalConstraintsSelectedPieceKind,
    required ValueNotifier<PieceKind?>
        otherPiecesMutualConstraintsSelectedPieceKind,
    required ValueNotifier<PieceKind?>
        otherPiecesIndexedConstraintsSelectedPieceKind,
  }) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              readOnly
                  ? t.script_editor_page.consult_variables_title
                  : t.script_editor_page.insert_variable_title,
            ),
            content: VariableInsertor(
              translations: getTranslations(context),
              data: data,
              controller: controller,
              onDone: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                _focusEditor(
                  selectedTabIndex: selectedTabIndex,
                  playerKingConstraintsFocusNode:
                      playerKingConstraintsFocusNode,
                  computerKingConstraintsFocusNode:
                      computerKingConstraintsFocusNode,
                  kingsMutualConstraintsFocusNode:
                      kingsMutualConstraintsFocusNode,
                  otherPiecesGlobalConstraintsFocusNode:
                      otherPiecesGlobalConstraintsFocusNode,
                  otherPiecesMutualConstraintsFocusNode:
                      otherPiecesMutualConstraintsFocusNode,
                  otherPiecesIndexedConstraintsFocusNode:
                      otherPiecesIndexedConstraintsFocusNode,
                  otherPiecesGlobalConstraintsSelectedPieceKind:
                      otherPiecesGlobalConstraintsSelectedPieceKind,
                  otherPiecesMutualConstraintsSelectedPieceKind:
                      otherPiecesMutualConstraintsSelectedPieceKind,
                  otherPiecesIndexedConstraintsSelectedPieceKind:
                      otherPiecesIndexedConstraintsSelectedPieceKind,
                );
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

  Future<void> _purposeInsertCommonConstant({
    required int selectedTabIndex,
    required BuildContext context,
    required FocusNode playerKingConstraintsFocusNode,
    required FocusNode computerKingConstraintsFocusNode,
    required FocusNode kingsMutualConstraintsFocusNode,
    required FocusNode otherPiecesGlobalConstraintsFocusNode,
    required FocusNode otherPiecesMutualConstraintsFocusNode,
    required FocusNode otherPiecesIndexedConstraintsFocusNode,
    required ValueNotifier<PieceKind?>
        otherPiecesGlobalConstraintsSelectedPieceKind,
    required ValueNotifier<PieceKind?>
        otherPiecesMutualConstraintsSelectedPieceKind,
    required ValueNotifier<PieceKind?>
        otherPiecesIndexedConstraintsSelectedPieceKind,
    required TextEditingController playerKingConstraintsScriptController,
    required TextEditingController computerKingConstraintsScriptController,
    required TextEditingController kingsMutualConstraintsScriptController,
    required Map<PieceKind, TextEditingController>
        otherPiecesGlobalConstraintsScripts,
    required Map<PieceKind, TextEditingController>
        otherPiecesMutualConstraintsScripts,
    required Map<PieceKind, TextEditingController>
        otherPiecesIndexedConstraintsScripts,
  }) async {
    final data = _getCommonVariablesData();

    if (readOnly) {
      await _showInsertVariableDialog(
        data: data,
        controller: null,
        context: context,
        selectedTabIndex: selectedTabIndex,
        playerKingConstraintsFocusNode: playerKingConstraintsFocusNode,
        computerKingConstraintsFocusNode: computerKingConstraintsFocusNode,
        kingsMutualConstraintsFocusNode: kingsMutualConstraintsFocusNode,
        otherPiecesGlobalConstraintsFocusNode:
            otherPiecesGlobalConstraintsFocusNode,
        otherPiecesMutualConstraintsFocusNode:
            otherPiecesMutualConstraintsFocusNode,
        otherPiecesIndexedConstraintsFocusNode:
            otherPiecesIndexedConstraintsFocusNode,
        otherPiecesGlobalConstraintsSelectedPieceKind:
            otherPiecesGlobalConstraintsSelectedPieceKind,
        otherPiecesMutualConstraintsSelectedPieceKind:
            otherPiecesMutualConstraintsSelectedPieceKind,
        otherPiecesIndexedConstraintsSelectedPieceKind:
            otherPiecesIndexedConstraintsSelectedPieceKind,
      );
      return;
    }

    final isInPiecesCountTabOrInGoalTab =
        (selectedTabIndex == 3) || (selectedTabIndex == 7);
    if (isInPiecesCountTabOrInGoalTab) {
      return;
    }

    final controller = _getControllerForCurrentScript(
      selectedTabIndex: selectedTabIndex,
      playerKingConstraintsScriptController:
          playerKingConstraintsScriptController,
      computerKingConstraintsScriptController:
          computerKingConstraintsScriptController,
      kingsMutualConstraintsScriptController:
          kingsMutualConstraintsScriptController,
      otherPiecesGlobalConstraintsScripts: otherPiecesGlobalConstraintsScripts,
      otherPiecesMutualConstraintsScripts: otherPiecesMutualConstraintsScripts,
      otherPiecesIndexedConstraintsScripts:
          otherPiecesIndexedConstraintsScripts,
      otherPiecesGlobalConstraintsSelectedPieceKind:
          otherPiecesGlobalConstraintsSelectedPieceKind.value,
      otherPiecesMutualConstraintsSelectedPieceKind:
          otherPiecesMutualConstraintsSelectedPieceKind.value,
      otherPiecesIndexedConstraintsSelectedPieceKind:
          otherPiecesIndexedConstraintsSelectedPieceKind.value,
    );
    final noTextFieldActive = controller == null;
    if (noTextFieldActive) {
      return;
    }

    return await _showInsertVariableDialog(
      data: data,
      controller: controller,
      context: context,
      playerKingConstraintsFocusNode: playerKingConstraintsFocusNode,
      computerKingConstraintsFocusNode: computerKingConstraintsFocusNode,
      kingsMutualConstraintsFocusNode: kingsMutualConstraintsFocusNode,
      otherPiecesGlobalConstraintsFocusNode:
          otherPiecesGlobalConstraintsFocusNode,
      otherPiecesMutualConstraintsFocusNode:
          otherPiecesMutualConstraintsFocusNode,
      otherPiecesIndexedConstraintsFocusNode:
          otherPiecesIndexedConstraintsFocusNode,
      otherPiecesGlobalConstraintsSelectedPieceKind:
          otherPiecesGlobalConstraintsSelectedPieceKind,
      otherPiecesMutualConstraintsSelectedPieceKind:
          otherPiecesMutualConstraintsSelectedPieceKind,
      otherPiecesIndexedConstraintsSelectedPieceKind:
          otherPiecesIndexedConstraintsSelectedPieceKind,
      selectedTabIndex: selectedTabIndex,
    );
  }

  Future<void> _purposeInsertScriptVariable({
    required int selectedTabIndex,
    required BuildContext context,
    required FocusNode playerKingConstraintsFocusNode,
    required FocusNode computerKingConstraintsFocusNode,
    required FocusNode kingsMutualConstraintsFocusNode,
    required FocusNode otherPiecesGlobalConstraintsFocusNode,
    required FocusNode otherPiecesMutualConstraintsFocusNode,
    required FocusNode otherPiecesIndexedConstraintsFocusNode,
    required ValueNotifier<PieceKind?>
        otherPiecesGlobalConstraintsSelectedPieceKind,
    required ValueNotifier<PieceKind?>
        otherPiecesMutualConstraintsSelectedPieceKind,
    required ValueNotifier<PieceKind?>
        otherPiecesIndexedConstraintsSelectedPieceKind,
    required TextEditingController playerKingConstraintsScriptController,
    required TextEditingController computerKingConstraintsScriptController,
    required TextEditingController kingsMutualConstraintsScriptController,
    required Map<PieceKind, TextEditingController>
        otherPiecesGlobalConstraintsScripts,
    required Map<PieceKind, TextEditingController>
        otherPiecesMutualConstraintsScripts,
    required Map<PieceKind, TextEditingController>
        otherPiecesIndexedConstraintsScripts,
  }) async {
    final data = _getInsertVariableForCurrentScript(selectedTabIndex);

    if (readOnly) {
      await _showInsertVariableDialog(
        data: data,
        context: context,
        controller: null,
        playerKingConstraintsFocusNode: playerKingConstraintsFocusNode,
        computerKingConstraintsFocusNode: computerKingConstraintsFocusNode,
        kingsMutualConstraintsFocusNode: kingsMutualConstraintsFocusNode,
        otherPiecesGlobalConstraintsFocusNode:
            otherPiecesGlobalConstraintsFocusNode,
        otherPiecesMutualConstraintsFocusNode:
            otherPiecesMutualConstraintsFocusNode,
        otherPiecesIndexedConstraintsFocusNode:
            otherPiecesIndexedConstraintsFocusNode,
        otherPiecesGlobalConstraintsSelectedPieceKind:
            otherPiecesGlobalConstraintsSelectedPieceKind,
        otherPiecesMutualConstraintsSelectedPieceKind:
            otherPiecesMutualConstraintsSelectedPieceKind,
        otherPiecesIndexedConstraintsSelectedPieceKind:
            otherPiecesIndexedConstraintsSelectedPieceKind,
        selectedTabIndex: selectedTabIndex,
      );
      return;
    }

    final isInPiecesCountTabOrInGoalTab =
        (selectedTabIndex == 3) || (selectedTabIndex == 7);
    if (isInPiecesCountTabOrInGoalTab) {
      return;
    }

    final controller = _getControllerForCurrentScript(
      playerKingConstraintsScriptController:
          playerKingConstraintsScriptController,
      computerKingConstraintsScriptController:
          computerKingConstraintsScriptController,
      kingsMutualConstraintsScriptController:
          kingsMutualConstraintsScriptController,
      otherPiecesGlobalConstraintsScripts: otherPiecesGlobalConstraintsScripts,
      otherPiecesMutualConstraintsScripts: otherPiecesMutualConstraintsScripts,
      otherPiecesIndexedConstraintsScripts:
          otherPiecesIndexedConstraintsScripts,
      otherPiecesGlobalConstraintsSelectedPieceKind:
          otherPiecesGlobalConstraintsSelectedPieceKind.value,
      otherPiecesMutualConstraintsSelectedPieceKind:
          otherPiecesMutualConstraintsSelectedPieceKind.value,
      otherPiecesIndexedConstraintsSelectedPieceKind:
          otherPiecesIndexedConstraintsSelectedPieceKind.value,
      selectedTabIndex: selectedTabIndex,
    );
    final noTextFieldActive = controller == null;
    if (noTextFieldActive) {
      return;
    }

    return await _showInsertVariableDialog(
      data: data,
      controller: controller,
      context: context,
      selectedTabIndex: selectedTabIndex,
      playerKingConstraintsFocusNode: playerKingConstraintsFocusNode,
      computerKingConstraintsFocusNode: computerKingConstraintsFocusNode,
      kingsMutualConstraintsFocusNode: kingsMutualConstraintsFocusNode,
      otherPiecesGlobalConstraintsFocusNode:
          otherPiecesGlobalConstraintsFocusNode,
      otherPiecesMutualConstraintsFocusNode:
          otherPiecesMutualConstraintsFocusNode,
      otherPiecesIndexedConstraintsFocusNode:
          otherPiecesIndexedConstraintsFocusNode,
      otherPiecesGlobalConstraintsSelectedPieceKind:
          otherPiecesGlobalConstraintsSelectedPieceKind,
      otherPiecesMutualConstraintsSelectedPieceKind:
          otherPiecesMutualConstraintsSelectedPieceKind,
      otherPiecesIndexedConstraintsSelectedPieceKind:
          otherPiecesIndexedConstraintsSelectedPieceKind,
    );
  }

  void _purposeInsertVariable({
    required BuildContext context,
    required int selectedTabIndex,
    required ValueNotifier<PieceKind?>
        otherPiecesGlobalConstraintsSelectedPieceKind,
    required ValueNotifier<PieceKind?>
        otherPiecesMutualConstraintsSelectedPieceKind,
    required ValueNotifier<PieceKind?>
        otherPiecesIndexedConstraintsSelectedPieceKind,
    required FocusNode playerKingConstraintsFocusNode,
    required FocusNode computerKingConstraintsFocusNode,
    required FocusNode kingsMutualConstraintsFocusNode,
    required FocusNode otherPiecesGlobalConstraintsFocusNode,
    required FocusNode otherPiecesMutualConstraintsFocusNode,
    required FocusNode otherPiecesIndexedConstraintsFocusNode,
    required TextEditingController playerKingConstraintsScriptController,
    required TextEditingController computerKingConstraintsScriptController,
    required TextEditingController kingsMutualConstraintsScriptController,
    required Map<PieceKind, TextEditingController>
        otherPiecesGlobalConstraintsScripts,
    required Map<PieceKind, TextEditingController>
        otherPiecesMutualConstraintsScripts,
    required Map<PieceKind, TextEditingController>
        otherPiecesIndexedConstraintsScripts,
  }) async {
    final notATextEditor = (selectedTabIndex == otherPiecesCountTabIndex) ||
        (selectedTabIndex == goalTabIndex);
    if (notATextEditor) return;

    final noPieceKindSelected =
        (selectedTabIndex == otherPiecesGlobalTabIndex &&
                otherPiecesGlobalConstraintsSelectedPieceKind.value == null) ||
            (selectedTabIndex == otherPiecesMutualTabIndex &&
                otherPiecesMutualConstraintsSelectedPieceKind.value == null) ||
            (selectedTabIndex == otherPiecesIndexedTabIndex &&
                otherPiecesIndexedConstraintsSelectedPieceKind.value == null);

    if (noPieceKindSelected) {
      return;
    }

    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text(
              readOnly
                  ? t.script_editor_page.consult_variables_title
                  : t.script_editor_page.insert_variable_title,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => _purposeInsertScriptVariable(
                      context: context,
                      playerKingConstraintsFocusNode:
                          playerKingConstraintsFocusNode,
                      computerKingConstraintsFocusNode:
                          computerKingConstraintsFocusNode,
                      kingsMutualConstraintsFocusNode:
                          kingsMutualConstraintsFocusNode,
                      otherPiecesGlobalConstraintsFocusNode:
                          otherPiecesGlobalConstraintsFocusNode,
                      otherPiecesMutualConstraintsFocusNode:
                          otherPiecesMutualConstraintsFocusNode,
                      otherPiecesIndexedConstraintsFocusNode:
                          otherPiecesIndexedConstraintsFocusNode,
                      playerKingConstraintsScriptController:
                          playerKingConstraintsScriptController,
                      computerKingConstraintsScriptController:
                          computerKingConstraintsScriptController,
                      kingsMutualConstraintsScriptController:
                          kingsMutualConstraintsScriptController,
                      otherPiecesGlobalConstraintsScripts:
                          otherPiecesGlobalConstraintsScripts,
                      otherPiecesMutualConstraintsScripts:
                          otherPiecesMutualConstraintsScripts,
                      otherPiecesIndexedConstraintsScripts:
                          otherPiecesIndexedConstraintsScripts,
                      otherPiecesGlobalConstraintsSelectedPieceKind:
                          otherPiecesGlobalConstraintsSelectedPieceKind,
                      otherPiecesMutualConstraintsSelectedPieceKind:
                          otherPiecesMutualConstraintsSelectedPieceKind,
                      otherPiecesIndexedConstraintsSelectedPieceKind:
                          otherPiecesIndexedConstraintsSelectedPieceKind,
                      selectedTabIndex: selectedTabIndex,
                    ),
                    child: Text(
                      t.script_editor_page.choice_script_variables,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => _purposeInsertCommonConstant(
                      context: context,
                      playerKingConstraintsFocusNode:
                          playerKingConstraintsFocusNode,
                      computerKingConstraintsFocusNode:
                          computerKingConstraintsFocusNode,
                      kingsMutualConstraintsFocusNode:
                          kingsMutualConstraintsFocusNode,
                      otherPiecesGlobalConstraintsFocusNode:
                          otherPiecesGlobalConstraintsFocusNode,
                      otherPiecesMutualConstraintsFocusNode:
                          otherPiecesMutualConstraintsFocusNode,
                      otherPiecesIndexedConstraintsFocusNode:
                          otherPiecesIndexedConstraintsFocusNode,
                      playerKingConstraintsScriptController:
                          playerKingConstraintsScriptController,
                      computerKingConstraintsScriptController:
                          computerKingConstraintsScriptController,
                      kingsMutualConstraintsScriptController:
                          kingsMutualConstraintsScriptController,
                      otherPiecesGlobalConstraintsScripts:
                          otherPiecesGlobalConstraintsScripts,
                      otherPiecesMutualConstraintsScripts:
                          otherPiecesMutualConstraintsScripts,
                      otherPiecesIndexedConstraintsScripts:
                          otherPiecesIndexedConstraintsScripts,
                      otherPiecesGlobalConstraintsSelectedPieceKind:
                          otherPiecesGlobalConstraintsSelectedPieceKind,
                      otherPiecesMutualConstraintsSelectedPieceKind:
                          otherPiecesMutualConstraintsSelectedPieceKind,
                      otherPiecesIndexedConstraintsSelectedPieceKind:
                          otherPiecesIndexedConstraintsSelectedPieceKind,
                      selectedTabIndex: selectedTabIndex,
                    ),
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
    final isCheckingPosition = useState(false);
    final isSavingFile = useState(false);
    final scriptCheckerIsolate = useState<Isolate?>(null);
    final selectedTabIndex = useState(playeKingTabIndex);

    final playerKingConstraintsScriptController =
        useTextEditingController(text: initialScriptsSet.playerKingConstraints);
    final computerKingConstraintsScriptController = useTextEditingController(
        text: initialScriptsSet.computerKingConstraints);
    final kingsMutualConstraintsScriptController = useTextEditingController(
        text: initialScriptsSet.kingsMutualConstraints);

    final otherPiecesGlobalConstraintsScripts =
        useState(<PieceKind, TextEditingController>{});
    final otherPiecesMutualConstraintsScripts =
        useState(<PieceKind, TextEditingController>{});
    final otherPiecesIndexedConstraintsScripts =
        useState(<PieceKind, TextEditingController>{});
    final otherPiecesCountConstraintsScript =
        useState(initialScriptsSet.otherPiecesCountConstraints);
    final goalScript =
        useState(initialScriptsSet.winningGoal ? winningString : drawingString);

    final otherPiecesKinds = _getOtherPiecesKindsFromPiecesCountScript(
        otherPiecesCountConstraintsScript.value);

    final notATextEditor =
        (selectedTabIndex.value == otherPiecesCountTabIndex) ||
            (selectedTabIndex.value == goalTabIndex);

    final playerKingConstraintsFocusNode = useFocusNode();
    final computerKingConstraintsFocusNode = useFocusNode();
    final kingsMutualConstraintsFocusNode = useFocusNode();
    final otherPiecesGlobalConstraintsFocusNode = useFocusNode();
    final otherPiecesIndexedConstraintsFocusNode = useFocusNode();
    final otherPiecesMutualConstraintsFocusNode = useFocusNode();

    final otherPiecesGlobalConstraintsSelectedPieceKind =
        useState<PieceKind?>(null);
    final otherPiecesIndexedConstraintsSelectedPieceKind =
        useState<PieceKind?>(null);
    final otherPiecesMutualConstraintsSelectedPieceKind =
        useState<PieceKind?>(null);

    useEffect(() {
      initState(
        otherPiecesGlobalConstraintsScripts:
            otherPiecesGlobalConstraintsScripts,
        otherPiecesMutualConstraintsScripts:
            otherPiecesMutualConstraintsScripts,
        otherPiecesIndexedConstraintsScripts:
            otherPiecesIndexedConstraintsScripts,
        otherPiecesCountConstraintsScript:
            otherPiecesCountConstraintsScript.value,
      );

      return () => dispose(
            scriptCheckerIsolate: scriptCheckerIsolate,
            playerKingConstraintsFocusNode: playerKingConstraintsFocusNode,
            computerKingConstraintsFocusNode: computerKingConstraintsFocusNode,
            kingsMutualConstraintsFocusNode: kingsMutualConstraintsFocusNode,
            otherPiecesGlobalConstraintsFocusNode:
                otherPiecesGlobalConstraintsFocusNode,
            otherPiecesMutualConstraintsFocusNode:
                otherPiecesMutualConstraintsFocusNode,
            otherPiecesIndexedConstraintsFocusNode:
                otherPiecesIndexedConstraintsFocusNode,
            playerKingConstraintsScriptController:
                playerKingConstraintsScriptController,
            computerKingConstraintsScriptController:
                computerKingConstraintsScriptController,
            kingsMutualConstraintsScriptController:
                kingsMutualConstraintsScriptController,
            otherPiecesGlobalConstraintsScripts:
                otherPiecesGlobalConstraintsScripts,
            otherPiecesMutualConstraintsScripts:
                otherPiecesMutualConstraintsScripts,
            otherPiecesIndexedConstraintsScripts:
                otherPiecesIndexedConstraintsScripts,
          );
    }, []);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) =>
          _handleExitPage(context: context, didPop: didPop),
      child: DefaultTabController(
        length: 8,
        child: Builder(builder: (context) {
          final TabController tabController = DefaultTabController.of(context);
          tabController.addListener(() {
            if (!tabController.indexIsChanging) {
              final index = tabController.index;
              selectedTabIndex.value = index;
            }
          });
          return Scaffold(
            appBar: AppBar(
              title: Text(
                t.script_editor_page.title,
              ),
              actions: [
                if (!notATextEditor)
                  IconButton(
                    onPressed: () => _purposeInsertVariable(
                      context: context,
                      selectedTabIndex: selectedTabIndex.value,
                      playerKingConstraintsFocusNode:
                          playerKingConstraintsFocusNode,
                      computerKingConstraintsFocusNode:
                          computerKingConstraintsFocusNode,
                      kingsMutualConstraintsFocusNode:
                          kingsMutualConstraintsFocusNode,
                      otherPiecesGlobalConstraintsFocusNode:
                          otherPiecesGlobalConstraintsFocusNode,
                      otherPiecesMutualConstraintsFocusNode:
                          otherPiecesMutualConstraintsFocusNode,
                      otherPiecesIndexedConstraintsFocusNode:
                          otherPiecesIndexedConstraintsFocusNode,
                      playerKingConstraintsScriptController:
                          playerKingConstraintsScriptController,
                      computerKingConstraintsScriptController:
                          computerKingConstraintsScriptController,
                      kingsMutualConstraintsScriptController:
                          kingsMutualConstraintsScriptController,
                      otherPiecesGlobalConstraintsScripts:
                          otherPiecesGlobalConstraintsScripts.value,
                      otherPiecesMutualConstraintsScripts:
                          otherPiecesMutualConstraintsScripts.value,
                      otherPiecesIndexedConstraintsScripts:
                          otherPiecesIndexedConstraintsScripts.value,
                      otherPiecesGlobalConstraintsSelectedPieceKind:
                          otherPiecesGlobalConstraintsSelectedPieceKind,
                      otherPiecesMutualConstraintsSelectedPieceKind:
                          otherPiecesMutualConstraintsSelectedPieceKind,
                      otherPiecesIndexedConstraintsSelectedPieceKind:
                          otherPiecesIndexedConstraintsSelectedPieceKind,
                    ),
                    icon: const FaIcon(
                      FontAwesomeIcons.book,
                    ),
                  ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return const SyntaxManualPage();
                      }),
                    );
                  },
                  icon: const FaIcon(
                    FontAwesomeIcons.circleQuestion,
                  ),
                )
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
                  controller: playerKingConstraintsScriptController,
                  focusNode: playerKingConstraintsFocusNode,
                  readOnly: readOnly,
                ),
                ComputerKingContraintsEditorWidget(
                  readOnly: readOnly,
                  focusNode: computerKingConstraintsFocusNode,
                  controller: computerKingConstraintsScriptController,
                ),
                KingsMutualConstraintEditorWidget(
                  readOnly: readOnly,
                  focusNode: kingsMutualConstraintsFocusNode,
                  controller: kingsMutualConstraintsScriptController,
                ),
                OtherPiecesCountConstraintsEditorWidget(
                  readOnly: readOnly,
                  onScriptUpdate: (counts) {
                    _updateOtherPiecesCountConstraintsScript(
                      counts: counts,
                      otherPiecesCountConstraintsScript:
                          otherPiecesCountConstraintsScript,
                    );
                  },
                  onKindAdded: (kind) {
                    otherPiecesGlobalConstraintsScripts.value[kind] =
                        TextEditingController();
                    otherPiecesMutualConstraintsScripts.value[kind] =
                        TextEditingController();
                    otherPiecesIndexedConstraintsScripts.value[kind] =
                        TextEditingController();
                  },
                  onKindRemoved: (kind) {
                    // Security cleaning
                    if (otherPiecesGlobalConstraintsSelectedPieceKind.value ==
                        kind) {
                      otherPiecesGlobalConstraintsSelectedPieceKind.value =
                          null;
                    }
                    if (otherPiecesIndexedConstraintsSelectedPieceKind.value ==
                        kind) {
                      otherPiecesIndexedConstraintsSelectedPieceKind.value =
                          null;
                    }
                    if (otherPiecesMutualConstraintsSelectedPieceKind.value ==
                        kind) {
                      otherPiecesMutualConstraintsSelectedPieceKind.value =
                          null;
                    }

                    otherPiecesGlobalConstraintsScripts.value.remove(kind);
                    otherPiecesMutualConstraintsScripts.value.remove(kind);
                    otherPiecesIndexedConstraintsScripts.value.remove(kind);
                  },
                  currentScript: otherPiecesCountConstraintsScript.value,
                ),
                OtherPiecesGlobalConstraintEditorWidget(
                  readOnly: readOnly,
                  availablePiecesKinds: otherPiecesKinds,
                  controllers: otherPiecesGlobalConstraintsScripts,
                  focusNode: otherPiecesGlobalConstraintsFocusNode,
                  selectedPieceKind:
                      otherPiecesGlobalConstraintsSelectedPieceKind.value,
                  onPieceKindSelection: (kind) {
                    otherPiecesGlobalConstraintsSelectedPieceKind.value = kind;
                  },
                ),
                OtherPiecesMutualConstraintEditorWidget(
                  readOnly: readOnly,
                  availablePiecesKinds: otherPiecesKinds,
                  controllers: otherPiecesMutualConstraintsScripts,
                  focusNode: otherPiecesMutualConstraintsFocusNode,
                  selectedPieceKind:
                      otherPiecesMutualConstraintsSelectedPieceKind.value,
                  onPieceKindSelection: (kind) {
                    otherPiecesMutualConstraintsSelectedPieceKind.value = kind;
                  },
                ),
                OtherPiecesIndexedConstraintEditorWidget(
                  readOnly: readOnly,
                  availablePiecesKinds: otherPiecesKinds,
                  controllers: otherPiecesIndexedConstraintsScripts,
                  focusNode: otherPiecesIndexedConstraintsFocusNode,
                  selectedType:
                      otherPiecesIndexedConstraintsSelectedPieceKind.value,
                  onPieceKindSelection: (kind) {
                    otherPiecesIndexedConstraintsSelectedPieceKind.value = kind;
                  },
                ),
                GameGoalEditorWidget(
                    readOnly: readOnly,
                    script: goalScript.value,
                    onChanged: (newValue) {
                      _updateGoalScript(
                        shouldWin: newValue,
                        goalScript: goalScript,
                      );
                    }),
              ]),
              if (isCheckingPosition.value || isSavingFile.value)
                const Center(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(),
                  ),
                )
            ]),
            floatingActionButton: readOnly
                ? null
                : FloatingActionButton(
                    onPressed: () => _processUserScript(
                      context: context,
                      goalScript: goalScript.value,
                      isSavingFile: isSavingFile,
                      isCheckingPosition: isCheckingPosition,
                      playerKingConstraintsScriptController:
                          playerKingConstraintsScriptController,
                      computerKingConstraintsScriptController:
                          computerKingConstraintsScriptController,
                      kingsMutualConstraintsScriptController:
                          kingsMutualConstraintsScriptController,
                      otherPiecesGlobalConstraintsScripts:
                          otherPiecesGlobalConstraintsScripts,
                      otherPiecesMutualConstraintsScripts:
                          otherPiecesMutualConstraintsScripts,
                      otherPiecesIndexedConstraintsScripts:
                          otherPiecesIndexedConstraintsScripts,
                      otherPiecesCountConstraintsScript:
                          otherPiecesCountConstraintsScript,
                      scriptCheckerIsolate: scriptCheckerIsolate,
                    ),
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
  final FocusNode focusNode;

  const PlayerKingConstraintsEditorWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.readOnly,
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
            focusNode: focusNode,
          ),
        ),
      ],
    );
  }
}

class ComputerKingContraintsEditorWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool readOnly;
  final FocusNode focusNode;

  const ComputerKingContraintsEditorWidget({
    super.key,
    required this.controller,
    required this.readOnly,
    required this.focusNode,
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
            focusNode: focusNode,
          ),
        ),
      ],
    );
  }
}

class KingsMutualConstraintEditorWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool readOnly;
  final FocusNode focusNode;

  const KingsMutualConstraintEditorWidget({
    super.key,
    required this.controller,
    required this.readOnly,
    required this.focusNode,
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
            focusNode: focusNode,
          ),
        ),
      ],
    );
  }
}

class OtherPiecesCountConstraintsEditorWidget extends HookWidget {
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

  void initState({
    required ValueNotifier<Map<PieceKind, int>> content,
    required ValueNotifier<PieceKind?> selectedType,
    required ValueNotifier<List<PieceKind>> remainingTypes,
  }) {
    content.value = convertScriptToPiecesCounts(currentScript);
    content.value.removeWhere((key, value) {
      final type = key.toEasyString();
      return type == 'player king' || type == 'computer king';
    });
    _updateAvailableTypes(
      content: content,
      remainingTypes: remainingTypes,
    );
  }

  void _updateAvailableTypes({
    required ValueNotifier<Map<PieceKind, int>> content,
    required ValueNotifier<List<PieceKind>> remainingTypes,
  }) {
    final storedTypes = content.value.keys;
    final tempRemainingTypes = allSelectableTypes
        .where((element) => !storedTypes.contains(element))
        .toList();
    remainingTypes.value = tempRemainingTypes;
  }

  void _addCurrentCount({
    required BuildContext context,
    required ValueNotifier<Map<PieceKind, int>> content,
    required ValueNotifier<PieceKind?> selectedType,
    required ValueNotifier<List<PieceKind>> remainingTypes,
  }) {
    if (selectedType.value == null) return;
    if (!remainingTypes.value.contains(selectedType.value)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.script_editor_page.type_already_added),
        ),
      );
      return;
    }
    content.value[selectedType.value!] = 1;
    _updateAvailableTypes(
      content: content,
      remainingTypes: remainingTypes,
    );
    // Here the order of following lines is important !
    onKindAdded(selectedType.value!);
    onScriptUpdate(content.value);
  }

  @override
  Widget build(BuildContext context) {
    final content = useState(<PieceKind, int>{});
    final selectedType = useState<PieceKind?>(null);
    final remainingTypes = useState(<PieceKind>[]);

    useEffect(() {
      initState(
        content: content,
        selectedType: selectedType,
        remainingTypes: remainingTypes,
      );
      return null;
    }, []);

    final countChildren = <Widget>[
      for (var entry in content.value.entries)
        Padding(
          padding: const EdgeInsets.all(10),
          child: PieceCountWidget(
            readOnly: readOnly,
            kind: entry.key,
            initialCount: entry.value,
            onChanged: (newValue) {
              content.value[entry.key] = newValue;
              onScriptUpdate(content.value);
            },
            onRemove: (valueToRemove) {
              content.value.removeWhere((type, count) => type == valueToRemove);

              _updateAvailableTypes(
                content: content,
                remainingTypes: remainingTypes,
              );
              onScriptUpdate(content.value);
              onKindRemoved(valueToRemove);
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
        if (!readOnly)
          PieceCountAdderWidget(
            selectedType: selectedType.value,
            onSelectionChanged: (newValue) {
              if (newValue == null) return;
              selectedType.value = newValue;
            },
            onValidate: () => _addCurrentCount(
              context: context,
              content: content,
              selectedType: selectedType,
              remainingTypes: remainingTypes,
            ),
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
  final ValueNotifier<Map<PieceKind, TextEditingController>> controllers;
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
  final ValueNotifier<Map<PieceKind, TextEditingController>> controllers;
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
  final ValueNotifier<Map<PieceKind, TextEditingController>> controllers;
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

class GameGoalEditorWidget extends HookWidget {
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
  Widget build(BuildContext context) {
    final shouldWin = useState(true);
    useEffect(() {
      shouldWin.value = script.trim() == winningString;
      return null;
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SectionHeader(
          title: t.script_editor_page.game_goal,
        ),
        readOnly
            ? Flexible(
                flex: 1,
                child: Center(
                  child: Text(
                    shouldWin.value
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
                      groupValue: shouldWin.value,
                      value: true,
                      onChanged: (newValue) {
                        if (newValue == null) return;
                        shouldWin.value = newValue;
                        onChanged(newValue);
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(t.script_editor_page.should_draw),
                    leading: Radio<bool>(
                      groupValue: shouldWin.value,
                      value: false,
                      onChanged: (newValue) {
                        if (newValue == null) return;
                        shouldWin.value = newValue;
                        onChanged(newValue);
                      },
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
