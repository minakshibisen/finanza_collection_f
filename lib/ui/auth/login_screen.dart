import 'package:animate_do/animate_do.dart';
import 'package:finanza_collection_f/common/common_toast.dart';
import 'package:finanza_collection_f/common/primary_button.dart';
import 'package:finanza_collection_f/main.dart';
import 'package:finanza_collection_f/ui/auth/pin/set_pin_screen.dart';
import 'package:finanza_collection_f/utils/colors.dart';
import 'package:finanza_collection_f/utils/common_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../common/api_helper.dart';
import '../../common/input_field.dart';
import '../../utils/constants.dart';
import '../../utils/session_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String errorMessage = '';
  var isLoading = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> loginApi() async {
    if (usernameController.text.isEmpty) {
      showSnackBar("Enter Username");
    } else if (passwordController.text.isEmpty) {
      showSnackBar("Enter Password");
    } else {
      setState(() {
        isLoading = true;
      });
      closeKeyboard(context);

      final response = await ApiHelper.postRequest(
        url: BaseUrl + getValidateLogin,
        body: {
          'user_id': usernameController.text,
          'password': passwordController.text,
          'mType': 'MTAy',
        },
      );
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      if (response['error'] == true) {
        CommonToast.showToast(
          context: context,
          title: "Login Failed",
          description: response['message'],
        );
      } else {
        final data = response;

        if (data['status'] == '0') {
          CommonToast.showToast(
              context: context,
              title: "Login Failed",
              description: data['response']['error'].toString(),
              duration: const Duration(seconds: 10));
        } else {
          var response = data['response'];
          var userdata = response['userdata'];
          var userProfile = response['userprofile'];

          await SessionHelper.saveSessionData(
              SessionKeys.userId, userdata?['user_id']);
          await SessionHelper.saveSessionData(
              SessionKeys.mobile, userdata?['mobile']);
          await SessionHelper.saveSessionData(
              SessionKeys.email, userProfile['email']);
          await SessionHelper.saveSessionData(
              SessionKeys.gender, userProfile['gender']);
          await SessionHelper.saveSessionData(
              SessionKeys.companyId, userdata?['company_id']);
          await SessionHelper.saveSessionData(
              SessionKeys.branchList, response['branch_list'].toString());
          await SessionHelper.saveSessionData(
              SessionKeys.userImage, response['userphoto']['file_content']);
          await SessionHelper.saveSessionData(
              SessionKeys.ledgerId, userdata?['ledger_id']);
          await SessionHelper.saveSessionData(
              SessionKeys.permissionGroup, userdata?['permission_group']);
          await SessionHelper.saveSessionData(
              SessionKeys.designation, userdata?['group_name']);
          await SessionHelper.saveSessionData(
              SessionKeys.userType, userdata?['user_type']);

          if (!mounted) return;

          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SetPinScreen()),
          );

          // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
          //   return const HomeScreen();
          // }), (r){
          //   return false;
          // });
        }
      }
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
                                    image:
                                        AssetImage('assets/images/clock.png'))),
                          )),
                    ),
                    Positioned(
                      child: FadeInDownBig(
                          duration: const Duration(milliseconds: 1000),
                          child: Container(
                            margin: const EdgeInsets.only(top: 50),
                            child: Center(
                              child: Padding(
                                padding:
                                    EdgeInsets.only(top: screenHeight * 0.05),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
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
                      child: PrimaryButton(
                        onPressed: () => loginApi(),
                        context: context,
                        text: "Login",
                        isLoading: isLoading,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: AppColors.primaryColor),
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
                              image:
                                  AssetImage('assets/images/client_logo.png'))),
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
