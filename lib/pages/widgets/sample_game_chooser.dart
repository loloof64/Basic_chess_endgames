import 'dart:io';

import 'package:basicchessendgamestrainer/data/asset_games.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:basicchessendgamestrainer/i18n/translations.g.dart';

final fontSize = Platform.isAndroid ? 21.0 : 25.0;
final iconSize = Platform.isAndroid ? 20.0 : 30.0;
final elementsGap = Platform.isAndroid ? 7.0 : 13.0;

class SampleGameChooserPage extends StatelessWidget {
  const SampleGameChooserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final games = getAssetGames(context);
    final dialogChoicesWidget = <Widget>[];

    for (final (index, currentGame) in games.indexed) {
      final targetWidget = GestureDetector(
        onTap: () {
          Navigator.of(context).pop(games[index]);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: elementsGap, right: 2.0),
              child: SvgPicture.asset(
                currentGame.hasWinningGoal
                    ? 'assets/images/trophy.svg'
                    : 'assets/images/handshake.svg',
                fit: BoxFit.cover,
                width: iconSize,
                height: iconSize,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: elementsGap, left: 2.0),
              child: Text(
                currentGame.label,
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          ],
        ),
      );
      dialogChoicesWidget.add(targetWidget);
    }

    final title = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: elementsGap),
          child: Text(
            t.home.goal_label,
            style: TextStyle(fontSize: fontSize),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 1.0, left: 8.0),
          child: SvgPicture.asset(
            'assets/images/trophy.svg',
            fit: BoxFit.cover,
            width: iconSize,
            height: iconSize,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            t.home.win_label,
            style: TextStyle(fontSize: fontSize),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 1.0),
          child: SvgPicture.asset(
            'assets/images/handshake.svg',
            fit: BoxFit.cover,
            width: iconSize,
            height: iconSize,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: elementsGap),
          child: Text(
            t.home.draw_label,
            style: TextStyle(fontSize: fontSize),
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(t.sample_chooser.title),
      ),
      body: Column(
        children: [
          title,
          SingleChildScrollView(
            child: Column(
              children: dialogChoicesWidget,
            ),
          ),
        ],
      ),
    );
  }
}
