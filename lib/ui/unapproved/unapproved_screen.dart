import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../common/default_app_bar.dart';

class UnapprovedScreen extends StatefulWidget {
  const UnapprovedScreen({super.key});

  @override
  State<UnapprovedScreen> createState() => _UnapprovedScreenState();
}

class _UnapprovedScreenState extends State<UnapprovedScreen> {
  List<String> items = [
    'Pramod Kumar Matho',
    'Bhooki Chudail',
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(title: "Unapproved", size: size),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return FadeInLeft(
            delay: Duration(milliseconds: index * 180),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: CollectionItemCard(
                title: items[index],
                amount: '14,000',
                address: 'BHAEE BUNGLOW 50 LOKMANYA PAUD ROAD',
                description: "asdf asdf asdf asdf",
                onTap: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}

class CollectionItemCard extends StatefulWidget {
  final String title;
  final String amount;
  final String description;
  final String address;
  final VoidCallback onTap;

  const CollectionItemCard({
    super.key,
    required this.title,
    required this.amount,
    required this.address,
    required this.description,
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
                        widget.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.titleColor,
                        ),
                      ),
                      Text(
                        '₹ ${widget.amount}',
                        style: const TextStyle(
                            fontSize: 16,
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
              padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
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
                  const Text(
                    "Added On 24 Nov 2024",
                    style: TextStyle(
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

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return Row(
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
    );
  }
}
