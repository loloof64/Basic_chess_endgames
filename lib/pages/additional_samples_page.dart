import 'dart:convert';

import 'package:basicchessendgamestrainer/components/internet_checker.dart';
import 'package:basicchessendgamestrainer/i18n/translations.g.dart';
import 'package:basicchessendgamestrainer/logic/save_text_file.dart';
import 'package:basicchessendgamestrainer/models/available_sample.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'package:basicchessendgamestrainer/models/action_result.dart';

class AdditionalSamplesPage extends HookWidget {
  const AdditionalSamplesPage({super.key});

  Future<AvailableSamplesList> _getAdditionalSamplesNames(Locale locale) async {
    try {
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
    final samplesList = useState<AvailableSamplesList?>(null);
    final isLoading = useState<bool>(true);
    final hasError = useState<bool>(false);
    final locale = Localizations.localeOf(context);

    // Function to fetch samples
    Future<void> fetchSamples() async {
      isLoading.value = true;
      hasError.value = false;
      try {
        samplesList.value = await _getAdditionalSamplesNames(locale);
      } catch (e) {
        hasError.value = true;
        debugPrint(e.toString());
      } finally {
        isLoading.value = false;
      }
    }

    // Fetch data initially
    useEffect(() {
      fetchSamples();
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.additional_samples_page.title),
      ),
      body: InternetChecker(
        onReconnect: fetchSamples, // Retry fetch on every connection change
        onDisconnect:
            fetchSamples, // Retry fetch on every connection change (will update UI with the error)
        child: Center(
          child: isLoading.value
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text(t.additional_samples_page.loading),
                  ],
                )
              : hasError.value
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 50),
                        SizedBox(height: 10),
                        Text(
                          t.additional_samples_page.error_message,
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: samplesList.value!.samples.length,
                      itemBuilder: (context, index) {
                        final sample = samplesList.value!.samples[index];
                        return ListTile(
                          title: ElevatedButton(
                            onPressed: () {
                              _purposeDownloadSample(
                                name: sample.name,
                                label: sample.label,
                                context: context,
                              );
                            },
                            child: Text(sample.label),
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}
