import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mobile_erp/features/customer/controller/customer_controller.dart';
import 'package:mobile_erp/features/customer/data/model/get_customer_model.dart';
import 'package:mobile_erp/features/customer/presentation/pages/add_customers.dart';
import 'package:mobile_erp/features/customer/presentation/pages/update_customer.dart';
import 'package:mobile_erp/features/customer/presentation/widget/customerCard.dart';
import 'package:mobile_erp/features/login/controller/login_controller.dart';
import 'package:mobile_erp/features/product/controller/product_controller.dart';
import 'package:mobile_erp/features/product/presentation/pages/product.dart';
import 'package:mobile_erp/ui/color/appColor.dart';

class ChangeCustomerScreen extends StatefulWidget {
  ChangeCustomerScreen({super.key});

  @override
  State<ChangeCustomerScreen> createState() => _ChangeCustomerScreenState();
}

class _ChangeCustomerScreenState extends State<ChangeCustomerScreen> {
  CustomerController customerController = Get.put(CustomerController());
  LoginController lc = Get.put(LoginController());
  List<CustomersModel> temp = [];

  @override
  void initState() {
    print("From init");
    print(customerController.customersList.value.length);
    super.initState();
  }

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
        toolbarHeight: 70,
        backgroundColor: AppColors.primary,
        title: Container(
          decoration: BoxDecoration(
              color: AppColors.white, borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 5),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search...",
                suffixIcon: Obx(
                  () => customerController.searchCustomer.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Text(
                              'Search',
                              style: TextStyle(fontSize: 15),
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
              },
            ),
          ),
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
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () => customerController.detailLoading.value == true
                ? Center(child: SizedBox())
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
              ? CircularProgressIndicator()
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
                            customerController.customersList.value.length,
                        itemBuilder: (BuildContext context, int index) {
                          var customer =
                              customerController.customersList.value[index];
                          return CustomerCard(
                            companyName: customer.company_name ?? '',
                            number: customer.phone.toString(),
                            onPressed: () {
                              customerController.selectCustomer(customer);
                              Navigator.of(context).pop();
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             SelectProductScreen()));
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
