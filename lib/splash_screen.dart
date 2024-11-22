import 'package:finanza_collection_f/ui/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {

    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // final prefs = await SharedPreferences.getInstance();
    // final userId = prefs.getString('user_id');
    //
    // if (userId != null) {
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (context) => HomeScreen()),
    //   );
    // } else {
    await Future.delayed(const Duration(seconds: 1), () {});
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    // }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Image.asset('assets/images/logo.png', width: size.width * 0.7, height: size.height * 0.3)),
    );
  }
}