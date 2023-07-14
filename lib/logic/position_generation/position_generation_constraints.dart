enum PieceType {
  pawn,
  knight,
  bishop,
  rook,
  queen,
  king;

  PieceKind belongingTo(Side owner) => PieceKind(this, owner);
}

enum Side { player, computer }

class PieceKind {
  final PieceType pieceType;
  final Side side;

  PieceKind(this.pieceType, this.side);

  PieceKindCount inCount(int count) => PieceKindCount(this, count);
}

class PieceKindCount {
  final PieceKind pieceKind;
  final int count;

  PieceKindCount(this.pieceKind, this.count);
}

class PositionConstraints {
  static const fileA = 0;
  static const fileB = 1;
  static const fileC = 2;
  static const fileD = 3;
  static const fileE = 4;
  static const fileF = 5;
  static const fileG = 6;
  static const fileH = 7;

  static const rank1 = 0;
  static const rank2 = 1;
  static const rank3 = 2;
  static const rank4 = 3;
  static const rank5 = 4;
  static const rank6 = 5;
  static const rank7 = 6;
  static const rank8 = 7;

  final SingleKingConstraintTester? playerKingIndividualConstraintTester;
  final SingleKingConstraintTester? computerKingIndividualConstraintTester;
  final KingsMutualConstraintTester? kingsMutualConstraintTester;
  final OtherPiecesCountConstraints? otherPiecesCountConstraint;
  final OtherPiecesGlobalConstraintTester? otherPiecesGlobalConstraintTester;
  final OtherPiecesMutualConstraintTester? otherPiecesMutualConstraintTester;
  final OtherPiecesIndexedConstraintTester? otherPiecesIndexedConstraintTester;

  PositionConstraints({
    this.playerKingIndividualConstraintTester,
    this.computerKingIndividualConstraintTester,
    this.kingsMutualConstraintTester,
    this.otherPiecesCountConstraint,
    this.otherPiecesGlobalConstraintTester,
    this.otherPiecesMutualConstraintTester,
    this.otherPiecesIndexedConstraintTester,
  });

  bool checkPlayerKingConstraint(
    int file,
    int rank,
    bool playerHasWhite,
  ) {
    return playerKingIndividualConstraintTester?.call(
          SingleKingConstraint(
            file: file,
            rank: rank,
            playerHasWhite: playerHasWhite,
          ),
        ) ??
        true;
  }

  bool checkComputerKingConstraint(
    int file,
    int rank,
    bool playerHasWhite,
  ) {
    return computerKingIndividualConstraintTester?.call(
          SingleKingConstraint(
            file: file,
            rank: rank,
            playerHasWhite: playerHasWhite,
          ),
        ) ??
        true;
  }

  bool checkKingsMutualConstraint(
    int playerKingFile,
    int playerKingRank,
    int computerKingFile,
    int computerKingRank,
    bool playerHasWhite,
  ) {
    return kingsMutualConstraintTester?.call(
          KingsMutualConstraint(
            playerKingFile: playerKingFile,
            playerKingRank: playerKingRank,
            computerKingFile: computerKingFile,
            computerKingRank: computerKingRank,
            playerHasWhite: playerHasWhite,
          ),
        ) ??
        true;
  }

  bool checkOtherPieceGlobalConstraint(
    PieceKind pieceKind,
    int file,
    int rank,
    bool playerHasWhite,
    int playerKingFile,
    int playerKingRank,
    int computerKingFile,
    int computerKingRank,
  ) {
    return otherPiecesGlobalConstraintTester?.call(
          OtherPiecesGlobalConstraint(
            file: file,
            rank: rank,
            playerHasWhite: playerHasWhite,
            playerKingFile: playerKingFile,
            playerKingRank: playerKingRank,
            computerKingFile: computerKingFile,
            computerKingRank: computerKingRank,
          ),
        ) ??
        true;
  }

  bool checkOtherPieceMutualConstraint(
    PieceKind pieceKind,
    int firstPieceFile,
    int firstPieceRank,
    int secondPieceFile,
    int secondPieceRank,
    bool playerHasWhite,
  ) {
    return otherPiecesMutualConstraintTester?.call(
          OtherPiecesMutualConstraint(
            firstPieceFile: firstPieceFile,
            firstPieceRank: firstPieceRank,
            secondPieceFile: secondPieceFile,
            secondPieceRank: secondPieceRank,
            playerHasWhite: playerHasWhite,
          ),
        ) ??
        true;
  }

  bool checkOtherPieceIndexedConstraint(
    PieceKind pieceKind,
    int apparitionIndex,
    int file,
    int rank,
    bool playerHasWhite,
  ) {
    return otherPiecesIndexedConstraintTester?.call(
          OtherPiecesIndexedConstraint(
            apparitionIndex: apparitionIndex,
            file: file,
            rank: rank,
            playerHasWhite: playerHasWhite,
          ),
        ) ??
        true;
  }
}

/*
 Individual king global constraint
 */
class SingleKingConstraint {
  final int file;
  final int rank;
  final bool playerHasWhite;

  SingleKingConstraint({
    required this.file,
    required this.rank,
    required this.playerHasWhite,
  });
}

typedef SingleKingConstraintTester = bool Function(
  SingleKingConstraint,
);

/*
 * Constraint between both kings
 */
class KingsMutualConstraint {
  final int playerKingFile;
  final int playerKingRank;
  final int computerKingFile;
  final int computerKingRank;
  final bool playerHasWhite;

  KingsMutualConstraint({
    required this.playerKingFile,
    required this.playerKingRank,
    required this.computerKingFile,
    required this.computerKingRank,
    required this.playerHasWhite,
  });
}

typedef KingsMutualConstraintTester = bool Function(
  KingsMutualConstraint,
);

/*
 * Constraint based on the count of several piece kinds (piece type and side : computer or player).
 */
class OtherPiecesCountConstraints {
  final List<PieceKindCount> allConstraints = <PieceKindCount>[];
}

typedef OtherPiecesGlobalConstraintTester = bool Function(
  OtherPiecesGlobalConstraint,
);

/*
 * Constraint based on the piece coordinate, and both kings positions
 */
class OtherPiecesGlobalConstraint {
  final Map<PieceKind, OtherPiecesGlobalConstraintTester> allConstraints =
      <PieceKind, OtherPiecesGlobalConstraintTester>{};

  final int file;
  final int rank;
  final bool playerHasWhite;
  final int playerKingFile;
  final int playerKingRank;
  final int computerKingFile;
  final int computerKingRank;

  OtherPiecesGlobalConstraint({
    required this.file,
    required this.rank,
    required this.playerHasWhite,
    required this.playerKingFile,
    required this.playerKingRank,
    required this.computerKingFile,
    required this.computerKingRank,
  });

  void set(PieceKind pieceKind, OtherPiecesGlobalConstraintTester constraint) {
    allConstraints[pieceKind] = constraint;
  }

  bool checkConstraint(PieceKind pieceKind) {
    // If no constraint available then condition is considered as met.
    return allConstraints[pieceKind]?.call(this) ?? true;
  }
}

typedef OtherPiecesMutualConstraintTester = bool Function(
  OtherPiecesMutualConstraint,
);

class OtherPiecesMutualConstraint {
  final int firstPieceFile;
  final int firstPieceRank;
  final int secondPieceFile;
  final int secondPieceRank;
  final bool playerHasWhite;

  final Map<PieceKind, OtherPiecesMutualConstraintTester> allConstraints =
      <PieceKind, OtherPiecesMutualConstraintTester>{};

  OtherPiecesMutualConstraint({
    required this.firstPieceFile,
    required this.firstPieceRank,
    required this.secondPieceFile,
    required this.secondPieceRank,
    required this.playerHasWhite,
  });

  void set(PieceKind pieceKind, OtherPiecesMutualConstraintTester constraint) {
    allConstraints[pieceKind] = constraint;
  }

  bool checkConstraint(PieceKind pieceKind) {
    // If no constraint available then condition is considered as met.
    return allConstraints[pieceKind]?.call(this) ?? true;
  }
}

typedef OtherPiecesIndexedConstraintTester = bool Function(
  OtherPiecesIndexedConstraint,
);

/*
 * Constraint based on the piece kind, its generation index (is it the first, the second, ... ?)
 */
class OtherPiecesIndexedConstraint {
  final Map<PieceKind, OtherPiecesIndexedConstraintTester> allConstraints =
      <PieceKind, OtherPiecesIndexedConstraintTester>{};

  final int apparitionIndex;
  final int file;
  final int rank;
  final bool playerHasWhite;

  OtherPiecesIndexedConstraint({
    required this.apparitionIndex,
    required this.file,
    required this.rank,
    required this.playerHasWhite,
  });

  void set(PieceKind pieceKind, OtherPiecesIndexedConstraintTester constraint) {
    allConstraints[pieceKind] = constraint;
  }

  bool checkConstraint(PieceKind pieceKind) {
    // If no constraint available then condition is considered as met.
    return allConstraints[pieceKind]?.call(this) ?? true;
  }
}
