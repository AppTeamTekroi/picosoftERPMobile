import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mobile_erp/features/Quotation/presentation/pages/quotation.dart';
import 'package:mobile_erp/features/product/controller/product_controller.dart';
import 'package:mobile_erp/features/product/data/model/get_product_data_model.dart';
import 'package:mobile_erp/features/product/presentation/pages/add_product.dart';
import 'package:mobile_erp/features/product/presentation/widget/productCard.dart';
import 'package:mobile_erp/ui/color/appColor.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class BarcodeSearchedProductScreen extends StatefulWidget {
  String? barcodeData;
  List<getProductDataModel>? selectedProducts;
  VoidCallback onUpdate;
  BarcodeSearchedProductScreen(
      {super.key,
      required this.barcodeData,
      required this.onUpdate,
      this.selectedProducts});

  @override
  State<BarcodeSearchedProductScreen> createState() =>
      _BarcodeSearchedProductScreenState();
}

class _BarcodeSearchedProductScreenState
    extends State<BarcodeSearchedProductScreen> {
  ProductController pc = Get.put(ProductController());

  // final List<getProductDataModel> selectedProducts = [];
  @override
  void initState() {
    pc.getProductFromBarcode(widget.barcodeData ?? '');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('${selectedProducts.length}: selected products');
    return WillPopScope(
      onWillPop: () async {
        widget.onUpdate();
        SchedulerBinding.instance.addPostFrameCallback((_) {
          //The provided callback is run immediately after a frame, just after the persistent frame callbacks (which is when the main rendering pipeline has been flushed)
          pc.searchProductByName('');
        });
        return true;
      },
      child: Scaffold(
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
          title: Container(
            margin: EdgeInsets.only(right: 0, left: 0),
            decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 5),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search Products",
                  suffixIcon: Obx(
                    () => pc.searchProduct.isNotEmpty
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
                  hintStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  border: InputBorder.none,
                ),
                onChanged: (val) {
                  pc.searchProduct.value = val;
                  pc.searchProductByName(pc.searchProduct.value);
                },
              ),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => pc.detailLoading.value == true
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        2, // number of items in each row
                                    mainAxisSpacing:
                                        10.0, // spacing between rows
                                    crossAxisSpacing:
                                        10.0, // spacing between columns
                                    childAspectRatio: 0.65),
                            itemCount: 20,
                            // itemCount: pc.getProductDetailList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          // child: Shimmer.fromColors(
                                          // baseColor: Colors.grey.shade300,
                                          // highlightColor: Colors.grey.shade100,
                                          child: Container(
                                            // height: 70,
                                            // width: 60,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade400,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            // ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 8),
                                        child: Container(
                                          height: 20,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade400,
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Container(
                                          height: 30,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade400,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    )
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        2, // number of items in each row
                                    mainAxisSpacing:
                                        10.0, // spacing between rows
                                    crossAxisSpacing:
                                        10.0, // spacing between columns
                                    childAspectRatio: 0.65),
                            itemCount: pc.searchedProductDetailList.length,
                            // itemCount: pc.getProductDetailList.length,
                            itemBuilder: (context, index) {
                              // final product = pc.getProductDetailList[index];
                              // final product =
                              //     pc.getBarcodeSearchDetailList[index];
                              final product =
                                  pc.searchedProductDetailList[index];
                              print(product.stock_price);
                              if (pc.searchedProductDetailList.isEmpty) {
                                return Center(
                                    child: Column(
                                  children: [
                                    SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: CircularProgressIndicator(
                                          color: AppColors.mainblue,
                                        )),
                                    SizedBox(height: 10),
                                    Text("loading..."),
                                  ],
                                ));
                              } else {
                                return IntrinsicHeight(
                                    child: ProductCard(product: product));
                              }
                            }),
                      ),
                    ),
            ),
            // Spacer(),
            Obx(() {
              return Visibility(
                visible: pc.totalAmount > 0,
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 65,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row(
                          //   children: [
                          //     RichText(
                          //       text: TextSpan(
                          //           text: "Items: ",
                          //           style: TextStyle(
                          //             fontSize: 16,
                          //             color: Colors.grey.shade600,
                          //           ),
                          //           children: [
                          //             TextSpan(
                          //               text: "${pc.selectedProducts.length}",
                          //               style: TextStyle(
                          //                 color: Colors.black,
                          //                 fontWeight: FontWeight.bold,
                          //               ),
                          //             ),
                          //           ]),
                          //     ),
                          //     SizedBox(
                          //       width: 10,
                          //     ),
                          //     RichText(
                          //       text: TextSpan(
                          //         text: "Qty: ",
                          //         style: TextStyle(
                          //           fontSize: 16,
                          //           color: Colors.grey.shade600,
                          //         ),
                          //         children: [
                          //           TextSpan(
                          //             text: "",
                          //             style: TextStyle(
                          //               color: Colors.black,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          RichText(
                            text: TextSpan(
                              text: "Amount: ",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                              children: [
                                TextSpan(
                                  text: "₹ ${pc.subtotal}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          // pc.selectedProducts.value =
                          //     pc.searchedProductDetailList.where((product) {
                          //   if (product.selectedQty != null &&
                          //       product.selectedQty! > 0) {
                          //     pc.showDes.add(false);
                          //     return true;
                          //   }
                          //   return false;
                          // }).toList();
                          pc.selectedProducts.addAll(
                            pc.searchedProductDetailList.where((product) {
                              if (product.selectedQty != null &&
                                  product.selectedQty! > 0) {
                                pc.showDes.add(false);
                                return true;
                              }
                              return false;
                            }).toList(),
                          );
                          // pc.selectedProducts.addAll(
                          //   pc.searchedProductDetailList.where((product) {
                          //     if (product.selectedQty != null &&
                          //         product.selectedQty! > 0) {
                          //       var existingProductIndex =
                          //           pc.selectedProducts.indexWhere(
                          //         (selectedProduct) =>
                          //             selectedProduct.id == product.id,
                          //       );

                          //       if (existingProductIndex != -1) {
                          //         var existingProduct =
                          //             pc.selectedProducts[existingProductIndex];
                          //         if (existingProduct.selectedQty !=
                          //             product.selectedQty) {
                          //           // Product already exists and its quantity has changed, update quantity
                          //           existingProduct.selectedQty =
                          //               product.selectedQty!;
                          //           pc.showDes.add(false);
                          //         }
                          //         return false; // Don't add the product again
                          //       } else {
                          //         pc.showDes.add(false);
                          //         return true; // Add the product to the list
                          //       }
                          //     }
                          //     return false; // Don't add products with a quantity of 0
                          //   }).toList(),
                          // );
                          Navigator.of(context)
                            ..pop()
                            ..pop();
                          // Navigator.push(
                          //     context,
                          //     CupertinoPageRoute(
                          //         builder: (context) => QuotationScreen()));
                        },
                        child: Container(
                          height: double.maxFinite,
                          width: 130,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.mainblue,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Continue",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 16,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
