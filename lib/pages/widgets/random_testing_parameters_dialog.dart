import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/services.dart';

const int defaultImagesCount = 15;

class RandomTestingParameters {
  final int imagesCount;

  RandomTestingParameters({required this.imagesCount});
}

class RandomTestingParametersDialog extends HookWidget {
  const RandomTestingParametersDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final imagesCount = useState(defaultImagesCount);
    final TextEditingController imagesCountController =
        useTextEditingController(text: imagesCount.value.toString());

    return AlertDialog(
      title: Text(
        t.random_testing.parameters_dialog.title,
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(t.random_testing.parameters_dialog.images_count),
            TextField(
            controller: imagesCountController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              imagesCount.value = int.parse(value);
            },
          ),
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
