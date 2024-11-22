
import 'package:animate_do/animate_do.dart';
import 'package:finanza_collection_f/ui/dashboard/homeScreen.dart';
import 'package:finanza_collection_f/ui/auth/pin/set_pin_screen.dart';
import 'package:finanza_collection_f/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../common/input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

String errorMessage = '';

TextEditingController usernameController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  Future<void> loginApi() async {
    if (usernameController.text.isEmpty) {
      showSnackBar("Enter Username");
    } else if (passwordController.text.isEmpty) {
      showSnackBar("Enter Password");
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const SetPinScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.textOnPrimary,
        systemNavigationBarIconBrightness:
        Brightness.light, // Adjust icon brightness
      ),
    );

    bool isLoading = false;
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.07;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.47;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: imageHeight,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/img_background.png'),
                        fit: BoxFit.fill)),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      width: 80,
                      height: screenHeight * 0.22,
                      child: FadeInUp(
                          duration: const Duration(seconds: 1),
                          child: Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    opacity: 0.7,
                                    image: AssetImage(
                                        'assets/images/light-1.png'))),
                          )),
                    ),
                    Positioned(
                      left: 140,
                      width: 80,
                      height: screenHeight * 0.17,
                      child: FadeInUp(
                          duration: const Duration(milliseconds: 1200),
                          child: Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                  opacity: 0.5,
                                    image: AssetImage(
                                        'assets/images/light-2.png'))),
                          )),
                    ),
                    Positioned(
                      right: 40,
                      top: 40,
                      width: 80,
                      height: screenHeight * 0.17,
                      child: FadeInUp(
                          duration: const Duration(milliseconds: 1300),
                          child: Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    opacity: 0.5,
                                    image: AssetImage(
                                        'assets/images/clock.png'))),
                          )),
                    ),
                    Positioned(
                      child: FadeInDownBig(
                          duration: const Duration(milliseconds: 1000),
                          child: Container(
                            margin: const EdgeInsets.only(top: 50),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: screenHeight * 0.05),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/logo_finanza.png'))),
                                ),
                              ),
                            ),
                          )),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                child: Column(
                  children: <Widget>[
                    FadeInUp(
                        duration: const Duration(milliseconds: 1200),
                        child: Column(
                          children: [
                            InputFieldWidget(
                                hintText: 'User Name',
                                icon: Icons.person,
                                textInputAction: TextInputAction.next,
                                controller: usernameController),
                            const SizedBox(
                              height: 10,
                            ),
                            InputFieldWidget(
                              hintText: 'Password',
                              icon: Icons.password,
                              controller: passwordController,
                              keyboardType: TextInputType.visiblePassword,
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    FadeInUp(
                        duration: const Duration(milliseconds: 1200),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
                              return const HomeScreen();
                            }), (r){
                              return false;
                            });
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(colors: [
                                  AppColors.primaryColor,
                                  Color.fromRGBO(
                                      24, 102, 169, 0.5803921568627451),
                                ])),
                            child: const Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )),
                    const SizedBox(
                      height: 40,
                    ),
                    FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color: AppColors.primaryColor),
                        )),
                  ],
                ),
              ),
              FadeInUp(
                  duration: const Duration(milliseconds: 1200),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: screenWidth * 0.7,
                      height: imageHeight * 0.4,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/client_logo.png'))),
                    ),
                  )),
            ],
          ),
        ));
    /*return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                  padding: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: horizontalPadding,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                child: Image.asset(
                                  'assets/images/ic_logo.png',
                                  width: 180,
                                  height: 75,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const Row(
                                children: [
                                  SizedBox(width: 3),
                                  Text(
                                    'Login to continue',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black54,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              InputFieldWidget(
                                  hintText: 'User Name',
                                  icon: Icons.person,
                                  textInputAction: TextInputAction.next,
                                  controller: usernameController),
                              const SizedBox(
                                height: 10,
                              ),
                              InputFieldWidget(
                                hintText: 'Password',
                                icon: Icons.password,
                                controller: passwordController,
                                keyboardType: TextInputType.visiblePassword,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: [
                                  isLoading
                                      ? CircularProgressIndicator()
                                      : PrimaryButton(
                                    context: context,
                                    text: 'Login',
                                    color: AppColors.primaryColor,
                                    textColor: Colors.white,
                                    borderColor: AppColors.primaryColor,
                                    onPressed: () {
                                      loginApi();
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                  const Padding(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 22),
                                    child: Text(
                                      '',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );*/
  }

  void showSnackBar(String s) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(s)),
    );
  }
}
