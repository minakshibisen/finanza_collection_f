import 'package:finanza_collection_f/utils/colors.dart';
import 'package:flutter/material.dart';

class InputFieldTitle extends StatelessWidget {
  final String titleText;
  final FontWeight fontWeight;

  const InputFieldTitle({
    required this.titleText,
    this.fontWeight = FontWeight.w600,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        titleText,
        style: TextStyle(fontSize: 14, fontWeight: fontWeight, color: AppColors.titleLightColor),
      ),
    );
  }
}
