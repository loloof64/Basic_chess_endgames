// ignore_for_file: non_constant_identifier_names

import 'dart:collection';
import 'dart:isolate';

import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/position_generation_constraints.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/position_generation_from_lua_vm.dart';
import 'package:basicchessendgamestrainer/pages/widgets/random_testing_parameters_dialog.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

const scriptsSeparator = '@@@@@@';
const otherPiecesSingleScriptSeparator = '€€€';

@immutable
class PositionGenerationError implements Exception {
  final String scriptType;
  final String message;

  const PositionGenerationError({
    required this.message,
    required this.scriptType,
  });

  factory PositionGenerationError.fromJson(Map<String, dynamic> json) {
    return PositionGenerationError(
      message: json['message'],
      scriptType: json['scriptType'],
    );
  }

  PositionGenerationError withComplexScriptType({
    required String typeLabel,
    required PieceKind pieceKind,
    required TranslationsWrapper translations,
  }) {
    return PositionGenerationError(
      message: message,
      scriptType:
          "$typeLabel [${pieceKind.toLocalizedEasyString(translations: translations)}]",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'scriptType': scriptType,
    };
  }
}

@immutable
class TranslationsWrapper {
  final String undefinedScriptType;
  final String missingScriptType;
  final String maxGenerationAttemptsAchieved;
  final String failedGeneratingPosition;
  final String playerKingConstraint;
  final String computerKingConstraint;
  final String kingsMutualConstraint;
  final String otherPiecesGlobalConstraint;
  final String otherPiecesIndexedConstraint;
  final String otherPiecesMutualConstraint;
  final String otherPiecesCountConstraint;
  final String Function({required Object PieceKind})
      otherPiecesGlobalConstraintSpecialized;
  final String Function({required Object PieceKind})
      otherPiecesIndexedConstraintSpecialized;
  final String Function({required Object PieceKind})
      otherPiecesMutualConstraintSpecialized;
  final String Function({required Object Type}) unrecognizedScriptType;
  final String miscSyntaxErrorUnknownToken;

  final String missingResultValue;

  final String player;
  final String computer;

  final String pawn;
  final String knight;
  final String bishop;
  final String rook;
  final String queen;
  final String king;

  final String variablesTableHeaderName;
  final String variablesTableHeaderDescription;
  final String variablesTableHeaderType;

  const TranslationsWrapper({
    required this.missingResultValue,
    required this.missingScriptType,
    required this.undefinedScriptType,
    required this.maxGenerationAttemptsAchieved,
    required this.failedGeneratingPosition,
    required this.playerKingConstraint,
    required this.computerKingConstraint,
    required this.kingsMutualConstraint,
    required this.otherPiecesGlobalConstraint,
    required this.otherPiecesIndexedConstraint,
    required this.otherPiecesMutualConstraint,
    required this.otherPiecesCountConstraint,
    required this.otherPiecesGlobalConstraintSpecialized,
    required this.otherPiecesIndexedConstraintSpecialized,
    required this.otherPiecesMutualConstraintSpecialized,
    required this.unrecognizedScriptType,
    required this.miscSyntaxErrorUnknownToken,
    required this.player,
    required this.computer,
    required this.pawn,
    required this.knight,
    required this.bishop,
    required this.rook,
    required this.queen,
    required this.king,
    required this.variablesTableHeaderName,
    required this.variablesTableHeaderDescription,
    required this.variablesTableHeaderType,
  });

  String fromPieceKind(PieceKind pieceKind) {
    String side = "";
    String type = "";

    switch (pieceKind.side) {
      case Side.player:
        side = player;
        break;
      case Side.computer:
        side = computer;
        break;
    }

    switch (pieceKind.pieceType) {
      case PieceType.pawn:
        type = pawn;
        break;
      case PieceType.knight:
        type = knight;
        break;
      case PieceType.bishop:
        type = bishop;
        break;
      case PieceType.rook:
        type = rook;
        break;
      case PieceType.queen:
        type = queen;
        break;
      case PieceType.king:
        type = king;
        break;
    }

    return "($side | $type)";
  }

  String fromScriptType(
      {required ScriptType scriptType, PieceKind? pieceKind}) {
    final pieceKindString = pieceKind != null ? fromPieceKind(pieceKind) : "";
    return switch (scriptType) {
      ScriptType.playerKingConstraint => playerKingConstraint,
      ScriptType.computerKingConstraint => computerKingConstraint,
      ScriptType.mutualKingConstraint => kingsMutualConstraint,
      ScriptType.otherPiecesGlobalConstraint =>
        otherPiecesGlobalConstraintSpecialized(PieceKind: pieceKindString),
      ScriptType.otherPiecesIndexedConstraint =>
        otherPiecesIndexedConstraintSpecialized(PieceKind: pieceKindString),
      ScriptType.otherPiecesMutualConstraint =>
        otherPiecesMutualConstraintSpecialized(PieceKind: pieceKindString),
      ScriptType.otherPiecesCount => otherPiecesCountConstraint,
      ScriptType.goal => "", // should not be met
    };
  }
}

bool overallScriptGoalIsToWin(String overallScriptContent) {
  final parts = overallScriptContent.split(scriptsSeparator);
  final goalPart = parts.where((singleScript) {
    final lines = singleScript
        .split(RegExp(r'\r?\n'))
        .map((line) => line.trim())
        .toList();
    return lines.contains('# goal');
  });
  if (goalPart.isEmpty) return true; // winning goal by default
  final lines = goalPart.first.split(RegExp(r'\r?\n'));
  final goalString = lines.where((elt) {
    final trimedLine = elt.trim();
    return trimedLine == 'win' || trimedLine == 'draw';
  });
  if (goalString.isEmpty) return true; // winning goal by default
  return goalString.first == 'win';
}

enum ScriptType {
  playerKingConstraint,
  computerKingConstraint,
  mutualKingConstraint,
  otherPiecesCount,
  otherPiecesGlobalConstraint,
  otherPiecesIndexedConstraint,
  otherPiecesMutualConstraint,
  goal;

  // can throw UnRecognizedScriptTypeException
  static ScriptType from(String line) {
    return switch (line) {
      'player king constraints' => ScriptType.playerKingConstraint,
      'computer king constraints' => ScriptType.computerKingConstraint,
      'kings mutual constraints' => ScriptType.mutualKingConstraint,
      'other pieces counts' => ScriptType.otherPiecesCount,
      'other pieces global constraints' =>
        ScriptType.otherPiecesGlobalConstraint,
      'other pieces indexed constraints' =>
        ScriptType.otherPiecesIndexedConstraint,
      'other pieces mutual constraints' =>
        ScriptType.otherPiecesMutualConstraint,
      'goal' => ScriptType.goal,
      _ => throw UnRecognizedScriptTypeException(line)
    };
  }
}

class MissingScriptTypeException implements Exception {}

class MissingOtherPieceScriptTypeException implements Exception {}

class UnRecognizedScriptTypeException implements Exception {
  final String type;

  const UnRecognizedScriptTypeException(this.type);
}

class ScriptTextTransformer {
  final TranslationsWrapper translations;
  final String allConstraintsScriptText;
  var constraints = PositionGeneratorConstraintsExpr();

  ScriptTextTransformer({
    required this.translations,
    required this.allConstraintsScriptText,
  });

  // can throw exceptions
  // MissingOtherPieceScriptTypeException
  // UnRecognizedScriptTypeException
  (PositionGeneratorConstraintsExpr, List<PositionGenerationError>)
      transformTextIntoConstraints() {
    final errors = <PositionGenerationError>[];
    final scripts = allConstraintsScriptText.split(scriptsSeparator);
    for (final singleScript in scripts) {
      final currentErrors = _transformScriptIntoConstraint(singleScript);
      if (currentErrors.isNotEmpty) {
        errors.addAll(currentErrors);
      }
    }
    return (constraints, errors);
  }

  // can throw exceptions
  // MissingOtherPieceScriptTypeException
  // UnRecognizedScriptTypeException
  List<PositionGenerationError> _transformScriptIntoConstraint(String script) {
    if (script.trim().isEmpty) return [];
    try {
      final lines = script.split(RegExp(r'\r?\n')).where(
            (line) => line.trim().isNotEmpty,
          );
      final firstLine = lines.firstOrNull?.trim();
      if (firstLine == null) throw MissingScriptTypeException();

      final scriptType =
          ScriptType.from(firstLine.substring(2)); // we skip the part '# '
      final scriptContent = lines.skip(1).join('\n');

      switch (scriptType) {
        case ScriptType.playerKingConstraint:
          constraints.playerKingConstraint = scriptContent;
          return <PositionGenerationError>[];
        case ScriptType.computerKingConstraint:
          constraints.computerKingConstraint = scriptContent;
          return <PositionGenerationError>[];
        case ScriptType.mutualKingConstraint:
          constraints.kingsMutualConstraint = scriptContent;
          return <PositionGenerationError>[];
        case ScriptType.otherPiecesCount:
          final (constraint, error) = _parsePieceKindCountList(scriptContent);
          if (error != null) {
            return <PositionGenerationError>[error];
          } else {
            constraints.otherPiecesCountConstraint = constraint;
            return <PositionGenerationError>[];
          }
        case ScriptType.otherPiecesGlobalConstraint:
          final constraint = _parseMapOfScripts(
            scriptContent,
            scriptType,
          );
          constraints.otherPiecesGlobalConstraints = constraint;
          return <PositionGenerationError>[];

        case ScriptType.otherPiecesIndexedConstraint:
          final constraint = _parseMapOfScripts(
            scriptContent,
            scriptType,
          );

          constraints.otherPiecesIndexedConstraints = constraint;
          return <PositionGenerationError>[];
        case ScriptType.otherPiecesMutualConstraint:
          final constraint = _parseMapOfScripts(
            scriptContent,
            scriptType,
          );

          constraints.otherPiecesMutualConstraints = constraint;
          return <PositionGenerationError>[];

        case ScriptType.goal:
          constraints.mustWin = _parseGoalScript(scriptContent);
          break;
      }
      return <PositionGenerationError>[];
    } on MissingScriptTypeException {
      final message = translations.undefinedScriptType;
      return <PositionGenerationError>[
        PositionGenerationError(
          message: message,
          scriptType: translations.undefinedScriptType,
        ),
      ];
    } on UnRecognizedScriptTypeException {
      final message = translations.undefinedScriptType;
      return <PositionGenerationError>[
        PositionGenerationError(
          message: message,
          scriptType: translations.undefinedScriptType,
        )
      ];
    } on Exception catch (ex) {
      final message = ex.toString();
      return <PositionGenerationError>[
        PositionGenerationError(
          message: message,
          scriptType: translations.undefinedScriptType,
        )
      ];
    }
  }

  (List<PieceKindCount>, PositionGenerationError?) _parsePieceKindCountList(
      String scriptContent) {
    final result = <PieceKindCount>[];
    final lines = scriptContent.split('\n');
    PositionGenerationError? error;
    for (String singleLine in lines) {
      try {
        final parts = singleLine.split(':');
        final kindString = parts[0].trim();
        final count = int.parse(parts[1].trim());
        final kind = PieceKind.from(kindString);

        result.add(PieceKindCount(kind, count));
      } on Exception {
        error = PositionGenerationError(
          message: translations.miscSyntaxErrorUnknownToken,
          scriptType: translations.fromScriptType(
              scriptType: ScriptType.otherPiecesCount, pieceKind: null),
        );
      }
    }
    return (result, error);
  }

  // can throw exception
  // MissingOtherPieceScriptTypeException
  Map<PieceKind, String> _parseMapOfScripts(
      String scriptContent, ScriptType scriptType) {
    final results = <PieceKind, String>{};
    final parts = scriptContent.split(otherPiecesSingleScriptSeparator);

    for (var scriptDivision in parts) {
      if (scriptDivision.trim().isEmpty) continue;

      final divisionParts =
          scriptDivision.split('\n').where((line) => line.trim().isNotEmpty);
      final firstLine = divisionParts.firstOrNull?.trim();
      if (firstLine == null) throw MissingOtherPieceScriptTypeException();
      final strippedFirstLine = firstLine.substring(1, firstLine.length - 1);
      final kind = PieceKind.from(strippedFirstLine);
      final scriptContent = divisionParts.skip(1).join('\n');
      results[kind] = scriptContent;
    }

    return results;
  }

  bool _parseGoalScript(String scriptContent) {
    return scriptContent.split('\n').first.trim() == 'win';
  }
}

void generatePositionsFromScript(SampleScriptGenerationParameters parameters) {
  try {
    final (constraintsExpr, generationErrors) = ScriptTextTransformer(
      allConstraintsScriptText: parameters.gameScript,
      translations: parameters.translations,
    ).transformTextIntoConstraints();
    if (generationErrors.isNotEmpty) {
      parameters.sendPort.send(
        (
          <String>[],
          <String>[],
          generationErrors
              .map(
                (singleErr) => singleErr.toJson(),
              )
              .toList(),
        ),
      );
    } else {
      final positionGenerator =
          PositionGeneratorFromLuaVM(translations: parameters.translations);
      positionGenerator.setConstraints(constraintsExpr);
      final generatedPositions = <String>[];
      final rejectedPositions = <String>[];
      try {
        for (var attemptIndex = 0;
            attemptIndex < parameters.positionsCount;
            attemptIndex++) {
          final (singleGeneratedPosition, rejectedFinalizedPositions, errors) =
              positionGenerator
                  .generatePosition(parameters.addIntermediatesPositions);
          rejectedPositions.addAll(rejectedFinalizedPositions);

          // We limit the number of errors to process
          const maxDisplayedErrors = 100;
          final limitedErrors = errors.take(maxDisplayedErrors).toList();
          if (limitedErrors.isNotEmpty) {
            for (final error in limitedErrors) {
              Logger().e("${error.message} <= ${error.scriptType}");
            }
            parameters.sendPort.send((
              <String>[],
              rejectedPositions,
              limitedErrors
                  .map(
                    (e) => e.toJson(),
                  )
                  .toList(),
            ));
          } else {
            if (singleGeneratedPosition == null) {
              parameters.sendPort.send((
                <String>[],
                rejectedPositions,
                <PositionGenerationError>[
                  PositionGenerationError(
                    scriptType: "",
                    message: parameters.translations.failedGeneratingPosition,
                  )
                ],
              ));
              return;
            }
            generatedPositions.add(singleGeneratedPosition);
          }
        }
        parameters.sendPort.send(
          (
            generatedPositions,
            rejectedPositions,
            <Map<String, dynamic>>[],
          ),
        );
      } on PositionGenerationLoopException catch (ex) {
        Logger().e(ex.message);

        parameters.sendPort.send(
          (
            <String>[],
            rejectedPositions,
            <PositionGenerationError>[
              PositionGenerationError(
                scriptType: "",
                message: parameters.translations.maxGenerationAttemptsAchieved,
              )
            ].map((e) => e.toJson()).toList(),
          ),
        );
      } on PositionGenerationError catch (ex) {
        Logger().e(ex.message);
        parameters.sendPort.send(
          (
            <String>[],
            rejectedPositions,
            <PositionGenerationError>[
              ex,
            ].map((e) => e.toJson()).toList(),
          ),
        );
      } on Exception catch (ex) {
        Logger().e(ex.toString());
        parameters.sendPort.send((
          <String>[],
          rejectedPositions,
          <PositionGenerationError>[
            PositionGenerationError(
              scriptType: "",
              message: ex.toString(),
            )
          ].map((e) => e.toJson()).toList(),
        ));
      }
    }
  } on PositionGenerationError catch (e) {
    parameters.sendPort.send((
      <String>[],
      <String>[],
      <PositionGenerationError>[e],
    ));
  } on MissingOtherPieceScriptTypeException {
    parameters.sendPort.send((
      <String>[],
      <String>[],
      <PositionGenerationError>[
        PositionGenerationError(
          scriptType: "",
          message: parameters.translations.missingScriptType,
        )
      ].map((e) => e.toJson()).toList()
    ));
  } on UnRecognizedScriptTypeException catch (ex) {
    parameters.sendPort.send((
      <String>[],
      <String>[],
      <PositionGenerationError>[
        PositionGenerationError(
          scriptType: "",
          message:
              parameters.translations.unrecognizedScriptType(Type: ex.type),
        )
      ].map((e) => e.toJson()).toList()
    ));
  } on Exception catch (ex) {
    parameters.sendPort.send((
      <String>[],
      <String>[],
      <PositionGenerationError>[
        PositionGenerationError(
          scriptType: "",
          message: ex.toString(),
        )
      ].map((e) => e.toJson()).toList()
    ));
  }
}

void checkScriptCorrectness(SampleScriptGenerationParameters parameters) {
  try {
    final (constraintsExpr, generationErrors) = ScriptTextTransformer(
      allConstraintsScriptText: parameters.gameScript,
      translations: parameters.translations,
    ).transformTextIntoConstraints();
    if (generationErrors.isNotEmpty) {
      parameters.sendPort.send(
        (
          false,
          generationErrors
              .map(
                (singleErr) => singleErr.toJson(),
              )
              .toList(),
        ),
      );
    } else {
      final positionGenerator =
          PositionGeneratorFromLuaVM(translations: parameters.translations);
      positionGenerator.setConstraints(constraintsExpr);
      try {
        final (success, errors) = positionGenerator.checkScriptCorrectness();
        if (errors.isNotEmpty) {
          for (var error in errors) {
            Logger().e("${error.message} <= ${error.scriptType}");
          }
          parameters.sendPort.send((
            false,
            errors
                .map(
                  (e) => e.toJson(),
                )
                .toList(),
          ));
        } else {
          parameters.sendPort.send(
            (
              true,
              <Map<String, dynamic>>[],
            ),
          );
        }
      } on PositionGenerationError catch (ex) {
        Logger().e("${ex.message} <= ${ex.scriptType}");
        parameters.sendPort.send((
          false,
          <PositionGenerationError>[ex].map((e) => e.toJson()).toList(),
        ));
      } on Exception catch (ex) {
        Logger().e(ex.toString());
        parameters.sendPort.send((
          false,
          <PositionGenerationError>[
            PositionGenerationError(
              scriptType: "",
              message: ex.toString(),
            )
          ].map((e) => e.toJson()).toList(),
        ));
      }
    }
  } on MissingOtherPieceScriptTypeException {
    parameters.sendPort.send((
      false,
      <PositionGenerationError>[
        PositionGenerationError(
          scriptType: "",
          message: parameters.translations.undefinedScriptType,
        )
      ].map((e) => e.toJson()).toList()
    ));
  } on UnRecognizedScriptTypeException catch (ex) {
    parameters.sendPort.send((
      false,
      <PositionGenerationError>[
        PositionGenerationError(
          scriptType: "",
          message:
              parameters.translations.unrecognizedScriptType(Type: ex.type),
        )
      ].map((e) => e.toJson()).toList()
    ));
  } on Exception catch (ex) {
    parameters.sendPort.send((
      false,
      <PositionGenerationError>[
        PositionGenerationError(
          scriptType: "",
          message: ex.toString(),
        )
      ].map((e) => e.toJson()).toList()
    ));
  }
}

Future<void> showGenerationErrorsPopup({
  required List<PositionGenerationError> errors,
  required BuildContext context,
}) async {
  showDialog(
      context: context,
      builder: (ctx2) {
        return AlertDialog(
          content: Container(
            width: double.maxFinite,
            height: 200.0,
            padding: const EdgeInsets.all(20.0),
            child: ErrorsSummaryWidget(
              items: errors,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(
                    context,
                  ).colorScheme.primary,
                ),
              ),
              child: Text(
                t.misc.button_ok,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onPrimary,
                ),
              ),
            )
          ],
        );
      });
}

class SampleScriptGenerationParameters {
  final SendPort sendPort;
  final String gameScript;
  final int positionsCount;
  final IntermediatePositionsLevel addIntermediatesPositions;
  final TranslationsWrapper translations;

  SampleScriptGenerationParameters({
    required this.gameScript,
    required this.sendPort,
    this.positionsCount = 1,
    this.addIntermediatesPositions = IntermediatePositionsLevel.none,
    required this.translations,
  });
}

class ErrorsSummaryWidget extends StatelessWidget {
  final List<PositionGenerationError> items;

  const ErrorsSummaryWidget({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Table(
            columnWidths: const {
              0: FractionColumnWidth(3 / 8),
              1: FractionColumnWidth(5 / 8),
            },
            children: [
              // Fixed content
              TableRow(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      t.home.errors_popup_labels.script_type,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      t.home.errors_popup_labels.message,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Contenu défilable
          Table(
            columnWidths: const {
              0: FractionColumnWidth(3 / 8),
              1: FractionColumnWidth(5 / 8),
            },
            children: items
                .map(
                  (err) => TableRow(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          err.scriptType,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          err.message,
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
