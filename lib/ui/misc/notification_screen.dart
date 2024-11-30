import 'package:animate_do/animate_do.dart';
import 'package:finanza_collection_f/utils/colors.dart';
import 'package:finanza_collection_f/common/default_app_bar.dart';
import 'package:flutter/material.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

List<String> items = [
  'Pramod Kumar Matho',
  'Minakshi Bisen',
];

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return  Scaffold(
      backgroundColor: AppColors.textOnPrimary,
      appBar: DefaultAppBar(title: "Notification", size: size),
      body:   ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return FadeInLeft(
            delay: Duration(milliseconds: index * 180),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: CollectionItemCard(
                title: items[index],
                amount: '14,000',
                date: '21 Nov 2024',
                address:
                'All notification types can be created locally or via remote push services',
                time: '3:56 PM',
                onTap: () {
                  // Handle item tap if needed
                },
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
  final String date;
  final String address;
  final String time;
  final VoidCallback onTap;

  const CollectionItemCard({
    super.key,
    required this.title,
    required this.amount,
    required this.date,
    required this.address,
    required this.time,
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
                    children: [
                      const Icon(Icons.circle_notifications,
                        color: AppColors.primaryColor,),
                      const SizedBox(width: 4),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: AppColors.titleColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.address,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),

                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                  Text(
                    widget.date,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: AppColors.titleColor,
                    ),
                  ),

                  Text(
                    widget.time,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: AppColors.titleColor,
                    ),
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

