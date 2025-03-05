import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:basicchessendgamestrainer/providers/random_testing_results_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TestingControls extends HookWidget {
  final RandomTestingResult results;
  final void Function() onBackwardFast;
  final void Function() onBackwardStep;
  final void Function() onForwardFast;
  final void Function() onForwardStep;
  final void Function(int pageIndex) onPageSelectionSubmit;

  const TestingControls({
    super.key,
    required this.results,
    required this.onBackwardFast,
    required this.onBackwardStep,
    required this.onForwardStep,
    required this.onForwardFast,
    required this.onPageSelectionSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final pageFieldController = useTextEditingController(text: "1");

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final firstChildrenGroup = [
      IconButton(
        onPressed: onBackwardFast,
        icon: FaIcon(
          FontAwesomeIcons.backwardFast,
        ),
      ),
      IconButton(
        onPressed: onBackwardStep,
        icon: FaIcon(
          FontAwesomeIcons.backwardStep,
        ),
      ),
      Text(
          "${(results.pageIndex + 1).toString().padLeft(3)} / ${(results.pagesCount).toString().padLeft(3)}"),
      IconButton(
        onPressed: onForwardStep,
        icon: FaIcon(
          FontAwesomeIcons.forwardStep,
        ),
      ),
      IconButton(
        onPressed: onForwardFast,
        icon: FaIcon(
          FontAwesomeIcons.forwardFast,
        ),
      ),
    ];

    final secondChildrenGroup = [
      SizedBox(
        width: 60.0,
        child: TextField(
          controller: pageFieldController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
      ),
      ElevatedButton(
        onPressed: () {
          final pageText = pageFieldController.text;
          final pageIndex = int.tryParse(pageText);
          if (pageIndex == null) return;
          // User thinks about pages from 1.
          onPageSelectionSubmit(pageIndex - 1);
        },
        child: Text(t.random_testing.select_page_button),
      ),
    ];

    return isLandscape
        ? Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 10.0,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...firstChildrenGroup,
              ...secondChildrenGroup,
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                Row(
                  spacing: 10,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: firstChildrenGroup,
                ),
                Row(
                  spacing: 10,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: secondChildrenGroup,
                ),
              ]);
  }
}
