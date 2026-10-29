import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mobile_erp/features/Quotation/presentation/pages/quotation.dart';
import 'package:mobile_erp/features/customer/controller/customer_controller.dart';
import 'package:mobile_erp/features/customer/data/model/get_customer_model.dart';
import 'package:mobile_erp/features/product/controller/product_controller.dart';
import 'package:mobile_erp/features/product/data/model/get_product_data_model.dart';
import 'package:mobile_erp/features/product/presentation/pages/add_product.dart';
import 'package:mobile_erp/features/product/presentation/pages/barcode_searched_product.dart';
import 'package:mobile_erp/features/product/presentation/pages/cartScreen.dart';
import 'package:mobile_erp/features/product/presentation/widget/productCard.dart';
import 'package:mobile_erp/ui/color/appColor.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class NavProductScreen extends StatefulWidget {
  NavProductScreen({super.key});

  @override
  State<NavProductScreen> createState() => _NavProductScreenState();
}

class _NavProductScreenState extends State<NavProductScreen> {
  ProductController pc = Get.put(ProductController());
  CustomerController cc = Get.find();

  final List<getProductDataModel> selectedProducts = [];

  @override
  void dispose() {
    // TODO: implement dispose
    // pc.count.value = 0.0;
    pc.clearDetails();

    pc.searchProductByName('');
    cc.initializeVariables(billing: true, shipping: true);
    // pc.getProductDetailsList();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('${selectedProducts.length}: selected products from products screen');
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 70,
        leadingWidth: 40,
        backgroundColor: AppColors.white,
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
                hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                border: InputBorder.none,
              ),
              onChanged: (val) {
                pc.searchProduct.value = val;
                pc.searchProductByName(pc.searchProduct.value);
              },
            ),
          ),
        ),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 15),
        //     child: GestureDetector(
        //       onTap: () async {
        //         var res = await Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => const SimpleBarcodeScannerPage(),
        //             ));
        //         if (res != null && res is String) {
        //           Navigator.push(
        //               context,
        //               CupertinoPageRoute(
        //                   builder: (context) => BarcodeSearchedProductScreen(
        //                         barcodeData: res,
        //                         onUpdate: () {
        //                           setState(() {});
        //                         },
        //                       )));
        //         }
        //         // print('response from barcode: ${res}');
        //       },
        //       child: FaIcon(
        //         FontAwesomeIcons.barcode,
        //         color: Colors.black,
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () => pc.getProductDetailList.isEmpty
                ? Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: 40,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => AddProduct()),
                        ),
                      );
                    },
                    child: Container(
                      height: 30,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle,
                            color: Colors.grey.shade600,
                            size: 17,
                          ),
                          Text(
                            "Add New Product",
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
                                  mainAxisSpacing: 10.0, // spacing between rows
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
                          physics: BouncingScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      2, // number of items in each row
                                  mainAxisSpacing: 10.0, // spacing between rows
                                  crossAxisSpacing:
                                      10.0, // spacing between columns
                                  childAspectRatio: 0.78),
                          itemCount: pc.searchedProductDetailList.length,
                          // itemCount: pc.getProductDetailList.length,
                          itemBuilder: (context, index) {
                            // final product = pc.getProductDetailList[index];
                            final product = pc.searchedProductDetailList[index];
                            print(product.stock_price);
                            if (pc.getProductDetailList.isEmpty) {
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
                                // child: ProductCard(product: product)
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
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
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8),
                                        child: Text(
                                          product.name ?? 'Null',
                                          style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "₹ ${product.stock_price}",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          }),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
