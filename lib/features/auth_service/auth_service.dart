import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../API/URLConst.dart';

class AuthService {
  bool isLoggedIn() {
    // Simulating authentication status
    return false;
  }

  Future<bool> login(String mobile, String password) async {
    try {
      // print('${mobile } and ${password}');
      final url = Uri.parse(URLConst.loginURL);

      final Map<String, dynamic> requestBody = {
        'mobile': mobile,
        'password': password,
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
      final name = jsonDecode(response.body)['data']['mobile_user']['name'];
      final email = jsonDecode(response.body)['data']['mobile_user']['email'];
      final id = jsonDecode(response.body)['data']['mobile_user']['id'];
      final mobile_num =
          jsonDecode(response.body)['data']['mobile_user']['mobile'];
      final store_id =
          jsonDecode(response.body)['data']['mobile_user']['store_id'];
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('userId', id ?? 0);
      prefs.setString('name', name ?? '');
      prefs.setString('email', email ?? '');
      prefs.setInt('mobile', mobile_num ?? 0);
      prefs.setInt('store_id', store_id ?? 0);

      // print(jsonDecode(response.body)['data']['mobile_user']['name']);
      // print(jsonDecode(response.body)['data']['mobile_user']['email']);
      // print(jsonDecode(response.body)['data']['mobile_user']['id']);
      // print(jsonDecode(response.body)['data']['mobile_user']['mobile']);
      // print(jsonDecode(response.body)['data']['mobile_user']['store_id']);

      if (response.statusCode == 200) {
        print('Login successful!');
        // If logged in, navigate to the home screen
        // Get.to(() => const BottomNav());
        await Future.delayed(const Duration(seconds: 1));
        return true;
      } else {
        print(
            'Login failed. Status code: ${response.statusCode}, Error: ${response.body}');
        Get.snackbar(
          'Login Failed',
          'Please check your credentials and try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (error) {
      // Handle other errors
      print('Error during login: $error');
      Get.snackbar(
        'Error',
        'An error occurred during login. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }
}
