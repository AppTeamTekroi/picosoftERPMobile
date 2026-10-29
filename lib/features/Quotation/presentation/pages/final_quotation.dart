// import 'dart:async';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:mobile_erp/features/Quotation/presentation/pages/pdfview.dart';
// import 'package:mobile_erp/features/customer/controller/customer_controller.dart';
//
// import '../../../../ui/color/appColor.dart';
// import '../../../product/controller/product_controller.dart';
// import '../../controller/quotation_controller.dart';
// import '../widget/additionalTable.dart';
// import '../widget/eyeTable.dart';
// import '../widget/return_values_bs.dart';
// import '../widget/thermalPrintDialog.dart';
//
// class FinalQuotationScreen extends StatefulWidget {
//   const FinalQuotationScreen({Key? key, required this.date}) : super(key: key);
//
//   final String date;
//
//   @override
//   State<FinalQuotationScreen> createState() => _CreatePurchaseScreenState();
// }
//
// class _CreatePurchaseScreenState extends State<FinalQuotationScreen> {
//   QuotationController qc = Get.find<QuotationController>();
//   CustomerController cc = Get.find<CustomerController>();
//   ProductController pc = Get.put(ProductController());
//   Set<int> expandedDetailsIndices = {};
//   late var totalPrice;
//   late ReturnValuesBS? resultValues;
//   bool _dialogShown = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//
//     return WillPopScope(
//         onWillPop: () async {
//           if (!_dialogShown) {
//             // If the dialog was not shown before, show it
//             _dialogShown = true;
//
//             bool shouldCloseApp = await showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return AlertDialog(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(5.0),
//                   ),
//                   backgroundColor: Colors.white,
//                   content: const Text(
//                     "Are you sure you want to exit?",
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   actions: <Widget>[
//                     TextButton(
//                       child: const Text(
//                         "Yes",
//                         style: TextStyle(
//                           color: AppColors.mainblue,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       onPressed: () {
//                         // Close the dialog and return true
//                         // Navigator.of(context)
//                         //   ..pop(true)
//                         //   ..pop();
//                         Navigator.popUntil(context, (route) => route.isFirst);
//                         // Navigator.pushReplacement(
//                         //     context,
//                         //     (CupertinoPageRoute(
//                         //         builder: (context) => const BottomNav())));
//                       },
//                     ),
//                     TextButton(
//                       child: const Text(
//                         "No",
//                         style: TextStyle(
//                           color: AppColors.mainblue,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       onPressed: () {
//                         // Close the dialog and return false
//                         Navigator.of(context).pop(false);
//                       },
//                     ),
//                   ],
//                 );
//               },
//             );
//
//             // Reset the variable when the dialog is closed
//             _dialogShown = false;
//             // Return whether the app should be closed based on user selection
//             return shouldCloseApp;
//           } else {
//             //   // If the dialog was already shown, allow the app to be closed without showing the dialog again
//             return true;
//           }
//         },
//         child: Scaffold(
//           backgroundColor: AppColors.primary,
//           appBar: AppBar(
//             backgroundColor: Colors.white,
//             title: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Order',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//                 ),
//                 // const Text(
//                 //   'Purchase',
//                 //   style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
//                 // ),
//               ],
//             ),
//             leading: GestureDetector(
//               onTap: () {
//                 // Go back to home screen this screen is opened from QuotationScreen, and QuotationScreen opened from HomeScreen
//                 Navigator.popUntil(context, (route) => route.isFirst);
//               },
//               child: const Padding(
//                 padding: EdgeInsets.only(left: 10.0),
//                 child: Icon(Icons.arrow_back),
//               ),
//             ),
//             // actions: [
//             //   GestureDetector(
//             //     onTap: () {},
//             //     child: Container(
//             //       decoration: BoxDecoration(
//             //           color: Colors.yellow.withOpacity(0.2),
//             //           borderRadius: BorderRadius.circular(8)),
//             //       child: Padding(
//             //         padding: const EdgeInsets.all(6.0),
//             //         child: Row(
//             //           children: [],
//             //         ),
//             //       ),
//             //     ),
//             //   ),
//             //   SizedBox(
//             //     width: 15,
//             //   ),
//             //   Icon(
//             //     Icons.menu,
//             //     color: Colors.black,
//             //   ),
//             //   SizedBox(
//             //     width: 20,
//             //   ),
//             // ],
//           ),
//           body: Stack(
//             children: [
//               // Your body content here
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
//                 child: SingleChildScrollView(
//                   physics: BouncingScrollPhysics(),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8.0),
//                         child: Text(
//                           'Order Details',
//                           style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w800,
//                               color: Colors.black),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 15,
//                       ),
//                       Container(
//                         // height: 100,
//                         decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10)),
//                         child: Padding(
//                           padding: const EdgeInsets.only(
//                               left: 15.0, right: 15.0, top: 10),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     'Quotation #',
//                                     style: TextStyle(
//                                         color: Colors.grey, fontSize: 12),
//                                   ),
//                                 ],
//                               ),
//                               const Text(
//                                 'EST-2',
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w600),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.fromLTRB(
//                                     0.0, 12.0, 0.0, 0.0),
//                                 child: Text(
//                                   "Date",
//                                   style: const TextStyle(
//                                       color: Colors.grey,
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.fromLTRB(
//                                     0.0, 0.0, 0.0, 10.0),
//                                 child: Text(
//                                   widget.date,
//                                   style: const TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 15,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8.0),
//                         child: Text(
//                           'Customer Details',
//                           style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w800,
//                               color: Colors.black),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 15,
//                       ),
//                       GetBuilder<CustomerController>(
//                         builder: (cc) => Container(
//                           // height: 100,
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10)),
//                           child: Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 15.0, right: 15.0, top: 10),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       'Name',
//                                       style: TextStyle(
//                                           color: Colors.grey, fontSize: 12),
//                                     ),
//                                   ],
//                                 ),
//                                 Text(
//                                   cc.selectedCustomer.value?.name ?? '',
//                                   style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.fromLTRB(
//                                       0.0, 12.0, 0.0, 0.0),
//                                   child: Text(
//                                     "Phone Number",
//                                     style: const TextStyle(
//                                         color: Colors.grey,
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.fromLTRB(
//                                       0.0, 0.0, 0.0, 10.0),
//                                   child: Text(
//                                     cc.selectedCustomer.value?.phone ?? '',
//                                     style: const TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 15,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8.0),
//                         child: Row(
//                           children: [
//                             Text(
//                               'Products Deatils',
//                               style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.black),
//                             ),
//                             SizedBox(
//                               width: 4,
//                             ),
//                             Text(
//                               ' (${pc.selectedProducts.length} Product)',
//                               style: TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w400,
//                                   color: Colors.grey.withOpacity(0.6)),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         height: 15,
//                       ),
//                       Column(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 8, horizontal: 4),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: ListView.builder(
//                                 physics: NeverScrollableScrollPhysics(),
//                                 shrinkWrap: true,
//                                 itemCount: pc.selectedProducts.length,
//                                 itemBuilder: (context, index) {
//                                   var item = pc.selectedProducts[index];
//
//                                   var taxWithPrice = (double.parse(
//                                           item.stock_price ?? '0.00')) +
//                                       (double.parse(
//                                               item.stock_price ?? '0.00') *
//                                           0.18);
//                                   var tax = (item.selectedQty ?? 0.00) *
//                                       (double.parse(
//                                               item.stock_price ?? '0.00') *
//                                           0.18);
//
//                                   totalPrice = (item.selectedQty ?? 0.00) *
//                                           double.parse(
//                                               item.stock_price ?? '0.00') +
//                                       ((item.selectedQty ?? 0.00) *
//                                           double.parse(
//                                               item.stock_price ?? '0.00') *
//                                           0.18);
//
//                                   var netAmount = (item.selectedQty ?? 0.00) *
//                                       double.parse(item.stock_price ?? '0.00');
//
//                                   bool isDetailsExpanded =
//                                       expandedDetailsIndices.contains(index);
//                                   return GestureDetector(
//                                     onTap: () {
//                                       setState(() {
//                                         // Toggle details expansion on button press
//                                         if (isDetailsExpanded) {
//                                           expandedDetailsIndices.remove(index);
//                                         } else {
//                                           expandedDetailsIndices.add(index);
//                                         }
//                                       });
//                                     },
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius:
//                                               BorderRadius.circular(10)),
//                                       child: Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 15.0),
//                                         child: Column(
//                                           children: [
//                                             const SizedBox(
//                                               height: 10,
//                                             ),
//                                             Row(
//                                               children: [
//                                                 SizedBox(
//                                                   height: 30,
//                                                   width: 30,
//                                                   child: Obx(() {
//                                                     final bool showDescription =
//                                                         pc.showDes.value[index];
//                                                     return Checkbox(
//                                                       value: showDescription,
//                                                       onChanged: (val) {
//                                                         pc.showDes
//                                                                 .value[index] =
//                                                             val!;
//                                                         pc.showDes.refresh();
//                                                       },
//                                                     );
//                                                   }),
//                                                 ),
//                                                 const Text(
//                                                   'Show Description',
//                                                   style:
//                                                       TextStyle(fontSize: 14),
//                                                 )
//                                               ],
//                                             ),
//                                             Padding(
//                                               padding: const EdgeInsets.only(
//                                                   left: 5.0),
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   Text(
//                                                     item.name ?? 'Null',
//                                                     style: const TextStyle(
//                                                         fontSize: 14,
//                                                         fontWeight:
//                                                             FontWeight.w600),
//                                                   ),
//                                                   Text(
//                                                     '₹ $totalPrice',
//                                                     style: const TextStyle(
//                                                         fontSize: 14,
//                                                         fontWeight:
//                                                             FontWeight.w600),
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
//                                             isDetailsExpanded
//                                                 ? Padding(
//                                                     padding: const EdgeInsets
//                                                         .symmetric(
//                                                       horizontal: 8.0,
//                                                       vertical: 10,
//                                                     ),
//                                                     child: Column(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .center,
//                                                       children: [
//                                                         Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .spaceBetween,
//                                                           children: [
//                                                             const Text(
//                                                                 'Price with Tax'),
//                                                             Text(taxWithPrice
//                                                                 .toStringAsFixed(
//                                                                     2))
//                                                           ],
//                                                         ),
//                                                         Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .spaceBetween,
//                                                           children: [
//                                                             const Text(
//                                                                 'Quantity'),
//                                                             Text(item
//                                                                 .selectedQty!
//                                                                 .toStringAsFixed(
//                                                                     2))
//                                                           ],
//                                                         ),
//                                                         Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .spaceBetween,
//                                                           children: [
//                                                             const Text(
//                                                                 'Net Amount'),
//                                                             Text(netAmount
//                                                                 .toStringAsFixed(
//                                                                     2))
//                                                           ],
//                                                         ),
//                                                         Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .spaceBetween,
//                                                           children: [
//                                                             const Text(
//                                                                 'Total Tax(18.0%)'),
//                                                             Text(tax
//                                                                 .toStringAsFixed(
//                                                                     2))
//                                                           ],
//                                                         ),
//                                                       ],
//                                                     ))
//                                                 : Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             left: 5.0),
//                                                     child: Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .spaceBetween,
//                                                       children: [
//                                                         Text(
//                                                           ' x ${item.selectedQty}',
//                                                           style: const TextStyle(
//                                                               fontSize: 13,
//                                                               color:
//                                                                   Colors.grey,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w400),
//                                                         ),
//                                                         const Row(
//                                                           children: [
//                                                             Text(
//                                                               'Details',
//                                                               style: TextStyle(
//                                                                   fontSize: 13,
//                                                                   color: Colors
//                                                                       .grey,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w400),
//                                                             ),
//                                                             Icon(
//                                                               Icons
//                                                                   .arrow_forward_ios,
//                                                               color:
//                                                                   Colors.grey,
//                                                               size: 12,
//                                                             )
//                                                           ],
//                                                         )
//                                                       ],
//                                                     ),
//                                                   ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 Obx(() {
//                                                   // Use GetX to conditionally show the description
//                                                   final bool showDescription =
//                                                       pc.showDes.value[index];
//                                                   return showDescription
//                                                       ? Padding(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                   .symmetric(
//                                                                   horizontal:
//                                                                       8.0,
//                                                                   vertical: 10),
//                                                           child: Text(
//                                                             item.description!,
//                                                             style:
//                                                                 const TextStyle(
//                                                               fontSize: 14,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w400,
//                                                             ),
//                                                           ),
//                                                         )
//                                                       : const SizedBox(
//                                                           height: 20,
//                                                         ); // Empty container if description should not be shown
//                                                 }),
//                                               ],
//                                             ),
//                                             Container(
//                                                 height: 1,
//                                                 decoration: BoxDecoration(
//                                                     color: Colors.grey
//                                                         .withOpacity(0.3))),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 }),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 15,
//                       ),
//                       Obx(() {
//                         return Padding(
//                           padding: EdgeInsets.only(
//                               bottom: qc.showfinalPresDetials.value ? 0 : 0,
//                               left: 8),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Text(
//                                 qc.showfinalPresDetials.value
//                                     ? 'Hide Details'
//                                     : 'See Prescription Details',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w800,
//                                     color: Colors.black,
//                                     fontSize: 14),
//                               ),
//                               SizedBox(
//                                 width: 8,
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   qc.showfinalPresDetials.value =
//                                       !qc.showfinalPresDetials.value;
//                                 },
//                                 child: Icon(
//                                     qc.showfinalPresDetials.value
//                                         ? Icons.remove_circle
//                                         : Icons.add_circle,
//                                     size: 18,
//                                     color: Colors.black),
//                               )
//                             ],
//                           ),
//                         );
//                       }),
//                       SizedBox(
//                         height: 15,
//                       ),
//                       Obx(() {
//                         return qc.showfinalPresDetials.value
//                             ? Container(
//                                 // height: 100,
//                                 decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(10)),
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(
//                                       left: 15.0, right: 15.0, top: 10),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       const Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             'Prescription Number',
//                                             style: TextStyle(
//                                                 color: Colors.grey,
//                                                 fontSize: 12),
//                                           ),
//                                         ],
//                                       ),
//                                       Text(
//                                         qc.selectPresId.value,
//                                         style: TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w600),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.fromLTRB(
//                                             0.0, 12.0, 0.0, 0.0),
//                                         child: Text(
//                                           "Prescription",
//                                           style: const TextStyle(
//                                               color: Colors.grey,
//                                               fontSize: 12,
//                                               fontWeight: FontWeight.w600),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.fromLTRB(
//                                             0.0, 0.0, 0.0, 10.0),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             EyeDetailsTable(
//                                               eye: 'Left',
//                                             ),
//                                             EyeDetailsTable(
//                                               eye: 'Right',
//                                             ),
//                                             AdditionalDetailsTable()
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               )
//                             : SizedBox();
//                       }),
//                       SizedBox(
//                         height: 15,
//                       ),
//                       Container(
//                         height: 10,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 8.0),
//                         child: Text(
//                           '',
//                           style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w800,
//                               color: Colors.black),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               // Add the DraggableScrollableSheet as a bottom sheet
//               NotificationListener<DraggableScrollableNotification>(
//                 onNotification: (notification) {
//                   qc.sheetHeight.value = 200.0 -
//                       notification.extent *
//                           200.0; // Calculate height based on scroll extent
//                   return true;
//                 },
//                 child: DraggableScrollableSheet(
//                   initialChildSize: 95 / height * 0.9, // Initial height of 100
//                   minChildSize: 95 / height * 0.9, // Minimum height
//                   maxChildSize: height * 0.7 / height, // Maximum height of 400
//                   builder: (BuildContext context,
//                       ScrollController scrollController) {
//                     // print(cic.sheetHeight.value);
//                     return Obx(() => Container(
//                           decoration: BoxDecoration(
//                             color: qc.sheetHeight.value < 165 &&
//                                     qc.sheetHeight.value != 100.0
//                                 ? AppColors.primary
//                                 : Colors.white,
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(20),
//                               topRight: Radius.circular(20),
//                             ),
//                           ),
//                           child: SingleChildScrollView(
//                             controller: scrollController,
//                             physics: NeverScrollableScrollPhysics(),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Center(
//                                   child: Container(
//                                     width: 80,
//                                     height: 0,
//                                     margin: EdgeInsets.symmetric(vertical: 5),
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(5),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 Obx(() {
//                                   return qc.sheetHeight.value < 165 &&
//                                           qc.sheetHeight.value != 100.0
//                                       ? Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 20.0),
//                                           child: SingleChildScrollView(
//                                             scrollDirection: Axis.horizontal,
//                                             physics: BouncingScrollPhysics(),
//                                             child: Row(
//                                               children: [
//                                                 Container(
//                                                   height: 80,
//                                                   width: 80,
//                                                   decoration: BoxDecoration(
//                                                       color: Colors.white,
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               20)),
//                                                   child: Padding(
//                                                     padding: const EdgeInsets
//                                                         .symmetric(
//                                                         horizontal: 8.0),
//                                                     child: Column(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .center,
//                                                       children: [
//                                                         Icon(
//                                                           Icons.edit,
//                                                           color: Colors.black
//                                                               .withOpacity(0.7),
//                                                           size: 26,
//                                                         ),
//                                                         SizedBox(
//                                                           height: 3,
//                                                         ),
//                                                         Text(
//                                                           'Edit',
//                                                           style: TextStyle(
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w600,
//                                                               fontSize: 12),
//                                                         )
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 8,
//                                                 ),
//                                                 InkWell(
//                                                   onTap: () {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                           builder: (context) =>
//                                                               pdfview()),
//                                                     );
//                                                   },
//                                                   child: Container(
//                                                     height: 80,
//                                                     width: 80,
//                                                     decoration: BoxDecoration(
//                                                         color: Colors.white,
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(20)),
//                                                     child: Padding(
//                                                       padding: const EdgeInsets
//                                                           .symmetric(
//                                                           horizontal: 8.0),
//                                                       child: Column(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .center,
//                                                         children: [
//                                                           Icon(
//                                                             Icons
//                                                                 .picture_as_pdf_outlined,
//                                                             color: Colors.black
//                                                                 .withOpacity(
//                                                                     0.7),
//                                                             size: 26,
//                                                           ),
//                                                           SizedBox(
//                                                             height: 3,
//                                                           ),
//                                                           Text(
//                                                             'View Pdf',
//                                                             style: TextStyle(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w600,
//                                                                 fontSize: 12),
//                                                           )
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 8,
//                                                 ),
//                                                 Container(
//                                                   height: 80,
//                                                   width: 80,
//                                                   decoration: BoxDecoration(
//                                                       color: Colors.white,
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               20)),
//                                                   child: Padding(
//                                                     padding: const EdgeInsets
//                                                         .symmetric(
//                                                         horizontal: 8.0),
//                                                     child: Column(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .center,
//                                                       children: [
//                                                         Icon(
//                                                           Icons.payments,
//                                                           color: Colors.black
//                                                               .withOpacity(0.7),
//                                                           size: 26,
//                                                         ),
//                                                         SizedBox(
//                                                           height: 3,
//                                                         ),
//                                                         Text(
//                                                           'Payment',
//                                                           style: TextStyle(
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w600,
//                                                               fontSize: 12),
//                                                         )
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 8,
//                                                 ),
//                                                 Container(
//                                                   height: 80,
//                                                   width: 80,
//                                                   decoration: BoxDecoration(
//                                                       color: Colors.white,
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               20)),
//                                                   child: Padding(
//                                                     padding: const EdgeInsets
//                                                         .symmetric(
//                                                         horizontal: 8.0),
//                                                     child: Column(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .center,
//                                                       children: [
//                                                         Icon(
//                                                           Icons.send,
//                                                           color: Colors.black
//                                                               .withOpacity(0.7),
//                                                           size: 26,
//                                                         ),
//                                                         SizedBox(
//                                                           height: 3,
//                                                         ),
//                                                         Text(
//                                                           'Send Bill',
//                                                           style: TextStyle(
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w600,
//                                                               fontSize: 12),
//                                                         )
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         )
//                                       : Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 20.0),
//                                           child: SingleChildScrollView(
//                                             scrollDirection: Axis.horizontal,
//                                             physics: BouncingScrollPhysics(),
//                                             child: Row(
//                                               children: [
//                                                 InkWell(
//                                                   onTap: () {
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                           builder: (context) =>
//                                                               pdfview()),
//                                                     );
//                                                   },
//                                                   child: Container(
//                                                     height: 40,
//                                                     decoration: BoxDecoration(
//                                                         color: Colors.blueAccent
//                                                             .withOpacity(0.16),
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(20)),
//                                                     child: Padding(
//                                                       padding: const EdgeInsets
//                                                           .symmetric(
//                                                           horizontal: 8.0),
//                                                       child: Row(
//                                                         children: [
//                                                           Icon(
//                                                             Icons
//                                                                 .picture_as_pdf_outlined,
//                                                             color: Colors
//                                                                 .blueAccent,
//                                                             size: 17,
//                                                           ),
//                                                           SizedBox(
//                                                             width: 3,
//                                                           ),
//                                                           Text(
//                                                             'View PDF',
//                                                             style: TextStyle(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w600,
//                                                                 fontSize: 12),
//                                                           )
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 8,
//                                                 ),
//                                                 Container(
//                                                   height: 40,
//                                                   decoration: BoxDecoration(
//                                                       color: Colors.blueAccent
//                                                           .withOpacity(0.16),
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               20)),
//                                                   child: Padding(
//                                                     padding: const EdgeInsets
//                                                         .symmetric(
//                                                         horizontal: 8.0),
//                                                     child: Row(
//                                                       children: [
//                                                         Icon(
//                                                           Icons.attach_money,
//                                                           color:
//                                                               Colors.blueAccent,
//                                                           size: 17,
//                                                         ),
//                                                         SizedBox(
//                                                           width: 3,
//                                                         ),
//                                                         Text(
//                                                           'Record Payment',
//                                                           style: TextStyle(
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w600,
//                                                               fontSize: 12),
//                                                         )
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 8,
//                                                 ),
//                                                 //TODO: Add Thermal Print Functionality
//                                                 InkWell(
//                                                   onTap: (){
//                                                     showDialog(
//                                                       context: context,
//                                                       builder: (BuildContext context) {
//                                                         return ThermalPrintDialog();
//                                                       },
//                                                     );
//                                                   },
//                                                   child: Container(
//                                                     height: 40,
//                                                     decoration: BoxDecoration(
//                                                         color: Colors.blueAccent
//                                                             .withOpacity(0.16),
//                                                         borderRadius:
//                                                             BorderRadius.circular(
//                                                                 20)),
//                                                     child: Padding(
//                                                       padding: const EdgeInsets
//                                                           .symmetric(
//                                                           horizontal: 8.0),
//                                                       child: Row(
//                                                         children: [
//                                                           Icon(
//                                                             Icons.note_outlined,
//                                                             color:
//                                                                 Colors.blueAccent,
//                                                             size: 17,
//                                                           ),
//                                                           SizedBox(
//                                                             width: 3,
//                                                           ),
//                                                           Text(
//                                                             'Thermal Print',
//                                                             style: TextStyle(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w600,
//                                                                 fontSize: 12),
//                                                           )
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 8,
//                                                 ),
//                                                 Container(
//                                                   height: 40,
//                                                   decoration: BoxDecoration(
//                                                       color: Colors.blueAccent
//                                                           .withOpacity(0.16),
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               20)),
//                                                   child: Padding(
//                                                     padding: const EdgeInsets
//                                                         .symmetric(
//                                                         horizontal: 8.0),
//                                                     child: Row(
//                                                       children: [
//                                                         Icon(
//                                                           Icons.send,
//                                                           color:
//                                                               Colors.blueAccent,
//                                                           size: 17,
//                                                         ),
//                                                         SizedBox(
//                                                           width: 3,
//                                                         ),
//                                                         Text(
//                                                           'Send Bill',
//                                                           style: TextStyle(
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w600,
//                                                               fontSize: 12),
//                                                         )
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 6,
//                                                 ),
//                                                 Container(
//                                                   height: 40,
//                                                   decoration: BoxDecoration(
//                                                       color: Colors.blueAccent
//                                                           .withOpacity(0.16),
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               20)),
//                                                   child: Padding(
//                                                     padding: const EdgeInsets
//                                                         .symmetric(
//                                                         horizontal: 8.0),
//                                                     child: Row(
//                                                       children: [
//                                                         Icon(
//                                                           Icons
//                                                               .change_circle_outlined,
//                                                           color:
//                                                               Colors.blueAccent,
//                                                           size: 17,
//                                                         ),
//                                                         SizedBox(
//                                                           width: 3,
//                                                         ),
//                                                         Text(
//                                                           'Convert To Sales',
//                                                           style: TextStyle(
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w600,
//                                                               fontSize: 12),
//                                                         )
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         );
//                                 }),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 20.0, vertical: 10),
//                                   child: SingleChildScrollView(
//                                     physics: BouncingScrollPhysics(),
//                                     child: Container(
//                                       width: width,
//                                       height: height * 0.45,
//                                       decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius:
//                                               BorderRadius.circular(10)),
//                                       child: SingleChildScrollView(
//                                         // controller: scrollController,
//                                         child: Column(
//                                           children: [
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 15.0),
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   Row(
//                                                     children: [
//                                                       Icon(Icons
//                                                           .delivery_dining),
//                                                       SizedBox(
//                                                         width: 15,
//                                                       ),
//                                                       Text('Delivery Challan'),
//                                                     ],
//                                                   ),
//                                                   Container(
//                                                     decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               100),
//                                                       border: Border.all(
//                                                         color: Colors.red
//                                                             .withOpacity(0.4),
//                                                         width: 4,
//                                                       ),
//                                                     ),
//                                                     child: CircleAvatar(
//                                                       backgroundColor:
//                                                           Colors.red,
//                                                       radius: 9,
//                                                       child: Icon(
//                                                         Icons.play_arrow,
//                                                         size: 14,
//                                                         color: Colors.white,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Container(
//                                               height: 1,
//                                               width: width,
//                                               decoration: BoxDecoration(
//                                                   color: Colors.grey
//                                                       .withOpacity(0.2)),
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 15.0),
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   Row(
//                                                     children: [
//                                                       Icon(Icons
//                                                           .control_point_duplicate),
//                                                       SizedBox(
//                                                         width: 15,
//                                                       ),
//                                                       Text('Duplicate'),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Container(
//                                               height: 1,
//                                               width: width,
//                                               decoration: BoxDecoration(
//                                                   color: Colors.grey
//                                                       .withOpacity(0.2)),
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 15.0),
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   Row(
//                                                     children: [
//                                                       Icon(Icons.print),
//                                                       SizedBox(
//                                                         width: 15,
//                                                       ),
//                                                       Text('Thermal Print'),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Container(
//                                               height: 1,
//                                               width: width,
//                                               decoration: BoxDecoration(
//                                                   color: Colors.grey
//                                                       .withOpacity(0.2)),
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 15.0),
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   Row(
//                                                     children: [
//                                                       Icon(
//                                                           Icons.email_outlined),
//                                                       SizedBox(
//                                                         width: 15,
//                                                       ),
//                                                       Text('Send Email'),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Container(
//                                               height: 1,
//                                               width: width,
//                                               decoration: BoxDecoration(
//                                                   color: Colors.grey
//                                                       .withOpacity(0.2)),
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 15.0),
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   Row(
//                                                     children: [
//                                                       Icon(Icons
//                                                           .sms_failed_outlined),
//                                                       SizedBox(
//                                                         width: 15,
//                                                       ),
//                                                       Text('Send SMS'),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Container(
//                                               height: 1,
//                                               width: width,
//                                               decoration: BoxDecoration(
//                                                   color: Colors.grey
//                                                       .withOpacity(0.2)),
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 15.0),
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   Row(
//                                                     children: [
//                                                       Icon(Icons
//                                                           .change_circle_outlined),
//                                                       SizedBox(
//                                                         width: 15,
//                                                       ),
//                                                       Text(
//                                                           'Convert to Sale'),
//                                                     ],
//                                                   ),
//                                                   Container(
//                                                     decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               100),
//                                                       border: Border.all(
//                                                         color: Colors.red
//                                                             .withOpacity(0.4),
//                                                         width: 4,
//                                                       ),
//                                                     ),
//                                                     child: CircleAvatar(
//                                                       backgroundColor:
//                                                           Colors.red,
//                                                       radius: 9,
//                                                       child: Icon(
//                                                         Icons.play_arrow,
//                                                         size: 14,
//                                                         color: Colors.white,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Container(
//                                               height: 1,
//                                               width: width,
//                                               decoration: BoxDecoration(
//                                                   color: Colors.grey
//                                                       .withOpacity(0.2)),
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 15.0),
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   Row(
//                                                     children: [
//                                                       Icon(Icons
//                                                           .fire_truck_outlined),
//                                                       SizedBox(
//                                                         width: 15,
//                                                       ),
//                                                       Text('Create E-way Bill'),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Container(
//                                               height: 1,
//                                               width: width,
//                                               decoration: BoxDecoration(
//                                                   color: Colors.grey
//                                                       .withOpacity(0.2)),
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 15.0),
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   Row(
//                                                     children: [
//                                                       Icon(Icons
//                                                           .file_copy_outlined),
//                                                       SizedBox(
//                                                         width: 15,
//                                                       ),
//                                                       Text('Create E-invoice'),
//                                                     ],
//                                                   ),
//                                                   Container(
//                                                     decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               100),
//                                                       border: Border.all(
//                                                         color: Colors.red
//                                                             .withOpacity(0.4),
//                                                         width: 4,
//                                                       ),
//                                                     ),
//                                                     child: CircleAvatar(
//                                                       backgroundColor:
//                                                           Colors.red,
//                                                       radius: 9,
//                                                       child: Icon(
//                                                         Icons.play_arrow,
//                                                         size: 14,
//                                                         color: Colors.white,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Container(
//                                               height: 1,
//                                               width: width,
//                                               decoration: BoxDecoration(
//                                                   color: Colors.grey
//                                                       .withOpacity(0.2)),
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 15.0),
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   Row(
//                                                     children: [
//                                                       Icon(Icons.qr_code),
//                                                       SizedBox(
//                                                         width: 15,
//                                                       ),
//                                                       Text('Generate QR Code'),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Container(
//                                               height: 1,
//                                               width: width,
//                                               decoration: BoxDecoration(
//                                                   color: Colors.grey
//                                                       .withOpacity(0.2)),
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 15.0),
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   Row(
//                                                     children: [
//                                                       Icon(Icons.settings),
//                                                       SizedBox(
//                                                         width: 15,
//                                                       ),
//                                                       Text('Document Setting'),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Container(
//                                               height: 1,
//                                               width: width,
//                                               decoration: BoxDecoration(
//                                                   color: Colors.grey
//                                                       .withOpacity(0.2)),
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 15.0),
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   Row(
//                                                     children: [
//                                                       Icon(
//                                                           Icons.cancel_outlined,
//                                                           color: Colors.red
//                                                               .withOpacity(
//                                                                   0.7)),
//                                                       SizedBox(
//                                                         width: 15,
//                                                       ),
//                                                       Text(
//                                                         'Cancel invoice',
//                                                         style: TextStyle(
//                                                             color: Colors.red),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   Container(
//                                                     decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               100),
//                                                       border: Border.all(
//                                                         color: Colors.red
//                                                             .withOpacity(0.4),
//                                                         width: 4,
//                                                       ),
//                                                     ),
//                                                     child: CircleAvatar(
//                                                       backgroundColor:
//                                                           Colors.red,
//                                                       radius: 9,
//                                                       child: Icon(
//                                                         Icons.play_arrow,
//                                                         size: 14,
//                                                         color: Colors.white,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Container(
//                                               height: 1,
//                                               width: width,
//                                               decoration: BoxDecoration(
//                                                   color: Colors.grey
//                                                       .withOpacity(0.2)),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                                 // Add your additional widgets here
//                               ],
//                             ),
//                           ),
//                         ));
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
// }
