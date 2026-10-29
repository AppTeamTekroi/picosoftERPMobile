import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_erp/features/Quotation/controller/quotation_controller.dart';
import 'package:mobile_erp/features/Quotation/presentation/widget/additionalTable.dart';
import 'package:mobile_erp/features/Quotation/presentation/widget/eyeTable.dart';
import 'package:mobile_erp/features/Quotation/presentation/widget/return_values_bs.dart';
import 'package:mobile_erp/features/customer/controller/customer_controller.dart';
import 'package:mobile_erp/features/customer/presentation/pages/customer.dart';
import 'package:mobile_erp/features/orders/presentation/pages/orderdetail.dart';
import 'package:mobile_erp/features/product/controller/product_controller.dart';
import 'package:mobile_erp/features/product/presentation/pages/product.dart';
import 'package:mobile_erp/ui/Buttons/buttonBS.dart';
import 'package:mobile_erp/ui/color/appColor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/enum/post_enum_response.dart';

class QuotationScreen extends StatefulWidget {
  const QuotationScreen({super.key});

  @override
  State<QuotationScreen> createState() => _QuotationScreenState();
}

class _QuotationScreenState extends State<QuotationScreen> {
  ProductController pc = Get.put(ProductController());
  CustomerController customerController = Get.put(CustomerController());
  bool _dialogShown = false;
  QuotationController qc = Get.put(QuotationController());

  final FocusNode unitPriceFocusNode = FocusNode();
  final FocusNode amountFocusNode = FocusNode();
  late double? selectedQty;
  late double? unitPrice;
  late double? priceWTax;
  late ReturnValuesBS? resultValues;

  late TextEditingController unitPriceController;
  late TextEditingController productQuantityController;
  late TextEditingController priceWithTaxController;
  late TextEditingController percentageController;
  late TextEditingController amountController;
  late TextEditingController description;


  Set<int> expandedDetailsIndices = {};

  late String totalValue;
  late double totalPrice;
  double finalTotalAmount = 0.0;
  double finalGstAmount = 0.0;
  double finalSubTotalAmount = 0.0;
  late double taxWithPrice;
  late double netAmount;
  late double tax;
  int selectedPaymentType = 1;
  int selectedPaymentSettlement = 1;

  bool isEyesSame = false;

  List<IconData> stylingIcons = [
    Icons.format_bold,
    Icons.format_italic,
    Icons.format_underline,
    Icons.format_list_numbered,
    Icons.format_list_bulleted
  ];

  List<String?> dueDateSelection = [
    'custom',
    'net 0',
    'net 15',
    'net 30',
    'net 60'
  ];
  List<String?> fullOrAdvance = ['Full Payment', 'Advance Payment'];

  List<String> stylingTitles = [
    'Bold',
    'Italic',
    'Underline',
    'OrderedList',
    'UnorderedList'
  ];

  List<String> radioOptionText = [
    'Unit Price',
    'Price with Tax',
    'Net Amount',
    'Total Amount'
  ];
  List<String> paymentType = ['Cash', 'Card', 'Online', 'UPI'];

  List<String> optionText = [
    'Select Bank',
    'Select Signature',
    'Add Reference',
    'Add Notes',
    'Add Terms',
    'Add Delivery/Shipping Charges',
    'Add Packaging Charges',
    'Extra Discount/Apply Coupon',
  ];

  List<IconData> optionIcon = [
    Icons.maps_home_work_outlined,
    Icons.pending_actions,
    Icons.book_outlined,
    Icons.edit_note_sharp,
    Icons.addchart_outlined,
    Icons.monetization_on_outlined,
    Icons.monetization_on_outlined,
    Icons.discount_outlined,
  ];

  @override
  void initState() {
    super.initState();
    pc.clearDetails();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    customerController.initializeVariables(billing: true, shipping: true);
    pc.clearDetails();
    customerController.selectedCustomer.value = null;
    qc.presId.clear();
    qc.selectPresId.value = '-1';
    log("Selected Product List: from dispose ${pc.selectedProducts}");
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Reset the variable when the app is resumed
      _dialogShown = false;
    }
  }

  String getFormattedDateTime() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd_HH:mm:ss');
    return formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    getFormattedDateTime();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    DateFormat('dd-MM-yyyy').format(DateTime.now());

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!_dialogShown) {
          // If the dialog was not shown before, show it
          _dialogShown = true;

          // bool shouldCloseApp = await
          showDialog(
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
                      _dialogShown = true;
                      qc.advanceAmount.value = 0;
                      pc.clearDetails();
                      Navigator.of(context)
                        ..pop(true)
                        ..pop();
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
          // log(shouldCloseApp);
          // Reset the variable when the dialog is closed
          _dialogShown = false;
          // Return whether the app should be closed based on user selection
          return;
        }
        // else {
        //   //   // If the dialog was already shown, allow the app to be closed without showing the dialog again
        //   return true;
        // }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          scrolledUnderElevation: 0,
          // this don't change the appbar color when the list is scrolled
          title: const Text(
            'Create Order',
            style: TextStyle(
                color: Colors.black, fontSize: 19, fontWeight: FontWeight.w400),
          ),
          leading: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          5.0), // Adjust the border radius here
                    ),
                    backgroundColor: Colors.white,
                    content: const Text("Are you sure you want to exit?",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    actions: <Widget>[
                      TextButton(
                        child: const Text("Yes",
                            style: TextStyle(
                                color: AppColors.mainblue,
                                fontWeight: FontWeight.bold)),
                        onPressed: () {
                          _dialogShown = true;
                          pc.clearDetails();
                          qc.advanceAmount.value = 0;
                          Navigator.of(context)
                            ..pop(true)
                            ..pop();
                        },
                      ),
                      TextButton(
                        child: const Text("No",
                            style: TextStyle(
                                color: AppColors.mainblue,
                                fontWeight: FontWeight.bold)),
                        onPressed: () {
                          // Add your code here for "No" action
                          Navigator.pop(context); // Close the dialog
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Icon(Icons.arrow_back_ios, color: Colors.black),
            ),
          ),
          actions: const [],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child:
                        // Obx(
                        //   () =>
                        Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Row(
                          children: [
                            Text(
                              'Customer',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.info,
                              size: 18,
                              color: Colors.black54,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () async {
                            // var selectedCustomer = await Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         SelectCustomers(), // Navigate to the SelectCustomers page
                            //   ),
                            // );
                            // if (selectedCustomer != null) {
                            //   // If a customer was selected, update it in the CustomerController
                            //   customerController
                            //       .selectCustomer(selectedCustomer);
                            // }
                          },
                          child: GetBuilder<CustomerController>(
                            builder: (controller) {
                              var selectedCustomer =
                                  controller.selectedCustomer.value;

                              return Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                //hello?

                                child: selectedCustomer?.name != null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const SizedBox(width: 15),
                                              // Add some spacing on the left
                                              Text(
                                                selectedCustomer?.name ?? 'n/a',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                child: const Text(
                                                  'View',
                                                  style: TextStyle(
                                                    color: AppColors.mainblue,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                onTap: () {
                                                  // customerController
                                                  //     .initializeAddressInUpdate(
                                                  //         customer:
                                                  //             customerController
                                                  //                 .selectedCustomer
                                                  //                 .value!);
                                                  showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    context: context,
                                                    builder: (context) {
                                                      if (selectedCustomer !=
                                                          null) {
                                                        return Container(
                                                          width: width,
                                                          height: height * 0.62,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(22),
                                                              topRight: Radius
                                                                  .circular(22),
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20.0),
                                                            child:
                                                                SingleChildScrollView(
                                                              physics:
                                                                  const BouncingScrollPhysics(),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <Widget>[
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Center(
                                                                    child:
                                                                        Container(
                                                                      height: 3,
                                                                      width: 80,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .grey,
                                                                        borderRadius:
                                                                            BorderRadius.circular(12),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 15,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    // Aligns the widgets to the right
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            '${selectedCustomer!.company_name}',
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 16,
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          Text(
                                                                            '${selectedCustomer!.phone}',
                                                                            style:
                                                                                const TextStyle(
                                                                              color: Colors.black54,
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            '${selectedCustomer!.email}',
                                                                            style:
                                                                                const TextStyle(
                                                                              color: Colors.black54,
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          GestureDetector(
                                                                              onTap: () {},
                                                                              child: const Text(
                                                                                'Edit',
                                                                                style: TextStyle(
                                                                                  color: AppColors.mainblue,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontSize: 15,
                                                                                ),
                                                                              )),
                                                                          const SizedBox(
                                                                              width: 10),
                                                                          GestureDetector(
                                                                              onTap: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: const Icon(Icons.close))
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const Divider(
                                                                    color: Colors
                                                                        .grey,
                                                                    thickness:
                                                                        0,
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  const Text(
                                                                    "Company Details",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          17,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  const Text(
                                                                    "Company Name",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black54,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                  Text(
                                                                    '${selectedCustomer!.company_name}',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  const Text(
                                                                    "GSTIN",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black54,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                  Text(
                                                                    '${selectedCustomer!.gstin}',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  const Text(
                                                                      "Billing Address",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      )),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  // TODO:
                                                                  Text(
                                                                    // '${selectedCustomer!.address?.type == 'billing' ? selectedCustomer!.address?.address_1 : '--'}',
                                                                    '${customerController.address_1_billing.value == 'null' ? '--' : customerController.address_1_billing}',
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                  Text(
                                                                    // '${selectedCustomer!.address?.type == 'billing' ? selectedCustomer!.address?.address_2 : '--'}',
                                                                    '${customerController.address_2_billing.value == 'null' ? '--' : customerController.address_2_billing}',
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                  Text(
                                                                    // '${selectedCustomer!.address?.type == 'billing' ? selectedCustomer!.address?.city : '--'}',
                                                                    '${customerController.city_billing.value == 'null' ? '--' : customerController.city_billing}',
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  const Text(
                                                                      "Shipping Address",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      )),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  //TODO
                                                                  Text(
                                                                    // '${selectedCustomer!.address?.type == 'shipping' ? selectedCustomer!.address?.address_1 : '--'}',
                                                                    '${customerController.address_1_shipping.value == 'null' ? '--' : customerController.address_1_shipping}',
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                  Text(
                                                                    // '${selectedCustomer!.address?.type == 'shipping' ? selectedCustomer!.address?.address_2 : '--'}',
                                                                    '${customerController.address_2_shipping.value == 'null' ? '--' : customerController.address_2_shipping}',
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                  Text(
                                                                    // '${selectedCustomer!.address?.type == 'shipping' ? selectedCustomer!.address?.city : '--'}',
                                                                    '${customerController.city_shipping.value == 'null' ? '--' : customerController.city_shipping}',
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                  const Divider(
                                                                    // Add a divider
                                                                    color: Colors
                                                                        .grey,
                                                                    // Customize the color as needed
                                                                    thickness:
                                                                        0, // Customize the thickness as needed// Customize the height as needed
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        return const Text(
                                                            "No Customer");
                                                      }
                                                    },
                                                  );
                                                },
                                              ),
                                              const SizedBox(width: 5),
                                              GestureDetector(
                                                child: const Text(
                                                  'Change',
                                                  style: TextStyle(
                                                    color: AppColors.mainblue,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                onTap: () async {
                                                  selectedCustomer =
                                                      await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          CustomerHomeScreen(),
                                                    ),
                                                  );
                                                  if (selectedCustomer !=
                                                      null) {
                                                    // Update the selected customer
                                                    customerController
                                                        .selectCustomer(
                                                            selectedCustomer!);
                                                  }
                                                },
                                              ),
                                              const SizedBox(width: 10),
                                            ],
                                          ),
                                        ],
                                      )
                                    : GestureDetector(
                                        onTap: () async {
                                          selectedCustomer =
                                              await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CustomerHomeScreen()),
                                          );
                                          if (selectedCustomer != null) {
                                            // Update the selected customer
                                            customerController.selectCustomer(
                                                selectedCustomer!);
                                          }

                                          // setState(() {});
                                        },
                                        child: const Row(children: [
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Icon(
                                            Icons.add_circle,
                                            size: 18,
                                            color: AppColors.mainblue,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Select Customer',
                                            style: TextStyle(
                                              color: AppColors.mainblue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ]),
                                      ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                log('${pc.selectedProducts.length}');
                                // setState(() {});
                              },
                              child: const Text(
                                'Products',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.info,
                              size: 18,
                              color: Colors.black54,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Obx(() {
                          log(
                              "Selected Product List: ${pc.selectedProducts}");
                          if (pc.selectedProducts.isNotEmpty) {
                            return Visibility(
                              visible: pc.totalAmount.value > 0,
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 4),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: pc.selectedProducts.length,
                                        itemBuilder: (context, index) {
                                          var item = pc.selectedProducts[index];

                                          var taxWithPrice = (double.parse(
                                                  item.stock_price ?? '0.00')) +
                                              (double.parse(item.stock_price ??
                                                      '0.00') *
                                                  0.18);
                                          var tax = (item.selectedQty ?? 0.00) *
                                              (double.parse(item.stock_price ??
                                                      '0.00') *
                                                  0.18);

                                          totalPrice =
                                              (item.selectedQty ?? 0.00) *
                                                      double.parse(
                                                          item.stock_price ??
                                                              '0.00') +
                                                  ((item.selectedQty ?? 0.00) *
                                                      double.parse(
                                                          item.stock_price ??
                                                              '0.00') *
                                                      0.18);

                                          var netAmount = (item.selectedQty ??
                                                  0.00) *
                                              double.parse(
                                                  item.stock_price ?? '0.00');

                                          bool isDetailsExpanded =
                                              expandedDetailsIndices
                                                  .contains(index);
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                // Toggle details expansion on button press
                                                if (isDetailsExpanded) {
                                                  expandedDetailsIndices
                                                      .remove(index);
                                                } else {
                                                  expandedDetailsIndices
                                                      .add(index);
                                                }
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0),
                                                child: Column(
                                                  children: [
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          height: 30,
                                                          width: 30,
                                                          child: Obx(() {
                                                            final bool
                                                                showDescription =
                                                                pc.showDes
                                                                        .value[
                                                                    index];
                                                            return Checkbox(
                                                              value:
                                                                  showDescription,
                                                              onChanged: (val) {
                                                                pc.showDes.value[
                                                                        index] =
                                                                    val!;
                                                                pc.showDes
                                                                    .refresh();
                                                              },
                                                            );
                                                          }),
                                                        ),
                                                        const Text(
                                                          'Show Description',
                                                          style: TextStyle(
                                                              fontSize: 14),
                                                        )
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                            width: width * 0.5,
                                                            child: Text(
                                                              item.name ??
                                                                  'Null',
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          Text(
                                                            '₹ ${totalPrice.toStringAsFixed(2)}',
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    isDetailsExpanded
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 8.0,
                                                              vertical: 10,
                                                            ),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    const Text(
                                                                        'Price with Tax'),
                                                                    // Text(item
                                                                    //         .stock_price ??
                                                                    //     '')
                                                                    Text(taxWithPrice
                                                                        .toStringAsFixed(
                                                                            2))
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    const Text(
                                                                        'Quantity'),
                                                                    Text(item
                                                                        .selectedQty!
                                                                        .toStringAsFixed(
                                                                            2))
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    const Text(
                                                                        'Net Amount'),
                                                                    Text(netAmount
                                                                        .toStringAsFixed(
                                                                            2))
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    const Text(
                                                                        'Total Tax(18.0%)'),
                                                                    Text(tax
                                                                        .toStringAsFixed(
                                                                            2))
                                                                  ],
                                                                ),
                                                              ],
                                                            ))
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 5.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  ' x ${item.selectedQty}',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                                const Row(
                                                                  children: [
                                                                    Text(
                                                                      'Details',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              13,
                                                                          color: Colors
                                                                              .grey,
                                                                          fontWeight:
                                                                              FontWeight.w400),
                                                                    ),
                                                                    Icon(
                                                                      Icons
                                                                          .arrow_forward_ios,
                                                                      color: Colors
                                                                          .grey,
                                                                      size: 12,
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Obx(() {
                                                          // Use GetX to conditionally show the description
                                                          final bool
                                                              showDescription =
                                                              pc.showDes
                                                                  .value[index];
                                                          return showDescription
                                                              ? Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8.0,
                                                                      vertical:
                                                                          10),
                                                                  child: Text(
                                                                    item.description!,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                  ),
                                                                )
                                                              : const SizedBox(
                                                                  height: 20,
                                                                ); // Empty container if description should not be shown
                                                        }),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            // Call _showBottomSheet and wait for the returned value
                                                            resultValues =
                                                                await _showBottomSheet(
                                                              context,
                                                              item.name,
                                                              double.parse(item
                                                                      .stock_price!)
                                                                  .toStringAsFixed(
                                                                      2),
                                                              item.selectedQty!
                                                                  .toStringAsFixed(
                                                                      2),
                                                              taxWithPrice
                                                                  .toStringAsFixed(
                                                                      2),
                                                              item.description,
                                                            );
                                                            log(
                                                                'result values is : ${resultValues?.priceWTax}, ${resultValues?.selectedQty}, ${resultValues?.unitPrice}');

                                                            // Check if a value was selected
                                                            if (resultValues !=
                                                                null) {
                                                              item.selectedQty =
                                                                  resultValues!
                                                                      .selectedQty;
                                                              taxWithPrice =
                                                                  resultValues!
                                                                      .priceWTax!;
                                                              item.stock_price =
                                                                  resultValues!
                                                                      .unitPrice
                                                                      .toString();
                                                              log(
                                                                  'tax with price from card: $taxWithPrice');
                                                              // setState(() {});
                                                              // taxWithPrice =
                                                              //     1211.00;
                                                              // item.stock_price =
                                                              //     '1234';
                                                              pc.calculateTotalAmount();
                                                              log(
                                                                  "Selected Quantity: ${resultValues!.selectedQty}");
                                                              log(
                                                                  "Selected taxWithPrice: ${resultValues!.priceWTax}");
                                                              log(
                                                                  "Selected Quantity: ${resultValues!.unitPrice}");
                                                            }
                                                          },
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 5.0),
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Text(
                                                                'Edit',
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .mainblue,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                        height: 1,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.3))),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      // pc.selectedProducts.value = [];
                                      // Navigator.of(context).pop();
                                      await Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              SelectProductScreen(),
                                        ),
                                      );
                                    },
                                    child: SizedBox(
                                      width: width * 0.9,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.3),
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            ),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 6.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.add_circle,
                                                  color: Colors.black,
                                                  size: 12,
                                                ),
                                                Text(
                                                  'Add More Items',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return GestureDetector(
                              onTap: () {
                                if (customerController.selectedCustomer.value ==
                                    null) {
                                  Get.showSnackbar(GetSnackBar(
                                    title: 'Error',
                                    message: 'Please select a customer first',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red.shade400,
                                    duration:
                                        const Duration(milliseconds: 1000),
                                  ));
                                } else {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                              SelectProductScreen()));
                                }
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Row(
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Icon(
                                      Icons.add_circle,
                                      size: 18,
                                      color: AppColors.mainblue,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Add Products',
                                      style: TextStyle(
                                          color: AppColors.mainblue,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        }),
                        const SizedBox(
                          height: 15,
                        ),
                        const Row(
                          children: [
                            Text(
                              'Prescription details',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.info,
                              size: 18,
                              color: Colors.black54,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),

                        Obx(() => Container(
                              margin: const EdgeInsets.symmetric(vertical: 0),
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: DropdownButton<String>(
                                hint: Text(qc.detailLoading.value
                                    ? 'Fetching data...'
                                    : 'Select Prescription'),
                                value: qc.presId.isEmpty
                                    ? ''
                                    : qc.selectPresId.value,
                                isExpanded: true,
                                underline: const SizedBox(),
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    qc.selectPresId.value = newValue;
                                    qc.setSelectedCustomerPrescription();
                                    log("Hello123 ${qc.selectPresId.value}");
                                    log('${qc.selectedCustomerPrescription?.id}');
                                  }
                                },
                                items: qc.presId.map<DropdownMenuItem<String>>(
                                  (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  },
                                ).toList(),
                              ),
                            )),
                        // GestureDetector(
                        //   onTap: () {
                        //     Navigator.push(
                        //         context,
                        //         CupertinoPageRoute(
                        //             builder: (context) =>
                        //                 OpticalDetailScreen()));
                        //     // showModalBottomSheet(
                        //     //     context: context,
                        //     //     isScrollControlled: true,
                        //     //     backgroundColor: Colors.transparent,
                        //     //     builder: (context) => Padding(
                        //     //           padding: EdgeInsets.only(
                        //     //               bottom: MediaQuery.of(context)
                        //     //                   .viewInsets
                        //     //                   .bottom),
                        //     //           child: EyeDetailsBottomSheet(),
                        //     //         ));
                        //   },
                        //   child: Padding(
                        //     padding:
                        //         const EdgeInsets.only(left: 10, right: 10),
                        //     child: Container(
                        //       height: 30,
                        //       decoration: BoxDecoration(
                        //           color: Colors.grey.shade300,
                        //           borderRadius: BorderRadius.only(
                        //               topLeft: Radius.circular(0),
                        //               topRight: Radius.circular(0),
                        //               bottomLeft: Radius.circular(10),
                        //               bottomRight: Radius.circular(10))),
                        //       child: const Row(
                        //         children: [
                        //           SizedBox(
                        //             width: 12,
                        //           ),
                        //           Icon(
                        //             Icons.add_circle,
                        //             size: 16,
                        //             color: AppColors.mainblue,
                        //           ),
                        //           SizedBox(
                        //             width: 12,
                        //           ),
                        //           Text(
                        //             'Add Additional details',
                        //             style: TextStyle(
                        //                 fontSize: 13,
                        //                 color: AppColors.mainblue,
                        //                 fontWeight: FontWeight.w600),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(
                          height: 10,
                        ),
                        Obx(() {
                          return customerController.selectedCustomer.value !=
                                  null
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          qc.showPresDetials.value ? 10 : 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        qc.showPresDetials.value
                                            ? 'Hide Details'
                                            : 'See Details',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.mainblue,
                                            fontSize: 14),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          qc.showPresDetials.value =
                                              !qc.showPresDetials.value;
                                        },
                                        child: Icon(
                                          qc.showPresDetials.value
                                              ? Icons.remove_circle
                                              : Icons.add_circle,
                                          size: 18,
                                          color: AppColors.mainblue
                                              .withOpacity(0.8),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : const SizedBox();
                        }),

                        const SizedBox(
                          height: 5,
                        ),
                        Obx(() {
                          return qc.selectPresId.value != "Other"
                              ? qc.showPresDetials.value
                                  ? GetBuilder<CustomerController>(
                                      builder: (controller) {
                                      var selectedCustomer =
                                          controller.selectedCustomer.value;
                                      return Visibility(
                                        visible: selectedCustomer != null,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const EyeDetailsTable(
                                                  eye: 'Left',
                                                ),
                                                const EyeDetailsTable(
                                                  eye: 'Right',
                                                ),
                                                AdditionalDetailsTable()
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    })
                                  : const SizedBox()
                              : Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: isEyesSame,
                                            onChanged: (value) {
                                              qc.right_sph.value =
                                                  qc.left_sph.value;
                                              qc.right_cyl.value =
                                                  qc.left_cyl.value;
                                              qc.right_axis.value =
                                                  qc.left_axis.value;
                                              qc.right_vision.value =
                                                  qc.left_vision.value;
                                              setState(() {
                                                isEyesSame = value!;
                                              });
                                            },
                                          ),
                                          const Text('Both Eyes same?'),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: Text(
                                              !isEyesSame
                                                  ? 'Left Eye : '
                                                  : 'Eye : ',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 8),
                                            child: Table(
                                              // defaultColumnWidth: FixedColumnWidth(120.0),
                                              border: TableBorder.all(
                                                  color: Colors.black,
                                                  style: BorderStyle.solid,
                                                  width: 1,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),

                                              children: [
                                                const TableRow(children: [
                                                  Column(children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 3),
                                                      child: Text('Sph.',
                                                          style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                    )
                                                  ]),
                                                  Column(children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 3),
                                                      child: Text('Cyl.',
                                                          style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                    )
                                                  ]),
                                                  Column(children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 3),
                                                      child: Text('Axis',
                                                          style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                    )
                                                  ]),
                                                  Column(children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 3),
                                                      child: Text('Vision',
                                                          style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                    )
                                                  ]),
                                                ]),
                                                TableRow(children: [
                                                  Column(children: [
                                                    TextField(
                                                      textAlign:
                                                          TextAlign.center,
                                                      minLines: 1,
                                                      maxLines: 2,
                                                      style: const TextStyle(
                                                          fontSize: 14.0),
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText: 'Sph.',
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        5),
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                      onChanged: (val) {
                                                        qc.left_sph.value = val;
                                                      },
                                                    ),
                                                  ]),
                                                  Column(children: [
                                                    TextField(
                                                      textAlign:
                                                          TextAlign.center,
                                                      minLines: 1,
                                                      maxLines: 2,
                                                      style: const TextStyle(
                                                          fontSize: 14.0),
                                                      decoration:
                                                          const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              5),
                                                              hintText: 'Cyl.',
                                                              border:
                                                                  InputBorder
                                                                      .none),
                                                      onChanged: (val) {
                                                        qc.left_cyl.value = val;
                                                      },
                                                    ),
                                                  ]),
                                                  Column(children: [
                                                    TextField(
                                                      textAlign:
                                                          TextAlign.center,
                                                      minLines: 1,
                                                      maxLines: 2,
                                                      style: const TextStyle(
                                                          fontSize: 14.0),
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText: 'Axis',
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        5),
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                      onChanged: (val) {
                                                        qc.left_axis.value =
                                                            val;
                                                      },
                                                    ),
                                                  ]),
                                                  Column(children: [
                                                    TextField(
                                                      minLines: 1,
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontSize: 14.0),
                                                      decoration:
                                                          const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              5),
                                                              hintText:
                                                                  'Vision',
                                                              border:
                                                                  InputBorder
                                                                      .none),
                                                      onChanged: (val) {
                                                        qc.left_vision.value =
                                                            val;
                                                      },
                                                    ),
                                                  ]),
                                                ]),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Visibility(
                                            visible: !isEyesSame,
                                            child: const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 15),
                                              child: Text(
                                                'Right Eye : ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: !isEyesSame,
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 8),
                                              child: Table(
                                                // defaultColumnWidth: FixedColumnWidth(120.0),
                                                border: TableBorder.all(
                                                    color: Colors.black,
                                                    style: BorderStyle.solid,
                                                    width: 1,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),

                                                children: [
                                                  const TableRow(children: [
                                                    Column(children: [
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 3),
                                                        child: Text('Sph.',
                                                            style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                      )
                                                    ]),
                                                    Column(children: [
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 3),
                                                        child: Text('Cyl.',
                                                            style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                      )
                                                    ]),
                                                    Column(children: [
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 3),
                                                        child: Text('Axis',
                                                            style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                      )
                                                    ]),
                                                    Column(children: [
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 3),
                                                        child: Text('Vision',
                                                            style: TextStyle(
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                      )
                                                    ]),
                                                  ]),
                                                  TableRow(children: [
                                                    Column(children: [
                                                      TextField(
                                                        textAlign:
                                                            TextAlign.center,
                                                        minLines: 1,
                                                        maxLines: 2,
                                                        style: const TextStyle(
                                                            fontSize: 14.0),
                                                        decoration:
                                                            const InputDecoration(
                                                          hintText: 'Sph.',
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          5),
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                        onChanged: (val) {
                                                          qc.right_sph.value =
                                                              val;
                                                        },
                                                      ),
                                                    ]),
                                                    Column(children: [
                                                      TextField(
                                                        textAlign:
                                                            TextAlign.center,
                                                        minLines: 1,
                                                        maxLines: 2,
                                                        style: const TextStyle(
                                                            fontSize: 14.0),
                                                        decoration: const InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            5),
                                                            hintText: 'Cyl.',
                                                            border: InputBorder
                                                                .none),
                                                        onChanged: (val) {
                                                          qc.right_cyl.value =
                                                              val;
                                                        },
                                                      ),
                                                    ]),
                                                    Column(children: [
                                                      TextField(
                                                        textAlign:
                                                            TextAlign.center,
                                                        minLines: 1,
                                                        maxLines: 2,
                                                        style: const TextStyle(
                                                            fontSize: 14.0),
                                                        decoration:
                                                            const InputDecoration(
                                                          hintText: 'Axis',
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          5),
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                        onChanged: (val) {
                                                          qc.right_axis.value =
                                                              val;
                                                        },
                                                      ),
                                                    ]),
                                                    Column(children: [
                                                      TextField(
                                                        minLines: 1,
                                                        maxLines: 2,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: const TextStyle(
                                                            fontSize: 14.0),
                                                        decoration: const InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            5),
                                                            hintText: 'Vision',
                                                            border: InputBorder
                                                                .none),
                                                        onChanged: (val) {
                                                          qc.right_vision
                                                              .value = val;
                                                        },
                                                      ),
                                                    ]),
                                                  ]),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(left: 15),
                                            child: Text(
                                              'Additional Details: ',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 8),
                                            child: Table(
                                              // defaultColumnWidth: FixedColumnWidth(120.0),
                                              border: TableBorder.all(
                                                  color: Colors.black,
                                                  style: BorderStyle.solid,
                                                  width: 1,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),

                                              children: [
                                                const TableRow(children: [
                                                  Column(children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 3),
                                                      child: Text('Add.',
                                                          style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                    )
                                                  ]),
                                                  Column(children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 3),
                                                      child: Text('PD',
                                                          style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                    )
                                                  ]),
                                                  Column(children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 3),
                                                      child: Text('Optometrist',
                                                          style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                    )
                                                  ]),
                                                ]),
                                                TableRow(children: [
                                                  Column(children: [
                                                    TextField(
                                                      textAlign:
                                                          TextAlign.center,
                                                      minLines: 1,
                                                      maxLines: 2,
                                                      style: const TextStyle(
                                                          fontSize: 14.0),
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText: 'Add.',
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        5),
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                      onChanged: (val) {
                                                        qc.add.value = val;
                                                      },
                                                    ),
                                                  ]),
                                                  Column(children: [
                                                    TextField(
                                                      textAlign:
                                                          TextAlign.center,
                                                      minLines: 1,
                                                      maxLines: 2,
                                                      style: const TextStyle(
                                                          fontSize: 14.0),
                                                      decoration:
                                                          const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              5),
                                                              hintText: 'PD',
                                                              border:
                                                                  InputBorder
                                                                      .none),
                                                      onChanged: (val) {
                                                        qc.pd.value = val;
                                                      },
                                                    ),
                                                  ]),
                                                  Column(children: [
                                                    TextField(
                                                      textAlign:
                                                          TextAlign.center,
                                                      minLines: 1,
                                                      maxLines: 2,
                                                      style: const TextStyle(
                                                          fontSize: 14.0),
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText: 'Optometrist',
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        5),
                                                        border:
                                                            InputBorder.none,
                                                      ),
                                                      onChanged: (val) {
                                                        qc.optometrics.value =
                                                            val;
                                                      },
                                                    ),
                                                  ]),
                                                ]),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                        }),

                        const SizedBox(
                          height: 0,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Payment',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Obx(() {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 0),
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: DropdownButton<String>(
                              hint: Text(
                                'Select Payment',
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.8)),
                              ),
                              value: qc.fullOrAdvancePayment.value,
                              isExpanded: true,
                              underline: const SizedBox(),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black.withOpacity(0.6),
                              ),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  qc.fullOrAdvancePayment.value = newValue;
                                  selectedPaymentSettlement =
                                      fullOrAdvance.indexWhere((element) =>
                                              element == newValue) +
                                          1;
                                  log("Selected index (1-based): $selectedPaymentSettlement");
                                }
                              },
                              items:
                                  fullOrAdvance.map<DropdownMenuItem<String>>(
                                (String? value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value ?? '',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.7)),
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          );
                        }),
                        const SizedBox(height: 0),
                        Obx(() {
                          return qc.fullOrAdvancePayment.value ==
                                  'Advance Payment'
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Enter Advanced Amount',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                    ),
                                    qc.largeAdvancePayment.value
                                        ? const SizedBox(height: 3)
                                        : const SizedBox(),
                                    qc.largeAdvancePayment.value
                                        ? const Text(
                                            'Advance Amount cannot be greater than total amount',
                                            style: TextStyle(color: Colors.red),
                                          )
                                        : const SizedBox(),
                                    const SizedBox(height: 5),
                                    //TODO: Show error if Advance Payment is greater than total amount
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 3),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: TextField(
                                          onChanged: (val) {
                                            // cc.companyName.value = val;
                                            if (val == '') {
                                              val = '0.0';
                                            }
                                            if (val ==
                                                (pc.calculateamount() * 1.18)
                                                    .toStringAsFixed(2)) {
                                              qc.fullOrAdvancePayment.value =
                                                  "Full Payment";
                                            }
                                            // Convert val to double
                                            if (double.parse(val) >
                                                (pc.calculateamount() * 1.18)) {
                                              qc.largeAdvancePayment.value =
                                                  true;
                                            } else {
                                              qc.largeAdvancePayment.value =
                                                  false;
                                            }
                                            qc.advanceAmount.value =
                                                double.parse(val);
                                          },
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.all(10),
                                            hintText: "0",
                                            alignLabelWithHint: true,
                                            hintStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox();
                        }),
                        const SizedBox(
                          height: 10,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Discount If Any',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Obx(
                              () => Radio(
                                value: 1,
                                groupValue: qc.selectedRadio.value,
                                onChanged: qc.onRadioChanged,
                              ),
                            ),
                            const Text(
                              '%',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            // Optional spacing between options
                            Obx(
                              () => Radio(
                                value: 2,
                                groupValue: qc.selectedRadio.value,
                                onChanged: qc.onRadioChanged,
                              ),
                            ),
                            const Text(
                              '₹',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Obx(
                              () => Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextFormField(
                                  // controller: qc.selectedRadio.value == 1
                                  //     ? qc.percentageController
                                  //     : pc.amountController,
                                  // focusNode: amountFocusNode,
                                  onChanged: (value) {
                                    pc.percentage.value = 0.0;
                                    pc.amount.value = 0.0;
                                    if (qc.selectedRadio.value == 1) {
                                      if (value == '') {
                                        value = '0';
                                      }
                                      pc.percentage.value = double.parse(value);
                                      setState(() {});
                                    } else {
                                      if (value == '') {
                                        value = '0';
                                      }
                                      pc.amount.value = double.parse(value);
                                      setState(() {});
                                    }
                                    // log(priceWithTax);
                                  },
                                  decoration: InputDecoration(
                                    labelText: qc.selectedRadio.value == 1
                                        ? 'Percentage'
                                        : 'Amount',
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    // fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 10.0,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, left: 16),
                                  child: Obx(() {
                                    double balance;
                                    if (qc.fullOrAdvancePayment.value ==
                                        'Full Payment') {
                                      balance = 0;
                                    } else {
                                      if (pc.selectedProducts.isNotEmpty) {
                                        double totalAmount =
                                            pc.calculateamount() * 1.18;
                                        balance = totalAmount -
                                            qc.advanceAmount.value;
                                      } else {
                                        balance = 0.0;
                                      }
                                    }
                                    return Text(
                                      'Balance: ${balance.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black),
                                    );
                                  }))),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Payment Type',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Obx(
                          () => Container(
                            margin: const EdgeInsets.symmetric(vertical: 0),
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: DropdownButton<String>(
                              hint: const Text('Payment Type'),
                              value: qc.paymentType.value,
                              isExpanded: true,
                              underline: const SizedBox(),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black.withOpacity(0.6),
                              ),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  qc.paymentType.value = newValue;
                                  selectedPaymentType = paymentType.indexWhere(
                                          (element) => element == newValue) +
                                      1;
                                  log("Selected index: $selectedPaymentType");
                                }
                              },
                              items: paymentType.map<DropdownMenuItem<String>>(
                                (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 130,
                        ),
                      ],
                    ),
                    // ),
                  )
                ],
              ),
            ),
            Obx(() {
              if (pc.selectedProducts.isNotEmpty && pc.totalAmount > 0) {
                return Visibility(
                  visible: true,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(220, 220, 220, 1.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Visibility(
                                    visible: pc.subtotal.value != 0,
                                    child: Row(
                                      children: [
                                        const Text(
                                          "Subtotal",
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const Spacer(),
                                        Text(
                                          pc
                                              .calculateamount()
                                              .toStringAsFixed(2),
                                          // pc.subtotal.toStringAsFixed(2),
                                          style: const TextStyle(
                                              color: Colors.black45,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: pc.subtotal.value != 0,
                                    child: Row(
                                      children: [
                                        const Text(
                                          "CGST + IGST",
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const Spacer(),
                                        Text(
                                          (pc.calculateamount() * 0.18)
                                              .toStringAsFixed(2),
                                          style: const TextStyle(
                                              color: Colors.black45,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: pc.extraDiscount.value != "0.00" &&
                                        pc.extraDiscount.isNotEmpty,
                                    child: Row(
                                      children: [
                                        const Text(
                                          "Discount:",
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '₹ ${pc.extraDiscount.value}',
                                          style: const TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                        pc.shippingCharges.value != "0.00" &&
                                            pc.shippingCharges.isNotEmpty,
                                    child: Row(
                                      children: [
                                        const Text(
                                          "Delivery/Shipping Charges: ",
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '₹${pc.shippingCharges.value}',
                                          style: const TextStyle(
                                              color: Colors.black45,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                        pc.packagingCharges.value != "0.00" &&
                                            pc.packagingCharges.isNotEmpty,
                                    child: Row(
                                      children: [
                                        const Text(
                                          "Packaging Charges:",
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '₹${pc.packagingCharges.value}',
                                          style: const TextStyle(
                                              color: Colors.black45,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: pc.subtotal.value != 0,
                                    child: Row(
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              "Round Off",
                                              style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              width: 5.0,
                                            ),
                                            Transform.scale(
                                              scale: 0.8,
                                              child: FlutterSwitch(
                                                width: 55.0,
                                                height: 25.0,
                                                valueFontSize: 12.0,
                                                toggleSize: 18.0,
                                                showOnOff: true,
                                                activeTextColor:
                                                    AppColors.mainblue,
                                                inactiveTextColor: Colors.white,
                                                value:
                                                    pc.isRoundOffEnabled.value,
                                                activeColor: Colors.white,
                                                inactiveToggleColor:
                                                    Colors.white,
                                                activeToggleColor:
                                                    AppColors.mainblue,
                                                inactiveColor:
                                                    AppColors.mainblue,
                                                inactiveSwitchBorder:
                                                    Border.all(
                                                  color: AppColors.mainblue,
                                                  width: 1.0,
                                                ),
                                                onToggle: (val) {
                                                  pc.roundOffEnable(val);
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                        const Spacer(),
                                        const Text(
                                          "₹0.00",
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            })
          ],
        ),
        bottomNavigationBar: Container(
          height: 70,
          decoration: const BoxDecoration(color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                    Obx(() {
                      return Text(
                        '₹${(pc.calculateamount() * 1.18).toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      );
                    }),
                  ],
                ),
                ButtonBS(
                    title: 'Buy Now',
                    textColor: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    width: width * 0.38,
                    height: 42,
                    padding: 10.0,
                    backgroundColor: qc.largeAdvancePayment.value
                        ? Colors.grey
                        : AppColors.mainblue,
                    borderRadius: 12,
                    suffixIcon: Icons.arrow_forward_ios,
                    suffixIconColor: Colors.white,
                    suffixIconSize: 18,
                    prefixIconSize: 0,
                    separateSuffixIcon: 5,
                    onPressed: () async {
                      if (!qc.largeAdvancePayment.value) {
                        log('value is :- ${qc.paymentType.value.toString()}');
                        if (pc.totalAmount <= 0.0) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Please Select Products First'),
                            duration: Duration(milliseconds: 1000),
                          ));
                        } else {
                          qc.postData.value = true;
                          final prefs = await SharedPreferences.getInstance();
                          final id = prefs.getInt('userId');
                          final storeId = prefs.getInt('store_id');
                          // log('id from quotation ${store_id}');
                          PostResponseType res = await qc.postOrderPlace(
                              customerController.selectedCustomer.value?.id ??
                                  0,
                              id ?? 0,
                              // store_id ?? 0,
                              customerController
                                      .selectedCustomer.value?.store_id ??
                                  0,
                              pc.totalAmount.value,
                              pc.extraDiscount.value,
                              selectedPaymentType,
                              selectedPaymentSettlement,
                              qc.left_sph.value,
                              qc.left_cyl.value,
                              qc.left_axis.value,
                              qc.left_vision.value,
                              qc.right_sph.value,
                              qc.right_cyl.value,
                              qc.right_axis.value,
                              qc.right_vision.value,
                              qc.add.value,
                              qc.pd.value,
                              qc.optometrics.value);
                          qc.postData.value = false;
                          if (res.postResponseEnum ==
                              PostResponseEnum.success) {
                            Get.showSnackbar(const GetSnackBar(
                              title: 'Success',
                              message: 'Data posted successfully',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppColors.mainblue,
                              duration: Duration(milliseconds: 1000),
                            ));
                            log("Response Message: ${res.message}");
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => OrderDetailsPage(
                                  id: res.message,
                                  isOrderDetails: false,
                                ),
                              ),
                            );
                          } else {
                            log("Response Message: ${res.message}");
                            Get.snackbar('', 'An error has occurred');
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(
                            //         content: Text('An error has occurred')));
                          }
                        }
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<ReturnValuesBS?> _showBottomSheet(
      BuildContext context,
      // getProductDataModel item,
      String? productName,
      String? price,
      String? productQty,
      String? priceWithTax,
      String? productDes) async {
    Completer<ReturnValuesBS?> completer = Completer<ReturnValuesBS?>();
    pc.unitPriceController = TextEditingController(text: price);
    productQuantityController = TextEditingController(text: productQty);
    pc.priceWithTaxController = TextEditingController(text: priceWithTax);
    pc.amountController = TextEditingController(text: '0.00');
    pc.percentageController = TextEditingController(text: '0.0');
    description = TextEditingController(text: productDes);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 10.0, right: 10.0, bottom: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            productName ?? 'Null',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.clear),
                        )
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 10.0, right: 20.0, left: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Change Price',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Get.to(() => UpdateProduct(
                                //       updateData: ProductUpdateData(
                                //         productName: productName ?? 'Null',
                                //         sellingPrice: price ?? '0.00',
                                //       ),
                                //     ));
                              },
                              child: const Text(
                                'Edit',
                                style: TextStyle(
                                  color: AppColors.mainblue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: pc.unitPriceController,
                                  onChanged: pc.onUnitPriceChanged,
                                  decoration: const InputDecoration(
                                    labelText: 'Unit Price',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 10.0,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: pc.priceWithTaxController,
                                  onChanged: pc.onPWTChanged,
                                  decoration: const InputDecoration(
                                    labelText: 'Price with Tax',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      // Adjust the vertical padding
                                      horizontal:
                                          10.0, // Adjust the horizontal padding
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        const Text(
                          'Discount in',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Obx(
                              () => Radio(
                                value: 1,
                                groupValue: pc.selectedRadio.value,
                                onChanged: pc.onRadioChanged,
                              ),
                            ),
                            const Text(
                              '%',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            // Optional spacing between options
                            Obx(
                              () => Radio(
                                value: 2,
                                groupValue: pc.selectedRadio.value,
                                onChanged: pc.onRadioChanged,
                              ),
                            ),
                            const Text(
                              '₹',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Obx(
                              () => TextFormField(
                                controller: pc.selectedRadio.value == 1
                                    ? pc.percentageController
                                    : pc.amountController,
                                focusNode: amountFocusNode,
                                onChanged: (value) {
                                  if (pc.selectedRadio.value == 1) {
                                    if (value == '') {
                                      value = '0';
                                    }
                                    pc.onPercentDiscountChanged(
                                        value, priceWithTax ?? '0.0');
                                    pc.percentage.value = double.parse(value);
                                    setState(() {});
                                  } else {
                                    if (value == '') {
                                      value = '0';
                                    }
                                    pc.onAmountDiscountChanged(
                                        value, priceWithTax ?? '0.0');
                                    pc.amount.value = double.parse(value);
                                    setState(() {});
                                  }
                                  pc.amount.value = 0.0;
                                  pc.percentage.value = 0.0;
                                  // log(priceWithTax);
                                },
                                decoration: InputDecoration(
                                  labelText: pc.selectedRadio.value == 1
                                      ? 'Percentage'
                                      : 'Amount',
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 10.0,
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            Positioned(
                                right: 10.0,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 2.0,
                                      height: 40.0,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _showTotalAmountBottomSheet(context);
                                      },
                                      // Add your button press handler
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Obx(() {
                                            String buttonText = radioOptionText[
                                                pc.priceSelectedRadio.value -
                                                    1];
                                            return Text(
                                              buttonText,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            );
                                          }),
                                          const Icon(Icons.arrow_drop_down),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        const Text(
                          'Change Quantities & Units',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            TextFormField(
                              controller: productQuantityController,
                              onChanged: pc.onQtyChanged,
                              decoration: const InputDecoration(
                                labelText: 'Product Quantity',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 10.0,
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            Positioned(
                                right: 10.0,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 2.0,
                                      height: 40.0,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      // Add your button press handler
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            'OTH',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        const Text(
                          'Product Description',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Stack(
                          children: [
                            TextFormField(
                              controller: description,
                              decoration: const InputDecoration(
                                labelText: 'Product Description',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 10.0,
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                            ),
                            Positioned.fill(
                              child: InkWell(
                                onTap: () {
                                  productDesBottomSheet(context, productDes);
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 70,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Total Amount',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Obx(() {
                                    log('total amout is: ${pc.totalAmount}');

                                    totalValue = (double.tryParse(pc.qtyInputValue.value) ==
                                            double.tryParse(
                                                productQuantityController.text)
                                        ? pc.qtyInputValue.value
                                        : ((double.tryParse(productQuantityController.text) ??
                                                    0.00) *
                                                ((pc.priceWithTaxController
                                                            .text ==
                                                        pc.pwtInputValue.value)
                                                    ? double.tryParse(pc
                                                            .pwtInputValue
                                                            .value) ??
                                                        0.00
                                                    : double.tryParse(
                                                            pc.priceWithTaxController
                                                                    .text ??
                                                                "0.00") ??
                                                        0.00))
                                            .toStringAsFixed(2));
                                    totalValue = (pc.calculateamount() * 1.18).toString();

                                    log(totalValue);
                                    // totalValue = 2.2;
                                    return Text(
                                      '₹$totalValue',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    );
                                  }),
                                ],
                              ),
                              ButtonBS(
                                title: 'Continue',
                                textColor: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                padding: 10.0,
                                // width: width * 0.28,
                                height: 42,
                                backgroundColor: AppColors.mainblue,
                                borderRadius: 12,
                                suffixIcon: Icons.arrow_forward_ios,
                                suffixIconColor: Colors.white,
                                suffixIconSize: 18,
                                prefixIconSize: 0,
                                separateSuffixIcon: 5,
                                onPressed: () {
                                  if (pc.totalAmount <= 0.0) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content:
                                          Text('Please Select Products First'),
                                      duration: Duration(milliseconds: 1000),
                                    ));
                                  } else {
                                    selectedQty = double.tryParse(
                                        productQuantityController.text);
                                    unitPrice = double.tryParse(
                                        pc.unitPriceController.text);
                                    priceWTax = double.tryParse(
                                        pc.priceWithTaxController.text);
                                    // priceWTax = double.tryParse(
                                    //     pc.priceWithTaxController.text);
                                    // pc.selectedProducts[index]
                                    log(
                                        'current price with tax is: ${pc.priceWithTaxController.text}');
                                    // Complete the completer with the selected values
                                    // if (pc.selectedRadio.value == 1) {
                                    //   item.stock_price = (double.parse(
                                    //               priceWithTax ?? '0.00') -
                                    //           double.parse(
                                    //                   priceWithTax ?? '0.00') *
                                    //               double.parse(
                                    //                   percentageController
                                    //                       .text) /
                                    //               100)
                                    //       .toString();
                                    // } else {
                                    //   priceWithTax = (double.parse(
                                    //               priceWithTax ?? '0.00') -
                                    //           double.parse(
                                    //               amountController.text))
                                    //       .toString();
                                    // }
                                    // priceWTax = 2.2;
                                    log(
                                        'price with tax updated is : $priceWTax');
                                    completer.complete(ReturnValuesBS(
                                      selectedQty: selectedQty,
                                      unitPrice: unitPrice,
                                      priceWTax: priceWTax,
                                      // discountPWT:
                                    ));
                                    // log()
                                    Navigator.pop(context);
                                  }
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    // Return the Future to be awaited
    return completer.future;
  }

  void _showTotalAmountBottomSheet(BuildContext context) {
    pc.priceSelectedRadio.value = radioOptionText.length;
    showModalBottomSheet(
      isScrollControlled: true,
      // Set to true to make the bottom sheet full screen
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min, // Set to MainAxisSize.min
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, left: 10.0, right: 10.0, bottom: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Discount Type',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.clear),
                  )
                ],
              ),
            ),
            const Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: radioOptionText.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          _buildRadio(index),
                          const SizedBox(height: 5.0),
                        ],
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildRadio(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Obx(
          () => Radio(
            value: index + 1,
            groupValue: pc.priceSelectedRadio.value,
            onChanged: (int? value) {
              pc.onPriceRadioChanged(value!);
              Navigator.pop(context); // Close the bottom sheet after selection
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                FocusScope.of(context).requestFocus(amountFocusNode);
              });
            },
          ),
        ),
        Text(
          radioOptionText[index],
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void productDesBottomSheet(BuildContext context, String? proDescription) {
    Navigator.of(context).pop(); // Close the current bottom sheet

    description = TextEditingController(text: proDescription);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SizedBox(
                  width: double.maxFinite,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: const Text(
                            'Product Description',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (int index = 0;
                                  index < stylingIcons.length;
                                  index++)
                                GestureDetector(
                                  onTap: () {},
                                  child: Column(
                                    children: [
                                      Icon(stylingIcons[index]),
                                      const SizedBox(height: 10.0),
                                      Text(stylingTitles[index]),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Stack(
                          children: [
                            Flexible(
                              child: TextFormField(
                                controller: description,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                maxLines:
                                    15, // Set maxLines to null for multiline editing
                              ),
                            ),
                            Positioned(
                              right: 16.0,
                              bottom: 16.0,
                              child: FloatingActionButton(
                                onPressed: () {},
                                foregroundColor: Colors.white,
                                backgroundColor: AppColors.mainblue,
                                shape: const CircleBorder(),
                                child: const Icon(Icons.check),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
