import 'package:flutter/material.dart';

import '../utils/colors.dart';

class InputFieldWidget extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool capitalize;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final int lines;
  final bool hasIcon;

  const InputFieldWidget(
      {required this.hintText,
      this.icon = Icons.receipt,
      Key? key,
      this.textInputAction = TextInputAction.done,
      this.lines = 1,
      this.keyboardType = TextInputType.text,
      this.capitalize = false,
      this.hasIcon = true,
      required this.controller})
      : super(key: key);

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
          if (hasIcon)
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
              maxLines: lines,
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
