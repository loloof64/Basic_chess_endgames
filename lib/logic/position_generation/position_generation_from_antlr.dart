import 'dart:collection';
import 'dart:math';

import 'package:basicchessendgamestrainer/antlr4/script_language_boolean_expr.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/position_generation_constraints.dart';
import 'package:chess/chess.dart' as chess;

const int maxOtherPiecesPlacementTries = 30;
const int maxOverallTries = 10;

const int boardCellsCount = 64;

class _BoardCoordinate {
  final int file;
  final int rank;

  _BoardCoordinate(this.file, this.rank);

  int toCellCode() => file + 8 * rank;

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
  LinkedHashMap<String, ScriptLanguageGenericExpr>? playerKingConstraint;
  LinkedHashMap<String, ScriptLanguageGenericExpr>? computerKingConstraint;
  LinkedHashMap<String, ScriptLanguageGenericExpr>? kingsMutualConstraint;
  List<PieceKindCount> otherPiecesCountConstraint;
  Map<PieceKind, LinkedHashMap<String, ScriptLanguageGenericExpr>?>
      otherPiecesGlobalConstraints;
  Map<PieceKind, LinkedHashMap<String, ScriptLanguageGenericExpr>?>
      otherPiecesMutualConstraints;
  Map<PieceKind, LinkedHashMap<String, ScriptLanguageGenericExpr>?>
      otherPiecesIndexedConstraints;
  bool mustWin;

  PositionGeneratorConstraintsExpr({
    this.playerKingConstraint,
    this.computerKingConstraint,
    this.kingsMutualConstraint,
    this.otherPiecesCountConstraint = const <PieceKindCount>[],
    this.otherPiecesGlobalConstraints =
        const <PieceKind, LinkedHashMap<String, ScriptLanguageGenericExpr>?>{},
    this.otherPiecesMutualConstraints =
        const <PieceKind, LinkedHashMap<String, ScriptLanguageGenericExpr>?>{},
    this.otherPiecesIndexedConstraints =
        const <PieceKind, LinkedHashMap<String, ScriptLanguageGenericExpr>?>{},
    this.mustWin = true,
  });
}

class PositionGeneratorConstraintsScripts {
  bool resultShouldBeDraw;
  String playerKingConstraint;
  String computerKingConstraint;
  String kingsMutualConstraint;
  String otherPiecesCountConstraint;
  String otherPiecesGlobalContraints;
  String otherPiecesMutualContraints;
  String otherPiecesIndexedContraints;
  String goal;

  PositionGeneratorConstraintsScripts({
    required this.resultShouldBeDraw,
    required this.playerKingConstraint,
    required this.computerKingConstraint,
    required this.kingsMutualConstraint,
    required this.otherPiecesCountConstraint,
    required this.otherPiecesGlobalContraints,
    required this.otherPiecesMutualContraints,
    required this.otherPiecesIndexedContraints,
    required this.goal,
  });
}

final noConstraint = PositionGeneratorConstraintsExpr(
  playerKingConstraint: null,
  computerKingConstraint: null,
  kingsMutualConstraint: null,
  otherPiecesCountConstraint: <PieceKindCount>[],
  otherPiecesGlobalConstraints: <PieceKind,
      LinkedHashMap<String, ScriptLanguageGenericExpr>?>{},
  otherPiecesMutualConstraints: <PieceKind,
      LinkedHashMap<String, ScriptLanguageGenericExpr>?>{},
  otherPiecesIndexedConstraints: <PieceKind,
      LinkedHashMap<String, ScriptLanguageGenericExpr>?>{},
  mustWin: true,
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
    String? finalPosition;

    for (int overallTries = 0; overallTries < maxOverallTries; overallTries++) {
      try {
        _playerKingCell = defaultBoardCoordinate;
        _computerKingCell = defaultBoardCoordinate;

        final playerHasWhite = _randomNumberGenerator.nextBool();
        final startFen =
            "8/8/8/8/8/8/8/8 ${playerHasWhite ? 'w' : 'b'} - - 0 1";
        final positionWithPlayerKing =
            _placePlayerKingInPosition(startFen, playerHasWhite);
        final positionWithComputerKing = _placeComputerKingInPosition(
            positionWithPlayerKing, playerHasWhite);
        for (var attemptIndex = 0;
            attemptIndex < maxOtherPiecesPlacementTries;
            attemptIndex++) {
          finalPosition = _placeOtherPiecesInPosition(
              positionWithComputerKing, playerHasWhite);
          if (finalPosition != null) break;
        }
      } on Exception {
        // at least we let the algorithm retry from scratch
      }
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

    Set<int> remainingCellsToTry = <int>{};
    for (var i = 0; i < boardCellsCount; i++) {
      remainingCellsToTry.add(i);
    }
    for (var tryNumber = 0; tryNumber < boardCellsCount; tryNumber++) {
      final kingCell = _generateCell(remainingCellsToTry);
      final builtPosition =
          _addPieceToPositionOrReturnNullIfCellAlreadyOccupied(
        startFen,
        kingPiece,
        kingCell,
      );
      if (builtPosition == null) {
        remainingCellsToTry.remove(kingCell.toCellCode());
        continue;
      }
      if (_allConstraints.playerKingConstraint != null) {
        final intValues = <String, int>{
          "file": kingCell.file,
          "rank": kingCell.rank,
        };
        final booleanValues = <String, bool>{
          "playerHasWhite": playerHasWhite,
        };
        final playerKingConstraintRespected = evaluateExpressionsSet(
          _allConstraints.playerKingConstraint!,
          intValues,
          booleanValues,
        );
        if (playerKingConstraintRespected) {
          _playerKingCell = kingCell;
          return builtPosition;
        } else {
          remainingCellsToTry.remove(kingCell.toCellCode());
        }
      } else {
        _playerKingCell = kingCell;
        return builtPosition;
      }
    }

    throw Exception("Failed to place player king !");
  }

  String _placeComputerKingInPosition(String startFen, bool playerHasWhite) {
    final kingPiece = chess.Piece(
      chess.Chess.KING,
      playerHasWhite ? chess.Color.BLACK : chess.Color.WHITE,
    );

    Set<int> remainingCellsToTry = <int>{};
    for (var i = 0; i < boardCellsCount; i++) {
      remainingCellsToTry.add(i);
    }
    for (var tryNumber = 0; tryNumber < boardCellsCount; tryNumber++) {
      final kingCell = _generateCell(remainingCellsToTry);
      final builtPosition =
          _addPieceToPositionOrReturnNullIfCellAlreadyOccupied(
        startFen,
        kingPiece,
        kingCell,
      );

      if (builtPosition == null) {
        remainingCellsToTry.remove(kingCell.toCellCode());
        continue;
      }
      final validationResult = chess.Chess.validate_fen(builtPosition);
      if (!validationResult['valid']) {
        remainingCellsToTry.remove(kingCell.toCellCode());
        continue;
      }

      if (_allConstraints.computerKingConstraint != null) {
        final computerKingConstraintIntValues = <String, int>{
          "file": kingCell.file,
          "rank": kingCell.rank,
        };
        final computerKingConstraintBooleanValues = <String, bool>{
          "playerHasWhite": playerHasWhite,
        };
        final computerKingConstraintRespected = evaluateExpressionsSet(
          _allConstraints.computerKingConstraint!,
          computerKingConstraintIntValues,
          computerKingConstraintBooleanValues,
        );
        if (!computerKingConstraintRespected) {
          remainingCellsToTry.remove(kingCell.toCellCode());
          continue;
        }
        if (_allConstraints.kingsMutualConstraint != null) {
          final kingsMutualConstraintIntValues = <String, int>{
            "playerKingFile": _playerKingCell.file,
            "playerKingRank": _playerKingCell.rank,
            "computerKingFile": kingCell.file,
            "computerKingRank": kingCell.rank,
          };
          final kingsMutualConstraintBooleanValues = <String, bool>{
            "playerHasWhite": playerHasWhite,
          };
          final kingsMutualConstraintRespected = evaluateExpressionsSet(
            _allConstraints.kingsMutualConstraint!,
            kingsMutualConstraintIntValues,
            kingsMutualConstraintBooleanValues,
          );
          if (!kingsMutualConstraintRespected) {
            remainingCellsToTry.remove(kingCell.toCellCode());
            continue;
          }
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

    throw Exception("Failed to place computer king !");
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
        Set<int> remainingCellsToTry = <int>{};
        for (var i = 0; i < boardCellsCount; i++) {
          remainingCellsToTry.add(i);
        }
        for (var attemptIndex = 0;
            attemptIndex < boardCellsCount;
            attemptIndex++) {
          final isAPieceOfPlayer =
              pieceCountConstraint.pieceKind.side == Side.player;
          final isAPieceOfComputer = !isAPieceOfPlayer;
          final computerHasWhite = !playerHasWhite;
          final mustBeWhitePiece = (isAPieceOfPlayer && playerHasWhite) ||
              (isAPieceOfComputer && computerHasWhite);
          final pieceCoordinates = _generateCell(remainingCellsToTry);
          final tempPosition =
              _addPieceToPositionOrReturnNullIfCellAlreadyOccupied(
            currentPosition.fen,
            _pieceKindToChessPiece(
                pieceCountConstraint.pieceKind, mustBeWhitePiece),
            pieceCoordinates,
          );

          if (tempPosition == null) {
            remainingCellsToTry.remove(pieceCoordinates.toCellCode());
            continue;
          }

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
                  : evaluateExpressionsSet(
                      currentPieceGlobalConstraint,
                      otherPiecesGlobalConstraintIntValues,
                      commonOtherPiecesConstraintBooleanValues,
                    );
          if (!positionRespectCurrentPieceGlobalConstraint) {
            remainingCellsToTry.remove(pieceCoordinates.toCellCode());
            continue;
          }

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
                  : evaluateExpressionsSet(
                      currentPieceIndexedConstraint,
                      otherPieceIndexedConstraintIntValues,
                      commonOtherPiecesConstraintBooleanValues,
                    );
          if (!positionRespectCurrentPieceIndexedConstraint) {
            remainingCellsToTry.remove(pieceCoordinates.toCellCode());
            continue;
          }

          // If for any previous piece of same kind, mutual constraint is not respected, will loop another time
          final currentPieceMutualConstraint = _allConstraints
              .otherPiecesMutualConstraints[pieceCountConstraint.pieceKind];
          final mutualConstraintsRespected =
              savedCoordinates.every((coordinate) {
            final otherPieceMutualConstraintIntValues = <String, int>{
              "firstPieceFile": coordinate.file,
              "firstPieceRank": coordinate.rank,
              "secondPieceFile": pieceCoordinates.file,
              "secondPieceRank": pieceCoordinates.rank,
            };
            final positionRespectCurrentPieceMutualConstraint =
                currentPieceMutualConstraint == null
                    ? true
                    : evaluateExpressionsSet(
                        currentPieceMutualConstraint,
                        otherPieceMutualConstraintIntValues,
                        commonOtherPiecesConstraintBooleanValues,
                      );
            return positionRespectCurrentPieceMutualConstraint;
          });

          if (!mutualConstraintsRespected) {
            remainingCellsToTry.remove(pieceCoordinates.toCellCode());
            continue;
          }

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

  _BoardCoordinate _generateCell(Set<int> remainingCellsToTry) {
    int cellCode;
    int file;
    int rank;
    do {
      file = _randomNumberGenerator.nextInt(8);
      rank = _randomNumberGenerator.nextInt(8);

      cellCode = file + 8 * rank;
    } while (!remainingCellsToTry.contains(cellCode));

    return _BoardCoordinate(file, rank);
  }
}
