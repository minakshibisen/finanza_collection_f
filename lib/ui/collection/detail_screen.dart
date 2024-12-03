import 'package:animate_do/animate_do.dart';
import 'package:finanza_collection_f/utils/loading_widget.dart';
import 'package:flutter/material.dart';
import '../../common/api_helper.dart';
import '../../common/common_toast.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../common/default_app_bar.dart';
import '../../utils/constants.dart';
import '../../utils/session_helper.dart';

class DetailScreen extends StatefulWidget {
  final String appId;
  final String fileId;
  final String leadId;
  final String lan;

  const DetailScreen({
    super.key,
    required this.appId,
    required this.fileId,
    required this.leadId,
    required this.lan,
  });

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<dynamic> applicantListItems = [];
  bool isLoading = false;
  bool coAppError = false;
  var detailsBody = {};

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  void getDetails() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      var userId = await SessionHelper.getUserId();
      var companyId = await SessionHelper.getSessionData(SessionKeys.companyId);
      var branchId = await SessionHelper.getSessionData(SessionKeys.branchId);

      final response = await ApiHelper.postRequest(
        url: BaseUrl + getCustomerDetail,
        body: {
          'user_id': userId.toString(),
          'app_id': widget.appId,
          'file_id': widget.fileId,
          'lead_id': widget.leadId,
          'lan': widget.lan,
          'company_id': companyId.toString(),
          'branch_id': branchId.toString(),
        },
      );

      final appCoAppList = await ApiHelper.postRequest(
        url: BaseUrl + listCoApplicant,
        body: {
          'lead_id': widget.leadId,
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
        setState(() {
          detailsBody = data['response'];
        });
      }

      if (appCoAppList['error'] == true) {
        setState(() {
          coAppError = true;
          isLoading = false;
        });

        return;
      }

      final coApps = appCoAppList;

      if (appCoAppList['status'] == 0) {
        setState(() {
          coAppError = true;
        });
      } else {
        setState(() {
          applicantListItems = coApps['response'];
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(title: "Details", size: size),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: isLoading
              ? const SizedBox(height: 200, child: LoadingWidget())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(title: "Account Detail"),
                    AccountDetailCard(
                      detailsBody: detailsBody,
                    ),
                    const SectionTitle(title: "Loan Details"),
                    InstallmentDetailCard(
                      detailsBody: detailsBody,
                    ),
                    const SectionTitle(title: "List Of Application Members"),
                    coAppError || applicantListItems.isEmpty
                        ? SizedBox(
                            height: 200,
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/ic_empty.png',
                                      width: 50, height: 50),
                                  const Text(
                                    "No Members Found!",
                                    style: TextStyle(
                                        color: AppColors.titleLightColor),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Column(
                            children:
                                applicantListItems.asMap().entries.map((entry) {
                              final index = entry.key;
                              final item = entry.value;
                              return FadeInLeft(
                                delay: Duration(milliseconds: index * 160),
                                child: CollectionItemCard(
                                  title: item['customer_name'],
                                  onTap: () {
                                    // Handle item tap if needed
                                  },
                                  mobile: item['mobile_no'],
                                  address: item['communication_address'],
                                  status: item['applicant_status'],
                                ),
                              );
                            }).toList(),
                          )
                  ],
                ),
        ),
      ),
    );
  }
}

class InstallmentDetailCard extends StatelessWidget {
  final Map<dynamic, dynamic> detailsBody;

  const InstallmentDetailCard({super.key, required this.detailsBody});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> details = [
      {
        "title": "Installment Amount",
        "value": detailsBody['installment_amount']
      },
      {"title": "Installment Date", "value": detailsBody['installment_date']},
      {"title": "Next Due Date", "value": detailsBody['next_due_date']},
      {"title": "Last Receipt Date", "value": detailsBody['last_receipt_date']},
      {"title": "Loan Status", "value": detailsBody['loan_status']},
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.lightestGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: details.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return InstallmentDetailRow(
            item: item,
            isLast: index == details.length - 1, // Set isLast for the last item
          );
        }).toList(),
      ),
    );
  }
}

class InstallmentDetailRow extends StatelessWidget {
  final Map<String, String> item;
  final bool isLast;

  const InstallmentDetailRow(
      {super.key, required this.item, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item['title']!,
                style: const TextStyle(
                  color: AppColors.textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                item['value'] ?? "-",
                style: const TextStyle(
                  color: AppColors.titleColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (!isLast)
            const Divider(color: AppColors.textColor, thickness: 0.5),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.titleColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class AccountDetailCard extends StatefulWidget {
  final Map<dynamic, dynamic> detailsBody;

  const AccountDetailCard({super.key, required this.detailsBody});

  @override
  State<AccountDetailCard> createState() => _AccountDetailCardState();
}

class _AccountDetailCardState extends State<AccountDetailCard> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> details = [
      {
        "title": "Number Of Overdue EMI's",
        "value": widget.detailsBody['no_of_od_emi']
      },
      {
        "title": "Overdue Installment",
        "value": widget.detailsBody['od_installment']
      },
      {
        "title": "Overdue Bounce Charges",
        "value": widget.detailsBody['od_bounce_charges']
      },
      {"title": "Overdue Charges", "value": widget.detailsBody['od_charges']},
      {
        "title": "Total Overdue Amount",
        "value": widget.detailsBody['total_od_amount']
      },
      {
        "title": "Future Principle",
        "value": widget.detailsBody['future_princ']
      },
      {
        "title": "Total Outstanding Amount",
        "value": widget.detailsBody['total_os_amount']
      },
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.lightestGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: details.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return AccountDetailRow(
            item: item,
            isLast: index == details.length - 1, // Set isLast for the last item
          );
        }).toList(),
      ),
    );
  }
}

class AccountDetailRow extends StatelessWidget {
  final Map<String, String> item;
  final bool isLast;

  const AccountDetailRow({super.key, required this.item, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item['title']!,
                style: const TextStyle(
                  color: AppColors.textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                item['value']!,
                style: const TextStyle(
                  color: AppColors.titleColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (!isLast)
            const Divider(color: AppColors.textColor, thickness: 0.5),
        ],
      ),
    );
  }
}

class CollectionItemCard extends StatefulWidget {
  final String title;
  final String mobile;
  final String address;
  final String status;
  final VoidCallback onTap;

  const CollectionItemCard({
    super.key,
    required this.title,
    required this.mobile,
    required this.address,
    required this.status,
    required this.onTap,
  });

  @override
  State<CollectionItemCard> createState() => _CollectionItemCardState();
}

class _CollectionItemCardState extends State<CollectionItemCard> {
  bool isOpen = false;

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
        elevation: 3,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRow(
                'Name',
                widget.title,
                AppColors.titleColor,
              ),
              const SizedBox(height: 4),
              _buildRow(
                  'Applicant Status', widget.status, AppColors.primaryColor),
              const SizedBox(height: 4),
              _buildRow('Mobile', widget.mobile, AppColors.titleColor),
              if (isOpen)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    widget.address,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.titleColor),
                    softWrap: true,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value,
    Color valueColor,
  ) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.titleColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: valueColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
