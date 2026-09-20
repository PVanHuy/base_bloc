import 'package:flutter/material.dart';

abstract final class DialogUtils {
  static Future<void> showErrorDialog(String? message) async {
    final context = _navigatorKey.currentContext;
    if (context == null || !context.mounted) return;

    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message ?? 'An unexpected error occurred.'),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();
}
