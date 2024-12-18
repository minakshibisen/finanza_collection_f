import 'package:animate_do/animate_do.dart';
import 'package:finanza_collection_f/common/success_dialog.dart';
import 'package:finanza_collection_f/ui/collection/collection_screen.dart';
import 'package:finanza_collection_f/ui/home/dashboard_location_bar.dart';
import 'package:finanza_collection_f/ui/misc/notification_screen.dart';
import 'package:finanza_collection_f/ui/report/report_screen.dart';
import 'package:finanza_collection_f/ui/unapproved/unapproved_screen.dart';
import 'package:finanza_collection_f/utils/colors.dart';
import 'package:finanza_collection_f/utils/common_util.dart';
import 'package:finanza_collection_f/utils/constants.dart';
import 'package:finanza_collection_f/utils/loading_widget.dart';
import 'package:finanza_collection_f/utils/session_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../common/api_helper.dart';
import '../../common/common_toast.dart';
import '../../main.dart';
import '../ptp/ptp_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var userName = '';

  @override
  void initState() {
    super.initState();
    getUser();
  }

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
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const NotificationScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            dashboardGreeting(),
            FadeInLeft(
                duration: const Duration(milliseconds: duration),
                child: const DashboardLocationBar()),
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
            FadeInLeft(
                duration: const Duration(milliseconds: duration),
                child: const DashboardGrid()),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hello, $userName",
            style: const TextStyle(
              color: AppColors.titleColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Welcome back!",
            style: TextStyle(color: AppColors.textColor, fontSize: 16),
          ),
        ],
      ),
    );
  }

  void getUser() async {
    var name = await SessionHelper.getSessionData(SessionKeys.username);
    setState(() {
      userName = name.toString();
    });
  }
}

class DashboardGrid extends StatefulWidget {
  const DashboardGrid({super.key});

  @override
  State<DashboardGrid> createState() => _DashboardGridState();
}

class _DashboardGridState extends State<DashboardGrid>
    with WidgetsBindingObserver {
  bool isLoading = false;
  var deviceId = '';
  var location = '';
  var pincode = '';
  var city = '';
  var noOfReceipt = '0';
  var totalCollectionAmount = '0';
  var numberOfApprovedReceipt = '0';
  var cashInHand = '0';

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(LifecycleEventHandler());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addObserver(LifecycleEventHandler(
        resumeCallBack: () async {
          getData();
        },
      ));
    });
  }

  void getData() async {
    try {
      var userId = await SessionHelper.getUserId();

      final response = await ApiHelper.postRequest(
          url: baseUrl + getDashboardData, body: {"user_id": userId});

      if (!mounted) return;

      if (response['error'] == true) {
        CommonToast.showToast(
          context: context,
          title: "Request Failed",
          description: response['message'] ?? "Unknown error occurred",
        );
        setState(() {
          isLoading = false;
        });
        return;
      }
      final data = response;

      if (data['status'] == 0) {
        CommonToast.showToast(
          context: context,
          title: "Request Failed",
          description: data['error']?.toString() ?? "No data found",
        );
        setState(() {
          isLoading = false;
        });
        return;
      } else {
        var response = data['response'];
        setState(() {
          noOfReceipt = response['no_of_receipt']?.toString() ?? "0";
          totalCollectionAmount =
              response['total_collection_amount']?.toString() ?? "0";
          cashInHand = response['cash_in_hand']?.toString() ?? "0";
          numberOfApprovedReceipt =
              response['no_of_approved_receipt']?.toString() ?? "0";
        });
      }

      setState(() {
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
        isLoading = false;
      });
    }
  }

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    noOfReceipt,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Flexible(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "₹ ${getFancyNumber(double.parse(totalCollectionAmount))}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Flexible(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    numberOfApprovedReceipt,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Flexible(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "₹ ${getFancyNumber(double.parse(cashInHand))}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Flexible(
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

class DashboardCard extends StatefulWidget {
  const DashboardCard({super.key});

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  bool isAttendanceLoading = false;

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
              'Check for unapproved collections', () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const UnapprovedScreen()),
            );
          }),
          _buildActionButton(
              Icons.document_scanner_sharp, 'Reports', 'View Your Reports', () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ReportScreen()),
            );
          }),
          _buildActionButton(
              Icons.punch_clock,
              'Attendance',
              loading: isAttendanceLoading,
              'Punch your daily attendance', () {
            showConfirmation(context);
          }),
        ],
      ),
    );
  }

  Future<bool> addAttendance(BuildContext context) async {
    _setLoading(true);
    try {
      var userId = await SessionHelper.getUserId();

      if (!context.mounted) return false;
      var address = await getCurrentLocation(context);
      var deviceId = await getId();

      final response =
          await ApiHelper.postRequest(url: baseUrl + saveUserAttendance, body: {
        "user_id": userId.toString(),
        'longitude': address['longitude'].toString(),
        'latitude': address['latitude'].toString(),
        "location": address['location'],
        "pincode": address['pincode'],
        "device_id": deviceId,
        "city": address['city'],
      });

      if (!context.mounted) return false;

      if (response['error'] == true) {
        CommonToast.showToast(
          context: context,
          title: "Request Failed",
          description: response['message'] ?? "Unknown error occurred",
        );

        _setLoading(false);
        return false;
      }
      final data = response;

      if (data['status'] == "0" || data['status'] == 0) {
        CommonToast.showToast(
          context: context,
          title: "Request Failed",
          description: data['error']?.toString() ?? "No data found",
        );

        _setLoading(false);
        return false;
      }
      if (data['status'] == "1" || data['status'] == 1) {
        _setLoading(false);
        return true;
      }
      _setLoading(false);
      return false;
    } catch (e) {
      if (!context.mounted) return false;
      _setLoading(false);

      CommonToast.showToast(
        context: context,
        title: "Error",
        description: "An unexpected error occurred: ${e.toString()}",
      );
      return false;
    }
  }

  Widget _buildActionButton(
      IconData icon, String label, String subTitle, VoidCallback onTap,
      {Color color = AppColors.primaryColor, bool loading = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.lightGrey,
            border: Border.all(color: Colors.grey.shade200)),
        child: loading
            ? const LoadingWidget()
            : Row(
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

  void _setLoading(bool bool) {
    setState(() {
      isAttendanceLoading = bool;
    });
  }

  void showConfirmation(BuildContext context) {
    if (isAttendanceLoading) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Attendance'),
          content: const Text('Are you sure you want to punch attendance?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                var added = await addAttendance(context);

                if (!context.mounted) return;
                if (added) {
                  showSuccessDialog(context, "Request Successful",
                      onDismiss: () => Navigator.of(context).pop());
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback? resumeCallBack;
  final AsyncCallback? suspendingCallBack;

  LifecycleEventHandler({
    this.resumeCallBack,
    this.suspendingCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed && resumeCallBack != null) {
      await resumeCallBack!();
    } else if (state == AppLifecycleState.inactive &&
        suspendingCallBack != null) {
      await suspendingCallBack!();
    }
  }
}
