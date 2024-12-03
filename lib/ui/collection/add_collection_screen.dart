import 'package:animate_do/animate_do.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:finanza_collection_f/common/primary_button.dart';
import 'package:finanza_collection_f/common/success_dialog.dart';
import 'package:finanza_collection_f/common/title_input_field.dart';
import 'package:finanza_collection_f/common/titled_dropdown.dart';
import 'package:finanza_collection_f/utils/colors.dart';
import 'package:finanza_collection_f/common/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/api_helper.dart';
import '../../common/common_toast.dart';
import '../../common/input_field.dart';
import '../../common/user_banner.dart';
import '../../main.dart';
import '../../utils/common_util.dart';
import '../../utils/constants.dart';
import '../../utils/session_helper.dart';

class AddCollectionScreen extends StatefulWidget {
  const AddCollectionScreen(
      {super.key,
      required this.name,
      required this.lan,
      required this.appId,
      required this.fileId});

  final String name;
  final String lan;
  final String appId;
  final String fileId;

  @override
  State<AddCollectionScreen> createState() => _AddCollectionScreenState();
}

class _AddCollectionScreenState extends State<AddCollectionScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _instrumentNumController =
      TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  String? selectedReceiptMode;
  String? selectedBankMode;
  var isLoading = false;
  Map<String, dynamic> receiptModeList = {};
  Map<String, dynamic> bankList = {};
  Map<String, dynamic> receiptTypeList = {};

  List<CollectionItem> collectionItems = [
    CollectionItem(
      amount: 0,
      type: '',
      controller: TextEditingController(),
    )
  ];

  void addReceipt() async {
    if (selectedReceiptMode == null || selectedReceiptMode!.isEmpty) {
      showSnackBar("Select Receipt Mode!", context);
      return;
    }
    if (selectedBankMode == null || selectedBankMode!.isEmpty) {
      showSnackBar("Select Account!", context);
      return;
    }
    if (_dateController.text.isEmpty) {
      showSnackBar("Select Instrument Date!", context);
      return;
    }
    if (_instrumentNumController.text.isEmpty) {
      showSnackBar("Enter Inst/Receipt Number!", context);
      return;
    }

    if (!checkCollectionItemValid()) {
      return;
    }

    if (_commentController.text.isEmpty) {
      showSnackBar("Enter Comment!", context);
      return;
    }

    setState(() {
      isLoading = true;
    });
    var userId = await SessionHelper.getUserId();
    var branchId = await SessionHelper.getBranchId();
    var appId = widget.appId;
    var fileId = widget.fileId;
    List<Map<dynamic, dynamic>> collectionData = [];

    for (var item in collectionItems) {
      collectionData
          .add({'"key"': '"${item.type}"', '"value"': '"${item.amount}"'});
    }

    try {
      final response =
          await ApiHelper.postRequest(url: BaseUrl + collectionSubmit, body: {
        "user_id": userId,
        "app_id": appId,
        "file_id": fileId,
        "lan": widget.lan,
        "narration": _commentController.text.toString(),
        "receipt_mode": selectedReceiptMode,
        "bank_ledger": selectedBankMode,
        "instrument_date": _dateController.text.toString(),
        "branch_id": branchId,
        "collection_data": '$collectionData',
        "instrument_no": _instrumentNumController.text.toString(),
      });

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
      } else if (data['status'] == 1) {
        showSuccessDialog(context, '${data['response']?[0]}', onDismiss: () {
          Navigator.pop(context);
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

  bool checkCollectionItemValid() {
    var index = 1;
    for (var item in collectionItems) {
      if (item.type.isEmpty) {
        showSnackBar('Select Collection type at $index position!', context);
        return false;
      }
      if (item.amount <= 0) {
        showSnackBar('Enter a valid amount at $index position!', context);
        return false;
      }

      index += 1;
    }
    return true;
  }

  @override
  void dispose() {
    _dateController.dispose();
    _instrumentNumController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    receiptModeApi();
    getReceiptType();
    isLoading = false;
  }

  void bankListApi(receiptMode) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    var ledgerId = await SessionHelper.getSessionData(SessionKeys.ledgerId);
    var userType = await SessionHelper.getSessionData(SessionKeys.userType);
    var companyId = await SessionHelper.getSessionData(SessionKeys.companyId);

    try {
      final response = await ApiHelper.postRequest(
        url: BaseUrl + getAccountCollection,
        body: {
          "ledger_id": ledgerId.toString(),
          "user_type": userType.toString(),
          "company_id": companyId.toString(),
          "receipt_mode": receiptMode.toString(),
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
          bankList = {};
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
          bankList = {};
          isLoading = false;
        });
        return;
      } else if (data['status'] == '1') {
        final Map<String, String> dropdownMap = {
          for (var item in data['response'])
            item['ledger_name']: item['ledger_id']
        };

        setState(() {
          bankList = dropdownMap;
          isLoading = false;
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
        bankList = {};
        isLoading = false;
      });
    }
  }

  void getReceiptType() async {
    var userId = await SessionHelper.getSessionData(SessionKeys.userId);
    var userType = await SessionHelper.getSessionData(SessionKeys.userType);

    try {
      final response = await ApiHelper.postRequest(
        url: BaseUrl + getCollectionsType,
        body: {
          "user_id": userId.toString(),
          "user_type": userType.toString(),
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
          receiptTypeList = {};
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
          receiptTypeList = {};
        });
        return;
      } else if (data['status'] == '1') {
        final Map<String, String> dropdownMap = {
          for (var item in data['response']) item['key']: item['value']
        };

        setState(() {
          receiptTypeList = dropdownMap;
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
        receiptTypeList = {};
      });
    }
  }

  void receiptModeApi() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await ApiHelper.getRequest(
        url: BaseUrl + getReceiptMode,
      );

      if (!mounted) return;

      if (response['error'] == true) {
        CommonToast.showToast(
          context: context,
          title: "Request Failed",
          description: response['message'] ?? "Unknown error occurred",
        );
        setState(() {
          receiptModeList = {};
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
          receiptModeList = {};
          isLoading = false;
        });
        return;
      } else if (data['status'] == '1') {
        final Map<String, String> dropdownMap = {
          for (var item in data['response']) item['key']: item['value']
        };

        setState(() {
          receiptModeList = dropdownMap;
          isLoading = false;
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
        receiptModeList = {};
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.textOnPrimary,
      appBar: DefaultAppBar(title: "Add Collection ", size: size),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FadeInDown(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const UserBanner(
                  name: 'CHANDA PRAKASH RAV',
                  lan: '101101100001',
                ),
                TitledDropdown(
                    items: receiptModeList != {}
                        ? receiptModeList.keys.toList()
                        : [],
                    title: "Receipt Mode",
                    onChanged: (value) {
                      selectedReceiptMode = receiptModeList[value];
                      bankListApi(value);
                    }),
                const SizedBox(
                  height: 15,
                ),
                TitledDropdown(
                    items: bankList != {} ? bankList.keys.toList() : [],
                    title: "Bank/Cash A/c",
                    onChanged: (value) {
                      selectedBankMode = bankList[value];
                    }),
                const SizedBox(
                  height: 15,
                ),
                const InputFieldTitle(titleText: "Instrument Date"),
                DatePickerField(
                  dateController: _dateController,
                ),
                const SizedBox(
                  height: 15,
                ),
                const InputFieldTitle(titleText: "Inst/Receipt Number"),
                InputFieldWidget(
                  hintText: "Enter Receipt No.",
                  icon: Icons.receipt,
                  textInputAction: TextInputAction.done,
                  capitalize: true,
                  controller: _instrumentNumController,
                ),
                const SizedBox(
                  height: 15,
                ),
                CollectionTypeSelect(
                  receiptTypeList: receiptTypeList,
                  collectionItemList: collectionItems,
                ),
                const InputFieldTitle(titleText: "Comment / Narration"),
                InputFieldWidget(
                  hintText: "Enter Comment",
                  icon: Icons.comment,
                  textInputAction: TextInputAction.done,
                  controller: _commentController,
                  keyboardType: TextInputType.multiline,
                  capitalize: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                PrimaryButton(
                  isLoading: isLoading,
                  onPressed: () => addReceipt(),
                  context: context,
                  text: 'Add Receipt',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CollectionTypeSelect extends StatefulWidget {
  final Map<String, dynamic> receiptTypeList;
  final List<CollectionItem> collectionItemList;

  const CollectionTypeSelect(
      {super.key,
      required this.receiptTypeList,
      required this.collectionItemList});

  @override
  State<CollectionTypeSelect> createState() => CollectionTypeSelectState();
}

class CollectionTypeSelectState extends State<CollectionTypeSelect> {
  double amount = 0;

  void _addItem() {
    setState(() {
      widget.collectionItemList.add(CollectionItem(
        amount: 0,
        type: '',
        controller: TextEditingController(),
      ));
    });
  }

  void _removeItem() {
    setState(() {
      if (widget.collectionItemList.length > 1) {
        final item = widget.collectionItemList.removeLast();
        item.controller.dispose();
        _calculateAll();
      }
    });
  }

  @override
  void dispose() {
    for (var item in widget.collectionItemList) {
      item.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: _removeItem,
              child: Container(
                width: 33,
                height: 33,
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.titleLightColor,
                ),
                child: const Icon(
                  Icons.remove,
                  color: AppColors.textOnPrimary,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _addItem,
              child: Container(
                width: 33,
                height: 33,
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor,
                ),
                child: const Icon(
                  Icons.add,
                  color: AppColors.textOnPrimary,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            SizedBox(
              width: (size.width - 32) * .6,
              child: const Text(
                "Collection Type",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.titleLightColor,
                ),
              ),
            ),
            SizedBox(
              width: (size.width - 32) * .4,
              child: const Text(
                "Amount",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.titleLightColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Column(
          children: widget.collectionItemList.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: _buildCollectionRow(size.width, item, index),
            );
          }).toList(),
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            textAlign: TextAlign.end,
            "Total Amount: ₹ ${getFancyNumber(amount)}",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.titleLightColor,
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  void _calculateAll() {
    double amount = 0;
    for (var item in widget.collectionItemList) {
      amount += item.amount;
    }

    setState(() {
      this.amount = amount;
    });
  }

  Widget _buildCollectionRow(double size, CollectionItem item, int index) {
    if (!item.hasListener) {
      item.controller.addListener(() {
        final text = item.controller.text;
        if (text.isNotEmpty) {
          item.amount = double.tryParse(text) ?? 0;
        } else {
          item.amount = 0;
        }
      });
      item.hasListener = true;
    }

    return Row(
      children: [
        Flexible(
          flex: 6,
          child: CustomDropdown<String>(
            decoration: const CustomDropdownDecoration(
              expandedFillColor: AppColors.lightGrey,
              closedFillColor: AppColors.lightGrey,
              listItemStyle: TextStyle(fontSize: 13),
              headerStyle: TextStyle(fontSize: 14),
              prefixIcon: Icon(
                Icons.receipt,
                color: AppColors.primaryColor,
                size: 18,
              ),
              hintStyle: TextStyle(fontSize: 12),
            ),
            hintText: 'Please Select',
            closedHeaderPadding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 15,
            ),
            items: widget.receiptTypeList != {}
                ? widget.receiptTypeList.keys.toList()
                : [],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  item.type = value;
                });
              }
            },
          ),
        ),
        SizedBox(width: size * 0.05),
        Flexible(
          flex: 4,
          child: InputFieldWidget(
            hintText: "",
            keyboardType: TextInputType.number,
            length: 6,
            controller: item.controller,
            onChanged: (value) {
              setState(() {
                item.amount = double.tryParse(value) ?? 0;
                _calculateAll();
              });
            },
          ),
        ),
      ],
    );
  }
}

extension on String {
  get controller => null;

  num get amount => 3452;
}

class CollectionItem {
  double amount;
  String type;
  final TextEditingController controller;
  bool hasListener = false;

  CollectionItem({
    required this.amount,
    required this.type,
    required this.controller,
  });
}

class DatePickerField extends StatefulWidget {
  final TextEditingController dateController;

  const DatePickerField({super.key, required this.dateController});

  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
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
        widget.dateController.text = formattedDate.split(' ')[0];
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
          keyboardType: TextInputType.none,
          icon: Icons.calendar_month,
          textInputAction: TextInputAction.next,
          controller: widget.dateController,
          enabled: true,
        ),
      ),
    );
  }
}
