import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:basicchessendgamestrainer/i18n/translations.g.dart';

class InternetChecker extends StatefulWidget {
  final Widget child;
  final VoidCallback?
      onReconnect; // Callback triggered when connection is restored
  final VoidCallback?
      onDisconnect; // Callback triggered when connection is lost

  const InternetChecker({
    super.key,
    required this.child,
    this.onReconnect,
    this.onDisconnect,
  });

  @override
  InternetCheckerState createState() => InternetCheckerState();
}

class InternetCheckerState extends State<InternetChecker> {
  late Stream<List<ConnectivityResult>> _connectivityStream;

  @override
  void initState() {
    super.initState();
    _connectivityStream = Connectivity().onConnectivityChanged;
    _connectivityStream.listen(_handleConnectivityChange);
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    // Check if all internet connections are missing
    bool isCompletelyOffline =
        results.every((result) => result == ConnectivityResult.none);

    if (isCompletelyOffline) {
      if (widget.onDisconnect != null) {
        widget.onDisconnect!();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.additional_samples_page.no_internet),
        ),
      );
    } else  {
      // Trigger callback when the connection is restored
      if (widget.onReconnect != null) {
        widget.onReconnect!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
