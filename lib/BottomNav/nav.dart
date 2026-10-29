import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mobile_erp/features/NavbarScreens/Customer/customerNav.dart';
import 'package:mobile_erp/features/NavbarScreens/Product/productNav.dart';
import 'package:mobile_erp/features/customer/controller/customer_controller.dart';
import 'package:mobile_erp/features/customer/presentation/pages/customer.dart';
import 'package:mobile_erp/features/homescreen/controller/userController.dart';
import 'package:mobile_erp/features/homescreen/presentation/homeScreen.dart';
import 'package:mobile_erp/features/product/controller/product_controller.dart';
import 'package:mobile_erp/features/product/presentation/pages/product.dart';
import 'package:mobile_erp/ui/color/appColor.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  // final String isBarterFamily = 'yes';
  UserController uc = Get.put(UserController());
  CustomerController cc = Get.put(CustomerController());
  ProductController pc = Get.put(ProductController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // checkBarterFamily();
  }

  int _selectedIndex = 0;

  List<Widget> pages = [
    const HomeScreen(),
    NavProductScreen(),
    NavCustomerScreen(),
    // PartyScreen(),
    // MoreScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      uc.pageNumber.value = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // height: MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        if (uc.pageNumber.value == 0) {
          return true;
        } else {
          uc.pageNumber.value = 0;
          // _selectedIndex = 0;
          _onItemTapped(0);
          uc.update();
          return false;
        }
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          // body: pages.elementAt(_selectedIndex),
          bottomNavigationBar: ClipRRect(
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: Colors.white,
              unselectedItemColor: const Color.fromARGB(255, 225, 225, 225),
              selectedFontSize: 13,
              unselectedFontSize: 10,
              unselectedLabelStyle: TextStyle(
                fontFamily: "Poppins",
              ),
              selectedLabelStyle: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
              ),
              elevation: 0,
              backgroundColor: AppColors.mainblue,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.card_travel_outlined),
                  activeIcon: Icon(Icons.save_as),
                  label: 'Products',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.card_travel_outlined),
                  activeIcon: Icon(Icons.people),
                  label: 'Customers',
                ),
              ],
              currentIndex: _selectedIndex,
              // selectedItemColor: Colors.amber[800],
              onTap: (index) {
                //disabling Profile Page
                // if (index == 4) return;
                _onItemTapped(index);
              },
            ),
          ),
          body: GetBuilder<UserController>(builder: (controller) {
            return Builder(
              builder: (context) {
                switch (uc.pageNumber.value) {
                  case 0:
                    return const HomeScreen();
                  case 1:
                    return NavProductScreen();
                  case 2:
                    return NavCustomerScreen();
                  // case 3:
                  //   return const PartyScreen();
                  // case 4:
                  //   return const MoreScreen();
                  // case 5:
                  //   return const InvoiceScreen();
                  default:
                    return const Center(child: Text("Work in Progress"));
                }
              },
            );
          })),
    );
  }
}
