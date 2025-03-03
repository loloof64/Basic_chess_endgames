import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Goal {
  win,
  draw,
}

@immutable
class GameSession {
  final String title;
  final String startPosition;
  final Goal goal;
  final bool playerHasWhite;

  const GameSession({
    required this.title,
    required this.startPosition,
    required this.goal,
    required this.playerHasWhite,
  });

  GameSession copyWith({
    String? title,
    String? startPosition,
    Goal? goal,
    bool? playerHasWhite,
  }) {
    return GameSession(
      title: title ?? this.title,
      startPosition: startPosition ?? this.startPosition,
      goal: goal ?? this.goal,
      playerHasWhite: playerHasWhite ?? this.playerHasWhite,
    );
  }

  Map<String, String> toMap() {
    return <String, String>{
      'title': title,
      'startPosition': startPosition,
      'goal': goal.toString(),
      'playerHasWhite': playerHasWhite.toString(),
    };
  }

  factory GameSession.fromMap(Map<String, String> map) {
    final titleStr = map['title'];
    final goalStr = map['goal'];
    final goalValue =
        Goal.values.firstWhere((goal) => goal.toString() == 'Goal.$goalStr');
    final playerHasWhite = map['playerHasWhite']!.toLowerCase() == "true";
    return GameSession(
      title: titleStr ?? '',
      startPosition: map['startPosition'] as String,
      goal: goalValue,
      playerHasWhite: playerHasWhite,
    );
  }

  String toJson() => json.encode(toMap());

  factory GameSession.fromJson(String source) =>
      GameSession.fromMap(json.decode(source) as Map<String, String>);

  @override
  String toString() => 'GameSession(startPosition: $startPosition, goal: $goal)';

  @override
  bool operator ==(covariant GameSession other) {
    if (identical(this, other)) return true;

    return other.startPosition == startPosition && other.goal == goal;
  }

  @override
  int get hashCode => startPosition.hashCode ^ goal.hashCode;
}

const emptyPosition = '8/8/8/8/8/8/8/8 w - - 0 1';

class GameSessionNotifier extends StateNotifier<GameSession> {
  GameSessionNotifier()
      : super(
          const GameSession(
            title: '',
            startPosition: emptyPosition,
            goal: Goal.win,
            playerHasWhite: true,
          ),
        );

  void updateStartPosition(String newPosition) {
    state = state.copyWith(startPosition: newPosition);
  }

  void updateGoal(Goal newGoal) {
    state = state.copyWith(goal: newGoal);
  }

  void updatePlayerHasWhite(bool hasWhite) {
    state = state.copyWith(playerHasWhite: hasWhite);
  }

  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }
}

final gameSessionProvider = StateNotifierProvider<GameSessionNotifier, GameSession>(
  (ref) => GameSessionNotifier(),
);