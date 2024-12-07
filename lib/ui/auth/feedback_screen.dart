import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:finanza_collection_f/common/default_app_bar.dart';
import 'package:finanza_collection_f/common/primary_button.dart';
import 'package:finanza_collection_f/utils/colors.dart';
import 'package:flutter/material.dart';

import '../../common/api_helper.dart';
import '../../common/common_toast.dart';
import '../../common/input_field.dart';
import '../../common/success_dialog.dart';
import '../../common/title_input_field.dart';
import '../../common/titled_dropdown.dart';
import '../../main.dart';
import '../../utils/common_util.dart';
import '../../utils/constants.dart';
import '../../utils/session_helper.dart';

class FeedbackScreen extends StatefulWidget {
  final String lan;
  const FeedbackScreen({super.key,
    required this.lan,});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  Map<String, dynamic> feedbackTypeList = {};
  String? selectFeedbackMode;
  bool isLoading = false;
  bool isListLoading = false;
  void addReceipt() {
    if (selectFeedbackMode == null || selectFeedbackMode!.isEmpty) {
      showSnackBar("Select Feedback Type", context);
      return;
    }
  }
  @override
  void initState() {
    super.initState();
    getFeedbackType();
  }

  void getFeedbackType() async {
    try {
      final response = await ApiHelper.getRequest(
        url: baseUrl + getFeedbackTypeList,
      );

      if (!mounted) return;

      if (response['error'] == true) {
        CommonToast.showToast(
          context: context,
          title: "Request Failed",
          description: response['message'] ?? "Unknown error occurred",
        );
        setState(() {
          feedbackTypeList = {};
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
          feedbackTypeList = {};
        });
        return;
      } else if (data['status'] == '1') {
        final Map<String, dynamic> dropdownMap = {
          for (var item in data['response']) item['key']: item['value']
        };

        setState(() {
          feedbackTypeList = dropdownMap;
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
        feedbackTypeList = {};
      });
    }
  }

  Future<void> submitFeedbackApi(selectFeedbackMode) async {
    if (isLoading) return;
    closeKeyboard(context);

   if (_descriptionController.text.isEmpty) {
      showSnackBar("Enter Remark", context);
    } else {
      setState(() {
        isLoading = true;
      });

      try {
        var userId = await SessionHelper.getSessionData(SessionKeys.userId);

        final response = await ApiHelper.postRequest(
          url: baseUrl + addClientFeedback,
          body: {
            'user_id': userId.toString(),
            'remark': _descriptionController.text,
            'lan': widget.lan,
            "feedback_type":selectFeedbackMode
          },
        );

        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        if (response['error'] == true) {
          CommonToast.showToast(
            context: context,
            title: "Request Failed",
            description: response['message'] ?? "Unknown error occurred",
          );
          return;
        } else {
          var data = response;
          if (data['status'] == '0' || (data['error'] != null)) {
            CommonToast.showToast(
                context: context,
                title: "Request Failed",
                description: data['error'].toString(),
                duration: const Duration(seconds: 5));
          } else {
            showSuccessDialog(context, "Feedback Added", duration: 2, onDismiss: () {
              Navigator.of(context).pop();
            });
          }
        }
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
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.textOnPrimary,
      appBar: DefaultAppBar(title: "Feedback", size: size),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        TitledDropdown(
            items: feedbackTypeList != {} ? feedbackTypeList.keys.toList() : [],
            title: "Product Type",
            onChanged: (value) {
              selectFeedbackMode = feedbackTypeList[value].toString();
              submitFeedbackApi(selectFeedbackMode);
            }),
            const SizedBox(
              height: 15,
            ),
            const InputFieldTitle(titleText: "Remarks"),
            InputFieldWidget(
              hintText: "Enter Remark",
              hasIcon: false,
              lines: 5,
              textInputAction: TextInputAction.done,
              controller: _descriptionController,
            ),
            const SizedBox(
              height: 25,
            ),
            PrimaryButton(onPressed: (){submitFeedbackApi(selectFeedbackMode);}, context: context,text: "Submit",)
          ],
        ),
      ),
    );
  }
}
