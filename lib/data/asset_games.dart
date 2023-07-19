import 'package:basicchessendgamestrainer/models/providers/game_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AssetGame {
  final String assetPath;
  final String label;
  final Goal goal;

  AssetGame({
    required this.assetPath,
    required this.label,
    required this.goal,
  });
}

List<AssetGame> getAssetGames(BuildContext context) {
  return <AssetGame>[
    AssetGame(
      assetPath: 'assets/sample_scripts/kq_k.txt',
      label: AppLocalizations.of(context)!.sampleScript_kqK,
      goal: Goal.win,
    ),
    AssetGame(
      assetPath: 'assets/sample_scripts/kr_k.txt',
      label: AppLocalizations.of(context)!.sampleScript_krK,
      goal: Goal.win,
    ),
    AssetGame(
      assetPath: 'assets/sample_scripts/krr_k.txt',
      label: AppLocalizations.of(context)!.sampleScript_krrK,
      goal: Goal.win,
    ),
    AssetGame(
      assetPath: 'assets/sample_scripts/kbb_k.txt',
      label: AppLocalizations.of(context)!.sampleScript_kbbK,
      goal: Goal.win,
    ),
    AssetGame(
      assetPath: 'assets/sample_scripts/kp_k_1.txt',
      label: AppLocalizations.of(context)!.sampleScript_kpK1,
      goal: Goal.win,
    ),
    AssetGame(
      assetPath: 'assets/sample_scripts/kp_k_2.txt',
      label: AppLocalizations.of(context)!.sampleScript_kpK2,
      goal: Goal.draw,
    ),
    AssetGame(
      assetPath: 'assets/sample_scripts/kppp_kppp.txt',
      label: AppLocalizations.of(context)!.sampleScript_kpppKppp,
      goal: Goal.win,
    ),
  ];
}
