import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:basicchessendgamestrainer/models/providers/game_provider.dart';
import 'package:flutter/material.dart';

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
      label: t.sample_script.kq_k,
      goal: Goal.win,
    ),
    AssetGame(
      assetPath: 'assets/sample_scripts/kr_k.txt',
      label: t.sample_script.kr_k,
      goal: Goal.win,
    ),
    AssetGame(
      assetPath: 'assets/sample_scripts/krr_k.txt',
      label: t.sample_script.krr_k,
      goal: Goal.win,
    ),
    AssetGame(
      assetPath: 'assets/sample_scripts/kbb_k.txt',
      label: t.sample_script.kbb_k,
      goal: Goal.win,
    ),
    AssetGame(
      assetPath: 'assets/sample_scripts/kp_k_1.txt',
      label: t.sample_script.kp_k1,
      goal: Goal.win,
    ),
    AssetGame(
      assetPath: 'assets/sample_scripts/kp_k_2.txt',
      label: t.sample_script.kp_k2,
      goal: Goal.draw,
    ),
    AssetGame(
      assetPath: 'assets/sample_scripts/kppp_kppp.txt',
      label: t.sample_script.kppp_kppp,
      goal: Goal.win,
    ),
    AssetGame(
      assetPath: 'assets/sample_scripts/lucena_rook_ending.txt',
      label: t.sample_script.rook_ending_lucena,
      goal: Goal.win,
    ),
    AssetGame(
      assetPath: 'assets/sample_scripts/philidor_rook_ending.txt',
      label: t.sample_script.rook_ending_philidor,
      goal: Goal.draw,
    )
  ];
}
