import 'package:basicchessendgamestrainer/antlr4/script_language_boolean_expr.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/position_generation_constraints.dart';

class PositionGeneratorConstraintsExpr {
  final ScriptLanguageBooleanExpr? playerKingConstraint;
  final ScriptLanguageBooleanExpr? computerKingConstraint;
  final ScriptLanguageBooleanExpr? kingsMutualConstraint;
  final List<PieceKindCount> otherPiecesCountConstraint;
  final Map<PieceKind, ScriptLanguageBooleanExpr?> otherPiecesGlobalConstraints;
  final Map<PieceKind, ScriptLanguageBooleanExpr?> otherPiecesMutualConstraints;
  final Map<PieceKind, ScriptLanguageBooleanExpr?>
      otherPiecesIndexedConstraints;

  PositionGeneratorConstraintsExpr({
    this.playerKingConstraint,
    this.computerKingConstraint,
    this.kingsMutualConstraint,
    this.otherPiecesCountConstraint = const <PieceKindCount>[],
    this.otherPiecesGlobalConstraints =
        const <PieceKind, ScriptLanguageBooleanExpr?>{},
    this.otherPiecesMutualConstraints =
        const <PieceKind, ScriptLanguageBooleanExpr?>{},
    this.otherPiecesIndexedConstraints =
        const <PieceKind, ScriptLanguageBooleanExpr?>{},
  });
}

class PositionGeneratorConstraintsScripts {
  final bool resultShouldBeDraw;
  final String playerKingConstraint;
  final String computerKingConstraint;
  final String kingsMutualConstraint;
  final String otherPiecesCountConstraint;
  final String otherPiecesGlobalContraints;
  final String otherPiecesMutualContraints;
  final String otherPiecesIndexedContraints;

  PositionGeneratorConstraintsScripts({
    required this.resultShouldBeDraw,
    required this.playerKingConstraint,
    required this.computerKingConstraint,
    required this.kingsMutualConstraint,
    required this.otherPiecesCountConstraint,
    required this.otherPiecesGlobalContraints,
    required this.otherPiecesMutualContraints,
    required this.otherPiecesIndexedContraints,
  });
}

const int maxLoopsIterations = 1000;

class PositionGeneratorFromAntlr {}
