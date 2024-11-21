import 'package:finanza_collection_f/ui/add_collection_screen.dart';
import 'package:finanza_collection_f/utils/default_app_bar.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import 'add_ptp_screen.dart';

class PTPScreen extends StatefulWidget {
  const PTPScreen({super.key});

  @override
  State<PTPScreen> createState() => _PTPScreenState();
}

class _PTPScreenState extends State<PTPScreen> {
  List<String> items = [
    'Pramod Kumar Matho',
    'Bhooki Chudail',
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(title: "Promise To Pay List", size: size),
      body: Column(
        children: [
          // Stack(
          //   alignment: Alignment.centerLeft,
          //   children: [
          //     Container(
          //       width: double.infinity,
          //       height: size.height * 0.1,
          //       decoration: BoxDecoration(
          //           color: AppColors.primaryColor,
          //           shape: BoxShape.rectangle,
          //           borderRadius:
          //           BorderRadius.only(bottomRight: Radius.circular(200))),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Text(
          //         "Today: 19 November",
          //         style: const TextStyle(
          //           fontSize: 15,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.white,
          //         ),
          //       ),
          //     ),
          //
          //   ],
          // ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: CollectionItemCard(
                    title: items[index],
                    lan: '101100156126',
                    description: 'BHAEE BUNGLOW 50 LOKMANYA PAUD ROAD',
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
    );
  }
}

class CollectionItemCard extends StatefulWidget {
  final String title;
  final String lan;
  final String description;
  final VoidCallback onTap;

  const CollectionItemCard({
    super.key,
    required this.title,
    required this.lan,
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: 8),
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
                  _buildActionButton(Icons.handshake, 'PTP', Colors.orange,(){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const AddPtpScreen()),
                    );
                  }),
                  Container(
                    color: AppColors.textColor,
                    width: .5,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                  ),
                  _buildActionButton(
                      Icons.account_balance_wallet, 'Collection', Colors.green,(){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const AddCollectionScreen()),
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

  Widget _buildActionButton(IconData icon, String label, Color color,VoidCallback onTap) {
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
