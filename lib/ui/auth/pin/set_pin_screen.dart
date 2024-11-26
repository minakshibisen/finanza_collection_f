import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/primary_button.dart';
import '../../../utils/colors.dart';
import '../../dashboard/homeScreen.dart';

class SetPinScreen extends StatefulWidget {
  const SetPinScreen({super.key});

  @override
  State<SetPinScreen> createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  String pin = '';

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
                onCompleted: (value) {
                  pin = value;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              PrimaryButton(
                color: AppColors.primaryColor,
                borderColor: AppColors.primaryColor,
                onPressed: () {
                  savePin();
                },
                context: context,
                text: 'Set Pin',
              )
            ],
          ),
        ),
      ),
    );
  }

  void savePin() async {
    if (pin.isEmpty || pin.length < 4) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter Pin!")));
    } else {
      var pref = await SharedPreferences.getInstance();

      await pref.setString('pin', pin);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Pin Saved!")));
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => const HomeScreen()), // Your Home Screen
      // );
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
        return const HomeScreen();
      }), (r){
        return false;
      });
    }
  }
}
