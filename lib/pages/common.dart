import 'package:url_launcher/url_launcher.dart';

const websiteHomePage = 'https://basic-chess-endgames.netlify.app/';
const privacyPolicyUrl = "https://basic-chess-endgames.netlify.app/privacy";
const useConditionsUrl = "https://basic-chess-endgames.netlify.app/conditions";

void loadWebsiteHomePage() async {
  await _loadWebsite(websiteHomePage);
}

void loadPrivacy() async {
  await _loadWebsite(privacyPolicyUrl);
}

void loadUseConditions() async {
  await _loadWebsite(useConditionsUrl);
}

Future<void> _loadWebsite(String page) async {
  final uri = Uri.parse(page);
  if (await canLaunchUrl(uri)) await launchUrl(uri);
}
