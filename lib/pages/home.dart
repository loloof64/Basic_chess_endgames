import 'package:basicchessendgamestrainer/data/stockfish_manager.dart';
import 'package:basicchessendgamestrainer/pages/widgets/home_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemNavigator;

const mainListItemsGap = 8.0;
const leadingImagesSize = 60.0;
const titlesFontSize = 26.0;
const rgpdWarningHeight = 200.0;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _handleExit(bool didPop, Object? result) async {
    if (didPop) return;
    stockfishManager.dispose();
    await SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _handleExit,
      child: const HomeWidget(),
    );
  }
}
