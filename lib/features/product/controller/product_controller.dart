import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_erp/features/product/data/model/add_to_cart_model.dart';
import 'package:mobile_erp/features/product/data/model/barcode_search_model.dart';
import 'package:mobile_erp/features/product/data/model/cart_item_model.dart';
import 'package:mobile_erp/features/product/data/model/get_barcode_search_model.dart';
import 'package:mobile_erp/features/product/data/model/get_product_data_model.dart';
import 'package:mobile_erp/features/product/data/model/get_products_model.dart';
import 'package:mobile_erp/features/product/data/model/post_products_model.dart';
import 'package:mobile_erp/features/product/data/model/remove_from_cart_model.dart';

import '../../../core/enum/post_enum_response.dart';
import '../data/dataSource/product_data_source_impl.dart';

class ProductController extends GetxController {
  late final ProductDataSourceImpl productDataSourceImpl;

  RxList<ProductsModel> productList = <ProductsModel>[].obs;
  // RxBool showDescription = false.obs;
  // final selectedProducts = <ProductsModel>[].obs;
  var selectedProducts = <getProductDataModel>[].obs;
  RxList<bool> showDes = <bool>[].obs;
  var product_count = 0.0.obs;
  var totalAmount = 0.0.obs;
  var subtotal = 0.0.obs;
  var count = 0.0.obs;
  var product_service = "".obs;
  var optionalFields = false.obs;
  var live = true.obs;
  final RxInt selectedRadio = 1.obs;
  final RxInt priceSelectedRadio = 4.obs;
  var isPressed = false.obs;
  var isRoundOffEnabled = false.obs;
  var showOnline = true.obs;
  var notSale = false.obs;
  var isExpanded = false.obs;
  var isClick = false.obs;

  var detailLoading = false.obs;
  RxList<getProductDataModel> getProductDetailList =
      <getProductDataModel>[].obs;
  RxList<getProductDataModel> getBarcodeSearchDetailList =
      <getProductDataModel>[].obs;
  RxList<getProductDataModel> searchedProductDetailList =
      <getProductDataModel>[].obs;
  RxList<CartItemModel> cartItemDetailList = <CartItemModel>[].obs;
  var finalAmount = 0.0.obs;

  /// add product variables

  var productName = "".obs;
  var searchProduct = "".obs;
  var sellingPrice = "".obs;
  var taxRate = "".obs;
  var purchasePrice = "".obs;
  var purchasePriceWithTax = "".obs;
  var hsnCode = "".obs;
  var unit = "".obs;
  var category = "".obs;
  var description = "".obs;
  var barcode = "".obs;
  var productImg = "".obs;
  var postData = false.obs;
  var extraDiscount = "0.00".obs;
  var packagingCharges = "0.00".obs;
  var shippingCharges = "0.00".obs;

  RxString qtyInputValue = ''.obs;
  RxString uPriceInputValue = ''.obs;
  RxString pwtInputValue = ''.obs;

  var addToCartLoading = false.obs;

  var barcodeDetailLoading = false.obs;
  var cartLoading = false.obs;
  var unitPriceController;
  var priceWithTaxController;
  var amountController;
  var percentageController;
  var percentage = 0.0.obs;
  var amount = 0.0.obs;

  // Function to handle text changes
  void onQtyChanged(String newQty) {
    qtyInputValue.value = newQty;
    print('New qty value: $newQty');
  }

  // Function to handle unit price changes
  void onUnitPriceChanged(String newUnitPrice) {
    // Calculate and update the Price with Tax controller
    // print(newUnitPrice);
    double originalValue = double.tryParse(newUnitPrice) ?? 0.00;
    double newValue = originalValue + originalValue * 0.18;
    priceWithTaxController.text = newValue.toStringAsFixed(2);
    // uPriceInputValue.value = newUnitPrice;
    pwtInputValue.value = newValue.toStringAsFixed(2);
    print('New unit x price value: $newUnitPrice');
    print('New price x with tax value: $newValue');
  }

  void onPWTChanged(String newPWT) {
    // Calculate and update the Price with Tax controller
    double originalValue = double.tryParse(newPWT) ?? 0.00;
    double newValue = originalValue / (1 + 0.18);
    unitPriceController.text = newValue.toStringAsFixed(2);
    uPriceInputValue.value = newValue.toStringAsFixed(2);
    print('New unit price value: $newPWT');
    print('New price with tax value: $newValue');
  }

  String getquantity(String name) {
    for (int i = 0; i < cartItemDetailList.length; i++) {
      if (cartItemDetailList[i].product_name == name) {
        return cartItemDetailList[i].quantities!.split('.').first ?? "0";
      }
    }
    return "0";
  }

  void setCartProductInitally() {
    // print('nihal');
    // calculateTotalAmount();
    selectedProducts.clear();
    showDes.clear();
    // print('selected products initially:${selectedProducts.length}');
    // print('cart size initially:${cartItemDetailList.length}');

    for (int i = 0; i < cartItemDetailList.length; i++) {
      if (int.parse(cartItemDetailList[i].quantities ?? '0') > 0) {
        getProductDetailList.map((element) {
          if (element.id == cartItemDetailList[i].product_id) {
            // print('testt');
            // print('${element.id}');
            totalAmount.value +=
                double.parse(cartItemDetailList[i].total_amount.toString());
            element.selectedQty =
                double.parse(cartItemDetailList[i].quantities.toString());
            // element.selectedQty = int.parse(cartItemDetailList[i].quantities??'0');
            selectedProducts.add(element);
            showDes.add(false);
            update();
            // selectedProducts.refresh();
          }
        }).toList();
      }
    }
    print('length is : ${selectedProducts.length}');
  }

  double calculateamount() {
    double amount1 = 0;
    for (int i = 0; i < cartItemDetailList.length; i++) {
      amount1 += (double.parse(cartItemDetailList[i].price!) *
          double.parse(cartItemDetailList[i].quantities!));
    }
    if (percentage.value > 0) {
      amount1 -= (amount1 * percentage.value / 100);
    }

    // Apply fixed discount amount if provided
    if (amount.value > 0) {
      amount1 -= amount.value;
    }

    // Ensure amount does not go negative
    if (amount1 < 0) {
      amount1 = 0;
    }
    return amount1;
    // print('////////////////////////$amount');
  }

  void onPercentDiscountChanged(String dis, String original) {
    // Calculate and update the Price with Tax controller
    double originalValue = double.tryParse(original) ?? 0.00;
    double newValue = originalValue - originalValue * (double.parse(dis) / 100);
    priceWithTaxController.text = newValue.toStringAsFixed(2);
    unitPriceController.text = (newValue / (1 + 0.18)).toStringAsFixed(2);
    pwtInputValue.value = newValue.toStringAsFixed(2);
    print('New price with tax value: $newValue');
  }

  void onAmountDiscountChanged(String disAmount, String original) {
    // Calculate and update the Price with Tax controller
    double originalValue = double.tryParse(original) ?? 0.00;
    double newValue = originalValue - double.parse(disAmount);
    // unitPriceController.text = newValue.toStringAsFixed(2);
    priceWithTaxController.text = newValue.toStringAsFixed(2);
    unitPriceController.text = (newValue / (1 + 0.18)).toStringAsFixed(2);
    pwtInputValue.value = newValue.toStringAsFixed(2);
    print('New price with tax value: $newValue');
  }

  @override
  Future<void> onInit() async {
    productDataSourceImpl = ProductDataSourceImpl();
    // await getProductList();
    getProductDetailsList();

    ever(count, (_) {
      calculateTotalAmount();
    });

    ever(count, (_) {
      updateTotalAmount();
    });

    super.onInit();
  }

  void populateProductList() {
    print('tried populating');
    print(getProductDetailList.length);
    searchedProductDetailList.value = [];
    searchedProductDetailList.assignAll(getProductDetailList);
    print(searchedProductDetailList.length);
  }

  double calculateTotalAmount() {
    // Calculate the total price of selected products
    totalAmount.value = 0.0;
    subtotal.value = 0.0;

    // for (final product in getProductDetailList) {
    for (final product in searchedProductDetailList) {
      print('selectedQty in for loop: ${product.selectedQty}');
      if (product.selectedQty != null && product.stock_price != null) {
        print('x');
        subtotal.value +=
            product.selectedQty! * double.parse(product.stock_price!);
      } else {
        product.selectedQty = 0.0;
        // product.stock_price = "0.0";
        subtotal.value +=
            product.selectedQty! * double.parse(product.stock_price!);
      }
    }

    totalAmount.value = subtotal.value + (subtotal.value * 0.18);
    print(totalAmount.value);
    // totalAmount.value = 100;
    return totalAmount.value;
  }

  double updateTotalAmount() {
    double totalAmountValue = totalAmount.value;

    totalAmountValue -= double.tryParse(extraDiscount.value) ?? 0.0;
    totalAmountValue += double.tryParse(packagingCharges.value) ?? 0.0;
    totalAmountValue += double.tryParse(shippingCharges.value) ?? 0.0;
    print("packagingCharges: ${packagingCharges.value}");
    print("totalAmountValue: $totalAmountValue");

    totalAmount.value = totalAmountValue; // Update the totalAmount variable

    return totalAmountValue;
  }

  void toggleExpanded() {
    isExpanded.toggle();
  }

  void clearExtraDiscount() {
    extraDiscount.value =
        "0.00"; // Set the extra discount value to 0.00 or an empty string as needed
  }

  void clearShippingCharges() {
    shippingCharges.value =
        "0.00"; // Set the shipping charges value to 0.00 or an empty string as needed
  }

  void clearPackagingCharges() {
    packagingCharges.value =
        "0.00"; // Set the packaging charges value to 0.00 or an empty string as needed
  }

  Future<void> getProductDetailsList() async {
    detailLoading.value = true;
    final response = await productDataSourceImpl.getProductDetailsData();
    Future.delayed(Duration(milliseconds: 500), () {
      detailLoading.value = false;
    });
    // detailLoading.value = false;
    response.fold((failure) {
      detailLoading.value = false;
      getProductDetailList.value = [];
      print(failure.message);
    }, (resData) {
      // print(resData[1].stock_price);
      getProductDetailList.value = resData;
    });
    print(getProductDetailList.length);
    searchedProductDetailList.assignAll(getProductDetailList);
  }

  Future<void> getCartItemDetailsList(String? id) async {
    cartLoading.value = true;
    final response = await productDataSourceImpl.cartItemDetailsData(id ?? '0');
    Future.delayed(Duration(milliseconds: 500), () {
      cartLoading.value = false;
    });
    response.fold((failure) {
      cartLoading.value = false;
      cartItemDetailList.value = [];
      print(failure.message);
    }, (resData) {
      cartItemDetailList.value = resData;
    });
  }

  Future<void> getProductFromBarcode(String filter) async {
    barcodeDetailLoading.value = true;
    final search = BarcodeSearchModel(filter: filter);
    final response = await productDataSourceImpl.getProductFromBarcode(search);

    barcodeDetailLoading.value = false;

    response.fold((failure) {
      barcodeDetailLoading.value = false;
      getBarcodeSearchDetailList.value = [];
      print(failure.message);
    }, (resData) {
      // print(resData[1].stock_price);
      getBarcodeSearchDetailList.value = resData;
    });
    print(getBarcodeSearchDetailList.length);
    print(searchedProductDetailList.length);
    // searchedProductDetailList.assignAll(getBarcodeSearchDetailList);
    print(searchedProductDetailList.length);
  }

  Rx<Map<String, bool>> cartItemLoadingMap = Rx<Map<String, bool>>({});

  // void setCartItemLoading(String productId, bool isLoading) {
  //   cartItemLoadingMap[productId]!.value = isLoading;
  //   update();
  // }

  // bool getCartItemLoading(String productId) {
  //   return cartItemLoadingMap[productId]?.value ?? false;
  // }

  Future<PostResponseType> postAddToCart(
      String prodId, String custId, String qty) async {
    try {
      // addToCartLoading.value = true;
      final detail = AddToCartModel(
        productId: prodId,
        customerId: custId,
        quantities: qty,
      );
      print('testing : ${detail.toString()}');
      final response = await productDataSourceImpl.postAddToCart(detail);

      print('API Response: $response');
      // addToCartLoading.value = false;
      // Return the appropriate PostResponseType based on the response
      if (response.isRight()) {
        getCartItemDetailsList(custId);
        // getCustomerList();
        return PostResponseType(postResponseEnum: PostResponseEnum.success);
      } else {
        return PostResponseType(postResponseEnum: PostResponseEnum.failed);
      }
    } catch (e) {
      addToCartLoading.value = false;
      print('Error: $e');
      return PostResponseType(postResponseEnum: PostResponseEnum.failed);
    }
  }

  Future<PostResponseType> postremovefromCart(
      String prodId, String custId, int qty) async {
    try {
      // addToCartLoading.value = true;
      final detail =
          RemoveFromCartModel(productId: prodId, customerId: custId, status: 0);
      print('testing : ${detail.toString()}');
      final response = await productDataSourceImpl.postRemovefromCart(detail);

      print('API Response: $response');
      // addToCartLoading.value = false;
      // Return the appropriate PostResponseType based on the response
      if (response.isRight()) {
        getCartItemDetailsList(custId);
        // getCustomerList();
        return PostResponseType(postResponseEnum: PostResponseEnum.success);
      } else {
        return PostResponseType(postResponseEnum: PostResponseEnum.failed);
      }
    } catch (e) {
      addToCartLoading.value = false;
      print('Error: $e');
      return PostResponseType(postResponseEnum: PostResponseEnum.failed);
    }
  }

  void searchProductByName(String? prod) {
    if (prod == null || prod.isEmpty) {
      // Reset the searched list to the original list
      searchedProductDetailList.assignAll(getProductDetailList);
      return;
    }
    searchedProductDetailList.clear();
    for (var product in getProductDetailList) {
      if (product.name!.toLowerCase().contains(prod.toLowerCase())) {
        searchedProductDetailList.add(product);
      }
    }
  }

  // Future<void> getProductList() async {
  //   var response = await productDataSourceImpl.getProductData();

  //   response.fold(
  //       (failure) => {print(failure.message)},
  //       (data) => {
  //             print("Hello from getProductList()"),
  //             data.forEach((element) {
  //               productList.add(new ProductsModel.fromJson(element));
  //             }),
  //             productList.refresh(),
  //             print(productList.value)
  //           });
  // }

  Future<PostResponseType> postProductData() async {
    try {
      final prodDetails = PostProductsModel(
          name: productName.value,
          stock_price: "",
          barcode: "",
          description: "",
          tax: 1,
          mrp: "",
          hsn: "",
          product_category_id: 0,
          item_type_id: 1
          // product_name: productName.value,
          // totalPrice: sellingPrice.value,
          // tax: taxRate.value,
          // purchase_price: purchasePrice.value,
          // is_price_with_tax: purchasePriceWithTax.value,
          // hsn_code: hsnCode.value,
          // unit: unit.value,
          // product_category: category.value,
          // description: description.value,
          // product_images: [
          //   PostProductImagesModel(url: 'url1', uid: 'uid1'),
          //   PostProductImagesModel(url: 'url2', uid: 'uid2'),
          //   // You can add more images here if needed
          // ],
          );

      final response = await productDataSourceImpl.postProductData(prodDetails);

      print('API Response: $response');

      // Return the appropriate PostResponseType based on the response
      if (response.isRight()) {
        return PostResponseType(postResponseEnum: PostResponseEnum.success);
      } else {
        return PostResponseType(postResponseEnum: PostResponseEnum.failed);
      }
    } catch (e) {
      print('Error: $e');
      return PostResponseType(postResponseEnum: PostResponseEnum.failed);
    }
  }

  void selectProduct(getProductDataModel product) {
    selectedProducts.add(product);
    update();
  }

  void clearProductList() {
    selectedProducts.clear();
    // showDes.clear();
  }

  void clearDetails() {
    selectedProducts.clear();
    totalAmount.value = 0.0;
    count.value = 0.0;
    product_service.value = "";
    optionalFields.value = false;
    live.value = true;
    subtotal.value = 0.0;
    productName.value = "";
    sellingPrice.value = "";
    taxRate.value = "";
    purchasePrice.value = "";
    purchasePriceWithTax.value = "";
    hsnCode.value = "";
    unit.value = "";
    category.value = "";
    description.value = "";
    barcode.value = "";
    productImg.value = "";
    postData.value = false;
    extraDiscount.value = "0.00";
    packagingCharges.value = "0.00";
    shippingCharges.value = "0.00";

    for (getProductDataModel prod in getProductDetailList) {
      prod.selectedQty = 0;
    }
    calculateTotalAmount();
    print("Total Amount: ${totalAmount.value} Sub Total: ${subtotal.value}");
  }

  void onPriceRadioChanged(int? value) {
    priceSelectedRadio.value = value!;
  }

  void roundOffEnable(bool value) {
    isRoundOffEnabled.value = value;
  }

  void showOnlineEnable(bool value) {
    showOnline.value = value;
  }

  void notSaleEnable(bool value) {
    notSale.value = value;
  }

  void onRadioChanged(int? value) {
    selectedRadio.value = value!;
  }

  void onChanged() {
    isPressed.toggle();
  }
}
