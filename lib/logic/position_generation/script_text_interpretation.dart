import 'package:antlr4/antlr4.dart';
import 'package:basicchessendgamestrainer/antlr4/generated/ScriptLanguageParser.dart';
import 'package:basicchessendgamestrainer/antlr4/position_constraint_bail_error_strategy.dart';
import 'package:basicchessendgamestrainer/antlr4/script_language_boolean_expr.dart';
import 'package:basicchessendgamestrainer/antlr4/script_language_builder.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/position_generation_constraints.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/position_generation_from_antlr.dart';
import 'package:basicchessendgamestrainer/models/providers/position_generation_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const scriptsSeparator = '@@@@@@';
const otherPiecesSingleScriptSeparator = '---';

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
  otherPiecesMutualConstraint;

  // can throw UnRecognizedScriptTypeException
  static ScriptType from(String line) {
    return switch (line) {
      'player king' => ScriptType.playerKingConstraint,
      'computer king' => ScriptType.computerKingConstraint,
      'kings mutual constraint' => ScriptType.mutualKingConstraint,
      'other pieces count' => ScriptType.otherPiecesCount,
      'other pieces global constraint' =>
        ScriptType.otherPiecesGlobalConstraint,
      'other pieces indexed constraint' =>
        ScriptType.otherPiecesIndexedConstraint,
      'other pieces mutual constraint' =>
        ScriptType.otherPiecesMutualConstraint,
      _ => throw UnRecognizedScriptTypeException()
    };
  }
}

class MissingScriptTypeException implements Exception {}

class MissingOtherPieceScriptTypeException implements Exception {}

class UnRecognizedScriptTypeException implements Exception {}

class ScriptTextTransformer {
  final AppLocalizations localizations;
  final WidgetRef ref;
  final String allConstraintsScriptText;
  var constraints = PositionGeneratorConstraintsExpr();

  ScriptTextTransformer({
    required this.localizations,
    required this.ref,
    required this.allConstraintsScriptText,
  });

  PositionGeneratorConstraintsExpr transformTextIntoConstraints() {
    constraints = PositionGeneratorConstraintsExpr();
    final scripts = allConstraintsScriptText.split(scriptsSeparator);
    for (final singleScript in scripts) {
      _transformScriptIntoConstraint(singleScript);
    }
    return constraints;
  }

  void _transformScriptIntoConstraint(String script) {
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
          constraints.playerKingConstraint =
              _parseBooleanExprScript(scriptContent);
          break;
        case ScriptType.computerKingConstraint:
          constraints.computerKingConstraint =
              _parseBooleanExprScript(scriptContent);
          break;
        case ScriptType.mutualKingConstraint:
          constraints.kingsMutualConstraint =
              _parseBooleanExprScript(scriptContent);
          break;
        case ScriptType.otherPiecesCount:
          constraints.otherPiecesCountConstraint =
              _parsePieceKindCountList(scriptContent);
          break;
        case ScriptType.otherPiecesGlobalConstraint:
          constraints.otherPiecesGlobalConstraints =
              _parseMapOfBooleanExprScript(scriptContent);
          break;
        case ScriptType.otherPiecesIndexedConstraint:
          constraints.otherPiecesIndexedConstraints =
              _parseMapOfBooleanExprScript(scriptContent);
          break;
        case ScriptType.otherPiecesMutualConstraint:
          constraints.otherPiecesMutualConstraints =
              _parseMapOfBooleanExprScript(scriptContent);
          break;
      }
    } on MissingScriptTypeException {
      final title = localizations.scriptParser_miscErrorDialogTitle;
      final message = localizations.scriptParser_missingScriptType;
      ref.read(positionGenerationProvider.notifier).addError(
            PositionGenerationError(title, message),
          );
    } on UnRecognizedScriptTypeException {
      final title = localizations.scriptParser_miscErrorDialogTitle;
      final message = localizations.scriptParser_missingScriptType;
      ref.read(positionGenerationProvider.notifier).addError(
            PositionGenerationError(title, message),
          );
      ref.read(positionGenerationProvider.notifier).addError(
            PositionGenerationError(title, message),
          );
    }
  }

  ScriptLanguageBooleanExpr _parseBooleanExprScript(String scriptContent) {
    final inputStream = InputStream.fromString(scriptContent);
    final lexer = BailScriptLanguageLexer(
      localizations: localizations,
      input: inputStream,
    );
    final tokens = CommonTokenStream(lexer);
    final parser = ScriptLanguageParser(tokens);
    parser.errorHandler = PositionConstraintBailErrorStrategy(localizations);
    final tree = parser.scriptLanguage();
    final scriptBuilder =
        ScriptLanguageBuilder(localizations: localizations, ref: ref);
    return scriptBuilder.visit(tree) as ScriptLanguageBooleanExpr;
  }

  List<PieceKindCount> _parsePieceKindCountList(String scriptContent) {
    final result = <PieceKindCount>[];
    final lines = scriptContent.split('\n');
    for (String singleLine in lines) {
      final parts = singleLine.split(':');
      final kindString = parts[0].trim();
      final count = int.parse(parts[1].trim());
      final kind = PieceKind.from(kindString);

      result.add(PieceKindCount(kind, count));
    }
    return result;
  }

  // can throw exceptions
  // MissingOtherPieceScriptTypeException
  Map<PieceKind, ScriptLanguageBooleanExpr> _parseMapOfBooleanExprScript(
      String scriptContent) {
    final results = <PieceKind, ScriptLanguageBooleanExpr>{};
    final parts = scriptContent.split(otherPiecesSingleScriptSeparator);

    for (var scriptDivision in parts) {
      final divisionParts = scriptDivision.split('\n');
      final firstLine = divisionParts.firstOrNull?.trim();
      if (firstLine == null) throw MissingOtherPieceScriptTypeException();
      final strippedFirstLine = firstLine.substring(1, firstLine.length - 1);
      final kind = PieceKind.from(strippedFirstLine);
      final scriptContent = divisionParts.skip(1).join('\n');

      results[kind] = _parseBooleanExprScript(scriptContent);
    }

    return results;
  }
}
