import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_erp/core/enum/post_enum_response.dart';
import 'package:mobile_erp/features/customer/controller/customer_controller.dart';
import 'package:mobile_erp/features/product/controller/product_controller.dart';
import 'package:mobile_erp/features/product/data/model/get_product_data_model.dart';
import 'package:mobile_erp/ui/Buttons/buttonBS.dart';
import 'package:mobile_erp/ui/color/appColor.dart';

class ProductCard extends StatefulWidget {
  final getProductDataModel product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  ProductController pc = Get.find<ProductController>();
  CustomerController cc = Get.find<CustomerController>();
  late RxDouble selectedQty;
  late String? productName;
  late RxDouble? price;
  late double? priceWithTax;
  late String? productDes;
  var tot;
  var totalamt;

  FocusNode amountFocusNode = FocusNode();

  List<IconData> stylingIcons = [
    Icons.format_bold,
    Icons.format_italic,
    Icons.format_underline,
    Icons.format_list_numbered,
    Icons.format_list_bulleted
  ];

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

  @override
  void initState() {
    pc.getCartItemDetailsList(cc.selectedCustomer.value?.id.toString());

    print("Selected Quantity: ${widget.product.selectedQty}");
    selectedQty = RxDouble(widget.product.selectedQty ?? 0.00);
    productName = widget.product.name ?? 'Null';
    price = RxDouble(double.parse(widget.product.stock_price ?? '0.00'));
    priceWithTax = (price!.value ?? 0.00) + ((price!.value ?? 0.00) * 0.18);
    productDes = widget.product.description;
    // print('description found : ${productDes}');
    super.initState();
  }

  void _updateSelectedQty(double newValue) {
    selectedQty.value = newValue;
    // print('updated selected qty ; ${selectedQty.value}');
    widget.product.selectedQty = newValue;
    print('updated selected qty int product; ${widget.product.selectedQty}');
    pc.calculateTotalAmount();
  }

  void _updateUnitPrice(double newPrice) {
    price!.value = newPrice;
    // widget.product.price = newPrice;
    pc.calculateTotalAmount();
  }

  @override
  Widget build(BuildContext context) {
    int value = 0;
    print("Hello21");

    selectedQty = RxDouble(widget.product.selectedQty ?? 0.0);
    if (widget.product.name != null && widget.product.name!.isEmpty) {
      value++;
    }
    if (value != 0) {
      return const Center(
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
      print("wassup");
      return Obx(() {
        return Container(
          // height: 600,
          // width: double.maxFinite,
          // margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColors.white,
            border: Border.all(
              color: Colors.grey.shade100,
              width: 0.2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    // Add other decoration properties as needed
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
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
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Text(
                  widget.product.name ?? 'Null',
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Text(
                "₹ ${widget.product.stock_price}",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              // Obx(
              //   () =>
              int.parse(pc.getquantity(widget.product.name!).split('.').first) >
                      0
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if (int.parse(pc
                                      .getquantity(widget.product.name!)
                                      .split('.')
                                      .first) >
                                  0) {
                                // _updateSelectedQty(selectedQty.value - 1);
                                pc.calculateTotalAmount();
                                print(
                                    'as of now the total amount is ;  +${pc.totalAmount.value}');
                                Get.dialog(
                                  IgnorePointer(
                                    ignoring: true,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                );

                                PostResponseType res =
                                    await pc.postremovefromCart(
                                        widget.product.id.toString(),
                                        cc.selectedCustomer.value?.id
                                                .toString() ??
                                            '',
                                        0);

                                Get.back();
                                // print(res.postResponseEnum);
                                if (res.postResponseEnum ==
                                    PostResponseEnum.success) {
                                  widget.product.selectedQty = int.parse(pc
                                          .getquantity(widget.product.name!)
                                          .split('.')
                                          .first)
                                      .toDouble();

                                  // Get.showSnackbar(GetSnackBar(
                                  //   title: 'Success',
                                  //   message: 'Product Removed from Cart',
                                  //   snackPosition: SnackPosition.BOTTOM,
                                  //   backgroundColor: AppColors.mainblue,
                                  //   duration:
                                  //       const Duration(milliseconds: 1000),
                                  // ));
                                }
                              }
                            },
                            child: Container(
                              height: 26,
                              width: 35,
                              decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(15)),
                              // backgroundColor: selectedQty.value > 0
                              //     ? AppColors.mainblue
                              //     : Colors.grey,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 0,
                            ),
                            child: Text(
                              // " ${selectedQty.value.toStringAsFixed(1)}",
                              pc.getquantity(widget.product.name!) + '.0',
                              style: const TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Obx(
                            () => GestureDetector(
                              onTap: () async {
                                // _updateSelectedQty(selectedQty.value + 1);
                                pc.calculateTotalAmount();
                                print(
                                    'as of now the total amount is ;  +${pc.totalAmount.value}');

                                Get.dialog(
                                  IgnorePointer(
                                    ignoring: true,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                );
                                PostResponseType res = await pc.postAddToCart(
                                    widget.product.id.toString(),
                                    cc.selectedCustomer.value?.id.toString() ??
                                        '',
                                    '1');
                                Get.back();
                                print(res.postResponseEnum);
                                if (res.postResponseEnum ==
                                    PostResponseEnum.success) {
                                  widget.product.selectedQty = int.parse(pc
                                          .getquantity(widget.product.name!)
                                          .split('.')
                                          .first)
                                      .toDouble();
                                  // Get.showSnackbar(GetSnackBar(
                                  //   title: 'Success',
                                  //   message: 'Product Added to Cart',
                                  //   snackPosition: SnackPosition.BOTTOM,
                                  //   backgroundColor: AppColors.mainblue,
                                  //   duration:
                                  //       const Duration(milliseconds: 1000),
                                  // ));
                                }
                              },
                              child: Container(
                                height: 26,
                                width: 35,
                                decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(15)),
                                // backgroundColor: selectedQty.value > 0
                                //     ? AppColors.mainblue
                                //     : Colors.grey,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 0),
                                  child: pc.addToCartLoading.value == false
                                      ? const Icon(
                                          Icons.add,
                                          size: 17,
                                          color: Colors.orange,
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          child: CircularProgressIndicator(
                                            color: Color.fromARGB(
                                                255, 255, 123, 0),
                                            strokeWidth: 2,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),

                          //  Obx(() => GestureDetector(
                          //         onTap: () async {
                          //           // print(
                          //           //     'custid = ${cc.selectedCustomer.value?.id}');
                          //           // PostResponseType res = await pc.postAddToCart(
                          //           //     widget.product.id.toString(),
                          //           //     cc.selectedCustomer.value?.id
                          //           //             .toString() ??
                          //           //         '',
                          //           //     selectedQty.value.toString());
                          //           // // print(res.postResponseEnum);
                          //           // if (res.postResponseEnum ==
                          //           //     PostResponseEnum.success) {
                          //           //   Get.showSnackbar(GetSnackBar(
                          //           //     title: 'Success',
                          //           //     message: 'Product Added to Cart',
                          //           //     snackPosition: SnackPosition.BOTTOM,
                          //           //     backgroundColor: AppColors.mainblue,
                          //           //     duration:
                          //           //         const Duration(milliseconds: 1000),
                          //           //   ));
                          //           // }
                          //         },
                          //         child: Container(
                          //           height: 26,
                          //           width: 40,
                          //           decoration: BoxDecoration(
                          //               color: Colors.orange.withOpacity(0.2),
                          //               borderRadius: BorderRadius.circular(15)),
                          //           // backgroundColor: selectedQty.value > 0
                          //           //     ? AppColors.mainblue
                          //           //     : Colors.grey,
                          //           child: Padding(
                          //             padding: const EdgeInsets.symmetric(
                          //                 horizontal: 11, vertical: 5),
                          //             // child: const Icon(
                          //             //   Icons.check,
                          //             //   size: 18,
                          //             //   color: Colors.orange,
                          //             // ),
                          //             child: pc.addToCartLoading.value == false
                          //                 ? const Icon(
                          //                     Icons.add_shopping_cart_outlined,
                          //                     size: 17,
                          //                     color: Colors.orange,
                          //                   )
                          //                 : CircularProgressIndicator(
                          //                     color: Color.fromARGB(
                          //                         255, 255, 123, 0),
                          //                     strokeWidth: 2,
                          //                   ),
                          //           ),
                          //         ),
                          //       ))
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 7),
                      child: InkWell(
                        onTap: () async {
                          // selectedQty.value++;
                          _updateSelectedQty(selectedQty.value + 1);
                          pc.calculateTotalAmount();
                          Get.dialog(
                            IgnorePointer(
                              ignoring: true,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          );
                          PostResponseType res = await pc.postAddToCart(
                              widget.product.id.toString(),
                              cc.selectedCustomer.value?.id.toString() ?? '',
                              '1');
                          Get.back();
                          // print(res.postResponseEnum);
                          if (res.postResponseEnum ==
                              PostResponseEnum.success) {
                            // Get.showSnackbar(GetSnackBar(
                            //   title: 'Success',
                            //   message: 'Product Added to Cart',
                            //   snackPosition: SnackPosition.BOTTOM,
                            //   backgroundColor: AppColors.mainblue,
                            //   duration: const Duration(milliseconds: 1000),
                            // ));
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Center(
                              child: Text(
                                'ADD',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
              // ),
              // Container(
              //   color: Colors.grey.shade100,
              //   height: 2,
              //   width: double.maxFinite,
              // ),
              // GestureDetector(
              //   onTap: () {
              //     _showBottomSheet(
              //         context,
              //         productName,
              //         price.toString(),
              //         selectedQty.toString(),
              //         priceWithTax.toString(),
              //         productDes);
              //   },
              //   child: const Padding(
              //     padding: EdgeInsets.all(6.0),
              //     child: Text(
              //       "Edit",
              //       style: TextStyle(
              //         fontSize: 14,
              //         fontWeight: FontWeight.bold,
              //         color: AppColors.mainblue,
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        );
      });
    }
  }

  void _showBottomSheet(
      BuildContext context,
      String? productName,
      String? price,
      String? productQty,
      String? priceWithTax,
      String? productDes) {
    pc.unitPriceController = TextEditingController(text: price);
    final productQuantityController = TextEditingController(text: productQty);
    pc.priceWithTaxController = TextEditingController(text: priceWithTax);
    final amountController = TextEditingController(text: '0.00');
    final percentageController = TextEditingController(text: '0.0');
    final description = TextEditingController(text: productDes);

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
                        Text(
                          productName ?? 'Null',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24.0),
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
                    padding: const EdgeInsets.all(10.0),
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
                                //   updateData: ProductUpdateData(
                                //     productName: productName ?? 'Null',
                                //     sellingPrice: price ?? '0.00',
                                //   ),
                                // ));
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
                                    ? percentageController
                                    : amountController,
                                focusNode: amountFocusNode,
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
                                    print(pc.totalAmount);
                                    totalamt = (pc.qtyInputValue.value ==
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

                                    print('$totalamt');
                                    return Text(
                                      '₹$totalamt',
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
                                // width: width * 0.28,
                                padding: 10.0,
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
                                    double? amt =
                                        double.tryParse(pc.qtyInputValue.value);
                                    if (amt != null) {
                                      print("value is - $amt");
                                    } else {
                                      amt = double.tryParse(
                                          productQuantityController.text);
                                      print("value is - $amt");
                                    }
                                    double? uPrice = double.tryParse(
                                        pc.uPriceInputValue.value);

                                    if (uPrice != null) {
                                      print("unit price is - $uPrice");
                                    } else {
                                      uPrice = double.tryParse(
                                          pc.unitPriceController.text);
                                      print("unit price is - $uPrice");
                                    }
                                    _updateSelectedQty(amt!);
                                    _updateUnitPrice(uPrice!);
                                    pc.updateTotalAmount();
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
              // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              //   FocusScope.of(context).requestFocus(amountFocusNode);
              // });
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

  void productDesBottomSheet(BuildContext context, String? description) {
    Navigator.of(context).pop(); // Close the current bottom sheet

    final productDescription = TextEditingController(text: description);
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
                                  onTap: () {
                                    // Handle icon tap
                                  },
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
                                controller: productDescription,
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
