import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:mobile_erp/API/URLConst.dart';
import 'package:mobile_erp/features/Quotation/data/model/get_prescription_model.dart';
import 'package:mobile_erp/features/orders/data/datasource/orderplaced_datasource_repository.dart';
import 'package:mobile_erp/features/orders/data/model/getOrderDetails.dart';
import 'package:mobile_erp/features/orders/data/model/getOrderPlacedModel.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/failure.dart';

class OrderPlacedDataSourceImpl implements OrderPlacedSourceRepository {
  OrderPlacedDataSourceImpl();

  @override
  Future<Either<Failure, List<GetOrderPlacedModel>>>
      getOrderPlacedData() async {
    try {
      log('Order Placed Data called');
      var response = await http.get(
        Uri.parse(URLConst.OrderPlacedURL),
      );
      log('${response.runtimeType}');
      // log(jsonDecode(response.body));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        List<GetOrderPlacedModel> order = [];
        data.forEach((element) {
          order.add(GetOrderPlacedModel.fromJson(element));
        });

        log('orderplaced is : $order');
        return Right(order);
      } else {
        return Left(Failure(statusCode: 500, message: 'Failed!'));
      }
    } catch (err) {
      log('$err');
      return Left(Failure(statusCode: 500, message: 'Error occurred!'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getOrderDetails(
      String currentcardid) async {
    try {
      log('Order Details Data called');
      var response = await http.post(
        Uri.parse(URLConst.OrderDetailsURL + currentcardid),
      );
      log('1 current id :- $currentcardid');

      log('2 ${response.runtimeType}');
      // log(jsonDecode(response.body));
      log("3 ******************");
      log('4 ${response.statusCode}');
      log('5 ${response.body}');
      log("******************");

      if (response.statusCode == 200) {
        // List<dynamic> data = jsonDecode(response.body);
        var data1 = jsonDecode(response.body);
        var data = data1['data']['order'];
        var data2 = data1['data']['prescription'];
        var data3 = data1['sales_order_copy_pdf'];

        log('6 $data');
        log('7 $data2');
        String jsonString = jsonEncode(data2);
        GetCustomerPrescriptionModel pres =
            GetCustomerPrescriptionModel.fromJson(jsonString);
        OrderDetailsModel order = OrderDetailsModel.fromJson(data);

        Map<String, dynamic> map = {
          "order_detail": order,
          "prescription_detail": pres,
          "sales_order_pdf_url": data3
        };
        log('8 orderplaced is : ${order.toJson()}');
        return Right(map);
      } else {
        return Left(Failure(statusCode: 500, message: 'Failed!'));
      }
    } catch (err) {
      log('$err');
      return Left(Failure(statusCode: 500, message: 'Error occurred!'));
    }
  }

  Future<Either<Failure, String>> cancelOrder(String id) async {
    try {
      log('Order Details Data called');
      var response = await http.put(
        Uri.parse(URLConst.cancelOrderURL + id),
      );
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (data['success'] == true) {
          return Right(data['message']);
        } else {
          log("Failure from Cancel Order API: $data ");
          return Left(
              Failure(statusCode: response.statusCode, message: data['error']));
        }
      } else {
        log("Failure from Cancel Order API: ${data['message']} ");
        return Left(
            Failure(statusCode: response.statusCode, message: 'Failed!'));
      }
    } catch (err) {
      log("Error from Cancel Order API: $err ");
      return Left(Failure(statusCode: 500, message: 'Error occurred!'));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> createInvoice(String id) async {
    try {
      var response = await http.get(
        Uri.parse(URLConst.createInvoiceURL + id),
      );
      var data = jsonDecode(response.body);
      log("Status Code from Create Invoice API: ${response.statusCode} ");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['success'] == true) {
          Map<String, dynamic> map = {
            "invoice_number": data['invoice_number'],
            "link": data['sales_invoice_pdf']
          };
          return Right(map);
        } else {
          log("Failuree from Create Invoice API: $data ");
          return Left(Failure(
              statusCode: response.statusCode, message: data['message']));
        }
      } else if (response.statusCode == 422) {
        log("Failure from Create Invoice API: $data ");
        return Left(
            Failure(statusCode: response.statusCode, message: data['message']));
      } else {
        log("Failure from Create Invoice API: $data ");
        return Left(
            Failure(statusCode: response.statusCode, message: 'Failed!'));
      }
    } catch (err) {
      log("Error from Create Invoice API: $err ");
      return Left(Failure(statusCode: 500, message: 'Error occurred!'));
    }
  }

  Future<Either<Failure, Map<String, dynamic>>> recordPayment(String id,
      double amount, String paymentType, String paymentSettlement) async {
    try {
      Map<String, dynamic> body = {
        "payment_type": paymentType,
        "payment_settlement": paymentSettlement,
        "paid_amount": amount.toString()
      };
      log("Body passed in Record Payment API: $body");
      var response =
          await http.post(Uri.parse(URLConst.recordPayment + id), body: body);
      var data = jsonDecode(response.body);
      log("Status Code from Record Payment API: ${response.statusCode} ");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['success'] == true) {
          return Right(data['data']);
        } else {
          log("Failure from Record Payment API: $data ");
          return Left(Failure(
              statusCode: response.statusCode, message: data['message']));
        }
      } else if (response.statusCode == 422) {
        log("Failure from Record Payment API: $data ");
        return Left(
            Failure(statusCode: response.statusCode, message: data['message']));
      } else {
        log("Failure from Record Payment API: $data ");
        return Left(
            Failure(statusCode: response.statusCode, message: 'Failed!'));
      }
    } catch (err) {
      log("Error from Record Payment API: $err ");
      return Left(Failure(statusCode: 500, message: 'Error occurred!'));
    }
  }
}
