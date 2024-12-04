import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/api_helper.dart';
import '../../common/common_toast.dart';
import '../../common/default_app_bar.dart';
import '../../common/input_field.dart';
import '../../common/title_input_field.dart';
import '../../common/titled_dropdown.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/common_util.dart';
import '../../utils/constants.dart';
import '../../utils/loading_widget.dart';
import '../../utils/session_helper.dart';

class CollectionReportScreen extends StatefulWidget {
  const CollectionReportScreen({super.key});

  @override
  State<CollectionReportScreen> createState() => _CollectionReportScreenState();
}

class _CollectionReportScreenState extends State<CollectionReportScreen> {
  final TextEditingController fromdateController = TextEditingController();
  final TextEditingController todateController = TextEditingController();
  String? selectStatusMode;
  var isLoading = false;
  Map<String, dynamic> statusTypeList = {};
  List<dynamic> collectionReportList = [];

  void addReceipt() {
    if (selectStatusMode == null || selectStatusMode!.isEmpty) {
      showSnackBar("Select Status", context);
      return;
    }
  }

  @override
  void dispose() {
    fromdateController.dispose();
    todateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getStatusType();
  }

  void getStatusType() async {
    try {
      final response = await ApiHelper.getRequest(
        url: baseUrl + getCollectionStatus,
      );

      if (!mounted) return;

      if (response['error'] == true) {
        CommonToast.showToast(
          context: context,
          title: "Request Failed",
          description: response['message'] ?? "Unknown error occurred",
        );
        setState(() {
          statusTypeList = {};
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
          statusTypeList = {};
        });
        return;
      } else if (data['status'] == '1') {
        final Map<String, dynamic> dropdownMap = {
          for (var item in data['response']) item['key']: item['value']
        };

        setState(() {
          statusTypeList = dropdownMap;
        });
      }
    } catch (e) {
      if (!mounted) return;

      CommonToast.showToast(
        context: context,
        title: "Error",
        description: "An unexpected error occurred: ${e.toString()}",
      );

      setState(() {
        statusTypeList = {};
      });
    }
  }

  void collectionReportApi(status) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });
    var userId = await SessionHelper.getUserId();
    try {
      final response = await ApiHelper.postRequest(
        url: baseUrl + getCollectionStatusReport,
        body: {
          "start_date": fromdateController.text.toString(),
          "end_date": todateController.text.toString(),
          "status": status.toString(),
          "user_id": userId.toString(),
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
          collectionReportList = [];
          isLoading = false;
        });
        return;
      }

      var data = response['response'] ?? [];

      setState(() {
        collectionReportList = data;
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
        collectionReportList = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.textOnPrimary,
      appBar: DefaultAppBar(title: "Collection Report", size: size),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InputFieldTitle(titleText: "Date Form"),
            DatePickerField(dateController: fromdateController),
            const SizedBox(
              height: 15,
            ),
            const InputFieldTitle(titleText: "Date To"),
            DatePickerField(dateController: todateController),
            const SizedBox(
              height: 15,
            ),
            TitledDropdown(
                items: statusTypeList != {} ? statusTypeList.keys.toList() : [],
                title: "Status",
                onChanged: (value) {
                  selectStatusMode = statusTypeList[value].toString();
                  collectionReportApi(selectStatusMode);
                }),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Collections:",
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
            isLoading
                ? const SizedBox(height: 200, child: LoadingWidget(size: 40))
                : Expanded(
                    child: collectionReportList.isEmpty
                        ? Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/ic_empty.png',
                                    width: 50, height: 50),
                                const Text(
                                  "No Item found",
                                  style: TextStyle(
                                      color: AppColors.titleLightColor),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: collectionReportList.length,
                            itemBuilder: (context, index) {
                              var item = collectionReportList[index];
                              return FadeInLeft(
                                delay: Duration(milliseconds: index * 180),
                                child: CollectionReportItemCard(
                                  name: item['customer_name'] ?? 'Unknown',
                                  lan: item['lan'] ?? 'N/A',
                                  onTap: () {},
                                  receiptMode: item['receipt_mode'] ?? 'N/A',
                                  receiptId: item['receipt_id'] ?? 'N/A',
                                  comment: item['narration'] ?? 'N/A',
                                  date: item['instrument_date'] ?? 'N/A',
                                  amount: item['amount'] ?? '0',
                                  index: index,
                                ),
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}

class DatePickerField extends StatelessWidget {
  final TextEditingController dateController;

  const DatePickerField({super.key, required this.dateController});

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      dateController.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: InputFieldWidget(
          hintText: "Select Date",
          keyboardType: TextInputType.none,
          icon: Icons.calendar_month,
          textInputAction: TextInputAction.next,
          controller: dateController,
        ),
      ),
    );
  }
}

class CollectionReportItemCard extends StatefulWidget {
  final String name;
  final String lan;
  final String comment;
  final String date;
  final String receiptId;
  final String receiptMode;
  final String amount;
  final VoidCallback onTap;
  final int index;

  const CollectionReportItemCard({
    super.key,
    required this.name,
    required this.date,
    required this.amount,
    required this.comment,
    required this.lan,
    required this.onTap,
    required this.index,
    required this.receiptId,
    required this.receiptMode,
  });

  @override
  State<CollectionReportItemCard> createState() =>
      _CollectionReportItemCardState();
}

class _CollectionReportItemCardState extends State<CollectionReportItemCard> {
  var isOpen = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: Colors.white,
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 8),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 7,
                        child: Text(
                          widget.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.titleColor,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Text(
                          '₹ ${getFancyNumber(double.parse(widget.amount))}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.titleColor,
                          ),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text(
                            'Receipt Mode: ',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.titleColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.receiptMode,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.titleColor,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
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
