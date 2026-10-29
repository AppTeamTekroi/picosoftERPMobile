import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_erp/features/auth_service/auth_service.dart';
import 'package:mobile_erp/features/customer/presentation/pages/customer.dart';
import 'package:mobile_erp/features/login/presentation/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../BottomNav/nav.dart';


class LoginController extends GetxController {
  final AuthService authService = AuthService();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var otpVisibility = false.obs;
  var isPasswordVisible = true.obs;
  var gstInfo = "".obs;
  var pin = false;
  var phone = "".obs;
  var password = "".obs;
  var pageNumber = 1.obs;
  var isLoading = false.obs;
  var isRegisterLoading = false.obs;
  var name = "".obs;
  var email = "".obs;
  var isLogin = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  @override
  void onInit() {
    super.onInit();
    // Load login state on controller initialization
    loadLoginState();
  }

  Future<void> loadLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    isLogin.value = prefs.getBool('isLogin') ?? false;
  }

  Future<void> loginUser() async {
    final String number = numberController.text;
    final String password = passwordController.text;
    try {
      isLoading.value = true;
      // Call login method from ApiService
      bool loginSuccess = await authService.login(
        number,
        password,
      );
      if (loginSuccess) {
        // Navigate to the home screen upon successful login
        Get.to(() =>  BottomNav());
        isLogin.value = true;
        saveLoginState();
      } else {
        // Show an error message or handle failed login
        // Get.snackbar('Login Failed', 'Invalid credentials');
      }
      clearTextLoginFields();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logOutUser() async {
    Get.off(() => const LoginScreen());
    isLogin.value = false;
    saveLoginState();
  }

  Future<void> saveLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', isLogin.value);
  }

  void clearTextLoginFields() {
    passwordController.clear();
    numberController.clear();
  }
}
