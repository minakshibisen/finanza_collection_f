import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/default_app_bar.dart';

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
    body:  Expanded(
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: CollectionItemCard(
              title: items[index],
              amount: '14,000',
              address:
              'BHAEE BUNGLOW 50 LOKMANYA PAUD ROAD',
              description:"asdf asdf asdf asdf",
              onTap: () {  },
            ),
          );
        },
      ),
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
        margin: EdgeInsets.all(8),
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

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: 8),

                      Text(
                        textAlign: TextAlign.start,
                        widget.address,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.titleColor),
                      ),

                      Text(
                        textAlign: TextAlign.start,
                        widget.description,
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