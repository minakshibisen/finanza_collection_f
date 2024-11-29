import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../common/default_app_bar.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    super.key,
  });

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

List<String> items = [
  'Pramod Kumar Matho',
  'Minakshi Bisen',
  'Minakshi Bisen',
  'Minakshi Bisen',
  'Minakshi Bisen',
];

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(title: "Details", size: size),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(title: "Account Detail"),
              const AccountDetailCard(),
              const SectionTitle(title: "Loan Details"),
              const InstallmentDetailCard(),
              const SectionTitle(title: "List Of Application Members"),
              Column(
                children: items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return FadeInLeft(
                    delay: Duration(milliseconds: index * 160),
                    child: CollectionItemCard(
                      title: item,
                      onTap: () {
                        // Handle item tap if needed
                      },
                      mobile: '0987654321',
                      address: 'Vijay Nagar Indore,452010',
                      status: 'Co Applicant',
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
  const InstallmentDetailCard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> details = [
      {"title": "Installment Amount", "value": "00"},
      {"title": "Installment Date", "value": "00"},
      {"title": "Next Due Date", "value": "00"},
      {"title": "Last Receipt Date", "value": "00"},
      {"title": "Loan Status", "value": "00"},
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
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

class AccountDetailCard extends StatelessWidget {
  const AccountDetailCard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> details = [
      {"title": "Number Of Overdue EMI's", "value": "00"},
      {"title": "Overdue Installment", "value": "00"},
      {"title": "Overdue Bounce Charges", "value": "00"},
      {"title": "Overdue Charges", "value": "00"},
      {"title": "Total Overdue Amount", "value": "00"},
      {"title": "Future Principle", "value": "00"},
      {"title": "Total Outstanding Amount", "value": "00"},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
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
      onTap:() {
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
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRow('Name', widget.title, AppColors.titleColor,),
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

  Widget _buildRow(String label, String value, Color valueColor,  ) {
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
