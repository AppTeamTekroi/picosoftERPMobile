import 'dart:convert';

import 'package:get/get.dart';
import 'package:dartz/dartz.dart';
import 'package:mobile_erp/API/URLConst.dart';
import 'package:mobile_erp/features/product/data/dataSource/product_data_source_repository.dart';
import 'package:mobile_erp/features/product/data/model/add_to_cart_model.dart';
import 'package:mobile_erp/features/product/data/model/barcode_search_model.dart';
import 'package:mobile_erp/features/product/data/model/cart_item_model.dart';
import 'package:mobile_erp/features/product/data/model/get_barcode_search_model.dart';
import 'package:mobile_erp/features/product/data/model/get_product_data_model.dart';
import 'package:mobile_erp/features/product/data/model/remove_from_cart_model.dart';
import '../../../../core/enum/post_enum_response.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/failure.dart';
import '../model/post_products_model.dart';

class ProductDataSourceImpl implements ProductSourceRepository {
  ProductDataSourceImpl();

  @override
  Future<Either<Failure, PostResponseType>> postProductData(
      PostProductsModel data) async {
    try {
      final Map<String, dynamic> jsonData = data.toMap(); // Convert to JSON
      final String jsonString = jsonEncode(jsonData); // Convert to JSON string

      print(URLConst.postProductURL);
      var response = await http.post(
        Uri.parse(URLConst.postProductURL),
        body: jsonString,
        headers: {'Content-Type': 'application/json'},
      );

      print('2345678 ${response}');

      if (response.statusCode == 200 || response.statusCode == 202) {
        final jsonResponse = jsonDecode(response.body);
        final jsonDecoded = jsonResponse;

        return Right(
            PostResponseType(postResponseEnum: PostResponseEnum.success));
      }
    } catch (e) {
      print('Error: $e');
      return Left(Failure(statusCode: 500, message: 'Test Message'));
    }

    throw Exception('Failed to Post Product Data');
  }

  @override
  Future<Either<Failure, PostResponseType>> postAddToCart(
      AddToCartModel data) async {
    try {
      final Map<String, dynamic> jsonData = data.toMap(); // Convert to JSON
      final String jsonString = jsonEncode(jsonData); // Convert to JSON string

      print(URLConst.addToCartURL);
      var response = await http.post(
        Uri.parse(URLConst.addToCartURL),
        body: jsonString,
        headers: {'Content-Type': 'application/json'},
      );

      print('addToCart Response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 202) {
        final jsonResponse = jsonDecode(response.body);
        final jsonDecoded = jsonResponse;

        return Right(
            PostResponseType(postResponseEnum: PostResponseEnum.success));
      }
    } catch (e) {
      print('Error: $e');
      return Left(Failure(statusCode: 500, message: 'Test Message'));
    }

    throw Exception('Failed to Post Add To Cart');
  }
  @override
  Future<Either<Failure, PostResponseType>> postRemovefromCart(
      RemoveFromCartModel data) async {
    try {
      final Map<String, dynamic> jsonData = data.toMap(); // Convert to JSON
      final String jsonString = jsonEncode(jsonData); // Convert to JSON string

      print(URLConst.deleteFromCartUrl+data.customerId!);
      var response = await http.delete(
        Uri.parse(URLConst.deleteFromCartUrl+data.customerId!),
        body: jsonString,
        headers: {'Content-Type': 'application/json'},
      );

      print('addToCart Response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 202) {
        final jsonResponse = jsonDecode(response.body);
        final jsonDecoded = jsonResponse;

        return Right(
            PostResponseType(postResponseEnum: PostResponseEnum.success));
      }
    } catch (e) {
      print('Error: $e');
      return Left(Failure(statusCode: 500, message: 'Test Message'));
    }

    throw Exception('Failed to Post remove from Cart');
  }

  @override
  Future<Either<Failure, List<getProductDataModel>>> getProductFromBarcode(
      BarcodeSearchModel data) async {
    try {
      print('nihal from barcode');
      final Map<String, dynamic> jsonData = data.toMap(); // Convert to JSON
      final String jsonString = jsonEncode(jsonData); // Convert to JSON string

      print(URLConst.addToCartURL);
      var response = await http.post(
        Uri.parse(URLConst.barcodeScanSearchURL),
        body: jsonString,
        headers: {'Content-Type': 'application/json'},
      );

      print('search Response: ${response.body}');
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['data'];
        List<getProductDataModel> prod = [];
        data.forEach((element) {
          prod.add(getProductDataModel.fromMap(element));
        });
        print('barcode result is : $prod');
        return Right(prod);
      } else {
        return Left(Failure(statusCode: 500, message: 'Failed!'));
      }
    } catch (e) {
      print('Error: $e');
      return Left(Failure(statusCode: 500, message: 'Test Message'));
    }

    throw Exception('Failed to Post Add To Cart');
  }

  @override
  Future<Either<Failure, List<getProductDataModel>>>
      getProductDetailsData() async {
    try {
      var response = await http.get(
        Uri.parse(URLConst.productURL),
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<getProductDataModel> prod = [];
        data.forEach((element) {
          prod.add(getProductDataModel.fromMap(element));
        });
        print('product is : $prod');
        return Right(prod);
      } else {
        return Left(Failure(statusCode: 500, message: 'Failed!'));
      }
    } catch (err) {
      print(err);
      return Left(Failure(statusCode: 500, message: 'Error occurred!'));
    }
  }

  @override
  Future<Either<Failure, List<CartItemModel>>> cartItemDetailsData(
      String id) async {
    try {
      // print(URLConst.CartItemURL + id);
      var response = await http.post(
        Uri.parse(URLConst.CartItemURL + id),
        body: "",
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['data'];
        List<CartItemModel> cart = [];
        data.forEach((element) {
          cart.add(CartItemModel.fromMap(element));
        });
        print('Cart have : $cart');
        return Right(cart);
      } else {
        return Left(Failure(statusCode: 500, message: 'Failed!'));
      }
    } catch (err) {
      print(err);
      return Left(Failure(statusCode: 500, message: 'Error occurred!'));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getProductData() async {
    try {
      var response = await http.get(
        Uri.parse(URLConst.productURL),
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        return Right(data);
      } else {
        return Left(Failure(statusCode: 500, message: 'Failed to login!'));
      }
    } catch (err) {
      print(err);
      return Left(Failure(statusCode: 500, message: 'Error occurred!'));
    }
  }
}
