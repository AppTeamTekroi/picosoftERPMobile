import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mobile_erp/core/enum/post_enum_response.dart';
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

class SelectProductScreen extends StatefulWidget {
  CustomersModel? customer;
  SelectProductScreen({super.key, this.customer});

  @override
  State<SelectProductScreen> createState() => _SelectProductScreenState();
}

class _SelectProductScreenState extends State<SelectProductScreen> {
  ProductController pc = Get.find();
  CustomerController cc = Get.find();
  @override
  void initState() {
    pc.getCartItemDetailsList(cc.selectedCustomer.value?.id.toString());
    // pc.calculateamount();

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // pc.count.value = 0.0;
    // pc.clearDetails();

    pc.searchProductByName('');
    cc.initializeVariables(billing: true, shipping: true);
    // pc.getProductDetailsList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pc.setCartProductInitally();
    });
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
                      Get.showSnackbar(GetSnackBar(
                        title: 'Success',
                        message: 'Product Added to Cart',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.mainblue,
                        duration: const Duration(milliseconds: 1000),
                      ));
                    }
                    print('we got a product with same barcode');
                  } else {
                    print('we cant find anything');
                  }
                }
                // print('response from barcode: ${res}');
              },
              child: FaIcon(
                FontAwesomeIcons.barcode,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartScreen(
                            customerId: widget.customer?.id.toString()),
                      ));
                },
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.black,
                )),
          )
        ],
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
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      2, // number of items in each row
                                  mainAxisSpacing: 10.0, // spacing between rows
                                  crossAxisSpacing:
                                      10.0, // spacing between columns
                                  childAspectRatio: 0.65),
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
                                  child: ProductCard(product: product));
                            }
                          }),
                    ),
                  ),
          ),
          // Spacer(),
          Obx(() {
            return Visibility(
              visible: pc.calculateamount() > 0.0,
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
                        RichText(
                          text: TextSpan(
                            text: "Amount: ",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                            children: [
                              TextSpan(
                                text: "₹ ${pc.calculateamount()}",
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
                        pc.setCartProductInitally();

                        // for (var product in pc.getProductDetailList) {
                        //   if (product.selectedQty == null) {
                        //   } else {
                        //     if (product.selectedQty! > 0) {
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
                        //         }
                        //       } else {
                        //         pc.selectedProducts.add(product);
                        //         pc.showDes.add(false);
                        //       }
                        //     }
                        //   }
                        // }

                        Navigator.pop(context, pc.selectedProducts);
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
    );
  }
}
