import 'package:basicchessendgamestrainer/logic/position_generation/script_text_interpretation.dart';
import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:flutter/material.dart';

TranslationsWrapper getTranslations(BuildContext context) {
  final t = Translations.of(context);
  return TranslationsWrapper(
  missingReturnStatement: t.script_parser.no_return_statement,
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
  overridingPredefinedVariable: t.script_parser.overriding_predefined_variable,
  parseErrorDialogTitle: t.script_parser.parse_error_dialog_title,
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
);
}