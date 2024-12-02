import 'package:animate_do/animate_do.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:finanza_collection_f/common/primary_button.dart';
import 'package:finanza_collection_f/common/user_banner.dart';
import 'package:finanza_collection_f/ui/ptp/ptp_screen.dart';
import 'package:finanza_collection_f/utils/colors.dart';
import 'package:finanza_collection_f/common/default_app_bar.dart';
import 'package:finanza_collection_f/utils/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/api_helper.dart';
import '../../common/common_toast.dart';
import '../../common/input_field.dart';
import '../../common/success_dialog.dart';
import '../../common/title_input_field.dart';
import '../../common/titled_dropdown.dart';
import '../../main.dart';
import '../../utils/common_util.dart';
import '../../utils/constants.dart';
import '../../utils/session_helper.dart';
import '../collection/detail_screen.dart';

class AddPtpScreen extends StatefulWidget {
  final String lan;
  final String name;
  final List<String> address;

  const AddPtpScreen({
    super.key,
    required this.lan,
    required this.name,
    required this.address,
  });

  @override
  State<AddPtpScreen> createState() => _AddPtpScreenState();
}

class _AddPtpScreenState extends State<AddPtpScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool isLoading = false;
  bool isListLoading = false;
  List<dynamic> ptpItems = [];

  @override
  void dispose() {
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> addPtpApi() async {
    if (isLoading) return;
    closeKeyboard(context);

    if (_dateController.text.isEmpty) {
      showSnackBar("Select Date", context);
    } else if (_descriptionController.text.isEmpty) {
      showSnackBar("Enter Note", context);
    } else {
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
            'ptp_time': _timeController.text.toString(),
            'user_id': userId.toString(),
            'branch_id': branchId.toString(),
            'longitude': '0.0',
            'latitude': '0.0',
            'narration': _descriptionController.text,
            'lan': widget.lan,
          },
        );

        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        if (response['error'] == true) {
          CommonToast.showToast(
            context: context,
            title: "Request Failed",
            description: response['message'] ?? "Unknown error occurred",
          );
          return;
        } else {
          var data = response;
          if (data['status'] == '0' || (data['error'] != null)) {
            CommonToast.showToast(
                context: context,
                title: "Request Failed",
                description: data['error'].toString(),
                duration: const Duration(seconds: 5));
          } else {
            showSuccessDialog(context, "PTP Added", duration: 2, onDismiss: () {
              Navigator.of(context).pop();
            });
          }
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
  }

  void ptpListApi() async {
    setState(() {
      isListLoading = true;
    });

    try {
      final response = await ApiHelper.postRequest(
        url: BaseUrl + getPTPListByLan,
        body: {
          'lan': widget.lan,
        },
      );

      if (!mounted) return;

      if (response['error'] == true) {
        CommonToast.showToast(
          context: context,
          title: "Request Failed",
          description: response['message'] ?? "Unknown error occurred",
        );
        setState(() {
          ptpItems = [];
          isListLoading = false;
        });
        return;
      }
      print(response);
      final data = response;

      if (data['status'] == '0') {
        CommonToast.showToast(
          context: context,
          title: "Request Failed",
          description: data['error']?.toString() ?? "No data found",
        );
        setState(() {
          ptpItems = [];
          isListLoading = false;
        });
        return;
      }

      setState(() {
        ptpItems = data['response'] ?? [];
        isListLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      CommonToast.showToast(
        context: context,
        title: "Error",
        description: "An unexpected error occurred: ${e.toString()}",
      );

      setState(() {
        ptpItems = [];
        isListLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    ptpListApi();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(title: "Add Promise To Pay", size: size),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserBanner(name: widget.name, lan: widget.lan),
                      const InputFieldTitle(titleText: "Next Visit Date"),
                      DatePickerField(
                        dateController: _dateController,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const InputFieldTitle(titleText: "Next Visit Time"),
                      DatePickerField(
                          dateController: _timeController, time: true),
                      const SizedBox(
                        height: 15,
                      ),
                      /*Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const InputFieldTitle(titleText: "Visit Location"),
                          CustomDropdown<String>(
                            decoration: const CustomDropdownDecoration(
                                expandedFillColor: AppColors.lightGrey,
                                closedFillColor: AppColors.lightGrey,
                                listItemStyle:
                                    TextStyle(fontSize: 13),
                                headerStyle:
                                    TextStyle(fontSize: 14),
                                prefixIcon: Icon(Icons.receipt,
                                    color: AppColors.primaryColor,
                                    size: 18),
                                hintStyle:
                                    TextStyle(fontSize: 12)),
                            hintText: 'Select Visit Location',
                            closedHeaderPadding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 15),
                            items: widget.address,
                            onChanged: (value) => {},
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),*/
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
                      isListLoading
                          ? const SizedBox(
                              height: 150,
                              child: LoadingWidget(
                                size: 30,
                              ),
                            )
                          : Column(
                              children: ptpItems.asMap().entries.map((entry) {
                                final index = entry.key;
                                final item = entry.value;
                                return FadeInLeft(
                                  delay: Duration(milliseconds: index * 160),
                                  child: PtpItemCard(
                                    name: item['pay_date'],
                                    comment: item['comment'],
                                    onTap: () {
                                      // Handle item tap if needed
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FadeInUp(
                duration: const Duration(milliseconds: 1200),
                child: PrimaryButton(
                  onPressed: addPtpApi,
                  context: context,
                  text: "Save",
                  isLoading: isLoading,
                ),
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
  final bool time;

  const DatePickerField(
      {super.key, required this.dateController, this.time = false});

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
    if (!widget.time) {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );

      if (pickedDate != null) {
        setState(() {
          String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
          widget.dateController.text = formattedDate;
        });
      }
    }

    if (widget.time) {
      if (!context.mounted) return;

      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        },
      );
      if (pickedTime != null) {
        setState(() {
          final formattedTime = pickedTime.format(context);
          widget.dateController.text = formattedTime;
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

class PtpItemCard extends StatefulWidget {
  final String name;
  final String comment;
  final VoidCallback onTap;

  const PtpItemCard({
    super.key,
    required this.name,
    required this.comment,
    required this.onTap,
  });

  @override
  State<PtpItemCard> createState() => _PtpItemCardState();
}

class _PtpItemCardState extends State<PtpItemCard> {
  var isOpen = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: Colors.white,
        elevation: 1,
        margin: const EdgeInsets.all(8),
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
                        widget.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.titleColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        textAlign: TextAlign.start,
                        widget.comment,
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
