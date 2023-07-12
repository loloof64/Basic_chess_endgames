import 'package:basicchessendgamestrainer/components/rgpd_modal_bottom_sheet_content.dart';
import 'package:basicchessendgamestrainer/data/games.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

const mainListItemsGap = 8.0;
const leadingImagesSize = 60.0;
const titlesFontSize = 26.0;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    FlutterNativeSplash.remove();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showRgpdWarning());
    super.initState();
  }

  void _showRgpdWarning() {
    const height = 200.0;
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (ctx2) {
          return RgpdModalBottomSheetContent(
            context: ctx2,
            height: height,
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: mainListItemsGap,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: games.length,
                  itemBuilder: (ctx2, index) {
                    final game = games[index];

                    final leadingImage = game.goal == Goal.draw
                        ? SvgPicture.asset(
                            'assets/images/handshake.svg',
                            fit: BoxFit.cover,
                            width: leadingImagesSize,
                            height: leadingImagesSize,
                          )
                        : SvgPicture.asset(
                            'assets/images/trophy.svg',
                            fit: BoxFit.cover,
                            width: leadingImagesSize,
                            height: leadingImagesSize,
                          );

                    final title = Text(
                      game.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: titlesFontSize,
                      ),
                    );

                    return ListTile(
                      leading: leadingImage,
                      title: title,
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
