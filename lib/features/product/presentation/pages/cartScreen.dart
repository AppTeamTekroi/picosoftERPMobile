import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mobile_erp/core/enum/post_enum_response.dart';
import 'package:mobile_erp/features/customer/controller/customer_controller.dart';
import 'package:mobile_erp/features/product/controller/product_controller.dart';
import 'package:mobile_erp/ui/color/appColor.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class CartScreen extends StatefulWidget {
  String? customerId;
  CartScreen({super.key, required this.customerId});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  ProductController pc = Get.put(ProductController());
  CustomerController cc = Get.find<CustomerController>();

  @override
  void initState() {
    // TODO: implement initState
    //  print( cc.selectedCustomer.value?.id);
    pc.getCartItemDetailsList(cc.selectedCustomer.value?.id.toString());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 70,
        leadingWidth: 40,
        backgroundColor: AppColors.white,
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
        title: Text('Cart'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: () async {
                var res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SimpleBarcodeScannerPage(),
                    ));
                if (res != null && res is String) {
                  print('response from barcode: ${res}');
                  //  PostResponseType res = await pc.postAddToCart(
                  //                   widget.product.id.toString(),
                  //                   cc.selectedCustomer.value?.id.toString() ??
                  //                       '',
                  //                   selectedQty.value.toString());
                  //               // print(res.postResponseEnum);
                  //               if (res.postResponseEnum ==
                  //                   PostResponseEnum.success) {
                  //                 Get.showSnackbar(GetSnackBar(
                  //                   title: 'Success',
                  //                   message: 'Product Added to Cart',
                  //                   snackPosition: SnackPosition.BOTTOM,
                  //                   backgroundColor: AppColors.mainblue,
                  //                   duration:
                  //                       const Duration(milliseconds: 1000),
                  //                 ));
                  //               }
                  await pc.getProductFromBarcode(res);
                  if (pc.getBarcodeSearchDetailList.isNotEmpty) {
                    PostResponseType res = await pc.postAddToCart(
                        pc.getBarcodeSearchDetailList[0].id.toString(),
                        cc.selectedCustomer.value?.id.toString() ?? '',
                        '1');
                    // print(res.postResponseEnum);
                    if (res.postResponseEnum == PostResponseEnum.success) {
                      // Get.showSnackbar(GetSnackBar(
                      //   title: 'Success',
                      //   message: 'Product Added to Cart',
                      //   snackPosition: SnackPosition.BOTTOM,
                      //   backgroundColor: AppColors.mainblue,
                      //   duration: const Duration(milliseconds: 1000),
                      // ));
                    }
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => BarcodeSearchedProductScreen(
                    //         barcodeData: res,
                    //         onUpdate: () {
                    //           // setState(() {});
                    //         },
                    //         selectedProducts: selectedProducts,
                    //       ),
                    //     ));
                    print('we got a product with same barcode');
                  } else {
                    print('we cant find anything');
                  }
                  // Navigator.push(
                  //     context,
                  //     CupertinoPageRoute(
                  //         builder: (context) => BarcodeSearchedProductScreen(
                  //               barcodeData: res,
                  //               onUpdate: () {
                  //                 // setState(() {});
                  //               },
                  //               selectedProducts: selectedProducts,
                  //             )));
                }
                // print('response from barcode: ${res}');
              },
              child: FaIcon(
                FontAwesomeIcons.barcode,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () =>
                // () => pc.cartLoading.value == true
                //     ? Expanded(
                //         child: Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: ListView.builder(
                //               itemCount: 20,
                //               // itemCount: pc.getProductDetailList.length,
                //               itemBuilder: (context, index) {
                //                 return Container(
                //                   height: 150,
                //                   width: double.infinity,
                //                   decoration: BoxDecoration(
                //                     color: Colors.grey.shade200,
                //                     borderRadius: BorderRadius.circular(10),
                //                   ),
                //                   child: Column(
                //                     children: [
                //                       Expanded(
                //                         child: Padding(
                //                           padding: const EdgeInsets.all(8.0),
                //                           // child: Shimmer.fromColors(
                //                           // baseColor: Colors.grey.shade300,
                //                           // highlightColor: Colors.grey.shade100,
                //                           child: Container(
                //                             // height: 70,
                //                             // width: 60,
                //                             decoration: BoxDecoration(
                //                               color: Colors.grey.shade400,
                //                               borderRadius:
                //                                   BorderRadius.circular(10),
                //                             ),
                //                             // ),
                //                           ),
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 );
                //               }),
                //         ),
                //       )
                //     :
                Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: pc.cartItemDetailList.isEmpty
                    ? Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            "Cart is empty for this Customer",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ))
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: pc.cartItemDetailList.length,
                        itemBuilder: (context, index) {
                          final cartItem = pc.cartItemDetailList[index];
                          // print(product.stock_price);

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 13),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Container(
                                        height: 120,
                                        // width: 130,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          // Add other decoration properties as needed
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                              'lib/ui/assets/img.png',
                                            ),
                                            // height: 100,
                                            // width: 150,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: Get.width * 0.46,
                                          child: Text(
                                            cartItem.product_name ?? 'No Name',
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                overflow: TextOverflow.clip),
                                          ),
                                        ),
                                        // Container(
                                        //   width: Get.width * 0.46,
                                        //   child: Text.rich(
                                        //     TextSpan(
                                        //       children: [
                                        //         TextSpan(
                                        //             text: 'Product: ',
                                        //             style: TextStyle(
                                        //                 fontWeight:
                                        //                     FontWeight
                                        //                         .bold)),
                                        //         TextSpan(
                                        //           text: cartItem
                                        //                   .product_name ??
                                        //               'No Name',
                                        //           style: TextStyle(
                                        //               fontWeight:
                                        //                   FontWeight
                                        //                       .normal,
                                        //               overflow:
                                        //                   TextOverflow
                                        //                       .clip),
                                        //         ),
                                        //       ],
                                        //     ),
                                        //   ),
                                        // ),

                                        // Container(
                                        //   width: Get.width * 0.46,
                                        //   child: Text.rich(
                                        //     TextSpan(
                                        //       children: [
                                        //         TextSpan(
                                        //             text: 'Quantity: ',
                                        //             style: TextStyle(
                                        //                 fontWeight:
                                        //                     FontWeight
                                        //                         .w400)),
                                        //         TextSpan(
                                        //           text: cartItem
                                        //                   .quantities ??
                                        //               'Nil',
                                        //           style: TextStyle(
                                        //               fontWeight:
                                        //                   FontWeight
                                        //                       .normal),
                                        //         ),
                                        //       ],
                                        //     ),
                                        //   ),
                                        // ),
                                        // Container(
                                        //   width: Get.width * 0.46,
                                        //   child: Text.rich(
                                        //     TextSpan(
                                        //       children: [
                                        //         TextSpan(
                                        //             text: 'Discount: ',
                                        //             style: TextStyle(
                                        //                 fontWeight:
                                        //                     FontWeight
                                        //                         .w400)),
                                        //         TextSpan(
                                        //           text:
                                        //               cartItem.discount ??
                                        //                   '--',
                                        //           style: TextStyle(
                                        //               fontWeight:
                                        //                   FontWeight
                                        //                       .normal),
                                        //         ),
                                        //       ],
                                        //     ),
                                        //   ),
                                        // ),

                                        Container(
                                          width: Get.width * 0.46,
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                    text: 'Price: ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400)),
                                                TextSpan(
                                                  text: cartItem.price ?? '--',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: Get.width * 0.46,
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                    text: 'Total Amount: ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                TextSpan(
                                                  text: cartItem.total_amount ??
                                                      '--',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                // pc.calculateTotalAmount();
                                                // print(
                                                //     'as of now the total amount is ;  +${pc.totalAmount.value}');
                                                Get.dialog(
                                                  IgnorePointer(
                                                    ignoring: true,
                                                    child: Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  ),
                                                );
                                                PostResponseType res =
                                                    await pc.postremovefromCart(
                                                        cartItem.product_id
                                                            .toString(),
                                                        cc.selectedCustomer
                                                                .value?.id
                                                                .toString() ??
                                                            '',
                                                        0);
                                                Get.back();
                                                // print(res.postResponseEnum);
                                                if (res.postResponseEnum ==
                                                    PostResponseEnum.success) {
                                                  // Get.showSnackbar(
                                                  //     GetSnackBar(
                                                  //   title: 'Success',
                                                  //   message:
                                                  //       'Product Removed from Cart',
                                                  //   snackPosition:
                                                  //       SnackPosition
                                                  //           .BOTTOM,
                                                  //   backgroundColor:
                                                  //       AppColors
                                                  //           .mainblue,
                                                  //   duration:
                                                  //       const Duration(
                                                  //           milliseconds:
                                                  //               1000),
                                                  // ));
                                                }
                                              },
                                              child: Container(
                                                height: 26,
                                                width: 35,
                                                decoration: BoxDecoration(
                                                    color: Colors.orange
                                                        .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                // backgroundColor: selectedQty.value > 0
                                                //     ? AppColors.mainblue
                                                //     : Colors.grey,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 0,
                                                      vertical: 0),
                                                  child: const Icon(
                                                    Icons.remove,
                                                    size: 18,
                                                    color: Colors.orange,
                                                  ),
                                                ),
                                              ),
                                              // child: CircleAvatar(
                                              //   radius: 12,
                                              //   backgroundColor: selectedQty.value > 0
                                              //       ? AppColors.mainblue
                                              //       : Colors.grey,
                                              //   child: const Icon(
                                              //     Icons.remove,
                                              //     size: 15,
                                              //     color: Colors.white,
                                              //   ),
                                              // ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                              ),
                                              child: Text(
                                                double.tryParse(cartItem
                                                                .quantities ??
                                                            '')
                                                        ?.toStringAsFixed(1) ??
                                                    '',
                                                style: const TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            // Obx(
                                            //   () =>
                                            InkWell(
                                              onTap: () async {
                                                Get.dialog(
                                                  IgnorePointer(
                                                    ignoring: true,
                                                    child: Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  ),
                                                );
                                                PostResponseType res =
                                                    await pc.postAddToCart(
                                                        cartItem.product_id
                                                            .toString(),
                                                        cc.selectedCustomer
                                                                .value?.id
                                                                .toString() ??
                                                            '',
                                                        '1');
                                                Get.back();
                                                // print(res.postResponseEnum);
                                                if (res.postResponseEnum ==
                                                    PostResponseEnum.success) {
                                                  // Get.showSnackbar(
                                                  //     GetSnackBar(
                                                  //   title: 'Success',
                                                  //   message:
                                                  //       'Product Added to Cart',
                                                  //   snackPosition:
                                                  //       SnackPosition
                                                  //           .BOTTOM,
                                                  //   backgroundColor:
                                                  //       AppColors
                                                  //           .mainblue,
                                                  //   duration:
                                                  //       const Duration(
                                                  //           milliseconds:
                                                  //               1000),
                                                  // ));
                                                }
                                              },
                                              child: Container(
                                                height: 26,
                                                width: 35,
                                                decoration: BoxDecoration(
                                                    color: Colors.orange
                                                        .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                // backgroundColor: selectedQty.value > 0
                                                //     ? AppColors.mainblue
                                                //     : Colors.grey,
                                                child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 0,
                                                        vertical: 0),
                                                    child:
                                                        // pc.addToCartLoading
                                                        //             .value ==
                                                        //         false
                                                        //     ?
                                                        const Icon(
                                                      Icons.add,
                                                      size: 17,
                                                      color: Colors.orange,
                                                    )
                                                    // : Padding(
                                                    //     padding: const EdgeInsets
                                                    //         .symmetric(
                                                    //         horizontal:
                                                    //             8,
                                                    //         vertical:
                                                    //             4),
                                                    //     child:
                                                    //         CircularProgressIndicator(
                                                    //       color: Color.fromARGB(
                                                    //           255,
                                                    //           255,
                                                    //           123,
                                                    //           0),
                                                    //       strokeWidth:
                                                    //           2,
                                                    //     ),
                                                    //   ),
                                                    ),
                                              ),
                                            ),
                                            // ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
