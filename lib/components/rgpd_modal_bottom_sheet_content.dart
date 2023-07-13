import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const privacyPolicyUrl = "https://basic-chess-endgames.netlify.app/privacy";
const useConditionsUrl = "https://basic-chess-endgames.netlify.app/conditions";

class RgpdModalBottomSheetContent extends StatelessWidget {
  final spacerHeight = 10.0;

  const RgpdModalBottomSheetContent({
    super.key,
    required this.height,
    required this.context,
  });

  final double height;
  final BuildContext context;

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
              child: Text(
                AppLocalizations.of(context)!.rgpdPrivacy,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  decoration: TextDecoration.underline,
                ),
              ),
              onTap: () async {
                final uri = Uri.parse(privacyPolicyUrl);
                if (await canLaunchUrl(uri)) await launchUrl(uri);
              },
            ),
            SizedBox(
              height: spacerHeight,
            ),
            InkWell(
              child: Text(
                AppLocalizations.of(context)!.rgpdUseConditions,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondary,
                  decoration: TextDecoration.underline,
                ),
              ),
              onTap: () async {
                final uri = Uri.parse(useConditionsUrl);
                if (await canLaunchUrl(uri)) await launchUrl(uri);
              },
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
