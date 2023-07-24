import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

const websiteHomePage = 'https://basic-chess-endgames.netlify.app/';
const privacyPolicyUrl = "https://basic-chess-endgames.netlify.app/privacy";
const useConditionsUrl = "https://basic-chess-endgames.netlify.app/conditions";

Future<bool> loadWebsiteHomePage() async {
  return await _loadWebsite(websiteHomePage);
}

Future<bool> loadPrivacy() async {
  return await _loadWebsite(privacyPolicyUrl);
}

Future<bool> loadUseConditions() async {
  return await _loadWebsite(useConditionsUrl);
}

Future<bool> _loadWebsite(String page) async {
  try {
    final uri = Uri.parse(page);
    // cehcking that user can reach the page
    await http.get(uri);
    await launchUrl(uri);
    return Future.value(true);
  } catch (e) {
    return Future.value(false);
  }
}
