import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final int? length;
  final bool enabled;
  ValueChanged<String>? onChanged;

  InputFieldWidget(
      {required this.hintText,
      this.icon = Icons.receipt,
      super.key,
      this.textInputAction = TextInputAction.done,
      this.lines = 1,
      this.length,
      this.keyboardType = TextInputType.text,
      this.capitalize = false,
      this.hasIcon = true,
      this.enabled = false,
      this.onChanged, required this.controller});

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
          const SizedBox(width: 10.0),
          Expanded(
            child: TextField(
              textInputAction: textInputAction,
              textCapitalization: textCapitalization,
              keyboardType: keyboardType,
              maxLines: lines,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              readOnly: enabled,
              maxLength: length,
              controller: controller,
              canRequestFocus: !enabled,
              showCursor: !enabled,
              onChanged: onChanged,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                counterText: "",
                hintStyle: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
