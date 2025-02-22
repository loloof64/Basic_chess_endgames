import 'dart:math';

import 'package:basicchessendgamestrainer/logic/position_generation/position_generation_constraints.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/script_text_interpretation.dart';
import 'package:chess/chess.dart' as chess;
import 'package:logger/logger.dart';
import 'package:lua_dardo/lua.dart';

dynamic _getValueFromState(LuaState state, String variableName) {
  // Push the global variable onto the stack
  state.getGlobal(variableName);

  // Check the type of the value and return accordingly
  if (state.isNumber(-1)) {
    return state.toNumber(-1);
  } else if (state.isString(-1)) {
    return state.toStr(-1);
  } else if (state.isBoolean(-1)) {
    return state.toBoolean(-1);
  } else {
    return null; // Return null if the type is not handled
  }
}

void _setPredefinedVariableInLua(
  LuaState state,
  String variableName,
  dynamic value,
) {
  if (value is int) {
    state.pushInteger(value);
  } else if (value is double) {
    state.pushNumber(value);
  } else if (value is String) {
    state.pushString(value);
  } else if (value is bool) {
    state.pushBoolean(value);
  } else {
    return; // Return if the type is not handled
  }
  state.setGlobal(variableName);
}

String? _executeLuaCode(LuaState ls, String scriptCode) {
  final success = ls.doString(scriptCode);
  if (!success) {
    return ls.toStr(-1);
  }
  return null;
}

class ScriptResult {
  final dynamic result;
  final String? error;

  const ScriptResult({
    this.result,
    this.error,
  });
}

ScriptResult _loadScript(
    {required String scriptCode,
    Map<String, dynamic> predefinedValues = const {}}) {
  LuaState state = LuaState.newState();
  state.openLibs();

  for (final singleValue in predefinedValues.entries) {
    _setPredefinedVariableInLua(state, singleValue.key, singleValue.value);
  }

  final error = _executeLuaCode(state, scriptCode);
  if (error == null) {
    return ScriptResult(
      result: _getValueFromState(state, "result"),
      error: null,
    );
  } else {
    return ScriptResult(
      result: null,
      error: error,
    );
  }
}

class AlreadyAPieceThereException implements Exception {}

class ResultNotABooleanException implements Exception {}

class MissingResultException implements Exception {}

const commonConstantsPredefinedValues = <String, dynamic>{
  "FileA": 0,
  "FileB": 1,
  "FileC": 2,
  "FileD": 3,
  "FileE": 4,
  "FileF": 5,
  "FileG": 6,
  "FileH": 7,
  "Rank1": 0,
  "Rank2": 1,
  "Rank3": 2,
  "Rank4": 3,
  "Rank5": 4,
  "Rank6": 5,
  "Rank7": 6,
  "Rank8": 7,
};

bool executeScript({
  required String scriptTypeStr,
  required String script,
  required Map<String, dynamic> predefinedValues,
}) {
  final execResult = _loadScript(
    scriptCode: script,
    predefinedValues: predefinedValues,
  );
  if (execResult.error != null) {
    throw PositionGenerationError(
      message: execResult.error!,
      scriptType: scriptTypeStr,
    );
  }

  final returnedValue = execResult.result;
  if (returnedValue == null) {
    throw MissingResultException();
  }
  final valueConvertedAsNonNull = returnedValue;
  if (valueConvertedAsNonNull is! bool) {
    throw ResultNotABooleanException();
  }

  return returnedValue;
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

class PositionGeneratorFromLuaVM {
  PositionGeneratorFromLuaVM({
    required this.translations,
  });

  final TranslationsWrapper translations;
  final _randomNumberGenerator = Random();
  final List<PositionGenerationError> _errors = [];
  final List<String> _rejectedFinalizedPositions = [];

  var _allConstraints = noConstraint;

  void setConstraints(PositionGeneratorConstraintsExpr constraints) {
    _allConstraints = constraints;
  }

  (bool, List<PositionGenerationError>) checkScriptCorrectness() {
    _errors.clear();
    _rejectedFinalizedPositions.clear();

    final playerHasWhite = _randomNumberGenerator.nextBool();
    String currentFen = "8/8/8/8/8/8/8/8 ${playerHasWhite ? 'w' : 'b'} - - 0 1";

    (String, BoardCoordinate) placePieceRandomly(
        String currentPositionFen, String pieceToAddFen) {
      final builtPosition = chess.Chess.fromFEN(
        currentPositionFen,
        check_validity: false,
      );
      final wantedCellOccupied = true;
      while (wantedCellOccupied) {
        final file = _randomNumberGenerator.nextInt(8);
        final rank = _randomNumberGenerator.nextInt(8);
        final targetCell = BoardCoordinate(file, rank);
        if (builtPosition.get(targetCell.toUciString()) == null) {
          return (currentPositionFen, targetCell);
        }
      }
    }

    // place player king randomly
    final (String newFenPK, BoardCoordinate playerKingCell) =
        placePieceRandomly(
      currentFen,
      playerHasWhite ? 'K' : 'k',
    );

    // checks player king constraints
    if (_allConstraints.playerKingConstraint != null) {
      try {
        executeScript(
          scriptTypeStr: translations.fromScriptType(
            scriptType: ScriptType.playerKingConstraint,
          ),
          script: _allConstraints.playerKingConstraint!,
          predefinedValues: <String, dynamic>{
            "file": playerKingCell.file,
            "rank": playerKingCell.rank,
            "playerHasWhite": playerHasWhite,
            ...commonConstantsPredefinedValues,
          },
        );
      } on PositionGenerationError catch (ex) {
        Logger().e(ex);
        rethrow;
      } on MissingResultException catch (ex) {
        final scriptTypeLabel = translations.fromScriptType(
            scriptType: ScriptType.playerKingConstraint);
        final message = translations.missingResultValue;
        Logger().e(ex);
        throw PositionGenerationError(
          message: message,
          scriptType: scriptTypeLabel,
        );
      } on ResultNotABooleanException catch (ex) {
        final scriptTypeLabel = translations.fromScriptType(
            scriptType: ScriptType.playerKingConstraint);
        final message = translations.missingResultValue;
        Logger().e(ex);
        throw PositionGenerationError(
          message: message,
          scriptType: scriptTypeLabel,
        );
      } on Exception catch (ex) {
        final scriptTypeLabel = translations.fromScriptType(
            scriptType: ScriptType.playerKingConstraint);
        String message = ex.toString();
        // we need to find the last before the last index of ":"
        int position = message.lastIndexOf(":", message.lastIndexOf(":") - 1);
        message = message.substring(position).trim();
        message = message.replaceFirst(":", "@");
        Logger().e(ex);
        throw PositionGenerationError(
          message: message,
          scriptType: scriptTypeLabel,
        );
      }
    }

    //place computer king randomly
    final (String newFenBothKings, BoardCoordinate computerKingCell) =
        placePieceRandomly(
      newFenPK,
      playerHasWhite ? 'k' : 'K',
    );

    // checks computer king constraints
    if (_allConstraints.computerKingConstraint != null) {
      try {
        executeScript(
          script: _allConstraints.computerKingConstraint!,
          scriptTypeStr: translations.fromScriptType(
            scriptType: ScriptType.computerKingConstraint,
          ),
          predefinedValues: <String, dynamic>{
            "file": computerKingCell.file,
            "rank": computerKingCell.rank,
            "playerHasWhite": !playerHasWhite,
            ...commonConstantsPredefinedValues,
          },
        );
      } on PositionGenerationError catch (ex) {
        Logger().e(ex);
        rethrow;
      } on MissingResultException catch (ex) {
        final scriptTypeLabel = translations.fromScriptType(
            scriptType: ScriptType.computerKingConstraint);
        final message = translations.missingResultValue;
        Logger().e(ex);
        throw PositionGenerationError(
          message: message,
          scriptType: scriptTypeLabel,
        );
      } on ResultNotABooleanException catch (ex) {
        final scriptTypeLabel = translations.fromScriptType(
            scriptType: ScriptType.computerKingConstraint);
        final message = translations.missingResultValue;
        Logger().e(ex);
        throw PositionGenerationError(
          message: message,
          scriptType: scriptTypeLabel,
        );
      } on Exception catch (ex) {
        final scriptTypeLabel = translations.fromScriptType(
            scriptType: ScriptType.computerKingConstraint);
        String message = ex.toString();
        // we need to find the last before the last index of ":"
        int position = message.lastIndexOf(":", message.lastIndexOf(":") - 1);
        message = message.substring(position).trim();
        message = message.replaceFirst(":", "@");
        Logger().e(ex);
        throw PositionGenerationError(
          message: message,
          scriptType: scriptTypeLabel,
        );
      }
    }

    // checks kings mutual constraints
    if (_allConstraints.kingsMutualConstraint != null) {
      try {
        executeScript(
          script: _allConstraints.kingsMutualConstraint!,
          scriptTypeStr: translations.fromScriptType(
            scriptType: ScriptType.mutualKingConstraint,
          ),
          predefinedValues: <String, dynamic>{
            "playerKingFile": playerKingCell.file,
            "playerKingRank": playerKingCell.rank,
            "computerKingFile": computerKingCell.file,
            "computerKingRank": computerKingCell.rank,
            "playerHasWhite": playerHasWhite,
            ...commonConstantsPredefinedValues,
          },
        );
      } on PositionGenerationError catch (ex) {
        Logger().e(ex);
        rethrow;
      } on MissingResultException catch (ex) {
        final scriptTypeLabel = translations.fromScriptType(
            scriptType: ScriptType.mutualKingConstraint);
        final message = translations.missingResultValue;
        Logger().e(ex);
        throw PositionGenerationError(
          message: message,
          scriptType: scriptTypeLabel,
        );
      } on ResultNotABooleanException catch (ex) {
        final scriptTypeLabel = translations.fromScriptType(
            scriptType: ScriptType.mutualKingConstraint);
        final message = translations.missingResultValue;
        Logger().e(ex);
        throw PositionGenerationError(
          message: message,
          scriptType: scriptTypeLabel,
        );
      } on Exception catch (ex) {
        final scriptTypeLabel = translations.fromScriptType(
            scriptType: ScriptType.mutualKingConstraint);
        String message = ex.toString();
        // we need to find the last before the last index of ":"
        int position = message.lastIndexOf(":", message.lastIndexOf(":") - 1);
        message = message.substring(position).trim();
        message = message.replaceFirst(":", "@");
        Logger().e(ex);
        throw PositionGenerationError(
          message: message,
          scriptType: scriptTypeLabel,
        );
      }
    }

    // checks other pieces constraints
    for (final pieceKindCount in _allConstraints.otherPiecesCountConstraint) {
      // place two instances of pieces in the position with only the two kings
      final (newFen1, piece1Coord) = placePieceRandomly(
        newFenBothKings,
        pieceKindCount.pieceKind.getFen(
          playerHasWhite: playerHasWhite,
        ),
      );
      final (positionWithBothInstances, piece2Coord) = placePieceRandomly(
        newFen1,
        pieceKindCount.pieceKind.getFen(
          playerHasWhite: playerHasWhite,
        ),
      );

      // checks for global constraint
      if (_allConstraints
              .otherPiecesGlobalConstraints[pieceKindCount.pieceKind] !=
          null) {
        try {
          executeScript(
            script: _allConstraints
                .otherPiecesGlobalConstraints[pieceKindCount.pieceKind]!,
            scriptTypeStr: translations.fromScriptType(
              scriptType: ScriptType.otherPiecesGlobalConstraint,
              pieceKind: pieceKindCount.pieceKind,
            ),
            predefinedValues: <String, dynamic>{
              "file": piece1Coord.file,
              "rank": piece1Coord.rank,
              "playerKingFile": playerKingCell.file,
              "playerKingRank": playerKingCell.rank,
              "computerKingFile": computerKingCell.file,
              "computerKingRank": computerKingCell.rank,
              "playerHasWhite": playerHasWhite,
              ...commonConstantsPredefinedValues,
            },
          );
        } on PositionGenerationError catch (ex) {
          final morePreciseEx = ex.withComplexScriptType(
            typeLabel: translations.fromScriptType(
              scriptType: ScriptType.otherPiecesGlobalConstraint,
              pieceKind: pieceKindCount.pieceKind,
            ),
            pieceKind: pieceKindCount.pieceKind,
            translations: translations,
          );
          Logger().e(morePreciseEx);
          throw morePreciseEx;
        } on MissingResultException catch (ex) {
          final scriptTypeLabel = translations.fromScriptType(
            scriptType: ScriptType.otherPiecesGlobalConstraint,
            pieceKind: pieceKindCount.pieceKind,
          );
          final message = translations.missingResultValue;
          Logger().e(ex);
          throw PositionGenerationError(
                  scriptType: scriptTypeLabel, message: message)
              .withComplexScriptType(
            typeLabel: scriptTypeLabel,
            pieceKind: pieceKindCount.pieceKind,
            translations: translations,
          );
        } on ResultNotABooleanException catch (ex) {
          final scriptTypeLabel = translations.fromScriptType(
              scriptType: ScriptType.otherPiecesGlobalConstraint);
          final message = translations.missingResultValue;
          Logger().e(ex);
          throw PositionGenerationError(
            message: message,
            scriptType: scriptTypeLabel,
          ).withComplexScriptType(
            typeLabel: scriptTypeLabel,
            pieceKind: pieceKindCount.pieceKind,
            translations: translations,
          );
        } on Exception catch (ex) {
          final scriptTypeLabel = translations.fromScriptType(
              scriptType: ScriptType.otherPiecesGlobalConstraint);
          String message = ex.toString();
          // we need to find the last before the last index of ":"
          int position = message.lastIndexOf(":", message.lastIndexOf(":") - 1);
          message = message.substring(position).trim();
          message = message.replaceFirst(":", "@");
          Logger().e(ex);
          throw PositionGenerationError(
            message: message,
            scriptType: scriptTypeLabel,
          ).withComplexScriptType(
            typeLabel: scriptTypeLabel,
            pieceKind: pieceKindCount.pieceKind,
            translations: translations,
          );
        }
      }

      // check for mutual constraint
      if (_allConstraints
              .otherPiecesMutualConstraints[pieceKindCount.pieceKind] !=
          null) {
        try {
          executeScript(
            script: _allConstraints
                .otherPiecesMutualConstraints[pieceKindCount.pieceKind]!,
            scriptTypeStr: translations.fromScriptType(
              scriptType: ScriptType.otherPiecesMutualConstraint,
              pieceKind: pieceKindCount.pieceKind,
            ),
            predefinedValues: <String, dynamic>{
              "firstPieceFile": piece1Coord.file,
              "firstPieceRank": piece1Coord.rank,
              "secondPieceFile": piece2Coord.file,
              "secondPieceRank": piece2Coord.rank,
              "playerHasWhite": playerHasWhite,
              ...commonConstantsPredefinedValues,
            },
          );
        } on PositionGenerationError catch (ex) {
          final morePreciseEx = ex.withComplexScriptType(
            typeLabel: translations.fromScriptType(
              scriptType: ScriptType.otherPiecesMutualConstraint,
              pieceKind: pieceKindCount.pieceKind,
            ),
            pieceKind: pieceKindCount.pieceKind,
            translations: translations,
          );
          Logger().e(morePreciseEx);
          throw morePreciseEx;
        } on MissingResultException catch (ex) {
          final scriptTypeLabel = translations.fromScriptType(
            scriptType: ScriptType.otherPiecesMutualConstraint,
            pieceKind: pieceKindCount.pieceKind,
          );
          final message = translations.missingResultValue;
          Logger().e(ex);
          throw PositionGenerationError(
                  scriptType: scriptTypeLabel, message: message)
              .withComplexScriptType(
            typeLabel: scriptTypeLabel,
            pieceKind: pieceKindCount.pieceKind,
            translations: translations,
          );
        } on ResultNotABooleanException catch (ex) {
          final scriptTypeLabel = translations.fromScriptType(
              scriptType: ScriptType.otherPiecesMutualConstraint);
          final message = translations.missingResultValue;
          Logger().e(ex);
          throw PositionGenerationError(
            message: message,
            scriptType: scriptTypeLabel,
          ).withComplexScriptType(
            typeLabel: scriptTypeLabel,
            pieceKind: pieceKindCount.pieceKind,
            translations: translations,
          );
        } on Exception catch (ex) {
          final scriptTypeLabel = translations.fromScriptType(
              scriptType: ScriptType.otherPiecesMutualConstraint);
          String message = ex.toString();
          // we need to find the last before the last index of ":"
          int position = message.lastIndexOf(":", message.lastIndexOf(":") - 1);
          message = message.substring(position).trim();
          message = message.replaceFirst(":", "@");
          Logger().e(ex);
          throw PositionGenerationError(
            message: message,
            scriptType: scriptTypeLabel,
          ).withComplexScriptType(
            typeLabel: scriptTypeLabel,
            pieceKind: pieceKindCount.pieceKind,
            translations: translations,
          );
        }
      }

      // check for indexed constraint
      if (_allConstraints
              .otherPiecesIndexedConstraints[pieceKindCount.pieceKind] !=
          null) {
        try {
          executeScript(
            script: _allConstraints
                .otherPiecesIndexedConstraints[pieceKindCount.pieceKind]!,
            scriptTypeStr: translations.fromScriptType(
              scriptType: ScriptType.otherPiecesIndexedConstraint,
              pieceKind: pieceKindCount.pieceKind,
            ),
            predefinedValues: <String, dynamic>{
              "file": piece1Coord.file,
              "rank": piece1Coord.rank,
              "apparitionIndex": 0,
              "playerHasWhite": playerHasWhite,
              ...commonConstantsPredefinedValues,
            },
          );
        } on PositionGenerationError catch (ex) {
          final morePreciseEx = ex.withComplexScriptType(
            typeLabel: translations.fromScriptType(
              scriptType: ScriptType.otherPiecesIndexedConstraint,
              pieceKind: pieceKindCount.pieceKind,
            ),
            pieceKind: pieceKindCount.pieceKind,
            translations: translations,
          );
          Logger().e(morePreciseEx);
          throw morePreciseEx;
        } on MissingResultException catch (ex) {
          final scriptTypeLabel = translations.fromScriptType(
            scriptType: ScriptType.otherPiecesIndexedConstraint,
            pieceKind: pieceKindCount.pieceKind,
          );
          final message = translations.missingResultValue;
          Logger().e(ex);
          throw PositionGenerationError(
                  scriptType: scriptTypeLabel, message: message)
              .withComplexScriptType(
            typeLabel: scriptTypeLabel,
            pieceKind: pieceKindCount.pieceKind,
            translations: translations,
          );
        } on ResultNotABooleanException catch (ex) {
          final scriptTypeLabel = translations.fromScriptType(
              scriptType: ScriptType.otherPiecesIndexedConstraint);
          final message = translations.missingResultValue;
          Logger().e(ex);
          throw PositionGenerationError(
            message: message,
            scriptType: scriptTypeLabel,
          ).withComplexScriptType(
            typeLabel: scriptTypeLabel,
            pieceKind: pieceKindCount.pieceKind,
            translations: translations,
          );
        } on Exception catch (ex) {
          final scriptTypeLabel = translations.fromScriptType(
              scriptType: ScriptType.otherPiecesIndexedConstraint);
          String message = ex.toString();
          // we need to find the last before the last index of ":"
          int position = message.lastIndexOf(":", message.lastIndexOf(":") - 1);
          message = message.substring(position).trim();
          message = message.replaceFirst(":", "@");
          Logger().e(ex);
          throw PositionGenerationError(
            message: message,
            scriptType: scriptTypeLabel,
          ).withComplexScriptType(
            typeLabel: scriptTypeLabel,
            pieceKind: pieceKindCount.pieceKind,
            translations: translations,
          );
        }
      }
    }

    if (_errors.isNotEmpty) {
      return (false, _errors);
    }

    return (true, []);
  }

  // Returns a Record with
  // 1) String? : the generated position or null
  // 2) List<String> : the list of reject "finalized" positions because of illegals
  // 3) List<PositionGenerationError> : the list of errors
  // can throw
  // PositionGenerationLoopException
  (String?, List<String>, List<PositionGenerationError>) generatePosition() {
    String? finalPosition;

    _errors.clear();
    _rejectedFinalizedPositions.clear();

    final playerHasWhite = _randomNumberGenerator.nextBool();
    final startFen = "8/8/8/8/8/8/8/8 ${playerHasWhite ? 'w' : 'b'} - - 0 1";

    finalPosition = _placePiecesStepPlayerKing(
      startFen: startFen,
      playerHasWhite: playerHasWhite,
    );

    if (_errors.isNotEmpty) {
      return (null, [], _errors);
    }

    if (finalPosition == null) {
      throw PositionGenerationLoopException(
          message: "Failed to place pieces !");
    }

    return (finalPosition, _rejectedFinalizedPositions, []);
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
          ...commonConstantsPredefinedValues,
        };
        try {
          final success = executeScript(
            script: _allConstraints.playerKingConstraint!,
            scriptTypeStr: translations.fromScriptType(
              scriptType: ScriptType.playerKingConstraint,
            ),
            predefinedValues: predefinedValues,
          );
          return success;
        } on PositionGenerationError catch (ex) {
          Logger().e(ex);
          rethrow;
        } on MissingResultException catch (ex) {
          final scriptTypeLabel = translations.fromScriptType(
              scriptType: ScriptType.playerKingConstraint);
          final message = translations.missingResultValue;
          Logger().e(ex);
          throw PositionGenerationError(
            message: message,
            scriptType: scriptTypeLabel,
          );
        } on ResultNotABooleanException catch (ex) {
          final scriptTypeLabel = translations.fromScriptType(
              scriptType: ScriptType.playerKingConstraint);
          final message = translations.missingResultValue;
          Logger().e(ex);
          throw PositionGenerationError(
            message: message,
            scriptType: scriptTypeLabel,
          );
        } on Exception catch (ex) {
          final scriptTypeLabel = translations.fromScriptType(
              scriptType: ScriptType.playerKingConstraint);
          String message = ex.toString();
          // we need to find the last before the last index of ":"
          int position = message.lastIndexOf(":", message.lastIndexOf(":") - 1);
          message = message.substring(position).trim();
          message = message.replaceFirst(":", "@");
          Logger().e(ex);
          throw PositionGenerationError(
            message: message,
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
          ...commonConstantsPredefinedValues,
        };
        try {
          final success = executeScript(
            script: _allConstraints.computerKingConstraint!,
            scriptTypeStr: translations.fromScriptType(
              scriptType: ScriptType.computerKingConstraint,
            ),
            predefinedValues: computerKingConstraintPredefinedValues,
          );
          return success;
        } on PositionGenerationError catch (ex) {
          Logger().e(ex);
          rethrow;
        } on MissingResultException catch (ex) {
          final scriptTypeLabel = translations.fromScriptType(
              scriptType: ScriptType.computerKingConstraint);
          final message = translations.missingResultValue;
          Logger().e(ex);
          throw PositionGenerationError(
            message: message,
            scriptType: scriptTypeLabel,
          );
        } on ResultNotABooleanException catch (ex) {
          final scriptTypeLabel = translations.fromScriptType(
              scriptType: ScriptType.computerKingConstraint);
          final message = translations.missingResultValue;
          Logger().e(ex);
          throw PositionGenerationError(
            message: message,
            scriptType: scriptTypeLabel,
          );
        } on Exception catch (ex) {
          final scriptTypeLabel = translations.fromScriptType(
              scriptType: ScriptType.computerKingConstraint);
          String message = ex.toString();
          // we need to find the last before the last index of ":"
          int position = message.lastIndexOf(":", message.lastIndexOf(":") - 1);
          message = message.substring(position).trim();
          message = message.replaceFirst(":", "@");
          Logger().e(ex);
          throw PositionGenerationError(
            message: message,
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
          ...commonConstantsPredefinedValues,
        };
        try {
          final success = executeScript(
            script: _allConstraints.kingsMutualConstraint!,
            scriptTypeStr: translations.fromScriptType(
              scriptType: ScriptType.mutualKingConstraint,
            ),
            predefinedValues: kingsMutualConstraintPredefinedValues,
          );
          return success;
        } on PositionGenerationError catch (ex) {
          Logger().e(ex);
          rethrow;
        } on MissingResultException catch (ex) {
          final scriptTypeLabel = translations.fromScriptType(
              scriptType: ScriptType.mutualKingConstraint);
          final message = translations.missingResultValue;
          Logger().e(ex);
          throw PositionGenerationError(
            message: message,
            scriptType: scriptTypeLabel,
          );
        } on ResultNotABooleanException catch (ex) {
          final scriptTypeLabel = translations.fromScriptType(
              scriptType: ScriptType.mutualKingConstraint);
          final message = translations.missingResultValue;
          Logger().e(ex);
          throw PositionGenerationError(
            message: message,
            scriptType: scriptTypeLabel,
          );
        } on Exception catch (ex) {
          final scriptTypeLabel = translations.fromScriptType(
              scriptType: ScriptType.mutualKingConstraint);
          String message = ex.toString();
          // we need to find the last before the last index of ":"
          int position = message.lastIndexOf(":", message.lastIndexOf(":") - 1);
          message = message.substring(position).trim();
          message = message.replaceFirst(":", "@");
          Logger().e(ex);
          throw PositionGenerationError(
            message: message,
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
              ...commonConstantsPredefinedValues,
            };
            try {
              final success = executeScript(
                script: currentPieceGlobalConstraint,
                scriptTypeStr: translations.fromScriptType(
                  scriptType: ScriptType.otherPiecesGlobalConstraint,
                ),
                predefinedValues: otherPiecesGlobalConstraintPredefinedValues,
              );
              return success;
            } on PositionGenerationError catch (ex) {
              final morePreciseEx = ex.withComplexScriptType(
                typeLabel: translations.fromScriptType(
                  scriptType: ScriptType.otherPiecesGlobalConstraint,
                  pieceKind: pieceCountConstraint.pieceKind,
                ),
                pieceKind: pieceCountConstraint.pieceKind,
                translations: translations,
              );
              Logger().e(morePreciseEx);
              throw morePreciseEx;
            } on MissingResultException catch (ex) {
              final scriptTypeLabel = translations.fromScriptType(
                scriptType: ScriptType.otherPiecesGlobalConstraint,
                pieceKind: pieceCountConstraint.pieceKind,
              );
              final message = translations.missingResultValue;
              Logger().e(ex);
              throw PositionGenerationError(
                      scriptType: scriptTypeLabel, message: message)
                  .withComplexScriptType(
                typeLabel: scriptTypeLabel,
                pieceKind: pieceCountConstraint.pieceKind,
                translations: translations,
              );
            } on ResultNotABooleanException catch (ex) {
              final scriptTypeLabel = translations.fromScriptType(
                  scriptType: ScriptType.otherPiecesGlobalConstraint);
              final message = translations.missingResultValue;
              Logger().e(ex);
              throw PositionGenerationError(
                message: message,
                scriptType: scriptTypeLabel,
              ).withComplexScriptType(
                typeLabel: scriptTypeLabel,
                pieceKind: pieceCountConstraint.pieceKind,
                translations: translations,
              );
            } on Exception catch (ex) {
              final scriptTypeLabel = translations.fromScriptType(
                  scriptType: ScriptType.otherPiecesGlobalConstraint);
              String message = ex.toString();
              // we need to find the last before the last index of ":"
              int position =
                  message.lastIndexOf(":", message.lastIndexOf(":") - 1);
              message = message.substring(position).trim();
              message = message.replaceFirst(":", "@");
              Logger().e(ex);
              throw PositionGenerationError(
                message: message,
                scriptType: scriptTypeLabel,
              ).withComplexScriptType(
                typeLabel: scriptTypeLabel,
                pieceKind: pieceCountConstraint.pieceKind,
                translations: translations,
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
              ...commonConstantsPredefinedValues,
            };
            try {
              final success = executeScript(
                script: currentPieceIndexedConstraint,
                scriptTypeStr: translations.fromScriptType(
                  scriptType: ScriptType.otherPiecesIndexedConstraint,
                ),
                predefinedValues: otherPieceIndexedConstraintPredefinedValues,
              );
              return success;
            } on PositionGenerationError catch (ex) {
              final morePreciseEx = ex.withComplexScriptType(
                typeLabel: translations.fromScriptType(
                  scriptType: ScriptType.otherPiecesGlobalConstraint,
                  pieceKind: pieceCountConstraint.pieceKind,
                ),
                pieceKind: pieceCountConstraint.pieceKind,
                translations: translations,
              );
              Logger().e(morePreciseEx);
              throw morePreciseEx;
            } on MissingResultException catch (ex) {
              final scriptTypeLabel = translations.fromScriptType(
                scriptType: ScriptType.otherPiecesIndexedConstraint,
                pieceKind: pieceCountConstraint.pieceKind,
              );
              final message = translations.missingResultValue;
              Logger().e(ex);
              throw PositionGenerationError(
                      scriptType: scriptTypeLabel, message: message)
                  .withComplexScriptType(
                typeLabel: scriptTypeLabel,
                pieceKind: pieceCountConstraint.pieceKind,
                translations: translations,
              );
            } on ResultNotABooleanException catch (ex) {
              final scriptTypeLabel = translations.fromScriptType(
                  scriptType: ScriptType.otherPiecesIndexedConstraint);
              final message = translations.missingResultValue;
              Logger().e(ex);
              throw PositionGenerationError(
                message: message,
                scriptType: scriptTypeLabel,
              ).withComplexScriptType(
                typeLabel: scriptTypeLabel,
                pieceKind: pieceCountConstraint.pieceKind,
                translations: translations,
              );
            } on Exception catch (ex) {
              final scriptTypeLabel = translations.fromScriptType(
                  scriptType: ScriptType.otherPiecesIndexedConstraint);
              String message = ex.toString();
              // we need to find the last before the last index of ":"
              int position =
                  message.lastIndexOf(":", message.lastIndexOf(":") - 1);
              message = message.substring(position).trim();
              message = message.replaceFirst(":", "@");
              Logger().e(ex);
              throw PositionGenerationError(
                message: message,
                scriptType: scriptTypeLabel,
              ).withComplexScriptType(
                typeLabel: scriptTypeLabel,
                pieceKind: pieceCountConstraint.pieceKind,
                translations: translations,
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
                ...commonConstantsPredefinedValues,
              };

              try {
                final success = executeScript(
                  script: currentPieceMutualConstraint,
                  scriptTypeStr: translations.fromScriptType(
                    scriptType: ScriptType.otherPiecesMutualConstraint,
                  ),
                  predefinedValues: otherPieceMutualConstraintIntValues,
                );
                return success;
              } on PositionGenerationError catch (ex) {
                final morePreciseEx = ex.withComplexScriptType(
                  typeLabel: translations.fromScriptType(
                    scriptType: ScriptType.otherPiecesGlobalConstraint,
                    pieceKind: pieceCountConstraint.pieceKind,
                  ),
                  pieceKind: pieceCountConstraint.pieceKind,
                  translations: translations,
                );
                Logger().e(morePreciseEx);
                throw morePreciseEx;
              } on MissingResultException catch (ex) {
                final scriptTypeLabel = translations.fromScriptType(
                  scriptType: ScriptType.otherPiecesMutualConstraint,
                  pieceKind: pieceCountConstraint.pieceKind,
                );
                final message = translations.missingResultValue;
                Logger().e(ex);
                throw PositionGenerationError(
                        scriptType: scriptTypeLabel, message: message)
                    .withComplexScriptType(
                  typeLabel: scriptTypeLabel,
                  pieceKind: pieceCountConstraint.pieceKind,
                  translations: translations,
                );
              } on ResultNotABooleanException catch (ex) {
                final scriptTypeLabel = translations.fromScriptType(
                    scriptType: ScriptType.otherPiecesMutualConstraint);
                final message = translations.missingResultValue;
                Logger().e(ex);
                throw PositionGenerationError(
                  message: message,
                  scriptType: scriptTypeLabel,
                ).withComplexScriptType(
                  typeLabel: scriptTypeLabel,
                  pieceKind: pieceCountConstraint.pieceKind,
                  translations: translations,
                );
              } on Exception catch (ex) {
                final scriptTypeLabel = translations.fromScriptType(
                    scriptType: ScriptType.otherPiecesMutualConstraint);
                String message = ex.toString();
                // we need to find the last before the last index of ":"
                int position =
                    message.lastIndexOf(":", message.lastIndexOf(":") - 1);
                message = message.substring(position).trim();
                message = message.replaceFirst(":", "@");
                Logger().e(ex);
                throw PositionGenerationError(
                  message: message,
                  scriptType: scriptTypeLabel,
                ).withComplexScriptType(
                  typeLabel: scriptTypeLabel,
                  pieceKind: pieceCountConstraint.pieceKind,
                  translations: translations,
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
          else {
            _rejectedFinalizedPositions.add(testPosition);
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
