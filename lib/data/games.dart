enum Goal {
  win,
  draw,
}

class Game {
  final String title;
  final Goal goal;

  Game({
    required this.title,
    required this.goal,
  });
}

final games = <Game>[
  Game(title: 'Queen&King / King', goal: Goal.win),
  Game(title: 'Philidor rooks endgame', goal: Goal.draw),
  Game(title: 'Lucena rooks endgame', goal: Goal.win),
];
