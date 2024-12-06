import 'package:finanza_collection_f/common/default_app_bar.dart';
import 'package:finanza_collection_f/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../common/api_helper.dart';
import '../../common/common_toast.dart';
import '../../main.dart';
import '../../utils/constants.dart';
import '../../utils/loading_widget.dart';
import '../../utils/session_helper.dart';

class AttendanceReportScreen extends StatefulWidget {
  const AttendanceReportScreen({super.key});

  @override
  State<AttendanceReportScreen> createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {
  var isLoading = false;
  List<dynamic> attendanceReportItems = [];

  @override
  void initState() {
    super.initState();
    attendanceReportListApi();
  }

  void attendanceReportListApi() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      var userId = await SessionHelper.getSessionData(SessionKeys.userId);

      final response = await ApiHelper.postRequest(
        url: baseUrl + getUserAttendance,
        body: {
          'user_id': userId.toString(),
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
          attendanceReportItems = [];
          isLoading = false;
        });
        return;
      }
      final data = response;

      if (data['status'] == '0') {
        CommonToast.showToast(
          context: context,
          title: "Request Failed",
          description: data['error']?.toString() ?? "No data found",
        );
        setState(() {
          attendanceReportItems = [];
          isLoading = false;
        });
        return;
      }

      setState(() {
        attendanceReportItems = data['response'] ?? [];
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
        attendanceReportItems = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: AppColors.textOnPrimary,
        appBar: DefaultAppBar(title: "Attendance Report", size: size),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isLoading
              ? const SizedBox(height: 200, child: LoadingWidget(size: 40))
              : attendanceReportItems.isEmpty
                  ? const Center(
                      child: Text(
                        "No Reports found",
                        style: TextStyle(color: AppColors.titleLightColor),
                      ),
                    )
                  : SizedBox(
                      child: CalendarWidget(
                          attendanceRecords: attendanceReportItems)),
        ));
  }
}

class AttendanceRecord {
  final DateTime date;
  final String inTime;
  final String outTime;

  AttendanceRecord({
    required this.date,
    required this.inTime,
    required this.outTime,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    // Parse the date string "dd-MM-yyyy" format
    final dateParts = json['attendence_date'].split('-');
    final date = DateTime(
      int.parse(dateParts[2]), // year
      int.parse(dateParts[1]), // month
      int.parse(dateParts[0]), // day
    );

    return AttendanceRecord(
      date: date,
      inTime: json['in_time'],
      outTime: json['out_time'],
    );
  }
}

class CalendarWidget extends StatelessWidget {
  final List<dynamic> attendanceRecords;

  const CalendarWidget({super.key, required this.attendanceRecords});

  List<AttendanceRecord> _parseAttendanceRecords() {
    return attendanceRecords
        .map((record) => AttendanceRecord.fromJson(record))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final parsedRecords = _parseAttendanceRecords();

    return SfCalendar(
      view: CalendarView.month,
      minDate: DateTime(DateTime.now().year, DateTime.now().month - 2, 1),
      maxDate: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
      allowViewNavigation: false,
      selectionDecoration:
          BoxDecoration(border: Border.all(color: Colors.transparent)),
      onTap: null,
      onLongPress: null,
      initialSelectedDate: null,
      onSelectionChanged: null,
      firstDayOfWeek: 1,
      headerHeight: 60,
      headerStyle: const CalendarHeaderStyle(
          backgroundColor: AppColors.textOnPrimary,
          textAlign: TextAlign.center,
          textStyle: TextStyle(fontWeight: FontWeight.bold)),
      monthViewSettings: const MonthViewSettings(
        showAgenda: false,
        showTrailingAndLeadingDates: false,
        appointmentDisplayMode: MonthAppointmentDisplayMode.none,
        monthCellStyle: MonthCellStyle(
          textStyle: TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ),
      cellBorderColor: Colors.grey[300],
      backgroundColor: Colors.white,
      monthCellBuilder: (context, details) {
        final attendanceRecord = parsedRecords.firstWhere(
          (record) => isSameDay(record.date, details.date),
          orElse: () => AttendanceRecord(
            date: details.date,
            inTime: "",
            outTime: "",
          ),
        );

        final today = DateTime.now();
        final isToday = isSameDay(details.date, today);

        final isPresent = attendanceRecord.inTime.isNotEmpty;
        final timeText = isPresent
            ? "In:${attendanceRecord.inTime}\nOut:${attendanceRecord.outTime}"
            : "";

        return Container(
          decoration: BoxDecoration(
            color: isPresent ? Colors.green[50] : null,
            border: isToday
                ? Border.all(color: AppColors.red, width: .4)
                : Border.all(color: AppColors.lightGrey, width: .2),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    details.date.day.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isPresent ? FontWeight.bold : FontWeight.normal,
                      color: AppColors.titleColor,
                    ),
                  ),
                ),
              ),
              if (isPresent)
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        timeText,
                        style: const TextStyle(
                          fontSize: 9,
                          color: AppColors.titleColor,
                        ),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
