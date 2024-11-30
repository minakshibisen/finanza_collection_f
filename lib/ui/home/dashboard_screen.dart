import 'package:animate_do/animate_do.dart';
import 'package:finanza_collection_f/ui/collection/collection_screen.dart';
import 'package:finanza_collection_f/ui/report/due_report_screen.dart';
import 'package:finanza_collection_f/ui/report/report_screen.dart';
import 'package:finanza_collection_f/ui/unapproved/unapproved_screen.dart';
import 'package:finanza_collection_f/utils/colors.dart';
import 'package:flutter/material.dart';

import '../ptp/ptp_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const duration = 1000;
    return Scaffold(
      backgroundColor: AppColors.textOnPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 1,
        title: const Text(
          "Dashboard",
          style: TextStyle(color: AppColors.textOnPrimary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none,
                color: AppColors.textOnPrimary),
            onPressed: () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
                return const DashboardScreen();
              }), (r){
                return false;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            dashboardGreeting(),
            FadeInLeft(duration: const Duration(milliseconds: duration),child: const DashboardLocationBar()),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Today's Snapshot",
                    style: TextStyle(
                      color: AppColors.titleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // SizedBox(width: 10,),
                  // Icon(Icons.arrow_forward_ios_rounded, color: AppColors.titleColor, size: 14),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FadeInLeft(duration: const Duration(milliseconds: duration),child: const DashboardGrid()),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "What's on your mind?",
                    style: TextStyle(
                      color: AppColors.titleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // SizedBox(width: 10,),
                  // Icon(Icons.arrow_forward_ios_rounded, color: AppColors.titleColor, size: 14),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const DashboardCard(),
          ],
        ),
      ),
    );
  }

  Widget dashboardGreeting() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(18, 18, 18, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hello, Provider Demo",
            style: TextStyle(
              color: AppColors.titleColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Welcome back!",
            style: TextStyle(color: AppColors.textColor, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class DashboardLocationBar extends StatelessWidget {
  const DashboardLocationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Vijay Nagar, Indore",
                    style: TextStyle(
                      color: AppColors.titleColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        "Nearby Collections: ",
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        "12",
                        style: TextStyle(
                          color: AppColors.titleColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 40.0,
              height: 40.0,
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
              ),
              child: const Icon(
                Icons.location_on_outlined,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardGrid extends StatelessWidget {
  const DashboardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 150,
              height: 90,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.titleColor.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "19",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  SizedBox(height: 5),
                  Flexible(
                    child: Text(
                      "Number Of Receipt",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 150,
              height: 90,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.titleColor.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "₹ 5,483",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  SizedBox(height: 5),
                  Flexible(
                      child: Text(
                    "Total Collection Amount",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textOnPrimary,
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 150,
              height: 90,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.titleColor.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "19",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  SizedBox(height: 5),
                  Flexible(
                      child: Text(
                    "Number of Approved Receipt",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textOnPrimary,
                    ),
                  )),
                ],
              ),
            ),
            Container(
              width: 150,
              height: 90,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.titleColor.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "₹ 5,483",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  SizedBox(height: 5),
                  Flexible(
                    child: Text("Cash In Hand",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textOnPrimary,
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DashboardCard extends StatelessWidget {
  const DashboardCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          _buildActionButton(
              Icons.collections, 'Collection', 'Add a new collection receipt',
              () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CollectionScreen()),
            );
          }),
          _buildActionButton(
              Icons.handshake, 'Promise to Pay', 'Add a new Promise', () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const PTPScreen()),
            );
          }),
          _buildActionButton(Icons.cancel_presentation_outlined, 'Unapproved',
              'Check for unapproved collections',
                  () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const UnapprovedScreen()),
                    );
                  }),
          _buildActionButton(Icons.document_scanner_sharp, 'Reports',
              'View Your Reports',
                  () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const ReportScreen()),
                    );
                  }),
          _buildActionButton(Icons.punch_clock, 'Attendance',
              'Punch your daily attendance', () {}),
        ],
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
