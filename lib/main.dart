import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale.fromSubtags(languageCode: 'en'),
        Locale.fromSubtags(languageCode: 'es'),
        Locale.fromSubtags(languageCode: 'fr'),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

const privacyPolicyUrl = "https://basic-chess-endgames.netlify.app/privacy";
const useConditionsUrl = "https://basic-chess-endgames.netlify.app/conditions";

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _showRgpdWarning());
    super.initState();
  }

  void _showRgpdWarning() {
    const height = 200.0;
    const spacerHeight = 10.0;
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (ctx2) {
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
                  const SizedBox(
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
                  const SizedBox(
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
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalizations.of(context)!.homeTitle),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Home page',
            ),
          ],
        ),
      ),
    );
  }
}
