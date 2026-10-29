import 'package:mobile_erp/features/login/controller/login_controller.dart';
import 'package:mobile_erp/ui/Buttons/CustomButton.dart';
import 'package:mobile_erp/ui/color/appColor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController loginController = Get.put(LoginController(), permanent: true);

  // List<String> database = [
  //   'TESTAC0718',
  //   'database 2',
  //   'database 3',
  //   'database 4',
  //   'database 5',
  // ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [AppColors.primary, AppColors.primary],
            ),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: width * 0.075),
                  child: const Text(
                    "Welcome!",
                    style: TextStyle(
                        fontSize: 40,
                        letterSpacing: 2,
                        color: Colors.black,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: width * 0.075),
                  child: const Text(
                    "Let's sign you in.",
                    style: TextStyle(
                        fontSize: 35,
                        color: Colors.black,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: width * 0.075,
                      right: width * 0.075,
                      top: width * 0.045,
                      bottom: width * 0.075),
                  child: const Text(
                    "You've been missed!",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w300),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: width * 0.075,
                      right: width * 0.075,
                      top: width * 0.035,
                      bottom: width * 0.075),
                  child: Container(
                    height: height * 0.44,
                    width: width * 0.85,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Phone Number'),
                          Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(9)),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: loginController.numberController,
                                style: const TextStyle(
                                  // fontFamily: 'REM',
                                  fontSize: 20,
                                  // fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Phone Number',
                                  hintStyle: TextStyle(
                                      color: Colors.grey.withOpacity(0.8),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                  contentPadding:
                                      const EdgeInsets.only(left: 12, top: 7),
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, left: 8),
                                    child: Text(
                                      "+91 ",
                                      style: TextStyle(
                                        fontFamily: 'REM',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  ),
                                ),
                                onChanged: (val) {
                                  if (val.length <= 10) {
                                    loginController.phone.value = val;
                                    if (val.length == 10) {
                                      FocusScope.of(context).unfocus();
                                    }
                                  } else {
                                    print(loginController.phone.value.length);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Number Should not be greater than 10')));
                                    // Update the text and place cursor at the end
                                    loginController.numberController.value =
                                        TextEditingValue(
                                      text: val.substring(0, 10),
                                      selection: const TextSelection.collapsed(
                                          offset: 10),
                                    );
                                  }
                                },
                              )),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          const Text('Password'),
                          Obx(
                            () => Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(9)),
                                child: TextFormField(
                                  obscureText:
                                      loginController.isPasswordVisible.value,
                                  controller:
                                      loginController.passwordController,
                                  obscuringCharacter: '*',
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Password',
                                    hintStyle: TextStyle(
                                        color: Colors.grey.withOpacity(0.8),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                    contentPadding: const EdgeInsets.only(
                                        left: 12, top: 14),
                                    suffixIcon: GestureDetector(
                                        onTap: () {
                                          loginController
                                              .togglePasswordVisibility();
                                        },
                                        child: loginController
                                                .isPasswordVisible.value
                                            ? const Icon(
                                                CupertinoIcons.eye_slash_fill,
                                                color: AppColors.mainblue,
                                              )
                                            : const Icon(
                                                CupertinoIcons.eye_fill,
                                                color: AppColors.mainblue,
                                              )),
                                  ),
                                  onChanged: (value) {
                                    loginController.password.value = value;
                                  },
                                )),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                         Obx(() =>  Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Center(
                              child: CustomButton(
                                title: 'Login',
                                buttonText:
                                    loginController.isLoading.value == true
                                        ? const CircularProgressIndicator(
                                            color: AppColors.white,
                                          )
                                        : const Text(
                                            'Login',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          ),
                                backgroundColor: AppColors.mainblue,
                                height: 50,
                                width: width * 0.9,
                                borderRadius: 12,
                                onPressed: () async {
                                  await loginController.loginUser();
                                  if (!loginController.isLoading.value) {
                                    loginController.numberController.clear();
                                    loginController.passwordController.clear();
                                  }
                                },
                              ),
                            ),
                          )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
