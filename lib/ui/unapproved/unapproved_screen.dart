import 'package:animate_do/animate_do.dart';
import 'package:finanza_collection_f/common/success_dialog.dart';
import 'package:flutter/material.dart';

import '../../common/api_helper.dart';
import '../../common/common_toast.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../common/default_app_bar.dart';
import '../../utils/constants.dart';
import '../../utils/loading_widget.dart';
import '../../utils/session_helper.dart';

class UnapprovedScreen extends StatefulWidget {
  const UnapprovedScreen({super.key});

  @override
  State<UnapprovedScreen> createState() => _UnapprovedScreenState();
}

class _UnapprovedScreenState extends State<UnapprovedScreen> {
  var isLoading = false;
  List<dynamic> unApprovedItems = [];

  @override
  void initState() {
    super.initState();
    unApprovedListApi();
  }

  void unApprovedListApi() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      var userId = await SessionHelper.getSessionData(SessionKeys.userId);

      final response = await ApiHelper.postRequest(
        url: baseUrl + getUnApprovedCollection,
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
          unApprovedItems = [];
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
          unApprovedItems = [];
          isLoading = false;
        });
        return;
      }

      setState(() {
        unApprovedItems = data['response'] ?? [];
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
        unApprovedItems = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(title: "Unapproved", size: size),
      body: isLoading
          ? const SizedBox(height: 200, child: LoadingWidget(size: 40))
          : Expanded(
              child: unApprovedItems.isEmpty
                  ? Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/ic_empty.png',
                              width: 50, height: 50),
                          const Text(
                            "No Data found",
                            style: TextStyle(color: AppColors.titleLightColor),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: unApprovedItems.length,
                      itemBuilder: (context, index) {
                        var item = unApprovedItems[index];
                        return FadeInLeft(
                          delay: Duration(milliseconds: index + 180),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: CollectionItemCard(
                              name: item['customer_name'],
                              amount: item['amount'],
                              date: item['updated_on'],
                              description: item['narration'],
                              receiptId: item['receipt_id'],
                              lan: item['lan'],
                              unApprovedListApi: unApprovedListApi,
                              onTap: () {},
                            ),
                          ),
                        );
                      },
                    )),
    );
  }
}

class CollectionItemCard extends StatefulWidget {
  final String name;
  final String amount;
  final String description;
  final String receiptId;
  final String lan;
  final String date;
  final VoidCallback onTap;
  final VoidCallback unApprovedListApi;

  const CollectionItemCard({
    super.key,
    required this.name,
    required this.amount,
    required this.date,
    required this.description,
    required this.onTap,
    required this.receiptId,
    required this.lan,
    required this.unApprovedListApi,
  });

  @override
  State<CollectionItemCard> createState() => _CollectionItemCardState();
}

class _CollectionItemCardState extends State<CollectionItemCard> {
  var isOpen = false;

  void deleteReceipt(receiptId) async {
    try {
      var userId = await SessionHelper.getSessionData(SessionKeys.userId);

      final response = await ApiHelper.postRequest(
        url: baseUrl + deleteCollection,
        body: {
          'receipt_id': receiptId,
        },
      );

      if (!mounted) return;

      if (response['error'] == true) {
        CommonToast.showToast(
          context: context,
          title: "Request Failed",
          description: response['message'] ?? "Unknown error occurred",
        );

        return;
      }
      final data = response;

      if (data['status'] == '0') {
        CommonToast.showToast(
          context: context,
          title: "Request Failed",
          description: data['error']?.toString() ?? "No data found",
        );
        return;
      } else if (data['status'] == '1') {
        showSuccessDialog(context, "Receipt Deleted!", onDismiss: () {
          widget.unApprovedListApi();
        });
      }
    } catch (e) {
      if (!mounted) return;

      CommonToast.showToast(
        context: context,
        title: "Error",
        description: "An unexpected error occurred: ${e.toString()}",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isOpen = !isOpen;
        });
      },
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
                        '₹ ${widget.amount}',
                        style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.titleColor,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        textAlign: TextAlign.start,
                        widget.description,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.titleColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: const BoxDecoration(
                  color: AppColors.lightGrey,
                  // border: Border(top: BorderSide(color: AppColors.lightGrey)),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadiusDirectional.only(
                      bottomEnd: Radius.circular(12),
                      bottomStart: Radius.circular(12))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // _buildActionButton(Icons.article, 'Detail', Colors.green),
                  // Container(
                  //   color: AppColors.textColor,
                  //   width: .5,
                  //   padding: EdgeInsets.symmetric(vertical: 5),
                  // ),
                  Text(
                    'Added On ${widget.date}',
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.bold),
                  ),

                  _buildActionButton(Icons.delete, 'Delete', Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    Color color,
  ) {
    return InkWell(
      onTap: () {
        openDeleteDialog();
      },
      child: Row(
        children: [
          Icon(
            icon,
            size: 15,
            color: Colors.red,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void openDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Receipt?'),
          content: Text(
              'Are you sure you want to delete Receipt: ${widget.receiptId} for ${widget.name}(Lan:${widget.lan})?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.titleLightColor),
              ),
            ),
            ElevatedButton(
              style: const ButtonStyle(
                  textStyle:
                      WidgetStatePropertyAll(TextStyle(color: AppColors.red))),
              onPressed: () {
                deleteReceipt(widget.receiptId);
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
