import 'package:animate_do/animate_do.dart';
import 'package:finanza_collection_f/utils/colors.dart';
import 'package:finanza_collection_f/common/default_app_bar.dart';
import 'package:flutter/material.dart';

import '../../common/api_helper.dart';
import '../../common/common_toast.dart';
import '../../main.dart';
import '../../utils/constants.dart';
import '../../utils/loading_widget.dart';
import '../../utils/session_helper.dart';

class DueReportScreen extends StatefulWidget {
  const DueReportScreen({super.key});

  @override
  State<DueReportScreen> createState() => _DueReportScreenState();
}

class _DueReportScreenState extends State<DueReportScreen> {
  var isLoading = false;
  List<dynamic> dueReportItems = [];

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
        url: BaseUrl + getDueReport,
        body: {
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
          dueReportItems = [];
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
          dueReportItems = [];
          isLoading = false;
        });
        return;
      }

      setState(() {
        dueReportItems = data['response'] ?? [];
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
        dueReportItems = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: AppColors.textOnPrimary,
        appBar: DefaultAppBar(title: "Due Reports", size: size),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: isLoading
              ? const SizedBox(height: 200, child: LoadingWidget(size: 40))
              : dueReportItems.isEmpty
                  ? const Center(
                      child: Text(
                        "No Reports found",
                        style: TextStyle(color: AppColors.titleLightColor),
                      ),
                    )
                  : ListView.builder(
                      itemCount: dueReportItems.length,
                      itemBuilder: (context, index) {
                        var item = dueReportItems[index];
                        return FadeInLeft(
                          delay: Duration(milliseconds: index * 180),
                          child: DueReportItemCard(
                            name: item['customer_name'] ?? 'Unknown',
                            lan: item['lan'] ?? 'N/A',
                            onTap: () {},
                            comment: item['narration'],
                            date: item['transaction_date'],
                            amount: item['due_amount'],
                            index: index,
                          ),
                        );
                      },
                    ),
        ));
  }
}

class DueReportItemCard extends StatefulWidget {
  final String name;
  final String lan;
  final String comment;
  final String date;
  final String amount;
  final VoidCallback onTap;
  final int index;

  const DueReportItemCard({
    super.key,
    required this.name,
    required this.date,
    required this.amount,
    required this.comment,
    required this.lan,
    required this.onTap,
    required this.index,
  });

  @override
  State<DueReportItemCard> createState() => _DueReportItemCardState();
}

class _DueReportItemCardState extends State<DueReportItemCard> {
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
                      Text(
                        widget.amount,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.titleColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'LAN: ',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.titleColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.lan,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.date,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.titleColor,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
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
}
