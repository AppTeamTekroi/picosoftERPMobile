import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_erp/constants/sized_box_utils.dart';
import 'package:mobile_erp/core/enum/post_enum_response.dart';
import 'package:mobile_erp/features/Quotation/controller/quotation_controller.dart';
import 'package:mobile_erp/features/Quotation/presentation/pages/pdfview.dart';
import 'package:mobile_erp/features/Quotation/presentation/widget/additionalTable.dart';
import 'package:mobile_erp/features/Quotation/presentation/widget/eyeTable.dart';
import 'package:mobile_erp/features/Quotation/presentation/widget/return_values_bs.dart';
import 'package:mobile_erp/features/orders/controller/OrderListController.dart';
import 'package:mobile_erp/ui/horizonatal_divider.dart';
import 'package:mobile_erp/ui/item_details.dart';
import 'package:mobile_erp/ui/options_button.dart';
import 'package:mobile_erp/utils/utils.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../ui/color/appColor.dart';
import '../../../Quotation/presentation/widget/thermalPrintDialog.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage(
      {super.key, required this.id, required this.isOrderDetails});

  final String id;
  final bool isOrderDetails;

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  QuotationController qc = Get.put(QuotationController());
  OrderPlacedController oc = Get.put(OrderPlacedController());
  Set<int> expandedDetailsIndices = {};
  String date = "";
  late double totalPrice;
  late ReturnValuesBS? resultValues;

  void _showInvoicePopUp(
      BuildContext context, String invoiceNumber, String link) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  link,
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 20),
                IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: link));
                      Navigator.of(context).pop();
                      Get.snackbar('Success', 'Link copied to clipboard');
                    },
                    icon: const Icon(
                      Icons.copy,
                      color: Colors.black,
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  PostResponseType _showRecordPaymentPopUp() {
    PostResponseType returnValue =
        PostResponseType(postResponseEnum: PostResponseEnum.alreadyAdded);
    final TextEditingController amountController = TextEditingController();

    // Get.defaultDialog(
    //   title: 'Payment Details',
    //   content: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Column(
    //       children: <Widget>[
    //         TextField(
    //           controller: amountController,
    //           keyboardType: TextInputType.number,
    //           decoration: const InputDecoration(
    //             labelText: 'Amount',
    //           ),
    //           onChanged: (value) {
    //             oc.record_payment_amout.value = double.parse(value);
    //           },
    //         ),
    //         SizedBoxUtils.height10,
    //         DropdownButtonFormField<String>(
    //           value: oc.record_payment_type.value,
    //           items: ['UPI', 'Cash', 'Card'].map((String type) {
    //             return DropdownMenuItem<String>(
    //               value: type,
    //               child: Text(type),
    //             );
    //           }).toList(),
    //           decoration: const InputDecoration(
    //             labelText: 'Payment Type',
    //           ),
    //           onChanged: (newValue) {
    //             oc.record_payment_type.value = newValue!;
    //           },
    //         ),
    //         SizedBoxUtils.height10,
    //         DropdownButtonFormField<String>(
    //           value: oc.record_payment_settlement.value,
    //           items:
    //               ['Full Payment', 'Advance Payment'].map((String settlement) {
    //             return DropdownMenuItem<String>(
    //               value: settlement,
    //               child: Text(settlement),
    //             );
    //           }).toList(),
    //           decoration: const InputDecoration(
    //             labelText: 'Payment Settlement',
    //           ),
    //           onChanged: (newValue) {
    //             oc.record_payment_settlement.value = newValue!;
    //           },
    //         )
    //       ],
    //     ),
    //   ),
    //   textCancel: 'Cancel',
    //   onCancel: () => Get.back(),
    //   buttonColor: AppColors.mainblue,
    //   textConfirm: 'Proceed',
    //   onConfirm: () async {
    //     returnValue = await oc.recordPayment(widget.id);
    //     Get.back();
    //   },
    // );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Payment Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBoxUtils.height15,
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                  ),
                  onChanged: (value) {
                    oc.record_payment_amout.value = double.parse(value);
                  },
                ),
                SizedBoxUtils.height15,
                DropdownButtonFormField<String>(
                  value: oc.record_payment_type.value,
                  items: ['UPI', 'Cash', 'Card'].map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Payment Type',
                  ),
                  onChanged: (newValue) {
                    oc.record_payment_type.value = newValue!;
                  },
                ),
                SizedBoxUtils.height15,
                DropdownButtonFormField<String>(
                  value: oc.record_payment_settlement.value,
                  items: ['Full Payment', 'Advance Payment']
                      .map((String settlement) {
                    return DropdownMenuItem<String>(
                      value: settlement,
                      child: Text(settlement),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Payment Settlement',
                  ),
                  onChanged: (newValue) {
                    oc.record_payment_settlement.value = newValue!;
                  },
                ),
                SizedBoxUtils.height15,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainblue,
                          foregroundColor: AppColors.white),
                      onPressed: () async {
                        returnValue = await oc.recordPayment(widget.id);
                        Get.back();
                      },
                      child: const Text('Proceed'),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
    return returnValue;
  }

  void invoiceGenerationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Dialog(
          surfaceTintColor: AppColors.white,
          backgroundColor: AppColors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Invoice Generation',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                SizedBoxUtils.height20,
                const Text('Full amount is required to generate the invoice.',
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 18)),
                SizedBoxUtils.height20,
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('OK',
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    oc.getOrderDetails(widget.id).then((value) => {
          if (value.postResponseEnum == PostResponseEnum.success)
            {
              oc.successfulFetch.value = true,
              date = Utils.convertDateFormat(oc.order.value.updatedAt != null
                  ? oc.order.value.updatedAt!
                  : oc.order.value.createdAt!)
            }
          else
            {oc.successfulFetch.value = false}
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQuery.sizeOf(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          leading: GestureDetector(
            onTap: () {
              if (widget.isOrderDetails == true) {
                Get.back();
              } else {
                Get.back();
                Get.back();
              }
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Icon(Icons.arrow_back),
            ),
          ),
        ),
        body: Obx(() {
          return oc.orderDetailFetching.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : oc.successfulFetch.value
                  ? Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 10),
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBoxUtils.height10,
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Customer Details',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black),
                                  ),
                                ),
                                SizedBoxUtils.height15,
                                GetBuilder<OrderPlacedController>(
                                  builder: (oc) => Container(
                                    // height: 100,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0, right: 15.0, top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Name',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            oc.order.value.customer?.name ?? '',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0.0, 12.0, 0.0, 0.0),
                                            child: Text(
                                              "Phone Number",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0.0, 0.0, 0.0, 10.0),
                                            child: Text(
                                              oc.order.value.customer?.phone ??
                                                  '',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBoxUtils.height15,
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Products Details',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        ' (${oc.order.value.orderItems?.length} Product)',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color:
                                                Colors.grey.withOpacity(0.6)),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBoxUtils.height15,
                                Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: oc.order.value.orderItems
                                                  ?.length ??
                                              0,
                                          itemBuilder: (context, index) {
                                            var item = oc
                                                .order.value.orderItems?[index];

                                            var taxWithPrice = (double.parse(
                                                    item!.product?.stockPrice ??
                                                        '0.00')) +
                                                (double.parse(item.product
                                                            ?.stockPrice ??
                                                        '0.00') *
                                                    0.18);
                                            var tax =
                                                (item.quantities ?? 0.00) *
                                                    (double.parse(item.product
                                                                ?.stockPrice ??
                                                            '0.00') *
                                                        0.18);

                                            totalPrice = (item.quantities ??
                                                        0.00) *
                                                    double.parse(item.product
                                                            ?.stockPrice ??
                                                        '0.00') +
                                                ((item.quantities ?? 0.00) *
                                                    double.parse(item.product
                                                            ?.stockPrice ??
                                                        '0.00') *
                                                    0.18);

                                            var netAmount = (item.quantities ??
                                                    0.00) *
                                                double.parse(
                                                    item.product?.stockPrice ??
                                                        '0.00');

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
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15.0),
                                                  child: Column(
                                                    children: [
                                                      SizedBoxUtils.height10,
                                                      // Row(
                                                      //   children: [
                                                      //     SizedBox(
                                                      //       height: 30,
                                                      //       width: 30,
                                                      //       child: Obx(() {
                                                      //         // final bool showDescription =
                                                      //         //     boolList[index];
                                                      //         bool
                                                      //             showDescription =
                                                      //             oc.boolList[
                                                      //                 index];
                                                      //         return Checkbox(
                                                      //           value:
                                                      //               showDescription,
                                                      //           onChanged:
                                                      //               (val) {
                                                      //             oc.boolList[
                                                      //                     index] =
                                                      //                 val!;
                                                      //             // setState(() {
                                                      //             //   boolList[index] =
                                                      //             //       val!;
                                                      //             // });
                                                      //           },
                                                      //         );
                                                      //       }),
                                                      //     ),
                                                      //     const Text(
                                                      //       'Show Description',
                                                      //       style: TextStyle(
                                                      //           fontSize: 14),
                                                      //     )
                                                      //   ],
                                                      // ),
                                                      ItemDetails(
                                                        title: item.product
                                                                ?.name ??
                                                            'Null',
                                                        value: totalPrice
                                                            .toString(),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      isDetailsExpanded
                                                          ? Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                ItemDetails(
                                                                    title:
                                                                        'Price with Tax',
                                                                    value: taxWithPrice
                                                                        .toStringAsFixed(
                                                                            2)),
                                                                ItemDetails(
                                                                    title:
                                                                        'Quantity',
                                                                    value: item
                                                                        .quantities!
                                                                        .toStringAsFixed(
                                                                            2)),
                                                                ItemDetails(
                                                                    title:
                                                                        'Net Amount',
                                                                    value: netAmount
                                                                        .toStringAsFixed(
                                                                            2)),
                                                                ItemDetails(
                                                                    title:
                                                                        'Total Tax(18.0%)',
                                                                    value: tax
                                                                        .toStringAsFixed(
                                                                            2)),
                                                              ],
                                                            )
                                                          : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          5.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    ' x ${item.quantities}',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                  const Row(
                                                                    children: [
                                                                      Text(
                                                                        'Details',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            color:
                                                                                Colors.grey,
                                                                            fontWeight: FontWeight.w400),
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .arrow_forward_ios,
                                                                        color: Colors
                                                                            .grey,
                                                                        size:
                                                                            12,
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
                                                            bool
                                                                showDescription =
                                                                oc.boolList[
                                                                    index];
                                                            // final bool showDescription =
                                                            //     boolList[index];
                                                            return showDescription
                                                                ? Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            8.0,
                                                                        vertical:
                                                                            10),
                                                                    child: Text(
                                                                      item.product
                                                                              ?.description ??
                                                                          '0',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.w400),
                                                                    ))
                                                                : SizedBoxUtils
                                                                    .height20;
                                                          }),
                                                        ],
                                                      ),
                                                      const HorizontalDivider(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                                SizedBoxUtils.height15,
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Payment Details',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                      SizedBoxUtils.width4,
                                      Text(
                                        ' (${oc.order.value.orderPayments?.length} Payment)',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color:
                                                Colors.grey.withOpacity(0.6)),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBoxUtils.height15,
                                Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: oc.order.value
                                                      .orderPayments?.length ??
                                                  0,
                                              itemBuilder: (context, index) {
                                                var item = oc.order.value
                                                    .orderPayments?[index];
                                                log('item json is  ------------------- ${item!.toJson()}');
                                                var paidAmount =
                                                    item.paidAmount ?? 0.0;
                                                var paymentDate = item
                                                            .createdAt ==
                                                        null
                                                    ? ''
                                                    : Utils.convertDateFormat(
                                                        item.createdAt!);
                                                var paymentTime = item
                                                            .createdAt ==
                                                        null
                                                    ? ''
                                                    : Utils.convertTimeFormat(
                                                        item.createdAt!);
                                                return Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15.0),
                                                    child: Column(
                                                      children: [
                                                        SizedBoxUtils.height10,
                                                        Padding(
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
                                                                "Payment ${index + 1}",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              Text(
                                                                '₹ $paidAmount',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
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
                                                                        'Payment Method'),
                                                                    Text(
                                                                        item.paymentType ??
                                                                            '')
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    const Text(
                                                                        'Date'),
                                                                    Text(
                                                                        paymentDate)
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    const Text(
                                                                        'Time'),
                                                                    Text(
                                                                        paymentTime)
                                                                  ],
                                                                ),
                                                              ],
                                                            )),
                                                        const HorizontalDivider()
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 15.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  "Total Payment",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  '₹ ${oc.order.value.paidAmount ?? '0'}',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBoxUtils.height15,
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Prescription Details',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black),
                                  ),
                                ),
                                SizedBoxUtils.height15,
                                Container(
                                  // height: 100,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0, top: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Prescription Number',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          oc.order.value.prescriptionId
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              0.0, 12.0, 0.0, 0.0),
                                          child: Text(
                                            "Prescription",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0.0, 0.0, 0.0, 10.0),
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
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBoxUtils.height15,
                                SizedBoxUtils.height10,
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    '',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Add the DraggableScrollableSheet as a bottom sheet
                        // NotificationListener<DraggableScrollableNotification>(
                        //   onNotification: (notification) {
                        //     qc.sheetHeight.value =
                        //         200.0 - notification.extent * 200.0;
                        //     return true;
                        //   },
                        //   child: DraggableScrollableSheet(
                        //     initialChildSize: 95 / size.height,
                        //     minChildSize: 95 / size.height,
                        //     maxChildSize: size.height * 0.7 / size.height,
                        //     builder: (BuildContext context,
                        //         ScrollController scrollController) {
                        //       return Obx(() => Container(
                        //             decoration: BoxDecoration(
                        //               color: qc.sheetHeight.value < 165 &&
                        //                       qc.sheetHeight.value != 100.0
                        //                   ? AppColors.primary
                        //                   : Colors.white,
                        //               borderRadius: const BorderRadius.only(
                        //                 topLeft: Radius.circular(20),
                        //                 topRight: Radius.circular(20),
                        //               ),
                        //             ),
                        //             child: SingleChildScrollView(
                        //               controller: scrollController,
                        //               child: Column(
                        //                 crossAxisAlignment:
                        //                     CrossAxisAlignment.start,
                        //                 mainAxisSize: MainAxisSize.min,
                        //                 children: [
                        //                   Center(
                        //                     child: Container(
                        //                       width: 80,
                        //                       height: 5,
                        //                       margin:
                        //                           const EdgeInsets.symmetric(
                        //                               vertical: 10),
                        //                       decoration: BoxDecoration(
                        //                         color: Colors.grey,
                        //                         borderRadius:
                        //                             BorderRadius.circular(5),
                        //                       ),
                        //                     ),
                        //                   ),
                        //                   SizedBoxUtils.height10,
                        //                   Padding(
                        //                     padding: const EdgeInsets.symmetric(
                        //                         horizontal: 20.0),
                        //                     child: SingleChildScrollView(
                        //                       scrollDirection: Axis.horizontal,
                        //                       physics:
                        //                           const BouncingScrollPhysics(),
                        //                       child: Row(
                        //                         children: [
                        //                           InkWell(
                        //                             onTap: () {
                        //                               Navigator.push(
                        //                                 context,
                        //                                 MaterialPageRoute(
                        //                                     builder: (context) =>
                        //                                         const pdfview()),
                        //                               );
                        //                             },
                        //                             child: Container(
                        //                               height: 40,
                        //                               decoration: BoxDecoration(
                        //                                   color: Colors
                        //                                       .blueAccent
                        //                                       .withOpacity(
                        //                                           0.16),
                        //                                   borderRadius:
                        //                                       BorderRadius
                        //                                           .circular(
                        //                                               20)),
                        //                               child: Padding(
                        //                                 padding:
                        //                                     const EdgeInsets
                        //                                         .symmetric(
                        //                                         horizontal:
                        //                                             8.0),
                        //                                 child: Row(
                        //                                   children: [
                        //                                     const Icon(
                        //                                       Icons
                        //                                           .picture_as_pdf_outlined,
                        //                                       color: Colors
                        //                                           .blueAccent,
                        //                                       size: 17,
                        //                                     ),
                        //                                     SizedBoxUtils
                        //                                         .width3,
                        //                                     const Text(
                        //                                       'View PDF',
                        //                                       style: TextStyle(
                        //                                           fontWeight:
                        //                                               FontWeight
                        //                                                   .w600,
                        //                                           fontSize: 12),
                        //                                     )
                        //                                   ],
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                           ),
                        //                           //TODO: Solve Pop screen issue in cancel button
                        //                           widget.isOrderDetails
                        //                               ? SizedBoxUtils.width8
                        //                               : Container(),
                        //                           widget.isOrderDetails
                        //                               ? GestureDetector(
                        //                                   onTap: () async {
                        //                                     PostResponseType
                        //                                         res = await oc
                        //                                             .cancelOrder(
                        //                                                 widget
                        //                                                     .id);
                        //                                     if (res.postResponseEnum ==
                        //                                         PostResponseEnum
                        //                                             .success) {
                        //                                       Get.back();
                        //                                     } else {
                        //                                       Get.snackbar(
                        //                                           'Error',
                        //                                           res.message);
                        //                                     }
                        //                                   },
                        //                                   child: Container(
                        //                                     height: 40,
                        //                                     decoration: BoxDecoration(
                        //                                         color: Colors
                        //                                             .blueAccent
                        //                                             .withOpacity(
                        //                                                 0.16),
                        //                                         borderRadius:
                        //                                             BorderRadius
                        //                                                 .circular(
                        //                                                     20)),
                        //                                     child: Padding(
                        //                                       padding:
                        //                                           const EdgeInsets
                        //                                               .symmetric(
                        //                                               horizontal:
                        //                                                   8.0),
                        //                                       child: Row(
                        //                                         children: [
                        //                                           const Icon(
                        //                                             Icons
                        //                                                 .cancel,
                        //                                             color: Colors
                        //                                                 .blueAccent,
                        //                                             size: 17,
                        //                                           ),
                        //                                           SizedBoxUtils
                        //                                               .width3,
                        //                                           const Text(
                        //                                             'Cancel Order',
                        //                                             style: TextStyle(
                        //                                                 fontWeight:
                        //                                                     FontWeight
                        //                                                         .w600,
                        //                                                 fontSize:
                        //                                                     12),
                        //                                           )
                        //                                         ],
                        //                                       ),
                        //                                     ),
                        //                                   ),
                        //                                 )
                        //                               : Container(),
                        //                           SizedBoxUtils.width8,
                        //                           InkWell(
                        //                             onTap: () async {
                        //                               //TODO: Add Record Payment
                        //                               // PostResponseType res = await oc.recordPayment(widget.id, 100.0, "1", "2");
                        //                               PostResponseType
                        //                                   response =
                        //                                   _showRecordPaymentPopUp(
                        //                                       context);
                        //                             },
                        //                             child: Container(
                        //                               height: 40,
                        //                               decoration: BoxDecoration(
                        //                                   color: Colors
                        //                                       .blueAccent
                        //                                       .withOpacity(
                        //                                           0.16),
                        //                                   borderRadius:
                        //                                       BorderRadius
                        //                                           .circular(
                        //                                               20)),
                        //                               child: const Padding(
                        //                                 padding: EdgeInsets
                        //                                     .symmetric(
                        //                                         horizontal:
                        //                                             8.0),
                        //                                 child: Row(
                        //                                   children: [
                        //                                     Icon(
                        //                                       Icons
                        //                                           .attach_money,
                        //                                       color: Colors
                        //                                           .blueAccent,
                        //                                       size: 17,
                        //                                     ),
                        //                                     SizedBox(
                        //                                       width: 3,
                        //                                     ),
                        //                                     Text(
                        //                                       'Record Payment',
                        //                                       style: TextStyle(
                        //                                           fontWeight:
                        //                                               FontWeight
                        //                                                   .w600,
                        //                                           fontSize: 12),
                        //                                     )
                        //                                   ],
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                           ),
                        //                           SizedBoxUtils.width8,
                        //                           InkWell(
                        //                             onTap: () {
                        //                               showDialog(
                        //                                 context: context,
                        //                                 builder: (BuildContext
                        //                                     context) {
                        //                                   return ThermalPrintDialog();
                        //                                 },
                        //                               );
                        //                             },
                        //                             child: Container(
                        //                               height: 40,
                        //                               decoration: BoxDecoration(
                        //                                   color: Colors
                        //                                       .blueAccent
                        //                                       .withOpacity(
                        //                                           0.16),
                        //                                   borderRadius:
                        //                                       BorderRadius
                        //                                           .circular(
                        //                                               20)),
                        //                               child: Padding(
                        //                                 padding:
                        //                                     const EdgeInsets
                        //                                         .symmetric(
                        //                                         horizontal:
                        //                                             8.0),
                        //                                 child: Row(
                        //                                   children: [
                        //                                     const Icon(
                        //                                       Icons
                        //                                           .note_outlined,
                        //                                       color: Colors
                        //                                           .blueAccent,
                        //                                       size: 17,
                        //                                     ),
                        //                                     SizedBoxUtils
                        //                                         .width3,
                        //                                     const Text(
                        //                                       'Print',
                        //                                       style: TextStyle(
                        //                                           fontWeight:
                        //                                               FontWeight
                        //                                                   .w600,
                        //                                           fontSize: 12),
                        //                                     )
                        //                                   ],
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                           ),
                        //                           SizedBoxUtils.width8,
                        //                           GestureDetector(
                        //                             onTap: () async {
                        //                               await Share.share(
                        //                                   'Check out this order details from Mobile ERP App \n \n ${qc.currentorderpdf.value}');
                        //                             },
                        //                             child: Container(
                        //                               height: 40,
                        //                               decoration: BoxDecoration(
                        //                                   color: Colors
                        //                                       .blueAccent
                        //                                       .withOpacity(
                        //                                           0.16),
                        //                                   borderRadius:
                        //                                       BorderRadius
                        //                                           .circular(
                        //                                               20)),
                        //                               child: Padding(
                        //                                 padding:
                        //                                     const EdgeInsets
                        //                                         .symmetric(
                        //                                         horizontal:
                        //                                             8.0),
                        //                                 child: Row(
                        //                                   children: [
                        //                                     const Icon(
                        //                                       Icons.send,
                        //                                       color: Colors
                        //                                           .blueAccent,
                        //                                       size: 17,
                        //                                     ),
                        //                                     SizedBoxUtils
                        //                                         .width3,
                        //                                     const Text(
                        //                                       'Send Bill',
                        //                                       style: TextStyle(
                        //                                           fontWeight:
                        //                                               FontWeight
                        //                                                   .w600,
                        //                                           fontSize: 12),
                        //                                     )
                        //                                   ],
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                           ),
                        //                           SizedBoxUtils.width6,
                        //                           GestureDetector(
                        //                             onTap: () async {
                        //                               PostResponseType res =
                        //                                   await oc
                        //                                       .createInvoice(
                        //                                           widget.id);
                        //                               if (res.postResponseEnum ==
                        //                                   PostResponseEnum
                        //                                       .success) {
                        //                                 final data = jsonDecode(
                        //                                     res.message);
                        //                                 _showInvoicePopUp(
                        //                                     context,
                        //                                     data[
                        //                                         "invoice_number"],
                        //                                     data["link"]);
                        //                               } else {
                        //                                 Get.snackbar('Error',
                        //                                     res.message);
                        //                               }
                        //                             },
                        //                             child: Container(
                        //                               height: 40,
                        //                               decoration: BoxDecoration(
                        //                                   color: Colors
                        //                                       .blueAccent
                        //                                       .withOpacity(
                        //                                           0.16),
                        //                                   borderRadius:
                        //                                       BorderRadius
                        //                                           .circular(
                        //                                               20)),
                        //                               child: Padding(
                        //                                 padding:
                        //                                     const EdgeInsets
                        //                                         .symmetric(
                        //                                         horizontal:
                        //                                             8.0),
                        //                                 child: Row(
                        //                                   children: [
                        //                                     const Icon(
                        //                                       Icons
                        //                                           .change_circle_outlined,
                        //                                       color: Colors
                        //                                           .blueAccent,
                        //                                       size: 17,
                        //                                     ),
                        //                                     SizedBoxUtils
                        //                                         .width3,
                        //                                     const Text(
                        //                                       'Generate Invoice',
                        //                                       style: TextStyle(
                        //                                           fontWeight:
                        //                                               FontWeight
                        //                                                   .w600,
                        //                                           fontSize: 12),
                        //                                     )
                        //                                   ],
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                           )
                        //                         ],
                        //                       ),
                        //                     ),
                        //                   )
                        //                   // Obx(() {
                        //                   //   return
                        //                   //     // qc.sheetHeight.value < 165 &&
                        //                   //       //       qc.sheetHeight.value !=
                        //                   //       //           100.0
                        //                   //       //   ? Padding(
                        //                   //       //       padding: const EdgeInsets
                        //                   //       //           .symmetric(
                        //                   //       //           horizontal: 20.0),
                        //                   //       //       child:
                        //                   //       //           SingleChildScrollView(
                        //                   //       //         scrollDirection:
                        //                   //       //             Axis.horizontal,
                        //                   //       //         physics:
                        //                   //       //             const BouncingScrollPhysics(),
                        //                   //       //         child: Row(
                        //                   //       //           children: [
                        //                   //       //             Container(
                        //                   //       //               height: 80,
                        //                   //       //               width: 80,
                        //                   //       //               decoration: BoxDecoration(
                        //                   //       //                   color: Colors
                        //                   //       //                       .white,
                        //                   //       //                   borderRadius:
                        //                   //       //                       BorderRadius
                        //                   //       //                           .circular(
                        //                   //       //                               20)),
                        //                   //       //               child: Padding(
                        //                   //       //                 padding:
                        //                   //       //                     const EdgeInsets
                        //                   //       //                         .symmetric(
                        //                   //       //                         horizontal:
                        //                   //       //                             8.0),
                        //                   //       //                 child: Column(
                        //                   //       //                   mainAxisAlignment:
                        //                   //       //                       MainAxisAlignment
                        //                   //       //                           .center,
                        //                   //       //                   children: [
                        //                   //       //                     Icon(
                        //                   //       //                       Icons.edit,
                        //                   //       //                       color: Colors
                        //                   //       //                           .black
                        //                   //       //                           .withOpacity(
                        //                   //       //                               0.7),
                        //                   //       //                       size: 26,
                        //                   //       //                     ),
                        //                   //       //                     const SizedBox(
                        //                   //       //                       height: 3,
                        //                   //       //                     ),
                        //                   //       //                     const Text(
                        //                   //       //                       'Edit',
                        //                   //       //                       style: TextStyle(
                        //                   //       //                           fontWeight:
                        //                   //       //                               FontWeight
                        //                   //       //                                   .w600,
                        //                   //       //                           fontSize:
                        //                   //       //                               12),
                        //                   //       //                     )
                        //                   //       //                   ],
                        //                   //       //                 ),
                        //                   //       //               ),
                        //                   //       //             ),
                        //                   //       //             SizedBoxUtils.width8,
                        //                   //       //             InkWell(
                        //                   //       //               onTap: () {
                        //                   //       //                 Navigator.push(
                        //                   //       //                   context,
                        //                   //       //                   MaterialPageRoute(
                        //                   //       //                       builder:
                        //                   //       //                           (context) =>
                        //                   //       //                               const pdfview()),
                        //                   //       //                 );
                        //                   //       //               },
                        //                   //       //               child: Container(
                        //                   //       //                 height: 80,
                        //                   //       //                 width: 80,
                        //                   //       //                 decoration: BoxDecoration(
                        //                   //       //                     color: Colors
                        //                   //       //                         .white,
                        //                   //       //                     borderRadius:
                        //                   //       //                         BorderRadius
                        //                   //       //                             .circular(
                        //                   //       //                                 20)),
                        //                   //       //                 child: Padding(
                        //                   //       //                   padding: const EdgeInsets
                        //                   //       //                       .symmetric(
                        //                   //       //                       horizontal:
                        //                   //       //                           8.0),
                        //                   //       //                   child: Column(
                        //                   //       //                     mainAxisAlignment:
                        //                   //       //                         MainAxisAlignment
                        //                   //       //                             .center,
                        //                   //       //                     children: [
                        //                   //       //                       Icon(
                        //                   //       //                         Icons
                        //                   //       //                             .picture_as_pdf_outlined,
                        //                   //       //                         color: Colors
                        //                   //       //                             .black
                        //                   //       //                             .withOpacity(
                        //                   //       //                                 0.7),
                        //                   //       //                         size: 26,
                        //                   //       //                       ),
                        //                   //       //                       SizedBoxUtils
                        //                   //       //                           .height3,
                        //                   //       //                       const Text(
                        //                   //       //                         'View Pdf',
                        //                   //       //                         style: TextStyle(
                        //                   //       //                             fontWeight: FontWeight
                        //                   //       //                                 .w600,
                        //                   //       //                             fontSize:
                        //                   //       //                                 12),
                        //                   //       //                       )
                        //                   //       //                     ],
                        //                   //       //                   ),
                        //                   //       //                 ),
                        //                   //       //               ),
                        //                   //       //             ),
                        //                   //       //             SizedBoxUtils.width8,
                        //                   //       //             Container(
                        //                   //       //               height: 80,
                        //                   //       //               width: 80,
                        //                   //       //               decoration: BoxDecoration(
                        //                   //       //                   color: Colors
                        //                   //       //                       .white,
                        //                   //       //                   borderRadius:
                        //                   //       //                       BorderRadius
                        //                   //       //                           .circular(
                        //                   //       //                               20)),
                        //                   //       //               child: Padding(
                        //                   //       //                 padding:
                        //                   //       //                     const EdgeInsets
                        //                   //       //                         .symmetric(
                        //                   //       //                         horizontal:
                        //                   //       //                             8.0),
                        //                   //       //                 child: Column(
                        //                   //       //                   mainAxisAlignment:
                        //                   //       //                       MainAxisAlignment
                        //                   //       //                           .center,
                        //                   //       //                   children: [
                        //                   //       //                     Icon(
                        //                   //       //                       Icons
                        //                   //       //                           .payments,
                        //                   //       //                       color: Colors
                        //                   //       //                           .black
                        //                   //       //                           .withOpacity(
                        //                   //       //                               0.7),
                        //                   //       //                       size: 26,
                        //                   //       //                     ),
                        //                   //       //                     SizedBoxUtils
                        //                   //       //                         .height3,
                        //                   //       //                     const Text(
                        //                   //       //                       'Payment',
                        //                   //       //                       style: TextStyle(
                        //                   //       //                           fontWeight:
                        //                   //       //                               FontWeight
                        //                   //       //                                   .w600,
                        //                   //       //                           fontSize:
                        //                   //       //                               12),
                        //                   //       //                     )
                        //                   //       //                   ],
                        //                   //       //                 ),
                        //                   //       //               ),
                        //                   //       //             ),
                        //                   //       //             SizedBoxUtils.width8,
                        //                   //       //             Container(
                        //                   //       //               height: 80,
                        //                   //       //               width: 80,
                        //                   //       //               decoration: BoxDecoration(
                        //                   //       //                   color: Colors
                        //                   //       //                       .white,
                        //                   //       //                   borderRadius:
                        //                   //       //                       BorderRadius
                        //                   //       //                           .circular(
                        //                   //       //                               20)),
                        //                   //       //               child: Padding(
                        //                   //       //                 padding:
                        //                   //       //                     const EdgeInsets
                        //                   //       //                         .symmetric(
                        //                   //       //                         horizontal:
                        //                   //       //                             8.0),
                        //                   //       //                 child: Column(
                        //                   //       //                   mainAxisAlignment:
                        //                   //       //                       MainAxisAlignment
                        //                   //       //                           .center,
                        //                   //       //                   children: [
                        //                   //       //                     Icon(
                        //                   //       //                       Icons.send,
                        //                   //       //                       color: Colors
                        //                   //       //                           .black
                        //                   //       //                           .withOpacity(
                        //                   //       //                               0.7),
                        //                   //       //                       size: 26,
                        //                   //       //                     ),
                        //                   //       //                     SizedBoxUtils
                        //                   //       //                         .height3,
                        //                   //       //                     const Text(
                        //                   //       //                       'Send Bill',
                        //                   //       //                       style: TextStyle(
                        //                   //       //                           fontWeight:
                        //                   //       //                               FontWeight
                        //                   //       //                                   .w600,
                        //                   //       //                           fontSize:
                        //                   //       //                               12),
                        //                   //       //                     )
                        //                   //       //                   ],
                        //                   //       //                 ),
                        //                   //       //               ),
                        //                   //       //             ),
                        //                   //       //           ],
                        //                   //       //         ),
                        //                   //       //       ),
                        //                   //       //     )
                        //                   //       //   :
                        //                   //       Padding(
                        //                   //           padding: const EdgeInsets
                        //                   //               .symmetric(
                        //                   //               horizontal: 20.0),
                        //                   //           child:
                        //                   //               SingleChildScrollView(
                        //                   //             scrollDirection:
                        //                   //                 Axis.horizontal,
                        //                   //             physics:
                        //                   //                 const BouncingScrollPhysics(),
                        //                   //             child: Row(
                        //                   //               children: [
                        //                   //                 InkWell(
                        //                   //                   onTap: () {
                        //                   //                     Navigator.push(
                        //                   //                       context,
                        //                   //                       MaterialPageRoute(
                        //                   //                           builder:
                        //                   //                               (context) =>
                        //                   //                                   const pdfview()),
                        //                   //                     );
                        //                   //                   },
                        //                   //                   child: Container(
                        //                   //                     height: 40,
                        //                   //                     decoration: BoxDecoration(
                        //                   //                         color: Colors
                        //                   //                             .blueAccent
                        //                   //                             .withOpacity(
                        //                   //                                 0.16),
                        //                   //                         borderRadius:
                        //                   //                             BorderRadius
                        //                   //                                 .circular(
                        //                   //                                     20)),
                        //                   //                     child: Padding(
                        //                   //                       padding: const EdgeInsets
                        //                   //                           .symmetric(
                        //                   //                           horizontal:
                        //                   //                               8.0),
                        //                   //                       child: Row(
                        //                   //                         children: [
                        //                   //                           const Icon(
                        //                   //                             Icons
                        //                   //                                 .picture_as_pdf_outlined,
                        //                   //                             color: Colors
                        //                   //                                 .blueAccent,
                        //                   //                             size: 17,
                        //                   //                           ),
                        //                   //                           SizedBoxUtils
                        //                   //                               .width3,
                        //                   //                           const Text(
                        //                   //                             'View PDF',
                        //                   //                             style: TextStyle(
                        //                   //                                 fontWeight: FontWeight
                        //                   //                                     .w600,
                        //                   //                                 fontSize:
                        //                   //                                     12),
                        //                   //                           )
                        //                   //                         ],
                        //                   //                       ),
                        //                   //                     ),
                        //                   //                   ),
                        //                   //                 ),
                        //                   //                 //TODO: Solve Pop screen issue in cancel button
                        //                   //                 widget.isOrderDetails
                        //                   //                     ? SizedBoxUtils
                        //                   //                         .width8
                        //                   //                     : Container(),
                        //                   //                 widget.isOrderDetails
                        //                   //                     ? GestureDetector(
                        //                   //                         onTap:
                        //                   //                             () async {
                        //                   //                           PostResponseType
                        //                   //                               res =
                        //                   //                               await oc
                        //                   //                                   .cancelOrder(widget.id);
                        //                   //                           if (res.postResponseEnum ==
                        //                   //                               PostResponseEnum
                        //                   //                                   .success) {
                        //                   //                            Get.back();
                        //                   //                           } else {
                        //                   //                             Get.snackbar(
                        //                   //                                 'Error',
                        //                   //                                 res.message);
                        //                   //                           }
                        //                   //                         },
                        //                   //                         child:
                        //                   //                             Container(
                        //                   //                           height: 40,
                        //                   //                           decoration: BoxDecoration(
                        //                   //                               color: Colors
                        //                   //                                   .blueAccent
                        //                   //                                   .withOpacity(
                        //                   //                                       0.16),
                        //                   //                               borderRadius:
                        //                   //                                   BorderRadius.circular(20)),
                        //                   //                           child:
                        //                   //                               Padding(
                        //                   //                             padding: const EdgeInsets
                        //                   //                                 .symmetric(
                        //                   //                                 horizontal:
                        //                   //                                     8.0),
                        //                   //                             child:
                        //                   //                                 Row(
                        //                   //                               children: [
                        //                   //                                 const Icon(
                        //                   //                                   Icons.cancel,
                        //                   //                                   color:
                        //                   //                                       Colors.blueAccent,
                        //                   //                                   size:
                        //                   //                                       17,
                        //                   //                                 ),
                        //                   //                                 SizedBoxUtils
                        //                   //                                     .width3,
                        //                   //                                 const Text(
                        //                   //                                   'Cancel Order',
                        //                   //                                   style:
                        //                   //                                       TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                        //                   //                                 )
                        //                   //                               ],
                        //                   //                             ),
                        //                   //                           ),
                        //                   //                         ),
                        //                   //                       )
                        //                   //                     : Container(),
                        //                   //                 SizedBoxUtils.width8,
                        //                   //                 InkWell(
                        //                   //                   onTap: () async {
                        //                   //                     //TODO: Add Record Payment
                        //                   //                     // PostResponseType res = await oc.recordPayment(widget.id, 100.0, "1", "2");
                        //                   //                     PostResponseType
                        //                   //                         response =
                        //                   //                         _showRecordPaymentPopUp(
                        //                   //                             context);
                        //                   //                   },
                        //                   //                   child: Container(
                        //                   //                     height: 40,
                        //                   //                     decoration: BoxDecoration(
                        //                   //                         color: Colors
                        //                   //                             .blueAccent
                        //                   //                             .withOpacity(
                        //                   //                                 0.16),
                        //                   //                         borderRadius:
                        //                   //                             BorderRadius
                        //                   //                                 .circular(
                        //                   //                                     20)),
                        //                   //                     child:
                        //                   //                         const Padding(
                        //                   //                       padding: EdgeInsets
                        //                   //                           .symmetric(
                        //                   //                               horizontal:
                        //                   //                                   8.0),
                        //                   //                       child: Row(
                        //                   //                         children: [
                        //                   //                           Icon(
                        //                   //                             Icons
                        //                   //                                 .attach_money,
                        //                   //                             color: Colors
                        //                   //                                 .blueAccent,
                        //                   //                             size: 17,
                        //                   //                           ),
                        //                   //                           SizedBox(
                        //                   //                             width: 3,
                        //                   //                           ),
                        //                   //                           Text(
                        //                   //                             'Record Payment',
                        //                   //                             style: TextStyle(
                        //                   //                                 fontWeight: FontWeight
                        //                   //                                     .w600,
                        //                   //                                 fontSize:
                        //                   //                                     12),
                        //                   //                           )
                        //                   //                         ],
                        //                   //                       ),
                        //                   //                     ),
                        //                   //                   ),
                        //                   //                 ),
                        //                   //                 SizedBoxUtils.width8,
                        //                   //                 InkWell(
                        //                   //                   onTap: () {
                        //                   //                     showDialog(
                        //                   //                       context:
                        //                   //                           context,
                        //                   //                       builder:
                        //                   //                           (BuildContext
                        //                   //                               context) {
                        //                   //                         return ThermalPrintDialog();
                        //                   //                       },
                        //                   //                     );
                        //                   //                   },
                        //                   //                   child: Container(
                        //                   //                     height: 40,
                        //                   //                     decoration: BoxDecoration(
                        //                   //                         color: Colors
                        //                   //                             .blueAccent
                        //                   //                             .withOpacity(
                        //                   //                                 0.16),
                        //                   //                         borderRadius:
                        //                   //                             BorderRadius
                        //                   //                                 .circular(
                        //                   //                                     20)),
                        //                   //                     child: Padding(
                        //                   //                       padding: const EdgeInsets
                        //                   //                           .symmetric(
                        //                   //                           horizontal:
                        //                   //                               8.0),
                        //                   //                       child: Row(
                        //                   //                         children: [
                        //                   //                           const Icon(
                        //                   //                             Icons
                        //                   //                                 .note_outlined,
                        //                   //                             color: Colors
                        //                   //                                 .blueAccent,
                        //                   //                             size: 17,
                        //                   //                           ),
                        //                   //                           SizedBoxUtils
                        //                   //                               .width3,
                        //                   //                           const Text(
                        //                   //                             'Print',
                        //                   //                             style: TextStyle(
                        //                   //                                 fontWeight: FontWeight
                        //                   //                                     .w600,
                        //                   //                                 fontSize:
                        //                   //                                     12),
                        //                   //                           )
                        //                   //                         ],
                        //                   //                       ),
                        //                   //                     ),
                        //                   //                   ),
                        //                   //                 ),
                        //                   //                 SizedBoxUtils.width8,
                        //                   //                 GestureDetector(
                        //                   //                   onTap: () async {
                        //                   //                     await Share.share(
                        //                   //                         'Check out this order details from Mobile ERP App \n \n ${qc.currentorderpdf.value}');
                        //                   //                   },
                        //                   //                   child: Container(
                        //                   //                     height: 40,
                        //                   //                     decoration: BoxDecoration(
                        //                   //                         color: Colors
                        //                   //                             .blueAccent
                        //                   //                             .withOpacity(
                        //                   //                                 0.16),
                        //                   //                         borderRadius:
                        //                   //                             BorderRadius
                        //                   //                                 .circular(
                        //                   //                                     20)),
                        //                   //                     child: Padding(
                        //                   //                       padding: const EdgeInsets
                        //                   //                           .symmetric(
                        //                   //                           horizontal:
                        //                   //                               8.0),
                        //                   //                       child: Row(
                        //                   //                         children: [
                        //                   //                           const Icon(
                        //                   //                             Icons
                        //                   //                                 .send,
                        //                   //                             color: Colors
                        //                   //                                 .blueAccent,
                        //                   //                             size: 17,
                        //                   //                           ),
                        //                   //                           SizedBoxUtils
                        //                   //                               .width3,
                        //                   //                           const Text(
                        //                   //                             'Send Bill',
                        //                   //                             style: TextStyle(
                        //                   //                                 fontWeight: FontWeight
                        //                   //                                     .w600,
                        //                   //                                 fontSize:
                        //                   //                                     12),
                        //                   //                           )
                        //                   //                         ],
                        //                   //                       ),
                        //                   //                     ),
                        //                   //                   ),
                        //                   //                 ),
                        //                   //                 SizedBoxUtils.width6,
                        //                   //                 GestureDetector(
                        //                   //                   onTap: () async {
                        //                   //                     PostResponseType
                        //                   //                         res = await oc
                        //                   //                             .createInvoice(
                        //                   //                                 widget
                        //                   //                                     .id);
                        //                   //                     if (res.postResponseEnum ==
                        //                   //                         PostResponseEnum
                        //                   //                             .success) {
                        //                   //                       final data =
                        //                   //                           jsonDecode(res
                        //                   //                               .message);
                        //                   //                       _showInvoicePopUp(
                        //                   //                           context,
                        //                   //                           data[
                        //                   //                               "invoice_number"],
                        //                   //                           data[
                        //                   //                               "link"]);
                        //                   //                     } else {
                        //                   //                       Get.snackbar(
                        //                   //                           'Error',
                        //                   //                           res.message);
                        //                   //                     }
                        //                   //                   },
                        //                   //                   child: Container(
                        //                   //                     height: 40,
                        //                   //                     decoration: BoxDecoration(
                        //                   //                         color: Colors
                        //                   //                             .blueAccent
                        //                   //                             .withOpacity(
                        //                   //                                 0.16),
                        //                   //                         borderRadius:
                        //                   //                             BorderRadius
                        //                   //                                 .circular(
                        //                   //                                     20)),
                        //                   //                     child: Padding(
                        //                   //                       padding: const EdgeInsets
                        //                   //                           .symmetric(
                        //                   //                           horizontal:
                        //                   //                               8.0),
                        //                   //                       child: Row(
                        //                   //                         children: [
                        //                   //                           const Icon(
                        //                   //                             Icons
                        //                   //                                 .change_circle_outlined,
                        //                   //                             color: Colors
                        //                   //                                 .blueAccent,
                        //                   //                             size: 17,
                        //                   //                           ),
                        //                   //                           SizedBoxUtils
                        //                   //                               .width3,
                        //                   //                           const Text(
                        //                   //                             'Generate Invoice',
                        //                   //                             style: TextStyle(
                        //                   //                                 fontWeight: FontWeight
                        //                   //                                     .w600,
                        //                   //                                 fontSize:
                        //                   //                                     12),
                        //                   //                           )
                        //                   //                         ],
                        //                   //                       ),
                        //                   //                     ),
                        //                   //                   ),
                        //                   //                 )
                        //                   //               ],
                        //                   //             ),
                        //                   //           ),
                        //                   //         );
                        //                   // }),
                        //                   // Padding(
                        //                   //   padding: const EdgeInsets.symmetric(
                        //                   //       horizontal: 20.0, vertical: 10),
                        //                   //   child: SingleChildScrollView(
                        //                   //     physics:
                        //                   //         const BouncingScrollPhysics(),
                        //                   //     child: Container(
                        //                   //       width: size.width,
                        //                   //       height: size.height * 0.45,
                        //                   //       decoration: BoxDecoration(
                        //                   //           color: Colors.white,
                        //                   //           borderRadius:
                        //                   //               BorderRadius.circular(
                        //                   //                   10)),
                        //                   //       child: SingleChildScrollView(
                        //                   //         // controller: scrollController,
                        //                   //         child: Column(
                        //                   //           children: [
                        //                   //             SizedBoxUtils.height10,
                        //                   //             Padding(
                        //                   //               padding:
                        //                   //                   const EdgeInsets
                        //                   //                       .symmetric(
                        //                   //                       horizontal:
                        //                   //                           15.0),
                        //                   //               child: Row(
                        //                   //                 mainAxisAlignment:
                        //                   //                     MainAxisAlignment
                        //                   //                         .spaceBetween,
                        //                   //                 children: [
                        //                   //                   Row(
                        //                   //                     children: [
                        //                   //                       const Icon(Icons
                        //                   //                           .delivery_dining),
                        //                   //                       SizedBoxUtils
                        //                   //                           .width15,
                        //                   //                       const Text(
                        //                   //                           'Delivery Challan'),
                        //                   //                     ],
                        //                   //                   ),
                        //                   //                   Container(
                        //                   //                     decoration:
                        //                   //                         BoxDecoration(
                        //                   //                       borderRadius:
                        //                   //                           BorderRadius
                        //                   //                               .circular(
                        //                   //                                   100),
                        //                   //                       border:
                        //                   //                           Border.all(
                        //                   //                         color: Colors
                        //                   //                             .red
                        //                   //                             .withOpacity(
                        //                   //                                 0.4),
                        //                   //                         width: 4,
                        //                   //                       ),
                        //                   //                     ),
                        //                   //                     child:
                        //                   //                         const CircleAvatar(
                        //                   //                       backgroundColor:
                        //                   //                           Colors.red,
                        //                   //                       radius: 9,
                        //                   //                       child: Icon(
                        //                   //                         Icons
                        //                   //                             .play_arrow,
                        //                   //                         size: 14,
                        //                   //                         color: Colors
                        //                   //                             .white,
                        //                   //                       ),
                        //                   //                     ),
                        //                   //                   ),
                        //                   //                 ],
                        //                   //               ),
                        //                   //             ),
                        //                   //             SizedBoxUtils.height10,
                        //                   //             Container(
                        //                   //               height: 1,
                        //                   //               width: size.width,
                        //                   //               decoration:
                        //                   //                   BoxDecoration(
                        //                   //                       color: Colors
                        //                   //                           .grey
                        //                   //                           .withOpacity(
                        //                   //                               0.2)),
                        //                   //             ),
                        //                   //             SizedBoxUtils.height10,
                        //                   //             Padding(
                        //                   //               padding:
                        //                   //                   const EdgeInsets
                        //                   //                       .symmetric(
                        //                   //                       horizontal:
                        //                   //                           15.0),
                        //                   //               child: Row(
                        //                   //                 mainAxisAlignment:
                        //                   //                     MainAxisAlignment
                        //                   //                         .spaceBetween,
                        //                   //                 children: [
                        //                   //                   Row(
                        //                   //                     children: [
                        //                   //                       const Icon(Icons
                        //                   //                           .control_point_duplicate),
                        //                   //                       SizedBoxUtils
                        //                   //                           .width15,
                        //                   //                       const Text(
                        //                   //                           'Duplicate'),
                        //                   //                     ],
                        //                   //                   ),
                        //                   //                 ],
                        //                   //               ),
                        //                   //             ),
                        //                   //             SizedBoxUtils.height10,
                        //                   //             Container(
                        //                   //               height: 1,
                        //                   //               width: size.width,
                        //                   //               decoration:
                        //                   //                   BoxDecoration(
                        //                   //                       color: Colors
                        //                   //                           .grey
                        //                   //                           .withOpacity(
                        //                   //                               0.2)),
                        //                   //             ),
                        //                   //             SizedBoxUtils.height10,
                        //                   //             Padding(
                        //                   //               padding:
                        //                   //                   const EdgeInsets
                        //                   //                       .symmetric(
                        //                   //                       horizontal:
                        //                   //                           15.0),
                        //                   //               child: Row(
                        //                   //                 mainAxisAlignment:
                        //                   //                     MainAxisAlignment
                        //                   //                         .spaceBetween,
                        //                   //                 children: [
                        //                   //                   Row(
                        //                   //                     children: [
                        //                   //                       const Icon(Icons
                        //                   //                           .print),
                        //                   //                       SizedBoxUtils
                        //                   //                           .width15,
                        //                   //                       const Text(
                        //                   //                           'Thermal Print'),
                        //                   //                     ],
                        //                   //                   ),
                        //                   //                 ],
                        //                   //               ),
                        //                   //             ),
                        //                   //             SizedBoxUtils.height10,
                        //                   //             Container(
                        //                   //               height: 1,
                        //                   //               width: size.width,
                        //                   //               decoration:
                        //                   //                   BoxDecoration(
                        //                   //                       color: Colors
                        //                   //                           .grey
                        //                   //                           .withOpacity(
                        //                   //                               0.2)),
                        //                   //             ),
                        //                   //             SizedBoxUtils.height10,
                        //                   //             Padding(
                        //                   //               padding:
                        //                   //                   const EdgeInsets
                        //                   //                       .symmetric(
                        //                   //                       horizontal:
                        //                   //                           15.0),
                        //                   //               child: Row(
                        //                   //                 mainAxisAlignment:
                        //                   //                     MainAxisAlignment
                        //                   //                         .spaceBetween,
                        //                   //                 children: [
                        //                   //                   Row(
                        //                   //                     children: [
                        //                   //                       const Icon(Icons
                        //                   //                           .email_outlined),
                        //                   //                       SizedBoxUtils
                        //                   //                           .width15,
                        //                   //                       const Text(
                        //                   //                           'Send Email'),
                        //                   //                     ],
                        //                   //                   ),
                        //                   //                 ],
                        //                   //               ),
                        //                   //             ),
                        //                   //             SizedBoxUtils.height10,
                        //                   //             Container(
                        //                   //               height: 1,
                        //                   //               width: size.width,
                        //                   //               decoration:
                        //                   //                   BoxDecoration(
                        //                   //                       color: Colors
                        //                   //                           .grey
                        //                   //                           .withOpacity(
                        //                   //                               0.2)),
                        //                   //             ),
                        //                   //             SizedBoxUtils.height10,
                        //                   //             Padding(
                        //                   //               padding:
                        //                   //                   const EdgeInsets
                        //                   //                       .symmetric(
                        //                   //                       horizontal:
                        //                   //                           15.0),
                        //                   //               child: Row(
                        //                   //                 mainAxisAlignment:
                        //                   //                     MainAxisAlignment
                        //                   //                         .spaceBetween,
                        //                   //                 children: [
                        //                   //                   Row(
                        //                   //                     children: [
                        //                   //                       const Icon(Icons
                        //                   //                           .sms_failed_outlined),
                        //                   //                       SizedBoxUtils
                        //                   //                           .width15,
                        //                   //                       const Text(
                        //                   //                           'Send SMS'),
                        //                   //                     ],
                        //                   //                   ),
                        //                   //                 ],
                        //                   //               ),
                        //                   //             ),
                        //                   //             SizedBoxUtils.height10,
                        //                   //             Container(
                        //                   //               height: 1,
                        //                   //               width: size.width,
                        //                   //               decoration:
                        //                   //                   BoxDecoration(
                        //                   //                       color: Colors
                        //                   //                           .grey
                        //                   //                           .withOpacity(
                        //                   //                               0.2)),
                        //                   //             ),
                        //                   //             SizedBoxUtils.height10,
                        //                   //             Padding(
                        //                   //               padding:
                        //                   //                   const EdgeInsets
                        //                   //                       .symmetric(
                        //                   //                       horizontal:
                        //                   //                           15.0),
                        //                   //               child: Row(
                        //                   //                 mainAxisAlignment:
                        //                   //                     MainAxisAlignment
                        //                   //                         .spaceBetween,
                        //                   //                 children: [
                        //                   //                   Row(
                        //                   //                     children: [
                        //                   //                       const Icon(Icons
                        //                   //                           .change_circle_outlined),
                        //                   //                       SizedBoxUtils
                        //                   //                           .width15,
                        //                   //                       const Text(
                        //                   //                           'Generate Invoice'),
                        //                   //                     ],
                        //                   //                   ),
                        //                   //                   Container(
                        //                   //                     decoration:
                        //                   //                         BoxDecoration(
                        //                   //                       borderRadius:
                        //                   //                           BorderRadius
                        //                   //                               .circular(
                        //                   //                                   100),
                        //                   //                       border:
                        //                   //                           Border.all(
                        //                   //                         color: Colors
                        //                   //                             .red
                        //                   //                             .withOpacity(
                        //                   //                                 0.4),
                        //                   //                         width: 4,
                        //                   //                       ),
                        //                   //                     ),
                        //                   //                     child:
                        //                   //                         const CircleAvatar(
                        //                   //                       backgroundColor:
                        //                   //                           Colors.red,
                        //                   //                       radius: 9,
                        //                   //                       child: Icon(
                        //                   //                         Icons
                        //                   //                             .play_arrow,
                        //                   //                         size: 14,
                        //                   //                         color: Colors
                        //                   //                             .white,
                        //                   //                       ),
                        //                   //                     ),
                        //                   //                   ),
                        //                   //                 ],
                        //                   //               ),
                        //                   //             ),
                        //                   //             SizedBoxUtils.height10,
                        //                   //             Container(
                        //                   //               height: 1,
                        //                   //               width: size.width,
                        //                   //               decoration:
                        //                   //                   BoxDecoration(
                        //                   //                       color: Colors
                        //                   //                           .grey
                        //                   //                           .withOpacity(
                        //                   //                               0.2)),
                        //                   //             ),
                        //                   //             SizedBoxUtils.height10,
                        //                   //             Padding(
                        //                   //               padding:
                        //                   //                   const EdgeInsets
                        //                   //                       .symmetric(
                        //                   //                       horizontal:
                        //                   //                           15.0),
                        //                   //               child: Row(
                        //                   //                 mainAxisAlignment:
                        //                   //                     MainAxisAlignment
                        //                   //                         .spaceBetween,
                        //                   //                 children: [
                        //                   //                   Row(
                        //                   //                     children: [
                        //                   //                       const Icon(Icons
                        //                   //                           .fire_truck_outlined),
                        //                   //                       SizedBoxUtils
                        //                   //                           .width15,
                        //                   //                       const Text(
                        //                   //                           'Create E-way Bill'),
                        //                   //                     ],
                        //                   //                   ),
                        //                   //                 ],
                        //                   //               ),
                        //                   //             ),
                        //                   //             SizedBoxUtils.height10,
                        //                   //             Container(
                        //                   //               height: 1,
                        //                   //               width: size.width,
                        //                   //               decoration:
                        //                   //                   BoxDecoration(
                        //                   //                       color: Colors
                        //                   //                           .grey
                        //                   //                           .withOpacity(
                        //                   //                               0.2)),
                        //                   //             ),
                        //                   //             SizedBoxUtils.height10,
                        //                   //             Padding(
                        //                   //               padding:
                        //                   //                   const EdgeInsets
                        //                   //                       .symmetric(
                        //                   //                       horizontal:
                        //                   //                           15.0),
                        //                   //               child: Row(
                        //                   //                 mainAxisAlignment:
                        //                   //                     MainAxisAlignment
                        //                   //                         .spaceBetween,
                        //                   //                 children: [
                        //                   //                   Row(
                        //                   //                     children: [
                        //                   //                       const Icon(Icons
                        //                   //                           .file_copy_outlined),
                        //                   //                       SizedBoxUtils
                        //                   //                           .width15,
                        //                   //                       const Text(
                        //                   //                           'Create E-invoice'),
                        //                   //                     ],
                        //                   //                   ),
                        //                   //                   Container(
                        //                   //                     decoration:
                        //                   //                         BoxDecoration(
                        //                   //                       borderRadius:
                        //                   //                           BorderRadius
                        //                   //                               .circular(
                        //                   //                                   100),
                        //                   //                       border:
                        //                   //                           Border.all(
                        //                   //                         color: Colors
                        //                   //                             .red
                        //                   //                             .withOpacity(
                        //                   //                                 0.4),
                        //                   //                         width: 4,
                        //                   //                       ),
                        //                   //                     ),
                        //                   //                     child:
                        //                   //                         const CircleAvatar(
                        //                   //                       backgroundColor:
                        //                   //                           Colors.red,
                        //                   //                       radius: 9,
                        //                   //                       child: Icon(
                        //                   //                         Icons
                        //                   //                             .play_arrow,
                        //                   //                         size: 14,
                        //                   //                         color: Colors
                        //                   //                             .white,
                        //                   //                       ),
                        //                   //                     ),
                        //                   //                   ),
                        //                   //                 ],
                        //                   //               ),
                        //                   //             ),
                        //                   //             SizedBoxUtils.height10,
                        //                   //             Container(
                        //                   //               height: 1,
                        //                   //               width: size.width,
                        //                   //               decoration:
                        //                   //                   BoxDecoration(
                        //                   //                       color: Colors
                        //                   //                           .grey
                        //                   //                           .withOpacity(
                        //                   //                               0.2)),
                        //                   //             ),
                        //                   //             SizedBoxUtils.height10,
                        //                   //             Padding(
                        //                   //               padding:
                        //                   //                   const EdgeInsets
                        //                   //                       .symmetric(
                        //                   //                       horizontal:
                        //                   //                           15.0),
                        //                   //               child: Row(
                        //                   //                 mainAxisAlignment:
                        //                   //                     MainAxisAlignment
                        //                   //                         .spaceBetween,
                        //                   //                 children: [
                        //                   //                   Row(
                        //                   //                     children: [
                        //                   //                       const Icon(Icons
                        //                   //                           .qr_code),
                        //                   //                       SizedBoxUtils
                        //                   //                           .width15,
                        //                   //                       const Text(
                        //                   //                           'Generate QR Code'),
                        //                   //                     ],
                        //                   //                   ),
                        //                   //                 ],
                        //                   //               ),
                        //                   //             ),
                        //                   //             SizedBoxUtils.height10,
                        //                   //             Container(
                        //                   //               height: 1,
                        //                   //               width: size.width,
                        //                   //               decoration:
                        //                   //                   BoxDecoration(
                        //                   //                       color: Colors
                        //                   //                           .grey
                        //                   //                           .withOpacity(
                        //                   //                               0.2)),
                        //                   //             ),
                        //                   //             SizedBoxUtils.height10,
                        //                   //             Padding(
                        //                   //               padding:
                        //                   //                   const EdgeInsets
                        //                   //                       .symmetric(
                        //                   //                       horizontal:
                        //                   //                           15.0),
                        //                   //               child: Row(
                        //                   //                 mainAxisAlignment:
                        //                   //                     MainAxisAlignment
                        //                   //                         .spaceBetween,
                        //                   //                 children: [
                        //                   //                   Row(
                        //                   //                     children: [
                        //                   //                       const Icon(Icons
                        //                   //                           .settings),
                        //                   //                       SizedBoxUtils
                        //                   //                           .width15,
                        //                   //                       const Text(
                        //                   //                           'Document Setting'),
                        //                   //                     ],
                        //                   //                   ),
                        //                   //                 ],
                        //                   //               ),
                        //                   //             ),
                        //                   //             SizedBoxUtils.height10,
                        //                   //             Container(
                        //                   //               height: 1,
                        //                   //               width: size.width,
                        //                   //               decoration:
                        //                   //                   BoxDecoration(
                        //                   //                       color: Colors
                        //                   //                           .grey
                        //                   //                           .withOpacity(
                        //                   //                               0.2)),
                        //                   //             ),
                        //                   //             SizedBoxUtils.height10,
                        //                   //             Padding(
                        //                   //               padding:
                        //                   //                   const EdgeInsets
                        //                   //                       .symmetric(
                        //                   //                       horizontal:
                        //                   //                           15.0),
                        //                   //               child: Row(
                        //                   //                 mainAxisAlignment:
                        //                   //                     MainAxisAlignment
                        //                   //                         .spaceBetween,
                        //                   //                 children: [
                        //                   //                   Row(
                        //                   //                     children: [
                        //                   //                       Icon(
                        //                   //                           Icons
                        //                   //                               .cancel_outlined,
                        //                   //                           color: Colors
                        //                   //                               .red
                        //                   //                               .withOpacity(
                        //                   //                                   0.7)),
                        //                   //                       SizedBoxUtils
                        //                   //                           .width15,
                        //                   //                       const Text(
                        //                   //                         'Cancel invoice',
                        //                   //                         style: TextStyle(
                        //                   //                             color: Colors
                        //                   //                                 .red),
                        //                   //                       ),
                        //                   //                     ],
                        //                   //                   ),
                        //                   //                   Container(
                        //                   //                     decoration:
                        //                   //                         BoxDecoration(
                        //                   //                       borderRadius:
                        //                   //                           BorderRadius
                        //                   //                               .circular(
                        //                   //                                   100),
                        //                   //                       border:
                        //                   //                           Border.all(
                        //                   //                         color: Colors
                        //                   //                             .red
                        //                   //                             .withOpacity(
                        //                   //                                 0.4),
                        //                   //                         width: 4,
                        //                   //                       ),
                        //                   //                     ),
                        //                   //                     child:
                        //                   //                         const CircleAvatar(
                        //                   //                       backgroundColor:
                        //                   //                           Colors.red,
                        //                   //                       radius: 9,
                        //                   //                       child: Icon(
                        //                   //                         Icons
                        //                   //                             .play_arrow,
                        //                   //                         size: 14,
                        //                   //                         color: Colors
                        //                   //                             .white,
                        //                   //                       ),
                        //                   //                     ),
                        //                   //                   ),
                        //                   //                 ],
                        //                   //               ),
                        //                   //             ),
                        //                   //             SizedBoxUtils.height10,
                        //                   //             Container(
                        //                   //               height: 1,
                        //                   //               width: size.width,
                        //                   //               decoration:
                        //                   //                   BoxDecoration(
                        //                   //                       color: Colors
                        //                   //                           .grey
                        //                   //                           .withOpacity(
                        //                   //                               0.2)),
                        //                   //             ),
                        //                   //           ],
                        //                   //         ),
                        //                   //       ),
                        //                   //     ),
                        //                   //   ),
                        //                   // )
                        //                   // Add your additional widgets here
                        //                 ],
                        //               ),
                        //             ),
                        //           ));
                        //     },
                        //   ),
                        // ),
                      ],
                    )
                  : const Center(child: Text("Error"));
        }),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            color: Colors.white,
            height: 50,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OptionsButton(
                    label: 'View PDF',
                    icon: Icons.picture_as_pdf_outlined,
                    onTap: () {
                      Get.to(() => const pdfview());
                    },
                  ),
                  widget.isOrderDetails ? SizedBoxUtils.width8 : Container(),
                  widget.isOrderDetails
                      ? OptionsButton(
                          label: 'Cancel Order',
                          icon: Icons.cancel,
                          onTap: () async {
                            PostResponseType res =
                                await oc.cancelOrder(widget.id);
                            if (res.postResponseEnum ==
                                PostResponseEnum.success) {
                              Get.back();
                            } else {
                              Get.snackbar('Error', res.message);
                            }
                          },
                        )
                      : Container(),
                  SizedBoxUtils.width8,
                  OptionsButton(
                    label: 'Record Payment',
                    onTap: () => _showRecordPaymentPopUp(),
                    icon: Icons.attach_money,
                  ),
                  SizedBoxUtils.width8,
                  OptionsButton(
                    label: 'Print',
                    icon: Icons.note_outlined,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ThermalPrintDialog();
                        },
                      );
                    },
                  ),
                  SizedBoxUtils.width8,
                  OptionsButton(
                    label: 'Send Bill',
                    icon: Icons.send,
                    onTap: () async {
                      await Share.share(
                          'Check out this order details from Mobile ERP App \n \n ${qc.currentorderpdf.value}');
                    },
                  ),
                  SizedBoxUtils.width6,
                  OptionsButton(
                    label: 'Generate Invoice',
                    icon: Icons.change_circle_outlined,
                    onTap: () async {
                      PostResponseType res = await oc.createInvoice(widget.id);
                      if (res.postResponseEnum == PostResponseEnum.success) {
                        final data = jsonDecode(res.message);
                        _showInvoicePopUp(
                            context, data["invoice_number"], data["link"]);
                      } else {
                        // Get.snackbar('Error', res.message);
                        invoiceGenerationDialog();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
