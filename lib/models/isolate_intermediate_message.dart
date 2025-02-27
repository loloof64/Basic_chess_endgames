import 'package:basicchessendgamestrainer/logic/position_generation/script_text_interpretation.dart';

class ExitBusyStatus {}

class CreateGeneratorIsolate {
  final SampleScriptGenerationParameters generationParameters;
  final void Function(SampleScriptGenerationParameters parameters)
      generatePosition;

  const CreateGeneratorIsolate({
    required this.generatePosition,
    required this.generationParameters,
  });
}

class KillPositionGeneratorIsolate {}

typedef GenerationResultReady = (List<String>, List<String>, List<Map<String, dynamic>>);
