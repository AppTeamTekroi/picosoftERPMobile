import 'dart:convert';

import 'package:get/get.dart';
import 'package:dartz/dartz.dart';
import 'package:mobile_erp/API/URLConst.dart';
import 'package:mobile_erp/features/customer/data/datasource/customers_datasource_repository.dart';
import 'package:mobile_erp/features/customer/data/model/get_customer_model.dart';
import 'package:mobile_erp/features/customer/data/model/post_cutomers_model.dart';
import 'package:mobile_erp/features/customer/data/model/put_customer_model.dart';
import '../../../../core/enum/post_enum_response.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/failure.dart';

class CustomerDataSourceImpl implements CustomerSourceRepository {
  CustomerDataSourceImpl();

  @override
  Future<Either<Failure, PostResponseType>> postCustomerData(
      PostCustomersModel data) async {
    try {
      final Map<String, dynamic> jsonData = data.toMap(); // Convert to JSON
      final String jsonString = jsonEncode(jsonData); // Convert to JSON string

      print(URLConst.postCustomerURL);
      var response = await http.post(
        Uri.parse(URLConst.postCustomerURL),
        body: jsonString,
        headers: {'Content-Type': 'application/json'},
      );

      print('11 ${response.body}');

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

  Future<Either<Failure, PostResponseType>> putCustomerData(
      PutCustomersModel data, String customerID) async {
    try {
      final Map<String, dynamic> jsonData = data.toMap(); // Convert to JSON
      final String jsonString = jsonEncode(jsonData); // Convert to JSON string

      String url = URLConst.putCustomerData + customerID;

      print(url);
      var response = await http.put(
        Uri.parse(url),
        body: jsonString,
        headers: {'Content-Type': 'application/json'},
      );

      print('Hello123 ${response.body}');

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
  Future<Either<Failure, List<CustomersModel>>> getCustomerData() async {
    try {
      print('Customer Data called');
      var response = await http.get(
        Uri.parse(URLConst.getCustomerURL),
      );
      // print(jsonDecode(response.body)['customers']);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['customers'];
        print(data.length);
        List<CustomersModel> prod = [];
        data.forEach((element) {
          prod.add(CustomersModel.fromMap(element));
        });
        print('customer is : $prod');
        return Right(prod);
      } else {
        return Left(Failure(statusCode: 500, message: 'Failed!'));
      }
    } catch (err) {
      print(err);
      return Left(Failure(statusCode: 500, message: 'Error occurred!'));
    }
  }
  // @override
  // Future<Either<Failure, List<CustomersModel>>> getCustomerData() async {
  //   try {
  //     print('Customer Data called');
  //     var response = await http.get(
  //       Uri.parse(URLConst.getCustomerURL),
  //     );

  //     if (response.statusCode == 200) {
  //       List<dynamic> data = jsonDecode(response.body);
  //       List<CustomersModel> prod = [];
  //       data.forEach((element) {
  //         prod.add(CustomersModel.fromMap(element));
  //       });
  //       print('customer is : $prod');
  //       return Right(prod);
  //     } else {
  //       return Left(Failure(statusCode: 500, message: 'Failed!'));
  //     }
  //   } catch (err) {
  //     print(err);
  //     return Left(Failure(statusCode: 500, message: 'Error occurred!'));
  //   }
  // }

  // @override
  // Future<Either<Failure, List<dynamic>>> getCustomerData() async {
  //   try {
  //     var response = await http.get(
  //       Uri.parse(URLConst.getCustomerURL),
  //     );
  //     if (response.statusCode == 200) {
  //       List<dynamic> data = jsonDecode(response.body);

  //       return Right(data);
  //     } else {
  //       return Left(Failure(statusCode: 500, message: 'Failed to login!'));
  //     }
  //   } catch (err) {
  //     print(err);
  //     return Left(Failure(statusCode: 500, message: 'Error occurred!'));
  //   }
  // }
}
