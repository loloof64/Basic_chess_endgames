import 'dart:math';

import 'package:antlr4/antlr4.dart';
import 'package:basicchessendgamestrainer/antlr4/script_interpreter.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/position_generation_constraints.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/script_text_interpretation.dart';
import 'package:chess/chess.dart' as chess;
import 'package:logger/logger.dart';

class AlreadyAPieceThereException implements Exception {}

class ReturnedValueNotABooleanException implements Exception {}

(bool, List<InterpretationError>) evaluateScript({
  required TranslationsWrapper translations,
  required String script,
  required Map<String, dynamic> predefinedValues,
}) {
  final interpreter = ScriptInterpreter(translations: translations);
  final values = interpreter.interpretScript(script, predefinedValues);
  final errors = interpreter.getErrors();
  if (errors.isNotEmpty) {
    return (false, errors);
  } else {
    final returnedValue = values?['return'];
    if (returnedValue == null) throw MissingReturnStatementException();
    if (returnedValue is! bool) throw ReturnedValueNotABooleanException();

    return (returnedValue, []);
  }
}

class BoardCoordinate {
  final int file;
  final int rank;

  BoardCoordinate(this.file, this.rank);

  int toCellCode() => file + 8 * rank;

  String toUciString() {
    final fileString = String.fromCharCode('a'.codeUnitAt(0) + file);
    final rankString = String.fromCharCode('1'.codeUnitAt(0) + rank);

    return "$fileString$rankString";
  }

  @override
  String toString() {
    return toUciString();
  }
}

class PositionGenerationLoopException implements Exception {
  final String? message;

  PositionGenerationLoopException({this.message});
}

class PositionGeneratorConstraintsExpr {
  String? playerKingConstraint;
  String? computerKingConstraint;
  String? kingsMutualConstraint;
  List<PieceKindCount> otherPiecesCountConstraint;
  Map<PieceKind, String> otherPiecesGlobalConstraints;
  Map<PieceKind, String> otherPiecesMutualConstraints;
  Map<PieceKind, String> otherPiecesIndexedConstraints;
  bool mustWin;

  PositionGeneratorConstraintsExpr({
    this.playerKingConstraint,
    this.computerKingConstraint,
    this.kingsMutualConstraint,
    this.otherPiecesCountConstraint = const <PieceKindCount>[],
    this.otherPiecesGlobalConstraints = const <PieceKind, String>{},
    this.otherPiecesMutualConstraints = const <PieceKind, String>{},
    this.otherPiecesIndexedConstraints = const <PieceKind, String>{},
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
  otherPiecesGlobalConstraints: <PieceKind, String>{},
  otherPiecesMutualConstraints: <PieceKind, String>{},
  otherPiecesIndexedConstraints: <PieceKind, String>{},
  mustWin: true,
);

final defaultBoardCoordinate = BoardCoordinate(0, 0);

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
  PositionGeneratorFromAntlr({
    required this.translations,
  });

  final TranslationsWrapper translations;
  final _randomNumberGenerator = Random();
  final List<InterpretationError> _errors = [];

  var _allConstraints = noConstraint;

  void setConstraints(PositionGeneratorConstraintsExpr constraints) {
    _allConstraints = constraints;
  }

  // can throw
  // PositionGenerationLoopException
  String? generatePosition() {
    String? finalPosition;

    _errors.clear();

    final playerHasWhite = _randomNumberGenerator.nextBool();
    final startFen = "8/8/8/8/8/8/8/8 ${playerHasWhite ? 'w' : 'b'} - - 0 1";

    finalPosition = _placePiecesStepPlayerKing(
      startFen: startFen,
      playerHasWhite: playerHasWhite,
    );

    if (_errors.isNotEmpty) {
      return null;
    }

    if (finalPosition == null) {
      throw PositionGenerationLoopException(
          message: "Failed to place pieces !");
    }

    return finalPosition;
  }

  String? _placePiecesStepPlayerKing({
    required String startFen,
    required bool playerHasWhite,
  }) {
    String? result;
    final kingConstraints = _allConstraints.playerKingConstraint;
    List<BoardCoordinate> cellsToTest = _getListWithAllCells();

    final kingPiece = chess.Piece(
      chess.Chess.KING,
      playerHasWhite ? chess.Color.WHITE : chess.Color.BLACK,
    );

    if (kingConstraints != null) {
      cellsToTest = filterCoordinates(cellsToTest, (currentCell) {
        final predefinedValues = <String, dynamic>{
          "file": currentCell.file,
          "rank": currentCell.rank,
          "playerHasWhite": playerHasWhite,
        };
        try {
          final (passedConditions, errors) = evaluateScript(
            script: _allConstraints.playerKingConstraint!,
            predefinedValues: predefinedValues,
            translations: translations,
          );
          if (errors.isNotEmpty) {
            final scriptTypeLabel = translations.fromScriptType(
                scriptType: ScriptType.playerKingConstraint);
            for (final currentError in errors) {
              _errors.add(currentError.withScriptType(scriptTypeLabel));
            }
          }
          return passedConditions;
        } on MissingReturnStatementException catch (ex) {
          final scriptTypeLabel = translations.fromScriptType(
              scriptType: ScriptType.playerKingConstraint);
          final message = translations.missingReturnStatement;
          Logger().e(ex);
          throw InterpretationError(
            message: message,
            scriptType: scriptTypeLabel,
          );
        } on VariableIsNotAffectedException catch (ex) {
          final scriptTypeLabel = translations.fromScriptType(
              scriptType: ScriptType.playerKingConstraint);
          final message = translations.variableNotAffected(Name: ex.varName);
          Logger().e(ex);
          throw InterpretationError(
            message: message,
            scriptType: scriptTypeLabel,
          );
        } on ReturnedValueNotABooleanException catch (ex) {
          final scriptTypeLabel = translations.fromScriptType(
              scriptType: ScriptType.playerKingConstraint);
          final message = translations.returnStatementNotABoolean;
          Logger().e(ex);
          throw InterpretationError(
            message: message,
            scriptType: scriptTypeLabel,
          );
        } on ParseCancellationException catch (ex) {
          final scriptTypeLabel = translations.fromScriptType(
              scriptType: ScriptType.playerKingConstraint);
          Logger().e(ex);
          throw InterpretationError(
            message: ex.message,
            scriptType: scriptTypeLabel,
          );
        }
      });
    }
    cellsToTest.shuffle();

    for (final currentCell in cellsToTest) {
      String testPosition;
      try {
        testPosition = _placePieceInPosition(
          currentPosition: startFen,
          pieceToAdd: kingPiece,
          targetCell: currentCell,
        );
      } on AlreadyAPieceThereException {
        continue;
      }

      result = _placePiecesStepComputerKing(
        startFen: testPosition,
        playerHasWhite: playerHasWhite,
        playerKingCell: currentCell,
      );
      if (result != null) {
        break;
      }
    }

    return result;
  }

  String? _placePiecesStepComputerKing({
    required String startFen,
    required bool playerHasWhite,
    required BoardCoordinate playerKingCell,
  }) {
    String? result;
    final computerKingConstraints = _allConstraints.computerKingConstraint;
    final kingsMutualConstraints = _allConstraints.kingsMutualConstraint;
    List<BoardCoordinate> cellsToTest = _getListWithAllCells();

    final kingPiece = chess.Piece(
      chess.Chess.KING,
      playerHasWhite ? chess.Color.BLACK : chess.Color.WHITE,
    );

    cellsToTest = cellsToTest.where((currentCell) {
      try {
        final builtPosition = _placePieceInPosition(
          currentPosition: startFen,
          pieceToAdd: kingPiece,
          targetCell: currentCell,
        );
        return chess.Chess.validate_fen(builtPosition)['valid'];
      } on AlreadyAPieceThereException {
        return false;
      }
    }).toList();

    if (computerKingConstraints != null) {
      cellsToTest = filterCoordinates(cellsToTest, (currentCell) {
        final computerKingConstraintPredefinedValues = <String, dynamic>{
          "file": currentCell.file,
          "rank": currentCell.rank,
          "playerHasWhite": playerHasWhite,
        };
        try {
          final (passedConditions, errors) = evaluateScript(
            script: _allConstraints.computerKingConstraint!,
            predefinedValues: computerKingConstraintPredefinedValues,
            translations: translations,
          );
          if (errors.isNotEmpty) {
            final scriptTypeLabel = translations.fromScriptType(
                scriptType: ScriptType.computerKingConstraint);
            for (final currentError in errors) {
              _errors.add(currentError.withScriptType(scriptTypeLabel));
            }
          }
          return passedConditions;
        } on MissingReturnStatementException catch (ex) {
          final scriptTypeLabel = translations.fromScriptType(
              scriptType: ScriptType.computerKingConstraint);
          final message = translations.missingReturnStatement;
          Logger().e(ex);
          throw InterpretationError(
            message: message,
            scriptType: scriptTypeLabel,
          );
        } on VariableIsNotAffectedException catch (ex) {
          final scriptTypeLabel = translations.fromScriptType(
              scriptType: ScriptType.computerKingConstraint);
          final message = translations.variableNotAffected(Name: ex.varName);
          Logger().e(ex);
          throw InterpretationError(
            message: message,
            scriptType: scriptTypeLabel,
          );
        } on ReturnedValueNotABooleanException catch (ex) {
          final scriptTypeLabel = translations.fromScriptType(
              scriptType: ScriptType.computerKingConstraint);
          final message = translations.returnStatementNotABoolean;
          Logger().e(ex);
          throw InterpretationError(
            message: message,
            scriptType: scriptTypeLabel,
          );
        } on ParseCancellationException catch (ex) {
          final scriptTypeLabel = translations.fromScriptType(
              scriptType: ScriptType.computerKingConstraint);
          Logger().e(ex);
          throw InterpretationError(
            message: ex.message,
            scriptType: scriptTypeLabel,
          );
        }
      });
    }

    if (kingsMutualConstraints != null) {
      cellsToTest = filterCoordinates(cellsToTest, (currentCell) {
        final kingsMutualConstraintPredefinedValues = <String, dynamic>{
          "playerKingFile": playerKingCell.file,
          "playerKingRank": playerKingCell.rank,
          "computerKingFile": currentCell.file,
          "computerKingRank": currentCell.rank,
          "playerHasWhite": playerHasWhite,
        };
        try {
          final (passedConditions2, errors2) = evaluateScript(
            script: _allConstraints.kingsMutualConstraint!,
            predefinedValues: kingsMutualConstraintPredefinedValues,
            translations: translations,
          );
          if (errors2.isNotEmpty) {
            final scriptTypeLabel = translations.fromScriptType(
                scriptType: ScriptType.mutualKingConstraint);
            for (final currentError in errors2) {
              _errors.add(currentError.withScriptType(scriptTypeLabel));
            }
          }
          return passedConditions2;
        } on MissingReturnStatementException catch (ex) {
          final scriptTypeLabel = translations.fromScriptType(
              scriptType: ScriptType.mutualKingConstraint);
          final message = translations.missingReturnStatement;
          Logger().e(ex);
          throw InterpretationError(
            message: message,
            scriptType: scriptTypeLabel,
          );
        } on VariableIsNotAffectedException catch (ex) {
          final scriptTypeLabel = translations.fromScriptType(
              scriptType: ScriptType.mutualKingConstraint);
          final message = translations.variableNotAffected(Name: ex.varName);
          Logger().e(ex);
          throw InterpretationError(
            message: message,
            scriptType: scriptTypeLabel,
          );
        } on ReturnedValueNotABooleanException catch (ex) {
          final scriptTypeLabel = translations.fromScriptType(
              scriptType: ScriptType.mutualKingConstraint);
          final message = translations.returnStatementNotABoolean;
          Logger().e(ex);
          throw InterpretationError(
            message: message,
            scriptType: scriptTypeLabel,
          );
        } on ParseCancellationException catch (ex) {
          final scriptTypeLabel = translations.fromScriptType(
              scriptType: ScriptType.mutualKingConstraint);
          Logger().e(ex);
          throw InterpretationError(
            message: ex.message,
            scriptType: scriptTypeLabel,
          );
        }
      });
    }
    cellsToTest.shuffle();

    for (final currentCell in cellsToTest) {
      String testPosition;
      try {
        testPosition = _placePieceInPosition(
          currentPosition: startFen,
          pieceToAdd: kingPiece,
          targetCell: currentCell,
        );
      } on AlreadyAPieceThereException {
        continue;
      }

      result = _placePiecesStepOtherPieces(
        startFen: testPosition,
        playerHasWhite: playerHasWhite,
        playerKingCell: playerKingCell,
        computerKingCell: currentCell,
      );
      if (result != null) {
        break;
      }
    }

    return result;
  }

  String? _placePiecesStepOtherPieces({
    required String startFen,
    required bool playerHasWhite,
    required BoardCoordinate playerKingCell,
    required BoardCoordinate computerKingCell,
  }) {
    // we check for legality of position once all pieces are placed :
    // because we could miss interesting position where opponent king
    // in chess issue is later resolved with the latest placed pieces.
    var currentPosition = chess.Chess.fromFEN(startFen, check_validity: false);

    var piecesCountConstraints = _allConstraints.otherPiecesCountConstraint;
    if (piecesCountConstraints.isEmpty) {
      return startFen;
    }

    for (var pieceCountConstraint in piecesCountConstraints) {
      final savedCoordinatesForThisCountConstraint = <BoardCoordinate>[];
      for (var constraintIndex = 0;
          constraintIndex < pieceCountConstraint.count;
          constraintIndex++) {
        var successForCurrentIndex = false;
        List<BoardCoordinate> cellsToTest = _getListWithAllCells();

        final isAPieceOfPlayer =
            pieceCountConstraint.pieceKind.side == Side.player;
        final isAPieceOfComputer = !isAPieceOfPlayer;
        final computerHasWhite = !playerHasWhite;
        final mustBeWhitePiece = (isAPieceOfPlayer && playerHasWhite) ||
            (isAPieceOfComputer && computerHasWhite);

        final currentPieceGlobalConstraint = _allConstraints
            .otherPiecesGlobalConstraints[pieceCountConstraint.pieceKind];
        final currentPieceMutualConstraint = _allConstraints
            .otherPiecesMutualConstraints[pieceCountConstraint.pieceKind];
        final currentPieceIndexedConstraint = _allConstraints
            .otherPiecesIndexedConstraints[pieceCountConstraint.pieceKind];

        final commonOtherPiecesConstraintBooleanValues = <String, bool>{
          "playerHasWhite": playerHasWhite,
        };

        if (currentPieceGlobalConstraint != null) {
          cellsToTest = filterCoordinates(cellsToTest, (currentCell) {
            final otherPiecesGlobalConstraintPredefinedValues =
                <String, dynamic>{
              "file": currentCell.file,
              "rank": currentCell.rank,
              "playerKingFile": playerKingCell.file,
              "playerKingRank": playerKingCell.rank,
              "computerKingFile": computerKingCell.file,
              "computerKingRank": computerKingCell.rank,
              ...commonOtherPiecesConstraintBooleanValues,
            };
            try {
              final (passedConditions1, errors1) = evaluateScript(
                script: currentPieceGlobalConstraint,
                predefinedValues: otherPiecesGlobalConstraintPredefinedValues,
                translations: translations,
              );
              if (errors1.isNotEmpty) {
                final scriptTypeLabel = translations.fromScriptType(
                    scriptType: ScriptType.otherPiecesGlobalConstraint);
                for (final currentError in errors1) {
                  _errors.add(currentError.withScriptType(scriptTypeLabel));
                }
              }
              return passedConditions1;
            } on MissingReturnStatementException catch (ex) {
              final scriptTypeLabel = translations.fromScriptType(
                scriptType: ScriptType.otherPiecesGlobalConstraint,
                pieceKind: pieceCountConstraint.pieceKind,
              );
              final message = translations.missingReturnStatement;
              Logger().e(ex);
              throw InterpretationError(
                  scriptType: scriptTypeLabel, message: message);
            } on VariableIsNotAffectedException catch (ex) {
              final scriptTypeLabel = translations.fromScriptType(
                scriptType: ScriptType.otherPiecesGlobalConstraint,
                pieceKind: pieceCountConstraint.pieceKind,
              );
              final message =
                  translations.variableNotAffected(Name: ex.varName);
              Logger().e(ex);
              throw InterpretationError(
                  scriptType: scriptTypeLabel, message: message);
            } on ReturnedValueNotABooleanException catch (ex) {
              final scriptTypeLabel = translations.fromScriptType(
                  scriptType: ScriptType.otherPiecesGlobalConstraint);
              final message = translations.returnStatementNotABoolean;
              Logger().e(ex);
              throw InterpretationError(
                message: message,
                scriptType: scriptTypeLabel,
              );
            } on ParseCancellationException catch (ex) {
              final scriptTypeLabel = translations.fromScriptType(
                  scriptType: ScriptType.otherPiecesGlobalConstraint);
              Logger().e(ex);
              throw InterpretationError(
                message: ex.message,
                scriptType: scriptTypeLabel,
              );
            }
          });
        }

        if (currentPieceIndexedConstraint != null) {
          cellsToTest = filterCoordinates(cellsToTest, (currentCell) {
            final otherPieceIndexedConstraintPredefinedValues =
                <String, dynamic>{
              "file": currentCell.file,
              "rank": currentCell.rank,
              "apparitionIndex": constraintIndex,
              ...commonOtherPiecesConstraintBooleanValues,
            };
            try {
              final (passedConditions2, errors2) = evaluateScript(
                script: currentPieceIndexedConstraint,
                predefinedValues: otherPieceIndexedConstraintPredefinedValues,
                translations: translations,
              );
              if (errors2.isNotEmpty) {
                final scriptTypeLabel = translations.fromScriptType(
                    scriptType: ScriptType.otherPiecesIndexedConstraint);
                for (final currentError in errors2) {
                  _errors.add(currentError.withScriptType(scriptTypeLabel));
                }
              }
              return passedConditions2;
            } on MissingReturnStatementException catch (ex) {
              final scriptTypeLabel = translations.fromScriptType(
                scriptType: ScriptType.otherPiecesIndexedConstraint,
                pieceKind: pieceCountConstraint.pieceKind,
              );
              final message = translations.missingReturnStatement;
              Logger().e(ex);
              throw InterpretationError(
                  scriptType: scriptTypeLabel, message: message);
            } on VariableIsNotAffectedException catch (ex) {
              final scriptTypeLabel = translations.fromScriptType(
                scriptType: ScriptType.otherPiecesIndexedConstraint,
                pieceKind: pieceCountConstraint.pieceKind,
              );
              final message =
                  translations.variableNotAffected(Name: ex.varName);
              Logger().e(ex);
              throw InterpretationError(
                  scriptType: scriptTypeLabel, message: message);
            } on ReturnedValueNotABooleanException catch (ex) {
              final scriptTypeLabel = translations.fromScriptType(
                  scriptType: ScriptType.otherPiecesIndexedConstraint);
              final message = translations.returnStatementNotABoolean;
              Logger().e(ex);
              throw InterpretationError(
                message: message,
                scriptType: scriptTypeLabel,
              );
            } on ParseCancellationException catch (ex) {
              final scriptTypeLabel = translations.fromScriptType(
                  scriptType: ScriptType.otherPiecesIndexedConstraint);
              Logger().e(ex);
              throw InterpretationError(
                message: ex.message,
                scriptType: scriptTypeLabel,
              );
            }
          });
        }

        /*
        Checks for mutual constraints respect with
        previous placed pieces of the same kind */
        if (currentPieceMutualConstraint != null) {
          cellsToTest = filterCoordinates(cellsToTest, (outerLoopCell) {
            return savedCoordinatesForThisCountConstraint
                .every((innerLoopCell) {
              final otherPieceMutualConstraintIntValues = <String, dynamic>{
                "firstPieceFile": innerLoopCell.file,
                "firstPieceRank": innerLoopCell.rank,
                "secondPieceFile": outerLoopCell.file,
                "secondPieceRank": outerLoopCell.rank,
                ...commonOtherPiecesConstraintBooleanValues,
              };

              try {
                final (passedConditions3, errors3) = evaluateScript(
                  script: currentPieceMutualConstraint,
                  predefinedValues: otherPieceMutualConstraintIntValues,
                  translations: translations,
                );
                if (errors3.isNotEmpty) {
                  final scriptTypeLabel = translations.fromScriptType(
                      scriptType: ScriptType.otherPiecesMutualConstraint);
                  for (final currentError in errors3) {
                    _errors.add(currentError.withScriptType(scriptTypeLabel));
                  }
                }
                return passedConditions3;
              } on MissingReturnStatementException catch (ex) {
                final scriptTypeLabel = translations.fromScriptType(
                  scriptType: ScriptType.otherPiecesMutualConstraint,
                  pieceKind: pieceCountConstraint.pieceKind,
                );
                final message = translations.missingReturnStatement;
                Logger().e(ex);
                throw InterpretationError(
                    scriptType: scriptTypeLabel, message: message);
              } on VariableIsNotAffectedException catch (ex) {
                final scriptTypeLabel = translations.fromScriptType(
                  scriptType: ScriptType.otherPiecesMutualConstraint,
                  pieceKind: pieceCountConstraint.pieceKind,
                );
                final message =
                    translations.variableNotAffected(Name: ex.varName);
                Logger().e(ex);
                throw InterpretationError(
                    scriptType: scriptTypeLabel, message: message);
              } on ReturnedValueNotABooleanException catch (ex) {
                final scriptTypeLabel = translations.fromScriptType(
                    scriptType: ScriptType.otherPiecesMutualConstraint);
                final message = translations.returnStatementNotABoolean;
                Logger().e(ex);
                throw InterpretationError(
                  message: message,
                  scriptType: scriptTypeLabel,
                );
              } on ParseCancellationException catch (ex) {
                final scriptTypeLabel = translations.fromScriptType(
                    scriptType: ScriptType.otherPiecesMutualConstraint);
                Logger().e(ex);
                throw InterpretationError(
                  message: ex.message,
                  scriptType: scriptTypeLabel,
                );
              }
            });
          });
        }
        cellsToTest.shuffle();

        for (final currentCell in cellsToTest) {
          String testPosition;
          try {
            testPosition = _placePieceInPosition(
              currentPosition: currentPosition.fen,
              pieceToAdd: _pieceKindToChessPiece(
                pieceCountConstraint.pieceKind,
                mustBeWhitePiece,
              ),
              targetCell: currentCell,
            );
          } on AlreadyAPieceThereException {
            continue;
          }

          // Checking that final position is legal
          final validationResult =
              chess.Chess.validate_fen(testPosition)['valid'];
          if (validationResult) {
            savedCoordinatesForThisCountConstraint.add(currentCell);
            currentPosition =
                chess.Chess.fromFEN(testPosition, check_validity: true);
            successForCurrentIndex = true;
            break;
          }
        }
        if (!successForCurrentIndex) {
          return null;
        }
      }
    }

    return currentPosition.fen;
  }

  List<BoardCoordinate> _getListWithAllCells() {
    List<BoardCoordinate> result = [];
    for (int rank = 0; rank < 8; rank++) {
      for (int file = 0; file < 8; file++) {
        result.add(BoardCoordinate(file, rank));
      }
    }
    return result;
  }

  String _placePieceInPosition({
    required String currentPosition,
    required chess.Piece pieceToAdd,
    required BoardCoordinate targetCell,
  }) {
    final builtPosition = chess.Chess.fromFEN(
      currentPosition,
      check_validity: false,
    );
    final wantedCellOccupied =
        builtPosition.get(targetCell.toUciString()) != null;
    if (wantedCellOccupied) throw AlreadyAPieceThereException();

    builtPosition.put(pieceToAdd, targetCell.toUciString());
    return builtPosition.fen;
  }
}

List<BoardCoordinate> filterCoordinates(List<BoardCoordinate> originalList,
    bool Function(BoardCoordinate) conditionFunc) {
  var result = <BoardCoordinate>[];

  for (final currentCell in originalList) {
    if (conditionFunc(currentCell)) {
      result.add(currentCell);
    }
  }

  return result;
}
