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
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.rgpdText,
            ),
            SizedBox(
              height: spacerHeight,
            ),
            InkWell(
              child: Text(
                AppLocalizations.of(context)!.rgpdPrivacy,
                style: TextStyle(
                  color: Colors.blue[300],
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
                  color: Colors.blue[300],
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
                  Colors.greenAccent,
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.buttonAccept,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
