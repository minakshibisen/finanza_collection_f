import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:finanza_collection_f/common/title_input_field.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class TitledDropdown extends StatefulWidget {
  final double fontSize;
  final double hintSize;
  final String title;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const TitledDropdown(
      {super.key, this.fontSize = 14, this.hintSize = 12, required this.items, required this.title, required this.onChanged});

  @override
  State<TitledDropdown> createState() => _TitledDropdownState();
}

class _TitledDropdownState extends State<TitledDropdown> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputFieldTitle(titleText: widget.title),
        CustomDropdown<String>(
          decoration: CustomDropdownDecoration(
              expandedFillColor: AppColors.lightGrey,
              closedFillColor: AppColors.lightGrey,
              listItemStyle: TextStyle(fontSize: widget.fontSize - 1),
              headerStyle: TextStyle(fontSize: widget.fontSize),
              prefixIcon: Icon(Icons.receipt, color: AppColors.primaryColor, size: widget.fontSize + 4),
              hintStyle: TextStyle(fontSize: widget.hintSize)),
          hintText: 'Select ${widget.title}',
          closedHeaderPadding:  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
          items: widget.items,
          onChanged: widget.onChanged,

        ),
      ],
    );
  }
}
