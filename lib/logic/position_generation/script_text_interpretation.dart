// ignore_for_file: non_constant_identifier_names

import 'dart:collection';
import 'dart:isolate';

import 'package:antlr4/antlr4.dart';
import 'package:basicchessendgamestrainer/antlr4/script_language_boolean_expr.dart';
import 'package:basicchessendgamestrainer/antlr4/script_language_builder.dart';
import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/position_generation_constraints.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/position_generation_from_antlr.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

const scriptsSeparator = '@@@@@@';
const otherPiecesSingleScriptSeparator = '---';
const positionGenerationErrorDialogSpacer = 20.0;

@immutable
class PositionGenerationError {
  final String title;
  final String message;

  const PositionGenerationError(
    this.title,
    this.message,
  );
}

@immutable
class TranslationsWrapper {
  final String miscErrorDialogTitle;
  final String missingScriptType;
  final String miscParseError;
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
  final String Function({required Object Symbol}) unrecognizedSymbol;
  final String Function({required Object Name}) variableNotAffected;
  final String Function({required Object Name}) overridingPredefinedVariable;
  final String Function({required Object Title}) parseErrorDialogTitle;
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

  const TranslationsWrapper({
    required this.miscErrorDialogTitle,
    required this.missingScriptType,
    required this.miscParseError,
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
    required this.variableNotAffected,
    required this.overridingPredefinedVariable,
    required this.parseErrorDialogTitle,
    required this.unrecognizedScriptType,
    required this.noViableAltException,
    required this.inputMismatch,
  });

  String fromScriptType(ScriptType scriptType) {
    return switch (scriptType) {
      ScriptType.playerKingConstraint => playerKingConstraint,
      ScriptType.computerKingConstraint => computerKingConstraint,
      ScriptType.mutualKingConstraint => kingsMutualConstraint,
      ScriptType.otherPiecesGlobalConstraint => otherPiecesGlobalConstraint,
      ScriptType.otherPiecesIndexedConstraint => otherPiecesIndexedConstraint,
      ScriptType.otherPiecesMutualConstraint => otherPiecesMutualConstraint,
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
          final (constraint, errors) =
              _parseBooleanExprScript(scriptContent, scriptType);
          if (errors.isNotEmpty) {
            return errors;
          } else {
            constraints.playerKingConstraint = constraint;
            return <PositionGenerationError>[];
          }
        case ScriptType.computerKingConstraint:
          final (constraint, errors) =
              _parseBooleanExprScript(scriptContent, scriptType);
          if (errors.isNotEmpty) {
            return errors;
          } else {
            constraints.computerKingConstraint = constraint;
            return <PositionGenerationError>[];
          }
        case ScriptType.mutualKingConstraint:
          final (constraint, errors) =
              _parseBooleanExprScript(scriptContent, scriptType);
          if (errors.isNotEmpty) {
            return errors;
          } else {
            constraints.kingsMutualConstraint = constraint;
            return <PositionGenerationError>[];
          }
        case ScriptType.otherPiecesCount:
          final (constraint, error) = _parsePieceKindCountList(scriptContent);
          if (error != null) {
            return <PositionGenerationError>[error];
          } else {
            constraints.otherPiecesCountConstraint = constraint;
            return <PositionGenerationError>[];
          }
        case ScriptType.otherPiecesGlobalConstraint:
          final (constraint, errors) = _parseMapOfBooleanExprScript(
            scriptContent,
            scriptType,
          );
          if (errors.isNotEmpty) {
            return errors;
          } else {
            constraints.otherPiecesGlobalConstraints = constraint;
            return <PositionGenerationError>[];
          }

        case ScriptType.otherPiecesIndexedConstraint:
          final (constraint, errors) = _parseMapOfBooleanExprScript(
            scriptContent,
            scriptType,
          );
          if (errors.isNotEmpty) {
            return errors;
          } else {
            constraints.otherPiecesIndexedConstraints = constraint;
            return <PositionGenerationError>[];
          }
        case ScriptType.otherPiecesMutualConstraint:
          final (constraint, errors) = _parseMapOfBooleanExprScript(
            scriptContent,
            scriptType,
          );
          if (errors.isNotEmpty) {
            return errors;
          } else {
            constraints.otherPiecesMutualConstraints = constraint;
            return <PositionGenerationError>[];
          }
        case ScriptType.goal:
          constraints.mustWin = _parseGoalScript(scriptContent);
          break;
      }
      return <PositionGenerationError>[];
    } on MissingScriptTypeException {
      final title = translations.miscErrorDialogTitle;
      final message = translations.missingScriptType;
      return <PositionGenerationError>[PositionGenerationError(title, message)];
    } on UnRecognizedScriptTypeException {
      final title = translations.miscErrorDialogTitle;
      final message = translations.missingScriptType;
      return <PositionGenerationError>[PositionGenerationError(title, message)];
    }
  }

  (
    LinkedHashMap<String, ScriptLanguageGenericExpr>?,
    List<PositionGenerationError>
  ) _parseBooleanExprScript(
    String scriptContent,
    ScriptType scriptType,
  ) {
    try {
      final builder = ScriptLanguageBuilder(translations: translations);
      final constraint =
          builder.buildExpressionObjectsFromScript(scriptContent);
      return (constraint, <PositionGenerationError>[]);
    } on VariableIsNotAffectedException catch (ex) {
      final scriptTypeLabel = translations.fromScriptType(scriptType);
      final title = translations.parseErrorDialogTitle(Title: scriptTypeLabel);
      final message = translations.variableNotAffected(Name: ex.varName);
      Logger().e(ex);
      // Add the error to the errors we must show once all scripts for
      // the position generation are built.
      return (
        null,
        <PositionGenerationError>[PositionGenerationError(title, message)]
      );
    } on ParseCancellationException catch (ex) {
      final scriptTypeLabel = translations.fromScriptType(scriptType);
      final title = translations.parseErrorDialogTitle(Title: scriptTypeLabel);
      final message = ex.message;
      Logger().e(ex);
      // Add the error to the errors we must show once all scripts for
      // the position generation are built.
      return (
        null,
        <PositionGenerationError>[PositionGenerationError(title, message)]
      );
    } on TypeError catch (ex) {
      final scriptTypeLabel = translations.fromScriptType(scriptType);
      final title = translations.parseErrorDialogTitle(Title: scriptTypeLabel);
      final message = translations.typeError;
      Logger().e(ex);
      // Add the error to the errors we must show once all scripts for
      // the position generation are built.
      return (
        null,
        <PositionGenerationError>[PositionGenerationError(title, message)]
      );
    } on Exception catch (ex) {
      final scriptTypeLabel = translations.fromScriptType(scriptType);
      final title = translations.parseErrorDialogTitle(Title: scriptTypeLabel);
      final message = translations.miscParseError;
      Logger().e(ex);
      // Add the error to the errors we must show once all scripts for
      // the position generation are built.
      return (
        null,
        <PositionGenerationError>[PositionGenerationError(title, message)]
      );
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
          translations.fromScriptType(ScriptType.otherPiecesCount),
          translations.miscParseError,
        );
      }
    }
    return (result, error);
  }

  // can throw exceptions
  // MissingOtherPieceScriptTypeException
  // UnRecognizedScriptTypeException
  (
    Map<PieceKind, LinkedHashMap<String, ScriptLanguageGenericExpr>?>,
    List<PositionGenerationError>
  ) _parseMapOfBooleanExprScript(String scriptContent, ScriptType scriptType) {
    final results =
        <PieceKind, LinkedHashMap<String, ScriptLanguageGenericExpr>?>{};
    final parts = scriptContent.split(otherPiecesSingleScriptSeparator);
    final errorsList = <PositionGenerationError>[];

    for (var scriptDivision in parts) {
      if (scriptDivision.trim().isEmpty) continue;
      
      final divisionParts =
          scriptDivision.split('\n').where((line) => line.trim().isNotEmpty);
      final firstLine = divisionParts.firstOrNull?.trim();
      if (firstLine == null) throw MissingOtherPieceScriptTypeException();
      final strippedFirstLine = firstLine.substring(1, firstLine.length - 1);
      final kind = PieceKind.from(strippedFirstLine);
      final scriptContent = divisionParts.skip(1).join('\n');

      final (constraints, errors) =
          _parseBooleanExprScript(scriptContent, scriptType);
      if (errors.isNotEmpty) {
        errorsList.addAll(errors);
      } else {
        results[kind] = constraints;
      }
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
      final positionGenerator = PositionGeneratorFromAntlr();
      positionGenerator.setConstraints(constraintsExpr);
      try {
        final generatedPosition = positionGenerator.generatePosition();
        parameters.sendPort
            .send((generatedPosition, <PositionGenerationError>[]));
      } on PositionGenerationLoopException catch (ex) {
        Logger().e(ex.message);
        if (parameters.inGameMode) {
          parameters.sendPort.send(
          (
            null,
            <PositionGenerationError>[
              PositionGenerationError(
                parameters.translations.miscErrorDialogTitle,
                parameters.translations.maxGenerationAttemptsAchieved,
              )
            ],
          ),
        );
        }
        else {
          parameters.sendPort
            .send(("", <PositionGenerationError>[]));
        }
      }
    }
  } on MissingOtherPieceScriptTypeException {
    parameters.sendPort.send((
      null,
      <PositionGenerationError>[
        PositionGenerationError(
          parameters.translations.miscErrorDialogTitle,
          parameters.translations.missingScriptType,
        )
      ]
    ));
  } on UnRecognizedScriptTypeException catch (ex) {
    parameters.sendPort.send((
      null,
      <PositionGenerationError>[
        PositionGenerationError(
          parameters.translations.miscErrorDialogTitle,
          parameters.translations.unrecognizedScriptType(Type: ex.type),
        )
      ]
    ));
  }
}

Future<void> showGenerationErrorsPopups({
  required List<PositionGenerationError> errors,
  required BuildContext context,
}) async {
  for (final singleError in errors) {
    showDialog(
        context: context,
        builder: (ctx2) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(singleError.title),
                  const SizedBox(
                    height: positionGenerationErrorDialogSpacer,
                  ),
                  Text(singleError.message),
                  const SizedBox(
                    height: positionGenerationErrorDialogSpacer,
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
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
              ),
            ),
          );
        });
  }
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
