import 'package:basicchessendgamestrainer/models/providers/game_provider.dart';

const games = <Game>[
  Game(
    title: 'Queen&King / King',
    goal: Goal.win,
    startPosition: '8/8/8/4k3/8/8/8/1Q2K3 w - - 0 1',
    playerHasWhite: true,
  ),
  Game(
    title: 'Philidor rooks endgame',
    goal: Goal.draw,
    startPosition: '4k3/7R/8/5K2/4P3/8/8/r7 b - - 0 1',
    playerHasWhite: false,
  ),
  Game(
    title: 'Lucena rooks endgame',
    goal: Goal.win,
    startPosition: '6K1/4k1P1/8/8/8/8/7r/5R2 w - - 0 1',
    playerHasWhite: true,
  ),
  Game(
    title: 'Queen&King / King (errorneous)',
    goal: Goal.win,
    startPosition: '8/8/8/4k3/8/8/1Q6/4K3 w - - 0 1',
    playerHasWhite: true,
  ),
];
