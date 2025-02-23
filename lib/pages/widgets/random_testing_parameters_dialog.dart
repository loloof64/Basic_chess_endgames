import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/services.dart';

const int defaultImagesCount = 15;

enum IntermediatePositionsLevel {
  none,
  withMoreThanTheKings,
  all,
}

class RandomTestingParameters {
  final int imagesCount;
  final IntermediatePositionsLevel intermediatePositionsLevel;

  RandomTestingParameters({
    required this.imagesCount,
    required this.intermediatePositionsLevel,
  });
}

class RandomTestingParametersDialog extends HookWidget {
  const RandomTestingParametersDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final imagesCount = useState(defaultImagesCount);
    final addIntermediatesPositions = useState(IntermediatePositionsLevel.none);
    final TextEditingController imagesCountController =
        useTextEditingController(text: imagesCount.value.toString());

    final dropDownButtons = <DropdownMenuItem<IntermediatePositionsLevel>>[
      DropdownMenuItem(
        value: IntermediatePositionsLevel.none,
        child: Text(
          t.random_testing.parameters_dialog.intermediates_positions_level_none,
        ),
      ),
      DropdownMenuItem(
        value: IntermediatePositionsLevel.withMoreThanTheKings,
        child: Text(t.random_testing.parameters_dialog
            .intermediates_positions_level_with_max_pieces),
      ),
      DropdownMenuItem(
        value: IntermediatePositionsLevel.all,
        child: Text(
          t.random_testing.parameters_dialog.intermediates_positions_level_all,
        ),
      ),
    ];

    return AlertDialog(
      title: Text(
        t.random_testing.parameters_dialog.title,
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Row(
              spacing: 10.0,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(t.random_testing.parameters_dialog.images_count),
                Expanded(
                  child: TextField(
                    controller: imagesCountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      imagesCount.value = int.parse(value);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              spacing: 10.0,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(t.random_testing.parameters_dialog
                    .intermediates_positions_level),
                DropdownButton<IntermediatePositionsLevel>(
                  value: addIntermediatesPositions.value,
                  items: dropDownButtons,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      addIntermediatesPositions.value = newValue;
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(null);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
          ),
          child: Text(
            t.misc.button_cancel,
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(
              RandomTestingParameters(
                imagesCount: imagesCount.value,
                intermediatePositionsLevel: addIntermediatesPositions.value,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent,
          ),
          child: Text(
            t.misc.button_ok,
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }
}
