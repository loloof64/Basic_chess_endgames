import 'dart:math';

import 'package:basicchessendgamestrainer/antlr4/script_language_boolean_expr.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/position_generation_constraints.dart';
import 'package:chess/chess.dart' as chess;

class _BoardCoordinate {
  final int file;
  final int rank;

  _BoardCoordinate(this.file, this.rank);

  String toUciString() {
    final fileString = String.fromCharCode('a'.codeUnitAt(0) + file);
    final rankString = String.fromCharCode('1'.codeUnitAt(0) + rank);

    return "$fileString$rankString";
  }
}

class PositionGenerationLoopException implements Exception {
  final String? message;

  PositionGenerationLoopException({this.message});
}

class PositionGeneratorConstraintsExpr {
  ScriptLanguageBooleanExpr? playerKingConstraint;
  ScriptLanguageBooleanExpr? computerKingConstraint;
  ScriptLanguageBooleanExpr? kingsMutualConstraint;
  List<PieceKindCount> otherPiecesCountConstraint;
  Map<PieceKind, ScriptLanguageBooleanExpr?> otherPiecesGlobalConstraints;
  Map<PieceKind, ScriptLanguageBooleanExpr?> otherPiecesMutualConstraints;
  Map<PieceKind, ScriptLanguageBooleanExpr?> otherPiecesIndexedConstraints;

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

const int maxLoopsForSinglePiecePlacement = 50;
const int maxOtherPiecesPlacementTries = 50;
final noConstraint = PositionGeneratorConstraintsExpr(
  playerKingConstraint: null,
  computerKingConstraint: null,
  kingsMutualConstraint: null,
  otherPiecesCountConstraint: <PieceKindCount>[],
  otherPiecesGlobalConstraints: <PieceKind, ScriptLanguageBooleanExpr?>{},
  otherPiecesMutualConstraints: <PieceKind, ScriptLanguageBooleanExpr?>{},
  otherPiecesIndexedConstraints: <PieceKind, ScriptLanguageBooleanExpr?>{},
);

final defaultBoardCoordinate = _BoardCoordinate(0, 0);

chess.Piece _pieceKindToChessPiece(PieceKind kind, bool whitePiece) {
  return switch (kind.pieceType) {
    PieceType.pawn => chess.Piece(
        chess.Chess.PAWN,
        whitePiece ? chess.Color.WHITE : chess.Color.BLACK,
      ),
    PieceType.knight => chess.Piece(
        chess.Chess.KNIGHT,
        whitePiece ? chess.Color.WHITE : chess.Color.BLACK,
      ),
    PieceType.bishop => chess.Piece(
        chess.Chess.BISHOP,
        whitePiece ? chess.Color.WHITE : chess.Color.BLACK,
      ),
    PieceType.rook => chess.Piece(
        chess.Chess.ROOK,
        whitePiece ? chess.Color.WHITE : chess.Color.BLACK,
      ),
    PieceType.queen => chess.Piece(
        chess.Chess.QUEEN,
        whitePiece ? chess.Color.WHITE : chess.Color.BLACK,
      ),
    PieceType.king => chess.Piece(
        chess.Chess.KING,
        whitePiece ? chess.Color.WHITE : chess.Color.BLACK,
      ),
  };
}

class PositionGeneratorFromAntlr {
  final _randomNumberGenerator = Random();

  var _allConstraints = noConstraint;
  var _playerKingCell = defaultBoardCoordinate;
  var _computerKingCell = defaultBoardCoordinate;

  void setConstraints(PositionGeneratorConstraintsExpr constraints) {
    _allConstraints = constraints;
  }

  // can throw
  // PositionGenerationLoopException
  String generatePosition() {
    _playerKingCell = defaultBoardCoordinate;
    _computerKingCell = defaultBoardCoordinate;

    final playerHasWhite = _randomNumberGenerator.nextBool();
    final startFen = "8/8/8/8/8/8/8/8 ${playerHasWhite ? 'w' : 'b'} - - 0 1";
    final positionWithPlayerKing =
        _placePlayerKingInPosition(startFen, playerHasWhite);
    final positionWithComputerKing =
        _placeComputerKingInPosition(positionWithPlayerKing, playerHasWhite);
    String? finalPosition;
    for (var attemptIndex = 0;
        attemptIndex < maxOtherPiecesPlacementTries;
        attemptIndex++) {
      finalPosition =
          _placeOtherPiecesInPosition(positionWithComputerKing, playerHasWhite);
      if (finalPosition != null) break;
    }

    if (finalPosition == null) {
      throw PositionGenerationLoopException(
          message: "Failed to place other pieces !");
    }

    return finalPosition;
  }

  String _placePlayerKingInPosition(String startFen, bool playerHasWhite) {
    final kingPiece = chess.Piece(
      chess.Chess.KING,
      playerHasWhite ? chess.Color.WHITE : chess.Color.BLACK,
    );

    for (var tryNumber = 0;
        tryNumber < maxLoopsForSinglePiecePlacement;
        tryNumber++) {
      final kingCell = _generateCell();
      final builtPosition =
          _addPieceToPositionOrReturnNullIfCellAlreadyOccupied(
        startFen,
        kingPiece,
        kingCell,
      );
      if (builtPosition == null) continue;
      if (_allConstraints.playerKingConstraint != null) {
        final intValues = <String, int>{
          "file": kingCell.file,
          "rank": kingCell.rank,
        };
        final booleanValues = <String, bool>{
          "playerHasWhite": playerHasWhite,
        };
        final playerKingConstraintRespected = evaluateBoolExpression(
          _allConstraints.playerKingConstraint!,
          intValues,
          booleanValues,
        );
        if (playerKingConstraintRespected) {
          _playerKingCell = kingCell;
          return builtPosition;
        }
      } else {
        _playerKingCell = kingCell;
        return builtPosition;
      }
    }

    throw PositionGenerationLoopException(
        message: "Failed to place player king !");
  }

  String _placeComputerKingInPosition(String startFen, bool playerHasWhite) {
    final kingPiece = chess.Piece(
      chess.Chess.KING,
      playerHasWhite ? chess.Color.BLACK : chess.Color.WHITE,
    );

    for (var tryNumber = 0;
        tryNumber < maxLoopsForSinglePiecePlacement;
        tryNumber++) {
      final kingCell = _generateCell();
      final builtPosition =
          _addPieceToPositionOrReturnNullIfCellAlreadyOccupied(
        startFen,
        kingPiece,
        kingCell,
      );

      if (builtPosition == null) continue;
      final validationResult = chess.Chess.validate_fen(builtPosition);
      if (!validationResult['valid']) continue;

      if (_allConstraints.computerKingConstraint != null) {
        final computerKingConstraintIntValues = <String, int>{
          "file": kingCell.file,
          "rank": kingCell.rank,
        };
        final computerKingConstraintBooleanValues = <String, bool>{
          "playerHasWhite": playerHasWhite,
        };
        final computerKingConstraintRespected = evaluateBoolExpression(
          _allConstraints.computerKingConstraint!,
          computerKingConstraintIntValues,
          computerKingConstraintBooleanValues,
        );
        if (!computerKingConstraintRespected) continue;
        if (_allConstraints.kingsMutualConstraint != null) {
          final kingsMutualConstraintIntValues = <String, int>{
            "playerKingFile": _playerKingCell.file,
            "playerKingRank": _playerKingCell.rank,
            "computerKingFile": _computerKingCell.file,
            "computerKingRank": _computerKingCell.rank,
          };
          final kingsMutualConstraintBooleanValues = <String, bool>{
            "playerHasWhite": playerHasWhite,
          };
          final kingsMutualConstraintRespected = evaluateBoolExpression(
            _allConstraints.kingsMutualConstraint!,
            kingsMutualConstraintIntValues,
            kingsMutualConstraintBooleanValues,
          );
          if (!kingsMutualConstraintRespected) continue;
          _computerKingCell = kingCell;
          return builtPosition;
        } else {
          _computerKingCell = kingCell;
          return builtPosition;
        }
      } else {
        _computerKingCell = kingCell;
        return builtPosition;
      }
    }

    throw PositionGenerationLoopException(
        message: "Failed to place computer king !");
  }

  String? _placeOtherPiecesInPosition(
    String startFen,
    bool playerHasWhite,
  ) {
    var currentPosition = chess.Chess.fromFEN(startFen, check_validity: false);
    // we check for legality of position once all pieces are placed :
    // because we could miss interesting position where opponent king
    // in chess issue is later resolved with the latest placed pieces.
    for (var pieceCountConstraint
        in _allConstraints.otherPiecesCountConstraint) {
      final savedCoordinates = <_BoardCoordinate>[];
      for (var constraintIndex = 0;
          constraintIndex < pieceCountConstraint.count;
          constraintIndex++) {
        var loopSuccess = false;
        for (var attemptIndex = 0;
            attemptIndex < maxLoopsForSinglePiecePlacement;
            attemptIndex++) {
          final isAPieceOfPlayer =
              pieceCountConstraint.pieceKind.side == Side.player;
          final isAPieceOfComputer = !isAPieceOfPlayer;
          final computerHasWhite = !playerHasWhite;
          final mustBeWhitePiece = (isAPieceOfPlayer && playerHasWhite) ||
              (isAPieceOfComputer && computerHasWhite);
          final pieceCoordinates = _generateCell();
          final tempPosition =
              _addPieceToPositionOrReturnNullIfCellAlreadyOccupied(
            currentPosition.fen,
            _pieceKindToChessPiece(
                pieceCountConstraint.pieceKind, mustBeWhitePiece),
            pieceCoordinates,
          );

          if (tempPosition == null) continue;

          final commonOtherPiecesConstraintBooleanValues = <String, bool>{
            "playerHasWhite": playerHasWhite,
          };

          final otherPiecesGlobalConstraintIntValues = <String, int>{
            "file": pieceCoordinates.file,
            "rank": pieceCoordinates.rank,
            "playerKingFile": _playerKingCell.file,
            "playerKingRank": _playerKingCell.rank,
            "computerKingFile": _computerKingCell.file,
            "computerKingRank": _computerKingCell.rank,
          };

          final currentPieceGlobalConstraint = _allConstraints
              .otherPiecesGlobalConstraints[pieceCountConstraint.pieceKind];
          final positionRespectCurrentPieceGlobalConstraint =
              currentPieceGlobalConstraint == null
                  ? true
                  : evaluateBoolExpression(
                      currentPieceGlobalConstraint,
                      otherPiecesGlobalConstraintIntValues,
                      commonOtherPiecesConstraintBooleanValues,
                    );
          if (!positionRespectCurrentPieceGlobalConstraint) continue;

          final otherPieceIndexedConstraintIntValues = <String, int>{
            "file": pieceCoordinates.file,
            "rank": pieceCoordinates.rank,
            "apparitionIndex": constraintIndex,
          };
          final currentPieceIndexedConstraint = _allConstraints
              .otherPiecesIndexedConstraints[pieceCountConstraint.pieceKind];
          final positionRespectCurrentPieceIndexedConstraint =
              currentPieceIndexedConstraint == null
                  ? true
                  : evaluateBoolExpression(
                      currentPieceIndexedConstraint,
                      otherPieceIndexedConstraintIntValues,
                      commonOtherPiecesConstraintBooleanValues,
                    );
          if (!positionRespectCurrentPieceIndexedConstraint) continue;

          // If for any previous piece of same kind, mutual constraint is not respected, will loop another time
          final currentPieceMutualConstraint = _allConstraints
              .otherPiecesMutualConstraints[pieceCountConstraint.pieceKind];
          if (savedCoordinates.any((coordinate) {
            final otherPieceMutualConstraintIntValues = <String, int>{
              "firstPieceFile": coordinate.file,
              "firstPieceRank": coordinate.rank,
              "secondPieceFile": pieceCoordinates.file,
              "secondPieceRank": pieceCoordinates.rank,
            };
            final positionRespectCurrentPieceMutualConstraint =
                currentPieceMutualConstraint == null
                    ? true
                    : evaluateBoolExpression(
                        currentPieceMutualConstraint,
                        otherPieceMutualConstraintIntValues,
                        commonOtherPiecesConstraintBooleanValues,
                      );
            return !positionRespectCurrentPieceMutualConstraint;
          })) continue;

          currentPosition =
              chess.Chess.fromFEN(tempPosition, check_validity: false);
          savedCoordinates.add(pieceCoordinates);
          loopSuccess = true;
          break;
        }
        if (!loopSuccess) {
          return null;
        }
      }
    }

    // Checking that final position is legal
    final validationResult = chess.Chess.validate_fen(currentPosition.fen);
    if (!validationResult['valid']) return null;

    return currentPosition.fen;
  }

  String? _addPieceToPositionOrReturnNullIfCellAlreadyOccupied(
      String startFen, chess.Piece pieceToAdd, _BoardCoordinate pieceCell) {
    final builtPosition = chess.Chess.fromFEN(startFen, check_validity: false);
    final wantedCellOccupied =
        builtPosition.get(pieceCell.toUciString()) != null;
    if (wantedCellOccupied) return null;

    builtPosition.put(pieceToAdd, pieceCell.toUciString());
    return builtPosition.fen;
  }

  _BoardCoordinate _generateCell() {
    final file = _randomNumberGenerator.nextInt(8);
    final rank = _randomNumberGenerator.nextInt(8);

    return _BoardCoordinate(file, rank);
  }
}
