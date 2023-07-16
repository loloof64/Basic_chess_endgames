// Generated from ScriptLanguage.g4 by ANTLR 4.13.0
// ignore_for_file: unused_import, unused_local_variable, prefer_single_quotes, file_names
import 'package:antlr4/antlr4.dart';

import 'ScriptLanguageParser.dart';

/// This abstract class defines a complete generic visitor for a parse tree
/// produced by [ScriptLanguageParser].
///
/// [T] is the eturn type of the visit operation. Use `void` for
/// operations with no return type.
abstract class ScriptLanguageVisitor<T> extends ParseTreeVisitor<T> {
  /// Visit a parse tree produced by [ScriptLanguageParser.scriptLanguage].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitScriptLanguage(ScriptLanguageContext ctx);

  /// Visit a parse tree produced by the {@code numericAssign}
  /// labeled alternative in {@link ScriptLanguageParser#variableAssign}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitNumericAssign(NumericAssignContext ctx);

  /// Visit a parse tree produced by the {@code booleanAssign}
  /// labeled alternative in {@link ScriptLanguageParser#variableAssign}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitBooleanAssign(BooleanAssignContext ctx);

  /// Visit a parse tree produced by [ScriptLanguageParser.comment].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitComment(CommentContext ctx);

  /// Visit a parse tree produced by [ScriptLanguageParser.terminalExpr].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitTerminalExpr(TerminalExprContext ctx);

  /// Visit a parse tree produced by the {@code numericEquality}
  /// labeled alternative in {@link ScriptLanguageParser#booleanExpr}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitNumericEquality(NumericEqualityContext ctx);

  /// Visit a parse tree produced by the {@code orComparison}
  /// labeled alternative in {@link ScriptLanguageParser#booleanExpr}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitOrComparison(OrComparisonContext ctx);

  /// Visit a parse tree produced by the {@code conditionalBooleanExpr}
  /// labeled alternative in {@link ScriptLanguageParser#booleanExpr}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitConditionalBooleanExpr(ConditionalBooleanExprContext ctx);

  /// Visit a parse tree produced by the {@code booleanVariable}
  /// labeled alternative in {@link ScriptLanguageParser#booleanExpr}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitBooleanVariable(BooleanVariableContext ctx);

  /// Visit a parse tree produced by the {@code parenthesisBooleanExpr}
  /// labeled alternative in {@link ScriptLanguageParser#booleanExpr}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitParenthesisBooleanExpr(ParenthesisBooleanExprContext ctx);

  /// Visit a parse tree produced by the {@code andComparison}
  /// labeled alternative in {@link ScriptLanguageParser#booleanExpr}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitAndComparison(AndComparisonContext ctx);

  /// Visit a parse tree produced by the {@code numericRelational}
  /// labeled alternative in {@link ScriptLanguageParser#booleanExpr}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitNumericRelational(NumericRelationalContext ctx);

  /// Visit a parse tree produced by [ScriptLanguageParser.fileConstant].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitFileConstant(FileConstantContext ctx);

  /// Visit a parse tree produced by [ScriptLanguageParser.rankConstant].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitRankConstant(RankConstantContext ctx);

  /// Visit a parse tree produced by the {@code absoluteNumericExpr}
  /// labeled alternative in {@link ScriptLanguageParser#numericExpr}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitAbsoluteNumericExpr(AbsoluteNumericExprContext ctx);

  /// Visit a parse tree produced by the {@code parenthesisNumericExpr}
  /// labeled alternative in {@link ScriptLanguageParser#numericExpr}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitParenthesisNumericExpr(ParenthesisNumericExprContext ctx);

  /// Visit a parse tree produced by the {@code conditionalNumericExpr}
  /// labeled alternative in {@link ScriptLanguageParser#numericExpr}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitConditionalNumericExpr(ConditionalNumericExprContext ctx);

  /// Visit a parse tree produced by the {@code numericVariable}
  /// labeled alternative in {@link ScriptLanguageParser#numericExpr}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitNumericVariable(NumericVariableContext ctx);

  /// Visit a parse tree produced by the {@code plusMinusNumericExpr}
  /// labeled alternative in {@link ScriptLanguageParser#numericExpr}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitPlusMinusNumericExpr(PlusMinusNumericExprContext ctx);

  /// Visit a parse tree produced by the {@code litteralNumericExpr}
  /// labeled alternative in {@link ScriptLanguageParser#numericExpr}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitLitteralNumericExpr(LitteralNumericExprContext ctx);

  /// Visit a parse tree produced by the {@code rankConstantNumericExpr}
  /// labeled alternative in {@link ScriptLanguageParser#numericExpr}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitRankConstantNumericExpr(RankConstantNumericExprContext ctx);

  /// Visit a parse tree produced by the {@code fileConstantNumericExpr}
  /// labeled alternative in {@link ScriptLanguageParser#numericExpr}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitFileConstantNumericExpr(FileConstantNumericExprContext ctx);

  /// Visit a parse tree produced by the {@code moduloNumericExpr}
  /// labeled alternative in {@link ScriptLanguageParser#numericExpr}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitModuloNumericExpr(ModuloNumericExprContext ctx);
}
