import 'dart:isolate';

import 'package:basicchessendgamestrainer/logic/position_generation/position_generation_from_antlr.dart';
import 'package:basicchessendgamestrainer/logic/position_generation/script_text_interpretation.dart';
import 'package:chess/chess.dart' as chess;
import 'package:basicchessendgamestrainer/components/rgpd_modal_bottom_sheet_content.dart';
import 'package:basicchessendgamestrainer/data/asset_games.dart';
import 'package:basicchessendgamestrainer/models/providers/game_provider.dart';
import 'package:basicchessendgamestrainer/pages/game_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart' show rootBundle;

const mainListItemsGap = 8.0;
const leadingImagesSize = 60.0;
const titlesFontSize = 26.0;
const rgpdWarningHeight = 200.0;
const positionGenerationErrorDialogSpacer = 20.0;

class _SampleScriptGenerationParameters {
  final SendPort sendPort;
  final AppLocalizations localizations;
  final WidgetRef ref;
  final String gameScript;

  _SampleScriptGenerationParameters({
    required this.gameScript,
    required this.localizations,
    required this.ref,
    required this.sendPort,
  });
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Isolate? _positionGenerationIsolate;

  @override
  void initState() {
    FlutterNativeSplash.remove();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showRgpdWarning());
    super.initState();
  }

  @override
  void dispose() {
    _positionGenerationIsolate?.kill();
    super.dispose();
  }

  void _showRgpdWarning() {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (ctx2) {
          return RgpdModalBottomSheetContent(
            context: ctx2,
            height: rgpdWarningHeight,
          );
        });
  }

  Future<void> _tryGeneratingAndPlayingPositionFromSample(
      AssetGame game) async {
    final gameScript = await rootBundle.loadString(game.assetPath);
    final receivePort = ReceivePort();

    setState(() async {
      _positionGenerationIsolate = await Isolate.spawn(
        _generatePositionFromScript,
        _SampleScriptGenerationParameters(
          gameScript: gameScript,
          localizations: AppLocalizations.of(context)!,
          ref: ref,
          sendPort: receivePort.sendPort,
        ),
      );
    });

    receivePort.listen((message) async {
      receivePort.close();
      _positionGenerationIsolate?.kill();

      final (newPosition, errors) =
          message as (String?, List<PositionGenerationError>);

      if (newPosition == null) {
        await _showGenerationErrorsPopups(errors);
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.home_failedGeneratingPosition,
            ),
          ),
        );
      } else {
        _tryPlayingGeneratedPosition(newPosition, game.goal);
      }
    });
  }

  void _generatePositionFromScript(
      _SampleScriptGenerationParameters parameters) {
    final (constraintsExpr, generationErrors) = ScriptTextTransformer(
      allConstraintsScriptText: parameters.gameScript,
      localizations: AppLocalizations.of(context)!,
      ref: parameters.ref,
    ).transformTextIntoConstraints();
    if (generationErrors.isNotEmpty) {
      parameters.sendPort.send((null, generationErrors));
    } else {
      final positionGenerator = PositionGeneratorFromAntlr();
      positionGenerator.setConstraints(constraintsExpr);
      try {
        final generatedPosition = positionGenerator.generatePosition();
        parameters.sendPort
            .send((generatedPosition, <PositionGenerationError>[]));
      } on PositionGenerationLoopException {
        parameters.sendPort.send(
          (
            null,
            PositionGenerationError(
              AppLocalizations.of(context)!.scriptParser_miscErrorDialogTitle,
              AppLocalizations.of(context)!.home_failedGeneratingPosition,
            ),
          ),
        );
      }
    }
  }

  Future<void> _showGenerationErrorsPopups(
      List<PositionGenerationError> errors) async {
    for (final singleError in errors) {
      showDialog(
          context: context,
          builder: (ctx2) {
            return Dialog(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(singleError.title),
                  const SizedBox(
                    height: positionGenerationErrorDialogSpacer,
                  ),
                  Text(singleError.message),
                  const SizedBox(
                    height: positionGenerationErrorDialogSpacer,
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Theme.of(
                          context,
                        ).colorScheme.primary,
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.buttonOk,
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
                      ),
                    ),
                  )
                ],
              ),
            );
          });
    }
  }

  void _tryPlayingGeneratedPosition(String position, Goal goal) {
    final validPositionStatus = chess.Chess.validate_fen(position);
    if (!validPositionStatus['valid']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.home_failedLoadingExercise,
          ),
        ),
      );
      return;
    }

    final playerHasWhite = position.split(' ')[1] != 'b';

    final gameNotifier = ref.read(gameProvider.notifier);
    gameNotifier.updateStartPosition(position);
    gameNotifier.updateGoal(goal);
    gameNotifier.updatePlayerHasWhite(playerHasWhite);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx2) {
        return const GamePage();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sampleGames = getAssetGames(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalizations.of(context)!.homeTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: mainListItemsGap,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: sampleGames.length,
                  itemBuilder: (ctx2, index) {
                    final game = sampleGames[index];

                    final leadingImage = game.goal == Goal.draw
                        ? SvgPicture.asset(
                            'assets/images/handshake.svg',
                            fit: BoxFit.cover,
                            width: leadingImagesSize,
                            height: leadingImagesSize,
                          )
                        : SvgPicture.asset(
                            'assets/images/trophy.svg',
                            fit: BoxFit.cover,
                            width: leadingImagesSize,
                            height: leadingImagesSize,
                          );

                    final title = Text(
                      game.label,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: titlesFontSize,
                      ),
                    );

                    return ListTile(
                      leading: leadingImage,
                      title: title,
                      onTap: () =>
                          _tryGeneratingAndPlayingPositionFromSample(game),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
