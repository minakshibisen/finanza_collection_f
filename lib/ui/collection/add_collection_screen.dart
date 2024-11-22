import 'package:animate_do/animate_do.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:finanza_collection_f/common/title_input_field.dart';
import 'package:finanza_collection_f/common/titled_dropdown.dart';
import 'package:finanza_collection_f/utils/colors.dart';
import 'package:finanza_collection_f/common/default_app_bar.dart';
import 'package:flutter/material.dart';

import '../../common/input_field.dart';
import '../../utils/common_util.dart';

class AddCollectionScreen extends StatefulWidget {
  const AddCollectionScreen({super.key});

  @override
  State<AddCollectionScreen> createState() => _AddCollectionScreenState();
}

final TextEditingController _dateController = TextEditingController();
final TextEditingController _receiptController = TextEditingController();
final TextEditingController _commentController = TextEditingController();

class _AddCollectionScreenState extends State<AddCollectionScreen> {
  List<String> receiptModeList = [
    "Cash",
    "Cheque",
    "Direct Deposit",
    "Internet",
  ];
  List<String> bankList = [
    "Option 1",
    "Option 2",
    "Option 3",
    "Option 4",
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.textOnPrimary,
      appBar: DefaultAppBar(title: "Add Collection ", size: size),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FadeInDown(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitledDropdown(
                    items: receiptModeList,
                    title: "Receipt Mode",
                    onChanged: (String? value) {}),
                const SizedBox(
                  height: 15,
                ),
                TitledDropdown(
                    items: bankList,
                    title: "Bank/Cash A/c",
                    onChanged: (String? value) {}),
                const SizedBox(
                  height: 15,
                ),
                const InputFieldTitle(titleText: "Instrument Date"),
                const DatePickerField(),
                const SizedBox(
                  height: 15,
                ),
                const InputFieldTitle(titleText: "Inst/Receipt Number"),
                InputFieldWidget(
                  hintText: "Enter Receipt No.",
                  icon: Icons.receipt,
                  textInputAction: TextInputAction.next,
                  capitalize: true,
                  controller: _receiptController,
                ),
                const SizedBox(
                  height: 15,
                ),
                CollectionTypeSelect(),
                const InputFieldTitle(titleText: "Comment / Narration"),
                InputFieldWidget(
                  hintText: "Enter Comment",
                  icon: Icons.comment,
                  textInputAction: TextInputAction.next,
                  controller: _commentController,
                  capitalize: true,
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CollectionTypeSelect extends StatefulWidget {
  CollectionTypeSelect({super.key});

  @override
  State<CollectionTypeSelect> createState() => _CollectionTypeSelectState();
}

class _CollectionTypeSelectState extends State<CollectionTypeSelect> {
  final List<String> type = [
    "Option 1",
    "Option 2",
    "Option 3",
    "Option 4",
  ];

  List<CollectionItem> items = [
    CollectionItem(
      amount: 0,
      type: "",
      controller: TextEditingController(), //
    )
  ];

  double totalAmount = 0;

  @override
  void initState() {
    super.initState();
    _addItem();
  }

  void _addItem() {
    setState(() {
      items.add(CollectionItem(
        amount: 0,
        type: type[0],
        controller: TextEditingController(), //
      ));
    });
  }

  void _removeItem() {
    setState(() {
      if (items.length > 1) {
        final item = items.removeLast();
        item.controller.dispose();
        _calculateAll();
      }
    });
  }

  @override
  void dispose() {
    for (var item in items) {
      item.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: _removeItem,
              child: Container(
                width: 33,
                height: 33,
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.titleLightColor,
                ),
                child: const Icon(
                  Icons.remove,
                  color: AppColors.textOnPrimary,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _addItem,
              child: Container(
                width: 33,
                height: 33,
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor,
                ),
                child: const Icon(
                  Icons.add,
                  color: AppColors.textOnPrimary,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            SizedBox(
              width: (size.width - 32) * .6,
              child: const Text(
                "Collection Type",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.titleLightColor,
                ),
              ),
            ),
            SizedBox(
              width: (size.width - 32) * .4,
              child: const Text(
                "Amount",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.titleLightColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Column(
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: _buildCollectionRow(size.width, item, index),
            );
          }).toList(),
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            textAlign: TextAlign.end,
            "Total Amount: ₹ ${getFancyNumber(totalAmount)}",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.titleLightColor,
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  void _calculateAll() {
    double amount = 0;
    for (var item in items) {
      amount += item.amount;
    }

    setState(() {
      totalAmount = amount;
    });
  }

  Widget _buildCollectionRow(double size, CollectionItem item, int index) {
    if (!item.hasListener) {
      item.controller.addListener(() {
        final text = item.controller.text;
        if (text.isNotEmpty) {
          item.amount = double.tryParse(text) ?? 0;
        } else {
          item.amount = 0;
        }
      });
      item.hasListener = true;
    }

    return Row(
      children: [
        Flexible(
          flex: 6,
          child: CustomDropdown<String>(
            decoration: const CustomDropdownDecoration(
              expandedFillColor: AppColors.lightGrey,
              closedFillColor: AppColors.lightGrey,
              listItemStyle: TextStyle(fontSize: 13),
              headerStyle: TextStyle(fontSize: 14),
              prefixIcon: Icon(
                Icons.receipt,
                color: AppColors.primaryColor,
                size: 18,
              ),
              hintStyle: TextStyle(fontSize: 12),
            ),
            hintText: 'Please Select',
            closedHeaderPadding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 15,
            ),
            items: type,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  item.type = value;
                });
              }
            },
          ),
        ),
        SizedBox(width: size * 0.05),
        Flexible(
          flex: 4,
          child: InputFieldWidget(
            hintText: "",
            keyboardType: TextInputType.number,
            length: 6,
            controller: item.controller,
            onChanged: (value) {
              setState(() {
                item.amount = double.tryParse(value) ?? 0;
                _calculateAll();
              });
            },
          ),
        ),
      ],
    );
  }
}

class CollectionItem {
  double amount;
  String type;
  final TextEditingController controller;
  bool hasListener = false;

  CollectionItem({
    required this.amount,
    required this.type,
    required this.controller,
  });
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
        child: InputFieldWidget(
          hintText: "Select Date",
          keyboardType: TextInputType.none,
          icon: Icons.calendar_month,
          textInputAction: TextInputAction.next,
          controller: _dateController,
          enabled: true,
        ),
      ),
    );
  }
}
