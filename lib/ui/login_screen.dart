import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:finanza_collection_f/ui/set_pin_screen.dart';
import 'package:finanza_collection_f/utils/colors.dart';
import 'package:flutter/material.dart';
import '../common/input_field.dart';
import '../common/primary_button.dart';

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
    bool isLoading = false;
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.07;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.2;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: FadeInUp(
                            duration: const Duration(seconds: 1),
                            child: Container(
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/light-1.png'))),
                            )),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: FadeInUp(
                            duration: const Duration(milliseconds: 1200),
                            child: Container(
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/light-2.png'))),
                            )),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: FadeInUp(
                            duration: const Duration(milliseconds: 1300),
                            child: Container(
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/clock.png'))),
                            )),
                      ),
                      Positioned(
                        child: FadeInUp(
                            duration: const Duration(milliseconds: 1600),
                            child: Container(
                              margin: const EdgeInsets.only(top: 50),
                              child: const Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      // FadeInUp(
                      //     duration: const Duration(milliseconds: 1800),
                      //     child: Container(
                      //       padding: const EdgeInsets.all(5),
                      //       decoration: BoxDecoration(
                      //           color: Colors.white,
                      //           borderRadius: BorderRadius.circular(10),
                      //           border: Border.all(
                      //               color:
                      //                   const Color.fromRGBO(143, 148, 251, 1)),
                      //           boxShadow: const [
                      //             BoxShadow(
                      //                 color: Color.fromRGBO(143, 148, 251, .2),
                      //                 blurRadius: 20.0,
                      //                 offset: Offset(0, 10))
                      //           ]),
                      //       child: Column(
                      //         children: <Widget>[
                      //           Container(
                      //             padding: const EdgeInsets.all(8.0),
                      //             decoration: const BoxDecoration(
                      //                 border: Border(
                      //                     bottom: BorderSide(
                      //                         color: Color.fromRGBO(
                      //                             143, 148, 251, 1)))),
                      //             child: TextField(
                      //               decoration: InputDecoration(
                      //                   border: InputBorder.none,
                      //                   hintText: "Email or Phone number",
                      //                   hintStyle:
                      //                       TextStyle(color: Colors.grey[700])),
                      //             ),
                      //           ),
                      //           Container(
                      //             padding: const EdgeInsets.all(8.0),
                      //             child: TextField(
                      //               obscureText: true,
                      //               decoration: InputDecoration(
                      //                   border: InputBorder.none,
                      //                   hintText: "Password",
                      //                   hintStyle:
                      //                       TextStyle(color: Colors.grey[700])),
                      //             ),
                      //           )
                      //         ],
                      //       ),
                      //     )),
                      FadeInUp(
                          duration: const Duration(milliseconds: 1800),
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
                          duration: const Duration(milliseconds: 1900),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const SetPinScreen()),
                              );
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
                        height: 70,
                      ),
                      FadeInUp(
                          duration: const Duration(milliseconds: 2000),
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                                color: Color.fromRGBO(143, 148, 251, 1)),
                          )),
                    ],
                  ),
                )
              ],
            ),
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
