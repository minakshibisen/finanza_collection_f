import 'package:flutter/material.dart';

import '../../common/api_helper.dart';
import '../../common/common_toast.dart';
import '../../common/input_field.dart';
import '../../common/title_input_field.dart';
import '../../common/titled_dropdown.dart';

import '../../main.dart';
import '../../utils/colors.dart';
import '../../common/default_app_bar.dart';
import '../../utils/constants.dart';


class CollectionReportScreen extends StatefulWidget {
  const CollectionReportScreen({super.key});

  @override
  State<CollectionReportScreen> createState() => _CollectionReportScreenState();
}

class _CollectionReportScreenState extends State<CollectionReportScreen> {

  final TextEditingController _dateController = TextEditingController();
  String? selectStatusMode;
  var isLoading = false;
  Map<String, dynamic> collectionStatusList = {};


  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    collectionStatusApi();
  }

  void collectionStatusApi() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await ApiHelper.getRequest(
        url: BaseUrl + getCollectionStatusReport,
      );

      if (!mounted) return;

      if (response['error'] == true) {
        CommonToast.showToast(
          context: context,
          title: "Request Failed",
          description: response['message'] ?? "Unknown error occurred",
        );
        setState(() {
          collectionStatusList = {};
          isLoading = false;
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
          collectionStatusList = {};
          isLoading = false;
        });
        return;
      } else if(data['status'] == '1') {
        final Map<String, String> dropdownMap = {
          for (var item in data['response'])
            item['key']: item['value']
        };

        setState(() {
          collectionStatusList = dropdownMap;
          isLoading = false;
        });
      }


    } catch (e) {
      if (!mounted) return;

      CommonToast.showToast(
        context: context,
        title: "Error",
        description: "An unexpected error occurred: ${e.toString()}",
      );

      setState(() {
        collectionStatusList = {};
        isLoading = false;
      });
      if (selectStatusMode == null) {
        CommonToast.showToast(
          context: context,
          title: "Validation Error",
          description: "Please select receipt mode",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return  Scaffold(
      backgroundColor: AppColors.textOnPrimary,
      appBar: DefaultAppBar(title: "Collection Report", size: size),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InputFieldTitle(titleText: "Date Form"),
            DatePickerField(
              dateController: _dateController,
            ),
            const SizedBox(
              height: 15,
            ),
            const InputFieldTitle(titleText: "Date To"),
            DatePickerField(
              dateController: _dateController,
            ),
            const SizedBox(
              height: 15,
            ),
            TitledDropdown(
                items:collectionStatusList.keys.toList(),
                title: "Status",
                onChanged: (value) {
                  setState(() {
                    selectStatusMode = value;
                  });
                }),



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
  DatePickerFieldState createState() => DatePickerFieldState();
}

class DatePickerFieldState extends State<DatePickerField> {
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
