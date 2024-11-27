import 'package:animate_do/animate_do.dart';
import 'package:finanza_collection_f/common/primary_button.dart';
import 'package:finanza_collection_f/ui/ptp/ptp_screen.dart';
import 'package:finanza_collection_f/utils/colors.dart';
import 'package:finanza_collection_f/common/default_app_bar.dart';
import 'package:flutter/material.dart';

import '../../common/api_helper.dart';
import '../../common/common_toast.dart';
import '../../common/input_field.dart';
import '../../common/title_input_field.dart';
import '../../common/titled_dropdown.dart';
import '../../main.dart';
import '../../utils/common_util.dart';
import '../../utils/constants.dart';
import '../../utils/session_helper.dart';
import '../collection/detail_screen.dart';

class AddPtpScreen extends StatefulWidget {
  const AddPtpScreen({
    super.key,
    required this.lan,
  });

  final String lan;

  @override
  State<AddPtpScreen> createState() => _AddPtpScreenState();
}

class _AddPtpScreenState extends State<AddPtpScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool isLoading = false;
  List<String> visitLocationList = ["a", "b", "c", "d"];

  @override
  void dispose() {
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> addPtpApi() async {
    if (isLoading) return;

    if (_dateController.text.isEmpty) {
    } else if (_descriptionController.text.isEmpty) {}

    setState(() {
      isLoading = true;
    });

    try {
      var userId = await SessionHelper.getSessionData(SessionKeys.userId);
      var branchId = await SessionHelper.getSessionData(SessionKeys.branchId);

      final response = await ApiHelper.postRequest(
        url: BaseUrl + savePtpList,
        body: {
          'ptp_date': _dateController.text.toString(),
          'user_id': userId.toString(),
          'branch_id': branchId.toString(),
          'longitude': '0.0',
          'latitude': '0.0',
          'narration': _descriptionController.text,
          'lan': '',
        },
      );

      if (!mounted) return;

      if (response['error'] == true) {
        CommonToast.showToast(
          context: context,
          title: "Request Failed",
          description: response['message'] ?? "Unknown error occurred",
        );
        return;
      }
      if (response['success'] == true) {
        CommonToast.showToast(
            context: context,
            title: 'Successfully Add PTP',
            description: response['message']);
      }
    } catch (e) {
      if (!mounted) return;

      CommonToast.showToast(
        context: context,
        title: "Error",
        description: "An unexpected error occurred: ${e.toString()}",
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(title: "Add Promise To Pay", size: size),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InputFieldTitle(titleText: "Next Visit Date/Time"),
            DatePickerField(
              dateController: _dateController,
            ),
            const SizedBox(
              height: 15,
            ),
            TitledDropdown(
                items: visitLocationList,
                title: "Visit Location",
                onChanged: (String? value) {}),
            const SizedBox(
              height: 15,
            ),
            const InputFieldTitle(titleText: "Notes"),
            InputFieldWidget(
              hintText: "Enter Notes",
              hasIcon: false,
              lines: 5,
              textInputAction: TextInputAction.done,
              controller: _descriptionController,
            ),
            const SizedBox(
              height: 15,
            ),
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
                  return FadeInLeft(
                    delay: Duration(milliseconds: index * 160),
                    child: CollectionItemCard(
                      title: items[index],
                      lan: '101100156126',
                      description: 'BHAEE BUNGLOW 50 LOKMANYA PAUD ROAD',
                      onTap: () {
                        // Handle item tap if needed
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            FadeInUp(
              duration: const Duration(milliseconds: 1200),
              child: PrimaryButton(
                onPressed: addPtpApi,
                context: context,
                text: "Save",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DatePickerField extends StatefulWidget {
  final TextEditingController dateController;

  const DatePickerField({super.key, required this.dateController});

  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  @override
  void dispose() {
    widget.dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    // Pick a date
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // Pick a time
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          final formattedDate = "${pickedDate.toLocal()}".split(' ')[0];
          final formattedTime = pickedTime.format(context);
          widget.dateController.text = "$formattedDate $formattedTime";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDateTime(context),
      child: AbsorbPointer(
        child: InputFieldWidget(
          hintText: "Select Date and Time",
          icon: Icons.calendar_month,
          textInputAction: TextInputAction.next,
          controller: widget.dateController,
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
