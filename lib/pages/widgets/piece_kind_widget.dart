import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const chessImagesSize = 30.0;

enum PieceKind {
  playerPawn("player pawn"),
  playerKnight("player knight"),
  playerBishop("player bishop"),
  playerRook("player rook"),
  playerQueen("player queen"),
  playerKing("player king"),
  computerPawn("computer pawn"),
  computerKnight("computer knight"),
  computerBishop("computer bishop"),
  computerRook("computer rook"),
  computerQueen("computer queen"),
  computerKing("computer king");

  final String stringRepr;
  const PieceKind(this.stringRepr);
}

class PieceKingWidget extends StatelessWidget {
  final PieceKind kind;
  const PieceKingWidget({
    super.key,
    required this.kind,
  });

  @override
  Widget build(BuildContext context) {
    final assets = pieceKindToAssetPathPair(kind);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          assets.first,
          fit: BoxFit.cover,
          width: chessImagesSize,
          height: chessImagesSize,
        ),
        SvgPicture.asset(
          assets.second,
          fit: BoxFit.cover,
          width: chessImagesSize,
          height: chessImagesSize,
        )
      ],
    );
  }
}

class StringPair {
  final String first;
  final String second;

  const StringPair({
    required this.first,
    required this.second,
  });
}

StringPair pieceKindToAssetPathPair(PieceKind kind) {
  switch (kind) {
    case PieceKind.playerPawn:
      return const StringPair(
        first: 'assets/images/user.svg',
        second: 'assets/images/chess/Chess_plt45.svg',
      );
    case PieceKind.playerKnight:
      return const StringPair(
        first: 'assets/images/user.svg',
        second: 'assets/images/chess/Chess_nlt45.svg',
      );
    case PieceKind.playerBishop:
      return const StringPair(
        first: 'assets/images/user.svg',
        second: 'assets/images/chess/Chess_blt45.svg',
      );
    case PieceKind.playerRook:
      return const StringPair(
        first: 'assets/images/user.svg',
        second: 'assets/images/chess/Chess_rlt45.svg',
      );
    case PieceKind.playerQueen:
      return const StringPair(
        first: 'assets/images/user.svg',
        second: 'assets/images/chess/Chess_qlt45.svg',
      );
    case PieceKind.computerPawn:
      return const StringPair(
        first: 'assets/images/computer.svg',
        second: 'assets/images/chess/Chess_plt45.svg',
      );
    case PieceKind.computerKnight:
      return const StringPair(
        first: 'assets/images/computer.svg',
        second: 'assets/images/chess/Chess_nlt45.svg',
      );
    case PieceKind.computerBishop:
      return const StringPair(
        first: 'assets/images/computer.svg',
        second: 'assets/images/chess/Chess_blt45.svg',
      );
    case PieceKind.computerRook:
      return const StringPair(
        first: 'assets/images/computer.svg',
        second: 'assets/images/chess/Chess_rlt45.svg',
      );
    case PieceKind.computerQueen:
      return const StringPair(
        first: 'assets/images/computer.svg',
        second: 'assets/images/chess/Chess_qlt45.svg',
      );
    default:
      throw "Invalid piece type $PieceKind";
  }
}
