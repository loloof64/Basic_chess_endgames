import 'package:basicchessendgamestrainer/pages/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RgpdModalBottomSheetContent extends StatelessWidget {
  final spacerHeight = 10.0;

  const RgpdModalBottomSheetContent({
    super.key,
    required this.height,
    required this.context,
  });

  final double height;
  final BuildContext context;

  void _loadPageWithUserAccessCheck(
      Future<bool> Function() pageLoaderFunction) async {
    final success = await pageLoaderFunction();
    if (!success) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            AppLocalizations.of(context)!.no_internet_connection,
          ),
        ),
      );
    }
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
              AppLocalizations.of(context)!.rgpdText,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            SizedBox(
              height: spacerHeight,
            ),
            InkWell(
              onTap: () => _loadPageWithUserAccessCheck(loadPrivacy),
              child: Text(
                AppLocalizations.of(context)!.rgpdPrivacy,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(
              height: spacerHeight,
            ),
            InkWell(
              onTap: () => _loadPageWithUserAccessCheck(loadUseConditions),
              child: Text(
                AppLocalizations.of(context)!.rgpdUseConditions,
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
                backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.tertiary,
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.buttonAccept,
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
