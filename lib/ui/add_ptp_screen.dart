import 'package:finanza_collection_f/utils/colors.dart';
import 'package:finanza_collection_f/utils/default_app_bar.dart';
import 'package:flutter/material.dart';

import '../common/input_field.dart';
import '../common/title_input_field.dart';

class AddPtpScreen extends StatefulWidget {
  const AddPtpScreen({super.key});

  @override
  State<AddPtpScreen> createState() => _AddPtpScreenState();
}
final TextEditingController _dateController = TextEditingController();
final TextEditingController _descriptionController = TextEditingController();

class _AddPtpScreenState extends State<AddPtpScreen> {
  List<String> items = [
    'Pramod Kumar Matho',
  ];
  get inputController => null;



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(title: "Promise To Pay", size: size),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleInputField(titleText: "Next Visit Date"),
            DatePickerField(),
            const SizedBox(
              height: 15,
            ),
            const TitleInputField(titleText: "Description"),
            InputFieldWidget(
              hintText: "Enter Description",
              icon: Icons.receipt,
              textInputAction: TextInputAction.next,
              controller: _descriptionController,
            ),
            const SizedBox(height: 15,),
            const Text(
              "Previous Promises",
              style: TextStyle(
                color: AppColors.titleColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return CollectionItemCard(
                    title: items[index],
                    lan: '101100156126',
                    description: 'BHAEE BUNGLOW 50 LOKMANYA PAUD ROAD',
                    onTap: () {
                      // Handle item tap if needed
                    },
                  );
                },
              ),
            ),
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

class CollectionItemCard extends StatefulWidget {
  final String title;
  final String lan;
  final String description;
  final VoidCallback onTap;

  const CollectionItemCard({
    super.key,
    required this.title,
    required this.lan,
    required this.description,
    required this.onTap,
  });

  @override
  State<CollectionItemCard> createState() => _CollectionItemCardState();
}

class _CollectionItemCardState extends State<CollectionItemCard> {
  var isOpen = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: Colors.white,
        elevation: 1,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Container(
              // color: AppColors.lightGrey,
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.titleColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'LAN: ',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.titleColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.lan,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        textAlign: TextAlign.start,
                        widget.description,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.titleColor),
                      ),
                      // const SizedBox(height: 8),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 15),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}