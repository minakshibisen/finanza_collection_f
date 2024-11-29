import 'package:flutter/material.dart';

import '../../common/input_field.dart';
import '../../common/title_input_field.dart';
import '../../common/titled_dropdown.dart';

import '../../utils/colors.dart';
import '../../common/default_app_bar.dart';


class CollectionReportScreen extends StatefulWidget {
  const CollectionReportScreen({super.key});

  @override
  State<CollectionReportScreen> createState() => _CollectionReportScreenState();
}

class _CollectionReportScreenState extends State<CollectionReportScreen> {

  final TextEditingController _dateController = TextEditingController();
  List<String> statusList = ["Pending", "Approved", "Rejected"];
/*
  var isLoading = false;
  List<dynamic> collectionReportItems = [];

  @override
  void initState() {
    super.initState();
    dueReportListApi();
  }

  void dueReportListApi() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      var userId = await SessionHelper.getSessionData(SessionKeys.userId);

      final response = await ApiHelper.postRequest(
        url: BaseUrl + getCollectionStatusReport,
        body: {
          'start_date': _dateController.toString(),
          'end_date': _dateController.toString(),
          'status': statusList.toString(),
          'user_id': userId.toString(),
        },
      );

      // Check if the widget is still mounted before updating state
      if (!mounted) return;

      if (response['error'] == true) {
        CommonToast.showToast(
          context: context,
          title: "Request Failed",
          description: response['message'] ?? "Unknown error occurred",
        );
        setState(() {
          collectionReportItems = [];
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
          collectionReportItems = [];
          isLoading = false;
        });
        return;
      }

      setState(() {
        collectionReportItems = data['response'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      CommonToast.showToast(
        context: context,
        title: "Error",
        description: "An unexpected error occurred: ${e.toString()}",
      );

      setState(() {
        collectionReportItems = [];
        isLoading = false;
      });
    }
  }*/

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
                items: statusList,
                title: "Status",
                onChanged: (String? value) {}),
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
