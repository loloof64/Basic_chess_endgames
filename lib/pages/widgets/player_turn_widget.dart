import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayerTurnWidget extends StatelessWidget {
  final bool isWhiteTurn;
  final double size;

  const PlayerTurnWidget({
    super.key,
    required this.isWhiteTurn,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      isWhiteTurn ? FontAwesomeIcons.square : FontAwesomeIcons.solidSquare,
      size: size,
    );
  }
}
