import 'package:animate_do/animate_do.dart';
import 'package:finanza_collection_f/ui/auth/pin/change_pin_Screen.dart';
import 'package:finanza_collection_f/utils/session_helper.dart';
import 'package:flutter/material.dart';

import '../../app_localizations.dart';
import '../../common/api_helper.dart';
import '../../common/common_toast.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../auth/change_password_screen.dart';
import '../auth/pin/check_pin_screen.dart';
import '../auth/login_screen.dart';
import '../misc/notification_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = '';
  String image = '';
  String email = '';
  String branch = '';
  String designation = '';
  String empCode = '';

  Future<void> profileDetailApi() async {
    var userId = await SessionHelper.getSessionData(SessionKeys.userId);
    final response = await ApiHelper.postRequest(
      url: baseUrl + profileDetails,
      body: {
        'user_id': userId,
      },
    );

    if (response['error'] == true) {
      if (!mounted) return;

      CommonToast.showToast(
        context: context,
        title: "Request Failed",
        description: response['message'] ?? "Unknown error occurred",
      );
      await SessionHelper.clearAllSessionData();

      if (!mounted) return;

      Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      final res = response;

      if (!mounted) return;

      if (res['status'] == '0') {
        CommonToast.showToast(
          context: context,
          title: "Request Failed",
          description: res['error']?.toString() ?? "No User found",
        );

        await SessionHelper.clearAllSessionData();
        if (!mounted) return;
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        var data = res['response'];

        setState(() {
          userName = data['name'].toString();
          empCode = data['employee_code'].toString();
          branch = data['branch_id'].toString();
          email = data['email'].toString();
          designation = data['designation'].toString();
          empCode = data['emp_code'].toString();
        });

        await SessionHelper.saveSessionData(SessionKeys.mobile, data['mobile']);
        await SessionHelper.saveSessionData(SessionKeys.email, data['email']);
        await SessionHelper.saveSessionData(SessionKeys.gender, data['gender']);
        await SessionHelper.saveSessionData(
            SessionKeys.branchId, data['branch_id']);
        await SessionHelper.saveSessionData(SessionKeys.username, data['name']);
        await SessionHelper.saveSessionData(
            SessionKeys.designation, data['designation']);
        await SessionHelper.saveSessionData(
            SessionKeys.employeeCode, data['emp_code']);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    profileDetailApi();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final List<Map<String, dynamic>> listItems = [
      {
        "title": "Change Language",
        "icon": Icons.language,
        "onTap": () {
          _showLanguageDialog(context);
        },
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
            MaterialPageRoute(
              builder: (context) => const ChangePasswordScreen(),
            ),
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
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            Stack(
              children: [
                _buildUserDetailCard(),
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
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: _buildCardItem(
                                title: "Branch",
                                subtitle: branch,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              child: Container(
                                height: 0.2,
                                color: Colors.grey[400],
                                width: double.infinity,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: _buildCardItem(
                                title: "Designation",
                                subtitle: designation,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              child: Container(
                                height: 0.2,
                                color: Colors.grey[400],
                                width: double.infinity,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: _buildCardItem(
                                title: "Employee Code",
                                subtitle: empCode,
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
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: listItems.length,
              itemBuilder: (context, index) {
                final item = listItems[index];
                return FadeInLeft(
                  duration: const Duration(milliseconds: 500),
                  delay: Duration(milliseconds: index * 200), // Staggered delay
                  child: Column(
                    children: [
                      _buildListTile(
                        title: item['title'] as String,
                        leadingIcon: item['icon'] as IconData,
                        onTap: item['onTap'] as VoidCallback,
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
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetailCard() {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.3,
      color: AppColors.primaryColor,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
      child: FadeIn(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/ic_image.png'),
            ),
            Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.mail, color: Colors.white, size: 16),
                    const SizedBox(width: 5),
                    Text(
                      email,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardItem({
    required String title,
    required String subtitle,
  }) {
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

void _showLanguageDialog(BuildContext context) {
  final languages = [
    {"code": "en", "name": "English"},
    {"code": "hi", "name": "हिन्दी"},
    {"code": "mr", "name": "मराठी"}
  ];

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(AppLocalizations.of(context)?.translate("change_language") ??
          "Change Language"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: languages
            .map((lang) => ListTile(
                  title: Text(lang['name']!),
                  onTap: () {
                    // Close the dialog
                    Navigator.of(context).pop();

                    // Update the locale using MyApp's setLocale method
                    MyApp.of(context)?.setLocale(Locale(lang['code']!));
                  },
                ))
            .toList(),
      ),
    ),
  );
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
            onPressed: () async {
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return const CheckPinScreen(
                  biometric: false,
                );
              }), (r) {
                return false;
              });
            },
            child: const Text('Logout'),
          ),
        ],
      );
    },
  );
}
