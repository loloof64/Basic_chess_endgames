import 'package:fast_equatable/fast_equatable.dart';

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

class PieceKind with FastEquatable {
  final PieceType pieceType;
  final Side side;

  PieceKind(this.pieceType, this.side);

  @override
  String toString() {
    return "${side.name} ${pieceType.name}";
  }

  @override
  bool get cacheHash => true;

  @override
  List<Object> get hashParameters => [pieceType, side];

  static PieceKind from(String line) {
    return switch (line) {
      'player pawn' => PieceKind(PieceType.pawn, Side.player),
      'player knight' => PieceKind(PieceType.knight, Side.player),
      'player bishop' => PieceKind(PieceType.bishop, Side.player),
      'player rook' => PieceKind(PieceType.rook, Side.player),
      'player queen' => PieceKind(PieceType.queen, Side.player),
      'player king' => PieceKind(PieceType.king, Side.player),
      'computer pawn' => PieceKind(PieceType.pawn, Side.computer),
      'computer knight' => PieceKind(PieceType.knight, Side.computer),
      'computer bishop' => PieceKind(PieceType.bishop, Side.computer),
      'computer rook' => PieceKind(PieceType.rook, Side.computer),
      'computer queen' => PieceKind(PieceType.queen, Side.computer),
      'computer king' => PieceKind(PieceType.king, Side.computer),
      _ => throw Exception('not a recognized piece kind variant : $line')
    };
  }

  String toEasyString() {
    return "${side.toString().split('.').last} ${pieceType.toString().split('.').last}";
  }
}

class PieceKindCount with FastEquatable {
  final PieceKind pieceKind;
  final int count;

  @override
  List<Object> get hashParameters => [pieceKind, count];

  @override
  bool get cacheHash => true;

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
    SingleKingConstraint constraint,
  ) {
    return playerKingIndividualConstraintTester?.call(
          constraint,
        ) ??
        true;
  }

  bool checkComputerKingConstraint(
    SingleKingConstraint constraint,
  ) {
    return computerKingIndividualConstraintTester?.call(
          constraint,
        ) ??
        true;
  }

  bool checkKingsMutualConstraint(
    KingsMutualConstraint constraint,
  ) {
    return kingsMutualConstraintTester?.call(
          constraint,
        ) ??
        true;
  }

  bool checkOtherPieceGlobalConstraint(
    OtherPiecesGlobalConstraint constraint,
  ) {
    return otherPiecesGlobalConstraintTester?.call(
          constraint,
        ) ??
        true;
  }

  bool checkOtherPieceMutualConstraint(
    OtherPiecesMutualConstraint constraint,
  ) {
    return otherPiecesMutualConstraintTester?.call(
          constraint,
        ) ??
        true;
  }

  bool checkOtherPieceIndexedConstraint(
      OtherPiecesIndexedConstraint constraint) {
    return otherPiecesIndexedConstraintTester?.call(
          constraint,
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
}
