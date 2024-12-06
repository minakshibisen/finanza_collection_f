import 'package:finanza_collection_f/common/default_app_bar.dart';
import 'package:finanza_collection_f/utils/colors.dart';
import 'package:flutter/material.dart';

class AttendanceReportLayout extends StatefulWidget {
  const AttendanceReportLayout({super.key});

  @override
  State<AttendanceReportLayout> createState() => _AttendanceReportLayoutState();
}

class _AttendanceReportLayoutState extends State<AttendanceReportLayout> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.textOnPrimary,
      appBar: DefaultAppBar(title: "Attendance Report", size: size),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: AppColors.lightestGrey,
                  borderRadius: BorderRadius.circular(10)),
              child:const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "06-12-2024",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20
                            )
                        ),

                        Text(
                            "10:00:00",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20
                            )
                        ),

                      ],
                    ),
                    SizedBox(height: 10,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "Friday",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20
                            )
                        ),

                        Text(
                            "0:4:46",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20
                            )
                        ),

                      ],
                    ),
                  ],
                ),
              ),

            )
          ],
        ),
      ),
    );
  }
}
