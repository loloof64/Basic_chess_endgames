// Generated from Lua.g4 by ANTLR 4.13.1
// ignore_for_file: unused_import, unused_local_variable, prefer_single_quotes, file_names
import 'package:antlr4/antlr4.dart';

import 'LuaParser.dart';

/// This abstract class defines a complete generic visitor for a parse tree
/// produced by [LuaParser].
///
/// [T] is the eturn type of the visit operation. Use `void` for
/// operations with no return type.
abstract class LuaVisitor<T> extends ParseTreeVisitor<T> {
  /// Visit a parse tree produced by [LuaParser.start_].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitStart_(Start_Context ctx);

  /// Visit a parse tree produced by [LuaParser.chunk].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitChunk(ChunkContext ctx);

  /// Visit a parse tree produced by [LuaParser.block].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitBlock(BlockContext ctx);

  /// Visit a parse tree produced by [LuaParser.returnStat].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitReturnStat(ReturnStatContext ctx);

  /// Visit a parse tree produced by the {@code semiColumnExec}
  /// labeled alternative in {@link LuaParser#stat}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitSemiColumnExec(SemiColumnExecContext ctx);

  /// Visit a parse tree produced by the {@code assignExec}
  /// labeled alternative in {@link LuaParser#stat}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitAssignExec(AssignExecContext ctx);

  /// Visit a parse tree produced by the {@code ifExec}
  /// labeled alternative in {@link LuaParser#stat}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitIfExec(IfExecContext ctx);

  /// Visit a parse tree produced by [LuaParser.assign].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitAssign(AssignContext ctx);

  /// Visit a parse tree produced by [LuaParser.ifstat].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitIfstat(IfstatContext ctx);

  /// Visit a parse tree produced by [LuaParser.namelist].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitNamelist(NamelistContext ctx);

  /// Visit a parse tree produced by [LuaParser.explist].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitExplist(ExplistContext ctx);

  /// Visit a parse tree produced by the {@code prefixExpr}
  /// labeled alternative in {@link LuaParser#exp}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitPrefixExpr(PrefixExprContext ctx);

  /// Visit a parse tree produced by the {@code unaryExpr}
  /// labeled alternative in {@link LuaParser#exp}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitUnaryExpr(UnaryExprContext ctx);

  /// Visit a parse tree produced by the {@code exponentExpr}
  /// labeled alternative in {@link LuaParser#exp}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitExponentExpr(ExponentExprContext ctx);

  /// Visit a parse tree produced by the {@code trueExpr}
  /// labeled alternative in {@link LuaParser#exp}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitTrueExpr(TrueExprContext ctx);

  /// Visit a parse tree produced by the {@code numberExpr}
  /// labeled alternative in {@link LuaParser#exp}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitNumberExpr(NumberExprContext ctx);

  /// Visit a parse tree produced by the {@code plusMinusExpr}
  /// labeled alternative in {@link LuaParser#exp}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitPlusMinusExpr(PlusMinusExprContext ctx);

  /// Visit a parse tree produced by the {@code booleanAndExpr}
  /// labeled alternative in {@link LuaParser#exp}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitBooleanAndExpr(BooleanAndExprContext ctx);

  /// Visit a parse tree produced by the {@code booleanOrExpr}
  /// labeled alternative in {@link LuaParser#exp}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitBooleanOrExpr(BooleanOrExprContext ctx);

  /// Visit a parse tree produced by the {@code mulDivModuloExpr}
  /// labeled alternative in {@link LuaParser#exp}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitMulDivModuloExpr(MulDivModuloExprContext ctx);

  /// Visit a parse tree produced by the {@code intBinaryLogicalExpr}
  /// labeled alternative in {@link LuaParser#exp}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitIntBinaryLogicalExpr(IntBinaryLogicalExprContext ctx);

  /// Visit a parse tree produced by the {@code falseExpr}
  /// labeled alternative in {@link LuaParser#exp}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitFalseExpr(FalseExprContext ctx);

  /// Visit a parse tree produced by the {@code booleanBinaryLogicalExpr}
  /// labeled alternative in {@link LuaParser#exp}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitBooleanBinaryLogicalExpr(BooleanBinaryLogicalExprContext ctx);

  /// Visit a parse tree produced by the {@code variablePrefix}
  /// labeled alternative in {@link LuaParser#prefix}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitVariablePrefix(VariablePrefixContext ctx);

  /// Visit a parse tree produced by the {@code parenthesisPrefix}
  /// labeled alternative in {@link LuaParser#prefix}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitParenthesisPrefix(ParenthesisPrefixContext ctx);

  /// Visit a parse tree produced by the {@code integerValue}
  /// labeled alternative in {@link LuaParser#number}.
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitIntegerValue(IntegerValueContext ctx);
}