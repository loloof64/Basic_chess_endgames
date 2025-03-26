import 'dart:convert';

import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:basicchessendgamestrainer/logic/save_text_file.dart';
import 'package:basicchessendgamestrainer/models/available_sample.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:basicchessendgamestrainer/models/action_result.dart';

class AdditionalSamplesPage extends StatelessWidget {
  const AdditionalSamplesPage({super.key});

  Future<AvailableSamplesList> _getAdditionalSamplesNames(
      BuildContext context) async {
    try {
      final locale = Localizations.localeOf(context);
      final response = await http.get(
          Uri.parse(
              'https://basic-chess-endgames.vercel.app/api/samples_names'),
          headers: {
            'locale': locale.languageCode,
          });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AvailableSamplesList.fromJson(data);
      } else {
        throw Exception("Failed to get the data from the server !");
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  void _purposeDownloadSample(
      {required String name,
      required String label,
      required BuildContext context}) async {
    final accepted = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:
                Text(t.additional_samples_page.confirm_download(Name: label)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  t.misc.button_cancel,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  t.misc.button_ok,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              )
            ],
          );
        });

    if (accepted != true) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.additional_samples_page.download_cancelled),
        ),
      );
      return;
    }

    try {
      final response = await http.get(
          Uri.parse('https://basic-chess-endgames.vercel.app/api/sample'),
          headers: {
            'name': name,
          });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['content'];

        if (!context.mounted) return;

        final result = await purposeSaveFile(
          context: context,
          content: content,
        );

        if (!context.mounted) return;
        switch (result) {
          case ActionResult.success:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(t.additional_samples_page.download_success),
              ),
            );
            break;
          case ActionResult.error:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(t.additional_samples_page.download_error),
              ),
            );
            break;
          case ActionResult.cancelled:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(t.additional_samples_page.download_cancelled),
              ),
            );
        }
      } else {
        throw Exception("Failed to get the data from the server !");
      }
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.additional_samples_page.download_error),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.additional_samples_page.title),
      ),
      body: Center(
        child: FutureBuilder<AvailableSamplesList>(
            future: _getAdditionalSamplesNames(context),
            builder: (BuildContext context,
                AsyncSnapshot<AvailableSamplesList> snapshot) {
              if (snapshot.hasData) {
                final names = snapshot.data!.samples;
                return ListView.builder(
                  itemCount: names.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: ElevatedButton(
                          onPressed: () => _purposeDownloadSample(
                                context: context,
                                name: names[index].name,
                                label: names[index].label,
                              ),
                          child: Text(names[index].label)),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(t.additional_samples_page.error_message),
                      Text(snapshot.error.toString()),
                    ]);
              } else {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      Text(t.additional_samples_page.loading),
                    ]);
              }
            }),
      ),
    );
  }
}
