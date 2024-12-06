import 'package:finanza_collection_f/ui/report/attendance_report_screen.dart';
import 'package:finanza_collection_f/ui/report/collection_report_screen.dart';
import 'package:finanza_collection_f/ui/report/due_report_screen.dart';
import 'package:flutter/material.dart';
import '../../common/default_app_bar.dart';
import '../../utils/colors.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(title: "Reports", size: size),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3.5,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildActionButton(Icons.collections, 'Collection Report',
                'Check your collection report', () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const CollectionReportScreen()),
              );
            }),
            _buildActionButton(
                Icons.report, 'Due Report', 'Check your due report', () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const DueReportScreen()),
              );
            }),
            _buildActionButton(Icons.repeat_one_on_sharp, 'Attendance Report',
                'Check your attendance report', () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const AttendanceReportScreen()),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, String subTitle, VoidCallback onTap,
      {Color color = AppColors.primaryColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.lightGrey,
            border: Border.all(color: Colors.grey.shade200)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  subTitle,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            const SizedBox(width: 4),
            Icon(icon, color: color, size: 30),
          ],
        ),
      ),
    );
  }
}
