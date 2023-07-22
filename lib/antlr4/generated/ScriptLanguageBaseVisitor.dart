// Generated from ScriptLanguage.g4 by ANTLR 4.13.0
// ignore_for_file: unused_import, unused_local_variable, prefer_single_quotes, file_names
import 'package:antlr4/antlr4.dart';

import 'ScriptLanguageParser.dart';
import 'ScriptLanguageVisitor.dart';

/// This class provides an empty implementation of [ScriptLanguageVisitor],
/// which can be extended to create a visitor which only needs to handle
/// a subset of the available methods.
///
/// [T] is the return type of the visit operation. Use `void` for
/// operations with no return type.
class ScriptLanguageBaseVisitor<T> extends ParseTreeVisitor<T>
    implements ScriptLanguageVisitor<T> {
  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitScriptLanguage(ScriptLanguageContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitNumericAssign(NumericAssignContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitBooleanAssign(BooleanAssignContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitTerminalExpr(TerminalExprContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitBooleanEquality(BooleanEqualityContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitNumericEquality(NumericEqualityContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitOrComparison(OrComparisonContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitConditionalBooleanExpr(ConditionalBooleanExprContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitBooleanVariable(BooleanVariableContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitParenthesisBooleanExpr(ParenthesisBooleanExprContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitAndComparison(AndComparisonContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitNumericRelational(NumericRelationalContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitFileConstant(FileConstantContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitRankConstant(RankConstantContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitAbsoluteNumericExpr(AbsoluteNumericExprContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitParenthesisNumericExpr(ParenthesisNumericExprContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitConditionalNumericExpr(ConditionalNumericExprContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitNumericVariable(NumericVariableContext ctx) => visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitPlusMinusNumericExpr(PlusMinusNumericExprContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitLitteralNumericExpr(LitteralNumericExprContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitRankConstantNumericExpr(RankConstantNumericExprContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitFileConstantNumericExpr(FileConstantNumericExprContext ctx) =>
      visitChildren(ctx);

  /// The default implementation returns the result of calling
  /// [visitChildren] on [ctx].
  @override
  T? visitModuloNumericExpr(ModuloNumericExprContext ctx) => visitChildren(ctx);
}
