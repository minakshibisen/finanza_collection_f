import 'package:flutter/material.dart';

import '../utils/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

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
              // Add your notification handling logic here
            },
          ),
        ],
      ),
      body:
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: Container(
              color: AppColors.textColor,
              width: double.infinity,
              height: 0.8,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Layout
                  Stack(
                    children: [
                      Container(
                        height: size.height * 0.3,
                        color: AppColors.primaryColor,
                        padding: const EdgeInsets.fromLTRB(
                            0, 0, 0, 40),
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
                                      style: TextStyle(color: Colors.white, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Profile Card
                      Column(
                        children: [
                          SizedBox(height: size.height * 0.26,),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                            ),
                            child: Container(

                              padding: const EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildCardItem(
                                    title: "0",
                                    subtitle: "Collection Till Date",
                                    icon: Icons.assignment,
                                  ),
                                  Container(
                                    width: 0.5,
                                    color: Colors.grey,
                                    height: 40,
                                  ),
                                  _buildCardItem(
                                    title: "0",
                                    subtitle: "Years of Experience",
                                    icon: Icons.calendar_today,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 10,),
                  _buildListTile(
                    title: "Change Language",
                    leadingIcon: Icons.language,
                    onTap: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 3, horizontal: 15),
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey,
                      height: 0.3,
                    ),
                  ),
                  _buildListTile(
                    title: "App Theme",
                    leadingIcon: Icons.settings,
                    onTap: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 3, horizontal: 15),
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey,
                      height: 0.3,
                    ),
                  ),
                  _buildListTile(
                    title: "Notifications",
                    leadingIcon: Icons.notifications,
                    onTap: () {},
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 3, horizontal: 15),
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey,
                      height: 0.3,
                    ),
                  ),
                  _buildListTile(
                    title: "Change Password",
                    leadingIcon: Icons.password_rounded,
                    onTap: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 3, horizontal: 15),
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey,
                      height: 0.3,
                    ),
                  ),
                  _buildListTile(
                    title: "Set Pin",
                    leadingIcon: Icons.pin,
                    onTap: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 3, horizontal: 15),
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey,
                      height: 0.3,
                    ),
                  ),
                  _buildListTile(
                    title: "Logout",
                    leadingIcon: Icons.logout,
                    onTap: () {
                      // Handle logout
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardItem({required String title,
    required String subtitle,
    required IconData icon}) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.titleColor),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: AppColors.textColor),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.titleColor),
      ),
    );
  }

  Widget _buildListTile({required String title,
    required IconData leadingIcon,
    required VoidCallback onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(leadingIcon, color: AppColors.iconColor),
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.titleColor),
      ),
      trailing:
      const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textColor),
      onTap: onTap,
    );
  }
}
