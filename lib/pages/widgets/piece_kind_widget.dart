import 'package:basicchessendgamestrainer/logic/position_generation/position_generation_constraints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const chessImagesSize = 20.0;

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
  switch (kind.toEasyString()) {
    case 'player pawn':
      return const StringPair(
        first: 'assets/images/user.svg',
        second: 'assets/images/chess/Chess_plt45.svg',
      );
    case 'player knight':
      return const StringPair(
        first: 'assets/images/user.svg',
        second: 'assets/images/chess/Chess_nlt45.svg',
      );
    case 'player bishop':
      return const StringPair(
        first: 'assets/images/user.svg',
        second: 'assets/images/chess/Chess_blt45.svg',
      );
    case 'player rook':
      return const StringPair(
        first: 'assets/images/user.svg',
        second: 'assets/images/chess/Chess_rlt45.svg',
      );
    case 'player queen':
      return const StringPair(
        first: 'assets/images/user.svg',
        second: 'assets/images/chess/Chess_qlt45.svg',
      );
    case 'computer pawn':
      return const StringPair(
        first: 'assets/images/computer.svg',
        second: 'assets/images/chess/Chess_plt45.svg',
      );
    case 'computer knight':
      return const StringPair(
        first: 'assets/images/computer.svg',
        second: 'assets/images/chess/Chess_nlt45.svg',
      );
    case 'computer bishop':
      return const StringPair(
        first: 'assets/images/computer.svg',
        second: 'assets/images/chess/Chess_blt45.svg',
      );
    case 'computer rook':
      return const StringPair(
        first: 'assets/images/computer.svg',
        second: 'assets/images/chess/Chess_rlt45.svg',
      );
    case 'computer queen':
      return const StringPair(
        first: 'assets/images/computer.svg',
        second: 'assets/images/chess/Chess_qlt45.svg',
      );
    default:
      throw "Invalid piece type '${kind.toEasyString()}'";
  }
}
