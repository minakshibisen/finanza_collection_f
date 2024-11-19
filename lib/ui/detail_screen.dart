import 'package:finanza_collection_f/utils/default_app_bar.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();

}

class _DetailScreenState extends State<DetailScreen> {
  List<String> items = [
    'Pramod Kumar Matho',
  ];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(title: "Details", size: size),
     body:
     Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         const Padding(
           padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
           child: Text(
             "Account Detail",
             style: TextStyle(
               color: AppColors.titleColor,
               fontSize: 16,
               fontWeight: FontWeight.w600,
             ),
           ),
         ),
         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
           child: Container(
             width: double.infinity,
             padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
             decoration: BoxDecoration(
               color: AppColors.lightGrey,
               borderRadius: BorderRadius.circular(10),
             ),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 const Padding(
                   padding: EdgeInsets.all(5.0),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text(
                         "Number Of EMI's Due",
                         style: TextStyle(
                           color: AppColors.textColor,
                           fontSize: 14,
                           fontWeight: FontWeight.w600,
                         ),
                       ),
                       Text(
                         "00",
                         style: TextStyle(
                           color: AppColors.titleColor,
                           fontSize: 12,
                           fontWeight: FontWeight.w600,
                         ),
                       ),
                     ],
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.symmetric(vertical: 10),
                   child: Container(
                     color: AppColors.textColor,
                         width: double.infinity,
                         height: 0.8,
                       ),
                 ),
                 const Padding(
                   padding: EdgeInsets.all(5.0),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text(
                         "EMI's Due",
                         style: TextStyle(
                           color: AppColors.textColor,
                           fontSize: 14,
                           fontWeight: FontWeight.w600,
                         ),
                       ),
                       Text(
                         "00",
                         style: TextStyle(
                           color: AppColors.titleColor,
                           fontSize: 12,
                           fontWeight: FontWeight.w600,
                         ),
                       ),
                     ],
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.symmetric(vertical: 10),
                   child: Container(
                     color: AppColors.textColor,
                     width: double.infinity,
                     height: 0.8,
                   ),
                 ),
                 const Padding(
                   padding: EdgeInsets.all(5.0),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text(
                         "Bounce Charges",
                         style: TextStyle(
                           color: AppColors.textColor,
                           fontSize: 14,
                           fontWeight: FontWeight.w600,
                         ),
                       ),
                       Text(
                         "00",
                         style: TextStyle(
                           color: AppColors.titleColor,
                           fontSize: 12,
                           fontWeight: FontWeight.w600,
                         ),
                       ),
                     ],
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.symmetric(vertical: 10),
                   child: Container(
                     color: AppColors.textColor,
                     width: double.infinity,
                     height: 0.8,
                   ),
                 ),
                 const Padding(
                   padding: EdgeInsets.all(5.0),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text(
                         "Interest on Do Principle",
                         style: TextStyle(
                           color: AppColors.textColor,
                           fontSize: 14,
                           fontWeight: FontWeight.w600,
                         ),
                       ),
                       Text(
                         "00",
                         style: TextStyle(
                           color: AppColors.titleColor,
                           fontSize: 12,
                           fontWeight: FontWeight.w600,
                         ),
                       ),
                     ],
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.symmetric(vertical: 10),
                   child: Container(
                     color: AppColors.textColor,
                     width: double.infinity,
                     height: 0.8,
                   ),
                 ),
                 const Padding(
                   padding: EdgeInsets.all(5.0),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text(
                         "Penal Interest",
                         style: TextStyle(
                           color: AppColors.textColor,
                           fontSize: 14,
                           fontWeight: FontWeight.w600,
                         ),
                       ),
                       Text(
                         "00",
                         style: TextStyle(
                           color: AppColors.titleColor,
                           fontSize: 12,
                           fontWeight: FontWeight.w600,
                         ),
                       ),
                     ],
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.symmetric(vertical: 10),
                   child: Container(
                     color: AppColors.textColor,
                     width: double.infinity,
                     height: 0.8,
                   ),
                 ),
                 const Padding(
                   padding: EdgeInsets.all(5.0),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text(
                         "Installment Amount",
                         style: TextStyle(
                           color: AppColors.textColor,
                           fontSize: 14,
                           fontWeight: FontWeight.w600,
                         ),
                       ),
                       Text(
                         "00",
                         style: TextStyle(
                           color: AppColors.titleColor,
                           fontSize: 12,
                           fontWeight: FontWeight.w600,
                         ),
                       ),
                     ],
                   ),
                 ),
                 Padding(
                   padding: const EdgeInsets.symmetric(vertical: 10),
                   child: Container(
                     color: AppColors.textColor,
                     width: double.infinity,
                     height: 0.8,
                   ),
                 ),
                 const Padding(
                   padding: EdgeInsets.all(5.0),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text(
                         "Total Due",
                         style: TextStyle(
                           color: AppColors.textColor,
                           fontSize: 14,
                           fontWeight: FontWeight.w600,
                         ),
                       ),
                       Text(
                         "00",
                         style: TextStyle(
                           color: AppColors.titleColor,
                           fontSize: 12,
                           fontWeight: FontWeight.w600,
                         ),
                       ),
                     ],
                   ),
                 ),

               ],
             ),
           ),
         ),
         const Padding(
           padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
           child: Text(
             "List Of Co Applicants",
             style: TextStyle(
               color: AppColors.titleColor,
               fontSize: 16,
               fontWeight: FontWeight.w600,
             ),
           ),
         ),
         Expanded(
           child: ListView.builder(
             itemCount: items.length,
             itemBuilder: (context, index) {
               return Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 5.0),
                 child: CollectionItemCard(
                   title: items[index],
                   Mobile: '0987654321',
                   address:
                   'BHAEE BUNGLOW 50 LOKMANYA PAUD ROAD, Pune City PUNE Kothrud S.O 411038, Test Landmark, PUNE, MAHARASHTRA - 411038',
                   Status: 'Co-applicant',
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
  final String Mobile;
  final String address;
  final String Status;
  final VoidCallback onTap;

  const CollectionItemCard({
    super.key,
    required this.title,
    required this.Mobile,
    required this.address,
    required this.Status,
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
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Mobile: ',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.titleColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.Mobile,
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
                  if (isOpen)
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
                        // Container(
                        //   decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.titleColor))),
                        //   padding: EdgeInsets.symmetric(vertical: 1, horizontal: 3),
                        //   child: const Text(
                        //     'View Details',
                        //     style: TextStyle(fontSize: 12, color: AppColors.titleColor, fontWeight: FontWeight.bold),
                        //   ),
                        // ),
                        // const SizedBox(height: 8),
                      ],
                    ),
                ],
              ),
            ),
            // Container(
            //   padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
            //   decoration: const BoxDecoration(
            //       color: AppColors.lightGrey,
            //       // border: Border(top: BorderSide(color: AppColors.lightGrey)),
            //       shape: BoxShape.rectangle,
            //       borderRadius: BorderRadiusDirectional.only(
            //           bottomEnd: Radius.circular(12),
            //           bottomStart: Radius.circular(12))),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: [
            //       // _buildActionButton(Icons.article, 'Detail', Colors.green),
            //       // Container(
            //       //   color: AppColors.textColor,
            //       //   width: .5,
            //       //   padding: EdgeInsets.symmetric(vertical: 5),
            //       // ),
            //       _buildActionButton(
            //           Icons.location_on, 'Location', Colors.orange),
            //       Container(
            //         color: AppColors.textColor,
            //         width: .5,
            //         padding: EdgeInsets.symmetric(vertical: 5),
            //       ),
            //       _buildActionButton(Icons.handshake, 'PTP', Colors.orange),
            //       Container(
            //         color: AppColors.textColor,
            //         width: .5,
            //         padding: EdgeInsets.symmetric(vertical: 5),
            //       ),
            //       _buildActionButton(
            //           Icons.account_balance_wallet, 'Collection', Colors.green),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 15),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}