import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../dashboard/homeScreen.dart';
import '../login_screen.dart';

class CheckPinScreen extends StatefulWidget {
  const CheckPinScreen({super.key});

  @override
  State<CheckPinScreen> createState() => _CheckPinScreenState();
}

String pin = '';

class _CheckPinScreenState extends State<CheckPinScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.2;
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: imageHeight,
                width: screenWidth * 0.75,
                child: Image.asset(
                  'assets/images/login-head.png',
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Image.asset(
                  'assets/images/ic_logo.png',
                  height: 50,
                  width: 160,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Hi, SuperUser',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Verify 4-digit security pin',
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                  textAlign: TextAlign.center),
              const SizedBox(
                height: 20,
              ),
              Pinput(
                length: 4,
                autofocus: true,
                defaultPinTheme: defaultPinTheme,
                submittedPinTheme: submittedPinTheme,
                focusedPinTheme: focusedPinTheme,
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: true,
                closeKeyboardWhenCompleted: false,
                onCompleted: (value) {
                  pin = value;
                  checkPin();
                },
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text('Register With Login ID?',
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                    textAlign: TextAlign.center),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Forgot Pin?',
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  void checkPin() async {
    if (pin.isEmpty || pin.length < 4) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter Pin!")));
    } else {
      var pref = await SharedPreferences.getInstance();
      var existingPin = pref.getString('pin');
      if (existingPin == pin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen()), // Your Home Screen
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Incorrect Pin!")));
      }
    }
  }
}
