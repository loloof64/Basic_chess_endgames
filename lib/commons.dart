import 'package:basicchessendgamestrainer/logic/position_generation/script_text_interpretation.dart';
import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

TranslationsWrapper getTranslations(BuildContext context) {
  final t = Translations.of(context);
  return TranslationsWrapper(
    missingReturnStatement: t.script_parser.no_return_statement,
    returnStatementNotABoolean: t.script_parser.return_statement_not_boolean,
    missingScriptType: t.script_parser.missing_script_type,
    maxGenerationAttemptsAchieved: t.home.max_generation_attempts_achieved,
    failedGeneratingPosition: t.home.failed_generating_position,
    unrecognizedSymbol: t.script_parser.unrecognized_token,
    typeError: t.script_parser.type_error,
    noAntlr4Token: t.script_parser.no_antlr4_token,
    eof: t.script_parser.eof,
    parenthesisWithoutExpression:
        t.script_parser.parenthesis_without_expression,
    variableNotAffected: t.script_parser.variable_not_affected,
    overridingPredefinedVariable:
        t.script_parser.overriding_predefined_variable,
    noViableAltException: t.script_parser.no_viable_alt_exception,
    inputMismatch: t.script_parser.input_mismatch,
    playerKingConstraint: t.script_type.player_king_constraint,
    computerKingConstraint: t.script_type.computer_king_constraint,
    kingsMutualConstraint: t.script_type.kings_mutual_constraint,
    otherPiecesCountConstraint: t.script_type.piece_kind_count_constraint,
    otherPiecesGlobalConstraint: t.script_type.other_pieces_global_constraint,
    otherPiecesIndexedConstraint: t.script_type.other_pieces_indexed_constraint,
    otherPiecesMutualConstraint: t.script_type.other_pieces_mutual_constraint,
    unrecognizedScriptType: t.script_parser.unrecognized_script_type,
    tooRestrictiveScriptTitle: t.script_parser.too_restrictive_script_title,
    tooRestrictiveScriptMessage: t.script_parser.too_restrictive_script_message,
    player: t.side.player,
    computer: t.side.computer,
    pawn: t.type.pawn,
    knight: t.type.knight,
    bishop: t.type.bishop,
    rook: t.type.rook,
    queen: t.type.queen,
    king: t.type.king,
    otherPiecesGlobalConstraintSpecialized:
        t.script_type.other_pieces_global_constraint_specialized,
    otherPiecesIndexedConstraintSpecialized:
        t.script_type.other_pieces_indexed_constraint_specialized,
    otherPiecesMutualConstraintSpecialized:
        t.script_type.other_pieces_mutual_constraint_specialized,
    wrongTokenAlternatives: t.script_parser.wrong_token_alternatives,
    invalidAssignment: t.script_parser.invalid_assignements,
    miscSyntaxError: t.script_parser.misc_syntaxt_error,
    miscSyntaxErrorUnknownToken:
        t.script_parser.misc_syntaxt_error_unknown_token,
    errorIfStatementMissingBlock: t.script_parser.if_statement_missing_block,
    errorSubstitutionEOF: t.script_parser.error_substitutions.eof,
    errorSubstitutionInteger: t.script_parser.error_substitutions.integer,
    errorSubstitutionVariableName:
        t.script_parser.error_substitutions.variable_name,
    variablesTableHeaderName: t.variables_table.headers.variable_name,
    variablesTableHeaderDescription:
        t.variables_table.headers.variable_description,
    variablesTableHeaderType: t.variables_table.headers.variable_type,
  );
}

void insertTextAtCursor({
  required String textToInsert,
  required TextEditingController controller,
}) {
  final text = controller.text;
  final selection = controller.selection;
  final newText =
      text.replaceRange(selection.start, selection.end, textToInsert);
  final newSelection = TextSelection.collapsed(
    offset: selection.start + textToInsert.length,
  );

  controller.value = TextEditingValue(
    text: newText,
    selection: newSelection,
  );
}
