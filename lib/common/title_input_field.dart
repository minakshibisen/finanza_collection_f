import 'package:flutter/material.dart';

class InputFieldTitle extends StatelessWidget {
  final String titleText;


  const InputFieldTitle({
    required this.titleText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        titleText,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      ),
    );
  }
}
