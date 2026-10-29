import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mobile_erp/core/enum/post_enum_response.dart';
import 'package:mobile_erp/features/customer/controller/customer_controller.dart';
import 'package:mobile_erp/features/customer/presentation/widget/add_address_widget.dart';
import 'package:mobile_erp/ui/Buttons/CustomButton.dart';

import '../../../../ui/color/appColor.dart';

class AddCustomers extends StatefulWidget {
  VoidCallback onUpdate;
  AddCustomers({super.key, required this.onUpdate});

  @override
  State<AddCustomers> createState() => _AddCustomersState();
}

class _AddCustomersState extends State<AddCustomers> {
  CustomerController cc = Get.put(CustomerController());

  @override
  void dispose() {
    // ignore: avoid_print
    print('Dispose used');
    cc.initializeVariables(billing: true, shipping: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: () async {
          widget.onUpdate();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Add Customer",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [],
          ),
          body: Column(
            children: [
              Expanded(
                child: Container(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                  ),
                  child: ListView(
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Basic Details",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: const TextSpan(
                                text: "Name ",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                      text: "*",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 13,
                                      ))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 3),
                              child: TextField(
                                onChanged: (val) {
                                  cc.cust_name.value = val;
                                },
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(10),
                                  hintText: "Enter Customer's Number",
                                  alignLabelWithHint: true,
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 16,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade200),
                                  ),
                                ),
                              ),
                            ),
                            const Text(
                              "Phone Number",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 3),
                              child: IntlPhoneField(
                                onCountryChanged: (val) {
                                  // cc.dial_code.value = val.dialCode;
                                },
                                flagsButtonPadding: const EdgeInsets.all(8),
                                dropdownIconPosition: IconPosition.trailing,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(0),
                                  hintText: 'Enter Phone Number',
                                  hintStyle:
                                      TextStyle(fontWeight: FontWeight.bold),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(),
                                  ),
                                ),
                                initialCountryCode: 'IN',
                                onChanged: (phone) {
                                  cc.phoneNumber.value = phone.completeNumber;
                                },
                              ),
                            ),
                            const Text(
                              "Email",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 3),
                              child: TextField(
                                onChanged: (val) {
                                  cc.email.value = val;
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(6),
                                  hintText: "Enter Customer's Email",
                                  // errorText: 'Enter Valid Email',
                                  alignLabelWithHint: true,
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 16,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade200),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        "Company Details (Optional)",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "GST Number",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 3),
                              child: TextField(
                                onChanged: (val) {
                                  cc.gstNumber.value = val;
                                },
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(6),
                                  hintText: "22AAAAA00000A1Z5",
                                  alignLabelWithHint: true,
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                  suffixIcon: Container(
                                    width: 100,
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        bottomRight: Radius.circular(5),
                                      ),
                                      color: AppColors.mainblue,
                                    ),
                                    child: const Text(
                                      "Fetch Details",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade200),
                                  ),
                                ),
                              ),
                            ),
                            const Text(
                              "omer GSTIN & click fetch to auto-fill company details",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                            const Text(
                              "Company Name",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 3),
                              child: TextField(
                                onChanged: (val) {
                                  cc.companyName.value = val;
                                },
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(10),
                                  hintText: "eg. Tata Motors Private Limited",
                                  alignLabelWithHint: true,
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade400,
                                    fontSize: 15,
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade200),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        "Address (Optional)",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => cc.address_1_billing.value != '' ||
                                      cc.address_2_billing.value != '' ||
                                      cc.pincode_billing.value != '' ||
                                      cc.city_billing.value != '' ||
                                      cc.state_billing.value != ''
                                  ? Container(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 7.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Billing Address",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey.shade600,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            cc.address_1_billing.value != ''
                                                ? Text(
                                                    cc.address_1_billing.value,
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  )
                                                : SizedBox(),
                                            cc.address_2_billing.value != ''
                                                ? Text(
                                                    cc.address_2_billing.value,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  )
                                                : SizedBox(),
                                            Row(
                                              children: [
                                                cc.city_billing.value != ''
                                                    ? Text(
                                                        '${cc.city_billing.value} ',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      )
                                                    : SizedBox(),
                                                cc.state_billing.value != ''
                                                    ? Text(
                                                        '${cc.state_billing.value} ',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      )
                                                    : SizedBox(),
                                                cc.pincode_billing.value != ''
                                                    ? Text(
                                                        '${cc.pincode_billing.value} ',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      )
                                                    : SizedBox(),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                      // constraints:
                                                      //     BoxConstraints.loose(Size(width, height * 0.75)),
                                                      isScrollControlled: true,
                                                      context: context,
                                                      builder: (context) =>
                                                          SingleChildScrollView(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            bottom:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom,
                                                          ),
                                                          child:
                                                              AddAddressWidget(),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    'Edit',
                                                    style: TextStyle(
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 6, 138, 246),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 13),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    cc.initializeVariables(
                                                        billing: true);
                                                  },
                                                  child: Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 239, 29, 14),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 13),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          // constraints:
                                          //     BoxConstraints.loose(Size(width, height * 0.75)),
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (context) =>
                                              SingleChildScrollView(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom,
                                              ),
                                              child: AddAddressWidget(),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.add_circle,
                                              color: Colors.grey.shade600,
                                              size: 17,
                                            ),
                                            Text(
                                              " Billing Address",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                            ),
                            Divider(
                              color: Colors.grey.shade300,
                            ),
                            Obx(
                              () => cc.address_1_shipping.value != '' ||
                                      cc.address_2_shipping.value != '' ||
                                      cc.pincode_shipping.value != '' ||
                                      cc.city_shipping.value != '' ||
                                      cc.state_shipping.value != ''
                                  ? Container(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 7.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Shipping Address",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey.shade600,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            cc.address_1_shipping.value != ''
                                                ? Text(
                                                    cc.address_1_shipping.value,
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  )
                                                : SizedBox(),
                                            cc.address_2_shipping.value != ''
                                                ? Text(
                                                    cc.address_2_shipping.value,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  )
                                                : SizedBox(),
                                            Row(
                                              children: [
                                                cc.city_shipping.value != ''
                                                    ? Text(
                                                        '${cc.city_shipping.value} ',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      )
                                                    : SizedBox(),
                                                cc.state_shipping.value != ''
                                                    ? Text(
                                                        '${cc.state_shipping.value} ',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      )
                                                    : SizedBox(),
                                                cc.pincode_shipping.value != ''
                                                    ? Text(
                                                        '${cc.pincode_shipping.value} ',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      )
                                                    : SizedBox(),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                      // constraints:
                                                      //     BoxConstraints.loose(Size(width, height * 0.75)),
                                                      isScrollControlled: true,
                                                      context: context,
                                                      builder: (context) =>
                                                          SingleChildScrollView(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            bottom:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom,
                                                          ),
                                                          child:
                                                              AddAddressWidget(
                                                            isShipping: true,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    'Edit',
                                                    style: TextStyle(
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 6, 138, 246),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 13),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    cc.initializeVariables(
                                                        shipping: true);
                                                  },
                                                  child: Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 239, 29, 14),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 13),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          // constraints:
                                          //     BoxConstraints.loose(Size(width, height * 0.75)),
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (context) =>
                                              SingleChildScrollView(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom,
                                              ),
                                              child: AddAddressWidget(
                                                isShipping: true,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.add_circle,
                                              color: Colors.grey.shade600,
                                              size: 17,
                                            ),
                                            Text(
                                              " Shipping Address",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 2,
                                                horizontal: 8,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors
                                                    .lightBlueAccent.shade100
                                                    .withOpacity(0.3),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      cc.address_1_shipping
                                                              .value =
                                                          cc.address_1_billing
                                                              .value;
                                                      cc.address_2_shipping
                                                              .value =
                                                          cc.address_2_billing
                                                              .value;
                                                      cc.city_shipping.value =
                                                          cc.city_billing.value;
                                                      cc.state_shipping.value =
                                                          cc.state_billing
                                                              .value;
                                                      cc.pincode_shipping
                                                              .value =
                                                          cc.pincode_billing
                                                              .value;
                                                    },
                                                    child: Text(
                                                      "Same as Billing? ",
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors
                                                            .grey.shade600,
                                                      ),
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.copy,
                                                    size: 13,
                                                    color: Colors.grey.shade600,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Other Details (Optional)",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: AppColors.mainblue,
                            child: Icon(
                              Icons.expand_more,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          "Add Opening balance, Notes, CC Emails, Tags",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Text(
                            "TDS applicable? ",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Obx(
                            () => FlutterSwitch(
                              showOnOff: true,
                              value: cc.tds_aplicable.value,
                              activeText: "Yes",
                              height: 22,
                              width: 50,
                              toggleSize: 18,
                              padding: 1,
                              inactiveText: "No",
                              valueFontSize: 13,
                              activeTextColor: Colors.white,
                              inactiveTextColor: AppColors.mainblue,
                              activeColor: AppColors.mainblue,
                              inactiveColor: Colors.white,
                              inactiveToggleColor: AppColors.mainblue,
                              switchBorder:
                                  Border.all(color: AppColors.mainblue),
                              activeTextFontWeight: FontWeight.normal,
                              inactiveTextFontWeight: FontWeight.normal,
                              onToggle: (val) {
                                cc.tds_aplicable.value =
                                    !cc.tds_aplicable.value;
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Obx(
                () => Container(
                  height: 90,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: CustomButton(
                        height: 53,
                        title: 'Add Customer',
                        buttonText: cc.postData.value == true
                            ? const CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                color: Colors.grey,
                              )
                            : const Text(
                                'Add Customer',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                        backgroundColor: AppColors.mainblue,
                        borderRadius: 15,
                        onPressed: () async {
                          cc.postData.value = true;
                          PostResponseType res = await cc.postCustomerData();
                          cc.postData.value = false;
                          if (res.postResponseEnum ==
                              PostResponseEnum.success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Data posted successfully')));
                                    Navigator.of(context)..pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('An error has occurred')));
                          }
                        },
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
