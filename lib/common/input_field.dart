import 'package:flutter/material.dart';

import '../utils/colors.dart';

class InputFieldWidget extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool capitalize;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextEditingController controller;

  const InputFieldWidget(
      {required this.hintText,
        required this.icon,
        super.key,
        this.textInputAction = TextInputAction.done,
        this.keyboardType = TextInputType.text,
        this.capitalize = false,
        required this.controller});

  @override
  Widget build(BuildContext context) {
    TextCapitalization textCapitalization;
    if (capitalize) {
      textCapitalization = TextCapitalization.words;
    } else {
      textCapitalization = TextCapitalization.none;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: AppColors.primaryColor,
          ),
          const SizedBox(width: 5.0),
          Expanded(
            child: TextField(
              textInputAction: textInputAction,
              textCapitalization: textCapitalization,
              keyboardType: keyboardType,
              controller: controller,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
