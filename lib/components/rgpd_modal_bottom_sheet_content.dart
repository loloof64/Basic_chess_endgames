import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

const spacerHeight = 10.0;

class RgpdModalBottomSheetContent extends StatelessWidget {
  const RgpdModalBottomSheetContent({
    super.key,
    required this.height,
    required this.context,
  });

  final double height;
  final BuildContext context;

  void _showPrivacyDialog() {
    showDialog(
        context: context,
        builder: (ctx2) {
          return AlertDialog(
            title: Text(t.privacy.title),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.privacy.content1),
                  Text(t.privacy.content2),
                  Text(t.privacy.content3),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx2).pop(),
                child: Text(
                  t.misc.button_ok,
                ),
              )
            ],
          );
        });
  }

  void _showUseConditionsDialog() {
    showDialog(
        context: context,
        builder: (ctx2) {
          return AlertDialog(
            title: Text(t.use_conditions.title),
            content:
                SingleChildScrollView(child: Text(t.use_conditions.content)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx2).pop(),
                child: Text(
                  t.misc.button_ok,
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: Theme.of(context).colorScheme.secondary,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              t.rgpd.text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            const Gap(spacerHeight),
            InkWell(
              onTap: _showPrivacyDialog,
              child: Text(
                t.privacy.title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const Gap(spacerHeight),
            InkWell(
              onTap: _showUseConditionsDialog,
              child: Text(
                t.use_conditions.title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).colorScheme.tertiary,
                ),
              ),
              child: Text(
                t.misc.button_ok,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
