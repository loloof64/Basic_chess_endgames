import 'package:basicchessendgamestrainer/logic/position_generation/position_generation_constraints.dart';
import 'package:basicchessendgamestrainer/providers/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const chessImagesSize = 20.0;

class PieceKindWidget extends ConsumerWidget {
  final PieceKind kind;
  const PieceKindWidget({
    super.key,
    required this.kind,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkThemeProvider);
    final backgroundColor = darkMode ? Colors.white60 : Colors.transparent;
    final assets = pieceKindToAssetPathPair(kind);
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6.0),
      ),
      padding: EdgeInsets.all(10.0),
      child: Row(
        spacing: 2.0,
        mainAxisSize: MainAxisSize.min,
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
      ),
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
