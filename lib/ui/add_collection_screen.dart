import 'package:finanza_collection_f/common/title_input_field.dart';
import 'package:finanza_collection_f/utils/colors.dart';
import 'package:finanza_collection_f/utils/default_app_bar.dart';
import 'package:flutter/material.dart';

import '../common/input_field.dart';

class AddCollectionScreen extends StatefulWidget {
  const AddCollectionScreen({super.key});

  @override
  State<AddCollectionScreen> createState() => _AddCollectionScreenState();
}

final TextEditingController _dateController = TextEditingController();
final TextEditingController _receiptController = TextEditingController();
final TextEditingController _commentController = TextEditingController();

class _AddCollectionScreenState extends State<AddCollectionScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.textOnPrimary,
      appBar: DefaultAppBar(title: "Add Collection ", size: size),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleInputField(titleText: "Instrument Date"),
            const DatePickerField(),
            const SizedBox(
              height: 15,
            ),
            const TitleInputField(titleText: "Inst / Receipt No."),
            InputFieldWidget(
              hintText: "Enter Receipt No.",
              icon: Icons.receipt,
              textInputAction: TextInputAction.next,
              controller: _receiptController,
            ),
            const SizedBox(
              height: 15,
            ),
            const TitleInputField(titleText: "Comment / Narration"),
            InputFieldWidget(
              hintText: "Enter Comment",
              icon: Icons.comment,
              textInputAction: TextInputAction.next,
              controller: _commentController,
            ),

            const SizedBox(
              height: 15,
            ),

          //const CustomDropdown(),
          ],
        ),
      ),
    );
  }
}

class DatePickerField extends StatefulWidget {
  const DatePickerField({super.key});

  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child:   InputFieldWidget(
          hintText: "Select Date",
          icon: Icons.calendar_month,
          textInputAction: TextInputAction.next,
          controller: _dateController,
        ),
      ),
    );
  }
}


class CustomDropdown extends StatefulWidget {
  const CustomDropdown({super.key});

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedBranch;
  final List<String> branches = [
    'Branch 1',
    'Branch 2',
    'Branch 3',
    'Branch 4'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: .5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: const Text(
            'Select Branch',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textColor,
              fontSize: 15,
            ),
          ),
          value: selectedBranch,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
          iconSize: 24,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
            fontSize: 15,
          ),
          onChanged: (String? newValue) {
            setState(() {
              selectedBranch = newValue!;
            });
          },
          items: branches.map<DropdownMenuItem<String>>((String branch) {
            return DropdownMenuItem<String>(
              value: branch,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  branch,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
