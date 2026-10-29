import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mobile_erp/features/Quotation/controller/quotation_controller.dart';
import 'package:mobile_erp/features/customer/controller/customer_controller.dart';
import 'package:mobile_erp/features/customer/presentation/pages/add_customers.dart';
import 'package:mobile_erp/features/customer/presentation/pages/update_customer.dart';
import 'package:mobile_erp/features/customer/presentation/widget/customerCard.dart';
import 'package:mobile_erp/features/login/controller/login_controller.dart';
import 'package:mobile_erp/features/product/controller/product_controller.dart';
import 'package:mobile_erp/features/product/presentation/pages/product.dart';
import 'package:mobile_erp/ui/color/appColor.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/model/get_customer_model.dart';

class CustomerHomeScreen extends StatefulWidget {
  CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  CustomerController customerController = Get.put(CustomerController());
  ProductController pc = Get.put(ProductController());
  QuotationController qc = Get.put(QuotationController());
  LoginController lc = Get.put(LoginController());
  List<CustomersModel> temp = [];

  @override
  void initState() {
    print("From init");
    print(customerController.customersList.value.length);
    super.initState();
  }

  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    temp.add(CustomersModel(company_name: "C1", phone: "1111"));
    temp.add(CustomersModel(company_name: "C2", phone: "2222"));
    temp.add(CustomersModel(company_name: "C3", phone: "3333"));
    // customerController.getCustomerList();
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 70,
        leadingWidth: 40,
        backgroundColor: AppColors.primary,
        leading: Padding(
          padding: EdgeInsets.only(left: 12),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_ios_sharp,
              size: 20,
            ),
          ),
        ),
        title: Container(
          decoration: BoxDecoration(
              color: AppColors.white, borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 5),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search...",
                suffixIcon: Obx(
                  () => customerController.searchCustomer.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            customerController.searchCustomer.value = '';
                            customerController.searchCustomerByNumber('');
                            print(
                                "Search value after cancel: ${customerController.searchCustomer.value}");
                            _searchController.clear();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Text(
                                'Cancel',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        )
                      : Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                ),
                hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                border: InputBorder.none,
              ),
              onChanged: (val) {
                customerController.searchCustomer.value = val;
                customerController.searchCustomerByNumber(
                    customerController.searchCustomer.value);
              },
            ),
          ),
        ),
        actions: [
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () => customerController.detailLoading.value == true
                ? Shimmer.fromColors(
                    baseColor: Colors.grey.withOpacity(0.1),
                    highlightColor: Colors.white.withOpacity(0.6),
                    child: Container(
                      height: 45,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle,
                            color: Colors.grey.shade800,
                            size: 17,
                          ),
                          Text(
                            "Add New Customer",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => AddCustomers(
                                onUpdate: () {
                                  // setState(() {});
                                },
                              )),
                        ),
                      );
                    },
                    child: Container(
                      height: 45,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle,
                            color: Colors.grey.shade800,
                            size: 17,
                          ),
                          Text(
                            "Add New Customer",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          Obx(() => customerController.detailLoading.value == true
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      //replaced container with ink for ripple effect
                      // margin: const EdgeInsets.symmetric(
                      //     horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: ListView.builder(
                          itemCount: 15,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.withOpacity(0.4),
                                highlightColor: Colors.white.withOpacity(0.6),
                                child: Container(
                                  height: 65,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.withOpacity(0.4)),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey.withOpacity(1),
                                    highlightColor: Colors.white.withOpacity(1),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12, right: 12),
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Colors.grey,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 20,
                                              width: Get.width * 0.4,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.grey),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              height: 15,
                                              width: Get.width * 0.3,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.grey),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Ink(
                      //replaced container with ink for ripple effect
                      // margin: const EdgeInsets.symmetric(
                      //     horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white),
                      child: ListView.builder(
                        itemCount:
                            // customerController.customersList.value.length,
                            customerController
                                .searchedCustomerDetailList.value.length,
                        itemBuilder: (BuildContext context, int index) {
                          var customer = customerController
                              .searchedCustomerDetailList.value[index];
                          // customerController.customersList.value[index];
                          return CustomerCard(
                            companyName: customer.name ?? '',
                            number: customer.phone.toString(),
                            onPressed: () {
                              customerController.selectCustomer(customer);
                              qc.getCustomerPrescriptionList(
                                  customer.id.toString());
                              customerController.initializeAddressInUpdate(
                                  customer: customer);
                              print(customerController.selectedCustomer.value?.name);
                              pc.clearDetails();
                              Navigator.of(context).pop();
                              // Navigator.push(
                              //     context,
                              //     CupertinoPageRoute(
                              //         builder: (context) => SelectProductScreen(
                              //             customer: customer)));
                            },
                            onLongPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    backgroundColor: Colors.white,
                                    content: const Text(
                                      "Do you want to edit the current customer?",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text(
                                          "Edit",
                                          style: TextStyle(
                                            color: AppColors.mainblue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                          Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (_) =>
                                                      UpdateCustomers(
                                                          customer: customer)));
                                        },
                                      ),
                                      TextButton(
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                            color: AppColors.mainblue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ))
        ],
      ),
    );
  }
}
