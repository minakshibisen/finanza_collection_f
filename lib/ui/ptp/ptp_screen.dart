import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:finanza_collection_f/ui/collection/add_collection_screen.dart';
import 'package:finanza_collection_f/common/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/api_helper.dart';
import '../../common/common_toast.dart';
import '../../common/input_field.dart';
import '../../common/title_input_field.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/loading_widget.dart';
import '../../utils/session_helper.dart';
import 'add_ptp_screen.dart';

class PTPScreen extends StatefulWidget {
  const PTPScreen({super.key});

  @override
  PTPScreenState createState() => PTPScreenState();
}

class PTPScreenState extends State<PTPScreen> {
  var isLoading = false;
  List<dynamic> ptpItems = [];
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.timestamp());
    _ptpListApi();
  }

  void _ptpListApi() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      var userId = await SessionHelper.getSessionData(SessionKeys.userId);
      var branchId = await SessionHelper.getSessionData(SessionKeys.branchId);

      final response = await ApiHelper.postRequest(
        url: BaseUrl + getPTPList,
        body: {
          'user_id': userId.toString(),
          'branch_id': branchId.toString(),
          'date': _dateController.text.toString(),
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
          ptpItems = [];
          isLoading = false;
        });
        return;
      }
      print(response);
      final data = response;

      if (data['status'] == '0') {
        CommonToast.showToast(
          context: context,
          title: "Request Failed",
          description: data['error']?.toString() ?? "No data found",
        );
        setState(() {
          ptpItems = [];
          isLoading = false;
        });
        return;
      }

      setState(() {
        ptpItems = data['response'] ?? [];
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
        ptpItems = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(title: "Promise To Pay List", size: size),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Promises For ",
                    style: TextStyle(
                      color: AppColors.titleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  DatePickerField(controller: _dateController,),
                  const SizedBox(height: 5),
                ],
              ),
            ),
            isLoading
                ? const SizedBox(height: 200, child: LoadingWidget(size: 40))
                : Expanded(
                    child: ptpItems.isEmpty
                        ? Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/ic_empty.png',
                                    width:50, height: 50),
                                const Text(
                                  "No PTP found",
                                  style:
                                      TextStyle(color: AppColors.titleLightColor),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: ptpItems.length,
                            itemBuilder: (context, index) {
                              var item = ptpItems[index];
                              return FadeInLeft(
                                delay: Duration(
                                    milliseconds: min(index * 180, 1000)),
                                child: CollectionItemCard(
                                  name: item['customer_name'] ?? 'Unknown',
                                  lan: item['lan'] ?? 'N/A',
                                  address:
                                      item['Communication'] ?? 'No address',
                                  alternateAddress:
                                      item['Permanent'] ?? 'No address',
                                  comment: item['comment'],
                                  onTap: () {
                                    // Handle item tap if needed
                                  },
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

class DatePickerField extends StatefulWidget {
  final TextEditingController controller;
  const DatePickerField({super.key, required this.controller});

  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
        widget.controller.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: InputFieldWidget(
          hintText: "Select Date",
          icon: Icons.calendar_month,
          textInputAction: TextInputAction.next,
          controller: widget.controller,
        ),
      ),
    );
  }
}

class CollectionItemCard extends StatefulWidget {
  final String name;
  final String lan;
  final String address;
  final String alternateAddress;
  final String comment;
  final VoidCallback onTap;

  const CollectionItemCard({
    super.key,
    required this.name,
    required this.lan,
    required this.address,
    required this.alternateAddress,
    required this.comment,
    required this.onTap,
  });

  @override
  State<CollectionItemCard> createState() => _CollectionItemCardState();
}

class _CollectionItemCardState extends State<CollectionItemCard> {
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
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.comment.isNotEmpty) const SizedBox(height: 8),
                      if (widget.comment.isNotEmpty) Text(
                        textAlign: TextAlign.start,
                        widget.comment,
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.titleColor),
                      ),
                      if (widget.address.isNotEmpty) const SizedBox(height: 8),
                      if (widget.address.isNotEmpty) Text(
                        textAlign: TextAlign.start,
                        widget.address,
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // _buildActionButton(Icons.article, 'Detail', Colors.green),
                  // Container(
                  //   color: AppColors.textColor,
                  //   width: .5,
                  //   padding: EdgeInsets.symmetric(vertical: 5),
                  // ),
                  _buildActionButton(Icons.handshake, 'PTP', Colors.orange, () {
                    List<String> list = [];
                    list.add(widget.address);
                    list.add(widget.alternateAddress);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => AddPtpScreen(
                              lan: widget.lan, name: widget.name, address: list,)),
                    );
                  }),
                  Container(
                    color: AppColors.textColor,
                    width: .5,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                  ),
                  _buildActionButton(
                      Icons.account_balance_wallet, 'Collection', Colors.green,
                      () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => AddCollectionScreen(
                              lan: widget.lan, name: widget.name,appId: '',fileId: '',)),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 15),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
