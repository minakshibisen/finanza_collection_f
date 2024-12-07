import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:finanza_collection_f/common/default_app_bar.dart';
import 'package:finanza_collection_f/ui/auth/feedback_screen.dart';
import 'package:finanza_collection_f/ui/collection/add_collection_screen.dart';
import 'package:finanza_collection_f/ui/maps/map_screen.dart';
import 'package:finanza_collection_f/ui/ptp/add_ptp_screen.dart';
import 'package:finanza_collection_f/utils/colors.dart';
import 'package:finanza_collection_f/utils/common_util.dart';
import 'package:finanza_collection_f/utils/constants.dart';
import 'package:finanza_collection_f/utils/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../common/api_helper.dart';
import '../../common/common_toast.dart';
import '../../main.dart';
import '../../utils/session_helper.dart';
import 'detail_screen.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  CollectionScreenState createState() => CollectionScreenState();
}

class CollectionScreenState extends State<CollectionScreen> {
  var isLoading = false;
  List<dynamic> collectionItems = [];
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  void _collectionListApi() async {
    // Prevent multiple simultaneous calls
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      var userId = await SessionHelper.getSessionData(SessionKeys.userId);
      var companyId = await SessionHelper.getSessionData(SessionKeys.companyId);
      var branchId = await SessionHelper.getSessionData(SessionKeys.branchId);

      final response = await ApiHelper.postRequest(
        url: baseUrl + searchCustomer,
        body: {
          'user_id': userId.toString(),
          'company_id': companyId.toString(),
          'branch_id': branchId.toString(),
          'search_key': _searchController.text.trim(),
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
          collectionItems = [];
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
          collectionItems = [];
          isLoading = false;
        });
        return;
      }

      setState(() {
        collectionItems = data['response'] ?? [];
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
        collectionItems = [];
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Add listener with debounce to prevent excessive API calls
    _searchController.addListener(() {
      if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        if (_searchController.text.isEmpty ||
            _searchController.text.length > 2) {
          _collectionListApi();
        }
      });
    });

    // Initial API call
    _collectionListApi();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: DefaultAppBar(title: "Collections", size: size),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildSearchLayout(),
          isLoading
              ? const SizedBox(height: 200, child: LoadingWidget(size: 40))
              : Expanded(
                  child: collectionItems.isEmpty
                      ? const Center(
                          child: Text(
                            "No collections found",
                            style: TextStyle(color: AppColors.titleLightColor),
                          ),
                        )
                      : ListView.builder(
                          itemCount: collectionItems.length,
                          itemBuilder: (context, index) {
                            var item = collectionItems[index];
                            return FadeInLeft(
                              delay: Duration(milliseconds: (index + 10) + 100),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: CollectionItemCard(
                                  title: item['customer_name'] ?? 'Unknown',
                                  amount:
                                      item['overdue_amount']?.toString() ?? '0',
                                  lan: item['lan'] ?? 'N/A',
                                  address:
                                      item['Communication'] ?? 'No address',
                                  alternateAddress:
                                      item['Permanent'] ?? 'No address',
                                  dueDays: item['dpd']?.toString() ?? '0',
                                  appId: item['app_id']?.toString() ?? '',
                                  fileId: item['file_id']?.toString() ?? '',
                                  leadId: item['lead_id']?.toString() ?? '',
                                  latitude: item['latitude'],
                                  longitude: item['longitude'],
                                  onTap: () {
                                    // Handle item tap if needed
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
        ],
      ),
    );
  }

  Widget _buildSearchLayout() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
        child: RoundedSearchInput(
            textController: _searchController, hintText: "Search..."));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }
}

class CollectionItemCard extends StatefulWidget {
  final String title;
  final String amount;
  final String lan;
  final String address;
  final String alternateAddress;
  final String dueDays;
  final String appId;
  final String leadId;
  final String fileId;
  final String? latitude;
  final String? longitude;
  final VoidCallback onTap;

  const CollectionItemCard({
    super.key,
    required this.title,
    required this.amount,
    required this.lan,
    required this.address,
    required this.dueDays,
    required this.onTap,
    required this.appId,
    required this.fileId,
    required this.alternateAddress,
    required this.leadId,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<CollectionItemCard> createState() => _CollectionItemCardState();
}

class _CollectionItemCardState extends State<CollectionItemCard> {
  var isOpen = false;
  List<MenuItem> menuItems = [];

  @override
  void initState() {
    super.initState();
    menuItems.add(MenuItem(
      icon: Icons.link,
      title: 'Link',
      context: context,
      onTap: () {
        showSnackBar("Payment Link Sent!", context);
      },
    ));

    menuItems.add(MenuItem(
      icon: Icons.feedback_outlined,
      title: 'Feedback',
      context: context,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) =>  FeedbackScreen( lan: widget.lan,)),
        );
      },
    ));
  }

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
                      Text(
                        'Due For ${widget.dueDays} Days ',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textColor,
                          fontWeight: FontWeight.bold,
                        ),
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
                        // const SizedBox(height: 8),

                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                          fileId: widget.fileId,
                                          appId: widget.appId,
                                          leadId: widget.leadId,
                                          lan: widget.lan,
                                        )),
                              );
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: AppColors.titleColor))),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 3),
                              child: const Text(
                                'View Details',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.titleColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
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
                  _buildActionButton(
                      Icons.location_on_outlined, 'Location', Colors.orange,
                      () {
                    double longitude = 0;
                    double latitude = 0;

                    if (widget.latitude != null &&
                        widget.latitude!.isNotEmpty) {
                      latitude = double.parse(widget.latitude!);
                    } else {
                      showSnackBar("Address Not Mapped!", context);
                      return;
                    }
                    if (widget.longitude != null &&
                        widget.longitude!.isNotEmpty) {
                      longitude = double.parse(widget.longitude!);
                    } else {
                      showSnackBar("Address Not Mapped!", context);
                      return;
                    }

                    LatLng destination = LatLng(latitude, longitude);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MapScreen(
                        title: "Navigate to User",
                        destination: destination,
                        customerAddress: widget.address,
                        customerName: widget.title,
                      ),
                    ));
                  }),
                  Container(
                    color: AppColors.textColor,
                    width: .5,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                  ),
                  _buildActionButton(
                      Icons.handshake_outlined, 'PTP', Colors.orange, () {
                    List<String> list = [];
                    list.add(widget.address);
                    list.add(widget.alternateAddress);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => AddPtpScreen(
                                lan: widget.lan,
                                name: widget.title,
                                address: list,
                              )),
                    );
                  }),
                  Container(
                    color: AppColors.textColor,
                    width: .5,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                  ),
                  _buildActionButton(Icons.account_balance_wallet_outlined,
                      'Collection', Colors.green, () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => AddCollectionScreen(
                                lan: widget.lan,
                                name: widget.title,
                                appId: widget.appId,
                                fileId: widget.fileId,
                              )),
                    );
                  }),
                  Container(
                    color: AppColors.textColor,
                    width: .5,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                  ),
                  PopupMenuButton<MenuItem>(
                    onSelected: (MenuItem item) {
                      item.onTap();
                    },
                    color: AppColors.textOnPrimary,
                    elevation: 2,
                    position: PopupMenuPosition.under,
                    itemBuilder: (BuildContext context) =>
                        menuItems.map((MenuItem item) {
                      return PopupMenuItem<MenuItem>(
                        value: item,
                        child: Row(
                          children: [
                            Icon(item.icon, size: 15),
                            const SizedBox(width: 4),
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    child: const Row(
                      children: [
                        Icon(Icons.more_vert, size: 15),
                        SizedBox(width: 4),
                        Text(
                          'More',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.normal),
                        ),
                      ],
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
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}

class RoundedSearchInput extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;

  const RoundedSearchInput(
      {required this.textController, required this.hintText, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
            offset: Offset(12, 26),
            blurRadius: 50,
            spreadRadius: 0,
            color: AppColors.lightGrey),
      ]),
      child: TextField(
        controller: textController,
        onChanged: (value) {
          //Do something wi
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[500]!,
          ),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400]!, width: 1.0),
            borderRadius: const BorderRadius.all(Radius.circular(35.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[600]!, width: 1.5),
            borderRadius: const BorderRadius.all(Radius.circular(35.0)),
          ),
        ),
      ),
    );
  }
}

class MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final BuildContext context;

  MenuItem(
      {required this.icon,
      required this.title,
      required this.onTap,
      required this.context});
}
