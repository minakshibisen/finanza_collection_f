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
    body:  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton( 'Collection Report',
                () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CollectionReportScreen()),
              );
            }),
        _buildActionButton( 'Due Report',
                () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const DueReportScreen()),
              );
            }),
        _buildActionButton( 'Attendance Report',
                () {
            //   Navigator.of(context).push(
            //     MaterialPageRoute(builder: (context) => const ReportScreen()),
            //   );
             }),
      ],
    ),

    );

  }
  Widget _buildActionButton(
       String label, VoidCallback onTap,) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 50),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.lightGrey,
              border: Border.all(color: Colors.grey.shade200)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
