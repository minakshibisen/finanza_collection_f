import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text("Logout"),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            _buildBackgroundShape(size),
            Column(
              children: [
                _buildHeader(context, size),
                _buildMenuItems(context, size),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundShape(Size size) {
    return Container(
      height: size.height * 0.45,
      decoration: const BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(80),
          bottomRight: Radius.circular(80),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Size size) {
    return SafeArea(
      child: Container(
        height: size.height * 0.3,
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 22.0),
                      child: Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: size.width * 0.06,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
            ),
            const SizedBox(height: 10),
            Text(
              'Bridglogicsoftware',
              style: TextStyle(
                fontSize: size.width * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context, Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: size.height * 0.05),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Employee Code',
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
                Text(
                  '1001',
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Contact',
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
                Text(
                  '09876543212',
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Email',
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
                Text(
                  'Email@gmail.com',
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Gender',
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
                Text(
                  'Female',
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
