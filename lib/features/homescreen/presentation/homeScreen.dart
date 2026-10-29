import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_erp/features/Quotation/presentation/pages/quotation.dart';
import 'package:mobile_erp/features/homescreen/controller/userController.dart';
import 'package:mobile_erp/features/login/controller/login_controller.dart';
import 'package:mobile_erp/features/orders/presentation/pages/orderPlaced.dart';
import 'package:mobile_erp/ui/color/appColor.dart';
import '../../product/controller/product_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  UserController uc = Get.find();
  ProductController pc = Get.find();
  LoginController lc = Get.put(LoginController());
  List<String> list = <String>['This Year', '2022', '2021', '2020'];
  String dropdownValue = 'This Year';
  List<String> names = [
    'Order',
    'Orders List',
    'Invoice',
    'Delivery Challan',
    'Credit Note',
    'Purchase Order',
    'Expenses order',
    'Pro-Forma',
    'Indirect Income'
  ];
  List<IconData> icons = [
    Icons.shopping_cart_outlined,
    Icons.receipt_outlined,
    Icons.receipt_long,
    Icons.local_shipping_outlined,
    Icons.credit_score_outlined,
    Icons.bookmark_border_outlined,
    Icons.account_balance_wallet_outlined,
    Icons.calculate_outlined,
    Icons.money,
  ];

  List<double> iconSizes = [
    40.0,
    40.0,
    40.0,
    43.0,
    40.0,
    40.0,
    40.0,
    40.0,
    40.0
  ];

  //This variable to track whether the dialog was shown
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Reset the variable when the app is resumed
      _dialogShown = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        if (!_dialogShown) {
          // If the dialog was not shown before, show it
          _dialogShown = true;

          bool shouldCloseApp = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                backgroundColor: Colors.white,
                content: const Text(
                  "Are you sure you want to exit?",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text(
                      "Yes",
                      style: TextStyle(
                        color: AppColors.mainblue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      // Close the dialog and return true
                      Navigator.of(context).pop(true);
                    },
                  ),
                  TextButton(
                    child: const Text(
                      "No",
                      style: TextStyle(
                        color: AppColors.mainblue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      // Close the dialog and return false
                      Navigator.of(context).pop(false);
                    },
                  ),
                ],
              );
            },
          );

          // Reset the variable when the dialog is closed
          _dialogShown = false;

          // Return whether the app should be closed based on user selection
          return shouldCloseApp ?? false;
        } else {
          // If the dialog was already shown, allow the app to be closed without showing the dialog again
          return true;
        }
      },
      child: Scaffold(
          backgroundColor: AppColors.primary,
          appBar: AppBar(
            backgroundColor: AppColors.mainblue,
            automaticallyImplyLeading:
                false, // Set to false to remove the back button
            title: const Text(
              'My Company',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w400),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    lc.logOutUser();
                  },
                  child: Icon(
                    Icons.logout,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      SizedBox(
                        height: 170,
                        child: PageView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          controller: uc.pageController,
                          onPageChanged: (index) {
                            setState(() {
                              uc.idx.value = index;
                            });
                          },
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                height: 75,
                                width: MediaQuery.of(context).size.width * 0.86,
                                decoration: BoxDecoration(
                                  color: AppColors.mainblue,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: SizedBox(
                          height: 8,
                          // width: 200,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Container(
                                  height: 5,
                                  width: 8,
                                  decoration: BoxDecoration(
                                      color: uc.idx.value == index
                                          ? Colors.white
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(100)),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Container(
                  //   width: 300,
                  //   height: 200,
                  //   child: ListView.builder(
                  //     scrollDirection: Axis.horizontal,
                  //     shrinkWrap: true,
                  //     itemCount: 5,
                  //     itemBuilder: (context, index) => Container(
                  //       height: 160,
                  //       decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           borderRadius: BorderRadius.circular(16)),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: 120,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: [
                                DropdownButton<String>(
                                  value: dropdownValue,
                                  icon: const Icon(
                                      Icons.keyboard_arrow_down_outlined),
                                  // elevation: -1,
                                  // elevation: 16,
                                  underline: Container(
                                    height: 0,
                                  ),
                                  style: const TextStyle(color: Colors.black),
                                  onChanged: (String? value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      dropdownValue = value!;
                                    });
                                  },
                                  items: list.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                const Spacer(),
                                const Text(
                                  'View bills',
                                  style: TextStyle(
                                      color: AppColors.mainblue,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Sales',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      '₹400.00',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: width * 0.26,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 1,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.3)),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Purchases',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          '₹0.0',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Create',
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                          onTap: () {
                            uc.toggleExpand();
                          },
                          child: Obx(
                            () => Icon(
                              !uc.expand.value
                                  ? Icons.arrow_circle_down
                                  : Icons.arrow_circle_up,
                              color: AppColors.mainblue,
                            ),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() => uc.expand.value
                      ? Container(
                          // height: 160,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisExtent: 112,
                                  crossAxisSpacing: 0.0,
                                  mainAxisSpacing: 0.0,
                                ),
                                // itemCount: pc.productDataList[0].listings!.length,
                                itemCount: 9,
                                itemBuilder: (context, index) => SizedBox(
                                      height: 100,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            if (index == 0) {
                                              Navigator.push(
                                                  context,
                                                  (CupertinoPageRoute(
                                                      builder: (context) =>
                                                          const QuotationScreen())));
                                              // Get.to(InvoiceScreen());
                                            }
                                            if (index == 1) {
                                              Navigator.push(
                                                  context,
                                                  (CupertinoPageRoute(
                                                      builder: (context) =>
                                                          const OrderPlacedScreen())));
                                            }
                                            if (index == 2) {
                                              // uc.pageNumber.value = 5;
                                              // uc.update();
                                              Navigator.popUntil(context,
                                                  (route) => route.isFirst);
                                              // TODO
                                              // Navigator.pushReplacement(
                                              //     context,
                                              //     (CupertinoPageRoute(
                                              //         builder: (context) =>
                                              //             QuotationScreen())));
                                              // Get.to(InvoiceScreen());
                                            }
                                            if (index == 3) {
                                              // uc.pageNumber.value = 5;
                                              // uc.update();
                                              Navigator.popUntil(context,
                                                  (route) => route.isFirst);
                                              // TODO
                                              // Navigator.pushReplacement(
                                              //     context,
                                              //     (CupertinoPageRoute(
                                              //         builder: (context) =>
                                              //             DeliveryChallanScreen())));
                                              // Get.to(InvoiceScreen());
                                            }
                                            if (index == 4) {
                                              // uc.pageNumber.value = 5;
                                              // uc.update();
                                              Navigator.popUntil(context,
                                                  (route) => route.isFirst);
                                              //TODO
                                              // Navigator.pushReplacement(
                                              //     context,
                                              //     (CupertinoPageRoute(
                                              //         builder: (context) =>
                                              //             CreditNoteScreen())));
                                              // Get.to(InvoiceScreen());
                                            }
                                            if (index == 5) {
                                              // uc.pageNumber.value = 5;
                                              // uc.update();
                                              Navigator.popUntil(context,
                                                  (route) => route.isFirst);
                                              // TODO
                                              // Navigator.pushReplacement(
                                              //     context,
                                              //     (CupertinoPageRoute(
                                              //         builder: (context) =>
                                              //             PurchaseOrderScreen())));
                                              // Get.to(InvoiceScreen());
                                            }
                                            if (index == 6) {
                                              // uc.pageNumber.value = 5;
                                              // uc.update();
                                              Navigator.popUntil(context,
                                                  (route) => route.isFirst);
                                              //TODO
                                              // Navigator.pushReplacement(
                                              //     context,
                                              //     (CupertinoPageRoute(
                                              //         builder: (context) =>
                                              //             ExpenseScreen())));
                                              // Get.to(InvoiceScreen());
                                            }
                                            if (index == 7) {
                                              // uc.pageNumber.value = 5;
                                              // uc.update();
                                              Navigator.popUntil(context,
                                                  (route) => route.isFirst);
                                              //TODO
                                              // Navigator.pushReplacement(
                                              //     context,
                                              //     (CupertinoPageRoute(
                                              //         builder: (context) =>
                                              //             ProFormaInvoiceScreen())));
                                              // Get.to(InvoiceScreen());
                                            }
                                            if (index == 8) {
                                              // uc.pageNumber.value = 5;
                                              // uc.update();
                                              Navigator.popUntil(context,
                                                  (route) => route.isFirst);
                                              //TODO
                                              // Navigator.pushReplacement(
                                              //     context,
                                              //     (CupertinoPageRoute(
                                              //         builder: (context) =>
                                              //             IndirectIncomeScreen())));
                                              // Get.to(InvoiceScreen());
                                            }
                                          },
                                          child: Container(
                                            height: 100,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                // border: Border.all(width: 1),
                                                color: Colors.white),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    icons[index],
                                                    color: AppColors.mainblue,
                                                    size: iconSizes[index],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    names[index],
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                          ))
                      : const SizedBox())
                ],
              ),
            ),
          )),
    );
  }
}
