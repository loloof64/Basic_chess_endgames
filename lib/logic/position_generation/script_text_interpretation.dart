// ignore_for_file: non_constant_identifier_names

import 'dart:collection';
import 'dart:isolate';

import 'package:basicchessendgamestrainer/antlr4/script_interpreter.dart';
import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/position_generation_constraints.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/position_generation_from_antlr.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

const scriptsSeparator = '@@@@@@';
const otherPiecesSingleScriptSeparator = '---';

@immutable
class TranslationsWrapper {
  final String missingScriptType;
  final String typeError;
  final String noAntlr4Token;
  final String eof;
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
  final String tooRestrictiveScriptTitle;
  final String tooRestrictiveScriptMessage;
  final String missingReturnStatement;
  final String returnStatementNotABoolean;
  final String Function({required Object Symbol}) unrecognizedSymbol;
  final String Function({required Object Name}) variableNotAffected;
  final String Function({required Object Name}) overridingPredefinedVariable;
  final String Function({required Object Type}) unrecognizedScriptType;
  final String Function({
    required Object LineNumber,
    required Object PositionInLine,
    required Object Token,
  }) noViableAltException;
  final String Function({
    required Object Expected,
    required Object Index,
    required Object Line,
    required Object Received,
  }) inputMismatch;
  final String Function({
    required Object Symbol,
    required Object ExpectedSymbols,
  }) wrongTokenAlternatives;
  final String invalidAssignment;
  final String Function({required Object Symbol}) miscSyntaxError;
  final String miscSyntaxErrorUnknownToken;
  final String errorSubstitutionEOF;
  final String errorSubstitutionVariableName;
  final String errorSubstitutionInteger;
  final String errorIfStatementMissingBlock;

  final String player;
  final String computer;

  final String pawn;
  final String knight;
  final String bishop;
  final String rook;
  final String queen;
  final String king;

  const TranslationsWrapper({
    required this.missingScriptType,
    required this.unrecognizedSymbol,
    required this.typeError,
    required this.noAntlr4Token,
    required this.eof,
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
    required this.variableNotAffected,
    required this.overridingPredefinedVariable,
    required this.unrecognizedScriptType,
    required this.noViableAltException,
    required this.inputMismatch,
    required this.wrongTokenAlternatives,
    required this.invalidAssignment,
    required this.miscSyntaxError,
    required this.miscSyntaxErrorUnknownToken,
    required this.errorSubstitutionEOF,
    required this.errorSubstitutionVariableName,
    required this.errorSubstitutionInteger,
    required this.errorIfStatementMissingBlock,
    required this.tooRestrictiveScriptTitle,
    required this.tooRestrictiveScriptMessage,
    required this.missingReturnStatement,
    required this.returnStatementNotABoolean,
    required this.player,
    required this.computer,
    required this.pawn,
    required this.knight,
    required this.bishop,
    required this.rook,
    required this.queen,
    required this.king,
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
    final lines =
        singleScript.split(RegExp(r'\r?\n')).map((line) => line.trim());
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
  (PositionGeneratorConstraintsExpr, List<InterpretationError>)
      transformTextIntoConstraints() {
    final errors = <InterpretationError>[];
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
  List<InterpretationError> _transformScriptIntoConstraint(String script) {
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
          return <InterpretationError>[];
        case ScriptType.computerKingConstraint:
          constraints.computerKingConstraint = scriptContent;
          return <InterpretationError>[];
        case ScriptType.mutualKingConstraint:
          constraints.kingsMutualConstraint = scriptContent;
          return <InterpretationError>[];
        case ScriptType.otherPiecesCount:
          final (constraint, error) = _parsePieceKindCountList(scriptContent);
          if (error != null) {
            return <InterpretationError>[error];
          } else {
            constraints.otherPiecesCountConstraint = constraint;
            return <InterpretationError>[];
          }
        case ScriptType.otherPiecesGlobalConstraint:
          final (constraint, errors) = _parseMapOfScripts(
            scriptContent,
            scriptType,
          );
          if (errors.isNotEmpty) {
            return errors;
          } else {
            constraints.otherPiecesGlobalConstraints = constraint;
            return <InterpretationError>[];
          }

        case ScriptType.otherPiecesIndexedConstraint:
          final (constraint, errors) = _parseMapOfScripts(
            scriptContent,
            scriptType,
          );
          if (errors.isNotEmpty) {
            return errors;
          } else {
            constraints.otherPiecesIndexedConstraints = constraint;
            return <InterpretationError>[];
          }
        case ScriptType.otherPiecesMutualConstraint:
          final (constraint, errors) = _parseMapOfScripts(
            scriptContent,
            scriptType,
          );
          if (errors.isNotEmpty) {
            return errors;
          } else {
            constraints.otherPiecesMutualConstraints = constraint;
            return <InterpretationError>[];
          }
        case ScriptType.goal:
          constraints.mustWin = _parseGoalScript(scriptContent);
          break;
      }
      return <InterpretationError>[];
    } on MissingScriptTypeException {
      final message = translations.missingScriptType;
      return <InterpretationError>[InterpretationError(message: message)];
    } on UnRecognizedScriptTypeException {
      final message = translations.missingScriptType;
      return <InterpretationError>[InterpretationError(message: message)];
    }
  }

  (List<PieceKindCount>, InterpretationError?) _parsePieceKindCountList(
      String scriptContent) {
    final result = <PieceKindCount>[];
    final lines = scriptContent.split('\n');
    InterpretationError? error;
    for (String singleLine in lines) {
      try {
        final parts = singleLine.split(':');
        final kindString = parts[0].trim();
        final count = int.parse(parts[1].trim());
        final kind = PieceKind.from(kindString);

        result.add(PieceKindCount(kind, count));
      } on Exception {
        error = InterpretationError(
          message: translations.fromScriptType(
              scriptType: ScriptType.otherPiecesCount, pieceKind: null),
        );
      }
    }
    return (result, error);
  }

  // can throw exceptions
  // MissingOtherPieceScriptTypeException
  // UnRecognizedScriptTypeException
  (Map<PieceKind, String>, List<InterpretationError>) _parseMapOfScripts(
      String scriptContent, ScriptType scriptType) {
    final results = <PieceKind, String>{};
    final parts = scriptContent.split(otherPiecesSingleScriptSeparator);
    final errorsList = <InterpretationError>[];

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

    return (results, errorsList);
  }

  bool _parseGoalScript(String scriptContent) {
    return scriptContent.split('\n').first.trim() == 'win';
  }
}

void generatePositionFromScript(SampleScriptGenerationParameters parameters) {
  try {
    final (constraintsExpr, generationErrors) = ScriptTextTransformer(
      allConstraintsScriptText: parameters.gameScript,
      translations: parameters.translations,
    ).transformTextIntoConstraints();
    if (generationErrors.isNotEmpty) {
      parameters.sendPort.send((null, generationErrors));
    } else {
      final positionGenerator =
          PositionGeneratorFromAntlr(translations: parameters.translations);
      positionGenerator.setConstraints(constraintsExpr);
      try {
        final generatedPosition = positionGenerator.generatePosition();
        parameters.sendPort
            .send((generatedPosition, <InterpretationError>[]));
      } on InterpretationError catch (ex) {
        Logger().e("${ex.message} (@${ex.position}) <= ${ex.scriptType}");
        parameters.sendPort.send((null, <InterpretationError>[ex]));
      } on PositionGenerationLoopException catch (ex) {
        Logger().e(ex.message);
        if (parameters.inGameMode) {
          parameters.sendPort.send(
            (
              null,
              <InterpretationError>[
                InterpretationError(
                  message:
                      parameters.translations.maxGenerationAttemptsAchieved,
                )
              ],
            ),
          );
        } else {
          parameters.sendPort.send((
            null,
            <InterpretationError>[
              InterpretationError(
                message: parameters.translations.tooRestrictiveScriptMessage,
              )
            ]
          ));
        }
      }
    }
  } on MissingOtherPieceScriptTypeException {
    parameters.sendPort.send((
      null,
      <InterpretationError>[
        InterpretationError(
          message: parameters.translations.missingScriptType,
        )
      ]
    ));
  } on UnRecognizedScriptTypeException catch (ex) {
    parameters.sendPort.send((
      null,
      <InterpretationError>[
        InterpretationError(
          message:
              parameters.translations.unrecognizedScriptType(Type: ex.type),
        )
      ]
    ));
  }
}

Future<void> showGenerationErrorsPopup({
  required List<InterpretationError> errors,
  required BuildContext context,
}) async {
  showDialog(
      context: context,
      builder: (ctx2) {
        return AlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: errors.map((singleError) {
                  return Row(children: [
                    Flexible(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(border: Border.all()),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(singleError.scriptType),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(border: Border.all()),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(singleError.position),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(border: Border.all()),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(singleError.message),
                        ),
                      ),
                    ),
                  ]);
                }).toList(),
              ),
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
  final bool inGameMode;
  final SendPort sendPort;
  final String gameScript;
  final TranslationsWrapper translations;

  SampleScriptGenerationParameters({
    required this.inGameMode,
    required this.gameScript,
    required this.sendPort,
    required this.translations,
  });
}
