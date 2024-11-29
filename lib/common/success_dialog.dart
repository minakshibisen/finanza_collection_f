import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Future<void> showSuccessDialog(
    BuildContext context,
    String title,
    {VoidCallback? onDismiss,
      int duration = 2}
    ) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      Future.delayed(Duration(seconds: duration), () {
        if (!context.mounted) return;
        Navigator.of(context).pop();
        onDismiss?.call();
      });
      return AlertDialog(
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Lottie.asset(
              'assets/animation/success.json',
              width: 200,
              height: 200,
              repeat: false,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Done'),
            onPressed: () {
              Navigator.of(context).pop();
              onDismiss?.call();
            },
          ),
        ],
      );
    },
  );
}