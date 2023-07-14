import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class PositionGenerationError {
  final String title;
  final String message;

  const PositionGenerationError(
    this.title,
    this.message,
  );
}

@immutable
class PositionGeneration {
  final String? generatedPosition;
  final List<PositionGenerationError> generationErrors;

  const PositionGeneration(this.generatedPosition, this.generationErrors);

  PositionGeneration copyWith({
    required String? newGeneratedPosition,
    List<PositionGenerationError>? newGenerationErrors,
  }) {
    return PositionGeneration(
      newGeneratedPosition,
      newGenerationErrors ?? generationErrors,
    );
  }
}

class PositionGenerationNotifier extends StateNotifier<PositionGeneration> {
  PositionGenerationNotifier()
      : super(
          const PositionGeneration(
            null,
            <PositionGenerationError>[],
          ),
        );

  void clear() {
    state = const PositionGeneration(null, <PositionGenerationError>[]);
  }

  void setGeneratedPosition(String newValue) {
    state = state.copyWith(newGeneratedPosition: newValue);
  }

  void addError(PositionGenerationError error) {
    state = state.copyWith(
      newGeneratedPosition: state.generatedPosition,
      newGenerationErrors: <PositionGenerationError>[
        ...state.generationErrors,
        error,
      ],
    );
  }
}

final positionGenerationProvider =
    StateNotifierProvider<PositionGenerationNotifier, PositionGeneration>(
  (ref) => PositionGenerationNotifier(),
);
