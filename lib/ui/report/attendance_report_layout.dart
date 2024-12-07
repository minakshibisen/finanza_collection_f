import 'package:finanza_collection_f/common/default_app_bar.dart';
import 'package:finanza_collection_f/utils/colors.dart';
import 'package:flutter/material.dart';

import '../../common/api_helper.dart';
import '../../common/common_toast.dart';
import '../../main.dart';
import '../../utils/constants.dart';
import '../../utils/session_helper.dart';

class AttendanceReportLayout extends StatefulWidget {
  const AttendanceReportLayout({super.key});

  @override
  State<AttendanceReportLayout> createState() => _AttendanceReportLayoutState();
}

class _AttendanceReportLayoutState extends State<AttendanceReportLayout> {
  var isLoading = false;
  List<dynamic> attendanceData = [];

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

      DateTime now =DateTime.now();



      final response = await ApiHelper.postRequest(
        url: baseUrl + getUserAttendanceList,
        body: {
          'user_id': userId.toString(),
          'attendence_month': '01-${now.month}-${now.year}',
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
          attendanceData = [];
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
          attendanceData = [];
          isLoading = false;
        });
        return;
      }

      setState(() {
        attendanceData = data['response'] ?? [];
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
        attendanceData = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.textOnPrimary,
      appBar: DefaultAppBar(title: "Attendance Report", size: size,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
        child: ListView.builder(
          itemCount: attendanceData.length,
          itemBuilder: (context, index) {
            final item = attendanceData[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child:
              AttendanceReportItemCard(
                day: item['attendence_day'] ?? 'N/A',
                onTap: () {},
                outTime: item['out_time'],
                date: item['attendence_date'],
                inTime: item['in_time'],
                index: index,
              ),
            );
          },
        ),
      ),
    );
  }

}
class AttendanceReportItemCard extends StatefulWidget {
  final String outTime;
  final String inTime;
  final String date;
  final String day;
  final VoidCallback onTap;
  final int index;

  const AttendanceReportItemCard({
    super.key,
    required this.date,
    required this.inTime,
    required this.outTime,
    required this.day,
    required this.onTap,
    required this.index,
  });

  @override
  State<AttendanceReportItemCard> createState() => _AttendanceReportItemCardState();
}

class _AttendanceReportItemCardState extends State<AttendanceReportItemCard> {
  var isOpen = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: Colors.white,
        elevation: 1,
        margin: const EdgeInsets.all(4),
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
                        widget.date,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        widget.inTime,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.day,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        widget.outTime,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
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
}