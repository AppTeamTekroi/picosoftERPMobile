import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_erp/BottomNav/nav.dart';
import 'package:mobile_erp/features/customer/controller/customer_controller.dart';
import 'package:mobile_erp/features/customer/presentation/pages/customer.dart';
import 'package:mobile_erp/features/login/controller/login_controller.dart';
import 'package:mobile_erp/features/login/presentation/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() async => LoginController());
  await Get.putAsync(() async => CustomerController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'Inter'),
      // home: const StartingScreen(),
      home: Obx(() {
        final loginController = Get.find<LoginController>();
        final customerController = Get.find<CustomerController>();
        // return loginController.isLogin.value ? const BottomNav() : const StartingScreen();
        return loginController.isLogin.value
            ? const BottomNav()
            : const LoginScreen();
      }),
    );
  }
}
