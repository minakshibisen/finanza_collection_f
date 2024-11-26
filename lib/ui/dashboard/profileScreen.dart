import 'package:animate_do/animate_do.dart';
import 'package:finanza_collection_f/ui/auth/pin/change_pin_Screen.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../auth/change_password_screen.dart';
import '../auth/pin/check_pin_screen.dart';
import '../auth/login_screen.dart';
import '../misc/notification_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    // List of tiles with their respective details
    final List<Map<String, dynamic>> listItems = [
      {
        "title": "Change Language",
        "icon": Icons.language,
        "onTap": () {},
      },
      {
        "title": "App Theme",
        "icon": Icons.settings,
        "onTap": () {
          _showThemeSelectionDialog(context);
        },
      },
      {
        "title": "Notifications",
        "icon": Icons.notifications,
        "onTap": () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const NotificationScreen()),
          );
        },
      },
      {
        "title": "Change Password",
        "icon": Icons.password_rounded,
        "onTap": () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
          );
        },
      },
      {
        "title": "Change Pin",
        "icon": Icons.pin,
        "onTap": () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ChangePinScreen()),
          );
        },
      },
      {
        "title": "Logout",
        "icon": Icons.logout,
        "onTap": () {
          _showLogoutDialog(context);
        },
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 1,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const NotificationScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: size.height * 0.3,
                    color: AppColors.primaryColor,
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                    child: FadeIn(
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage:
                            AssetImage('assets/images/ic_image.png'),
                          ),
                          Column(
                            children: [
                              SizedBox(height: 10),
                              Text(
                                "User Name", // Replace with user name
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.mail, color: Colors.white, size: 16),
                                  SizedBox(width: 5),
                                  Text(
                                    "user@example.com",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Profile Stats Card
                  Column(
                    children: [
                      SizedBox(height: size.height * 0.26),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                child: _buildCardItem(
                                  title: "Branch",
                                  subtitle: "Delhi - CP",
                                ),
                              ),
                              Padding(
                                 padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                                child: Container(
                                  height: 0.2,
                                  color: Colors.grey[400],
                                  width: double.infinity,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                child: _buildCardItem(
                                  title: "Designation",
                                  subtitle: "Collection Manager",
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                                child: Container(
                                  height: 0.2,
                                  color: Colors.grey[400],
                                  width: double.infinity,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                child: _buildCardItem(
                                  title: "Employee Code",
                                  subtitle: "1001",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                children: listItems.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return FadeInLeft(
                        duration: const Duration(milliseconds: 500),
                        delay: Duration(milliseconds: index * 200), // Staggered delay
                        child: Column(
                          children: [
                            _buildListTile(
                              title: item['title']!,
                              leadingIcon: item['icon']!,
                              onTap: item['onTap']!,
                            ),
                            if (index != listItems.length - 1)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 15),
                                child: Container(
                                  width: double.infinity,
                                  color: Colors.grey,
                                  height: 0.3,
                                ),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardItem(
      {required String title,required String subtitle,}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$title: ',
          textAlign: TextAlign.start,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: AppColors.textColor),
        ),
        Text(
          subtitle,
          textAlign: TextAlign.start,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.titleColor),
        ),

      ],
    );
  }

  Widget _buildListTile(
      {required String title,
        required IconData leadingIcon,
        required VoidCallback onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(leadingIcon, color: AppColors.iconColor),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.titleColor,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: AppColors.textColor,
      ),
      onTap: onTap,
    );
  }
}

void _showThemeSelectionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Choose the App Theme",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
            _buildThemeOption(
              context,
              title: "Light",
              isSelected: false, // Replace with actual theme state
            ),
            _buildThemeOption(
              context,
              title: "Dark",
              isSelected: false, // Replace with actual theme state
            ),
            _buildThemeOption(
              context,
              title: "System Default",
              isSelected: true, // Replace with actual theme state
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildThemeOption(BuildContext context,
    {required String title, required bool isSelected}) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(vertical: 3),
    leading: Radio(
      value: title,
      groupValue: isSelected ? title : null,
      onChanged: (value) {
        // Handle the theme selection logic
        Navigator.of(context).pop(); // Close dialog on selection
      },
      activeColor: AppColors.primaryColor, // Active theme color
    ),
    title: Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
    ),
  );
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Perform logout logic
              Navigator.of(context).pop(); // Close the dialog
              // Navigate to login screen or handle logout
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const CheckPinScreen()),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      );
    },
  );
}
