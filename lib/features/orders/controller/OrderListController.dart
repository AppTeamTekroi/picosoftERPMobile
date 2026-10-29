import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:mobile_erp/core/enum/post_enum_response.dart';
import 'package:mobile_erp/features/Quotation/data/model/get_prescription_model.dart';
import 'package:mobile_erp/features/orders/data/datasource/orderplaced_datasource_impl.dart';
import 'package:mobile_erp/features/orders/data/model/getOrderDetails.dart';
import 'package:mobile_erp/features/orders/data/model/getOrderPlacedModel.dart';

import '../../Quotation/controller/quotation_controller.dart';

class OrderPlacedController extends GetxController {
  late final OrderPlacedDataSourceImpl orderPlacedDataSourceImpl;

  RxList<GetOrderPlacedModel> orderPlacedList = <GetOrderPlacedModel>[].obs;

  RxList<GetOrderPlacedModel> pendingOrderList = <GetOrderPlacedModel>[].obs;
  RxList<GetOrderPlacedModel> paidOrderList = <GetOrderPlacedModel>[].obs;
  RxList<GetOrderPlacedModel> cancelledOrderList = <GetOrderPlacedModel>[].obs;
  Rx<OrderDetailsModel> order = OrderDetailsModel().obs;
  Rx<GetCustomerPrescriptionModel> prescription =
      GetCustomerPrescriptionModel().obs;
  RxList<bool> showdes = <bool>[].obs;
  RxList<bool> boolList = List.generate(20, (_) => false).obs;

  QuotationController qc = Get.put(QuotationController());

  var detailLoading = false.obs;
  var orderDetailFetching = false.obs;
  var successfulFetch = true.obs;
  var totalAmount = 0.0.obs;
  var pendingAmount = 0.0.obs;
  var paidAmount = 0.0.obs;
  var currentCardId = ''.obs;
  var expandedDetailsIndices = <int>[].obs;

  void toggleDetails(int index) {
    if (expandedDetailsIndices.contains(index)) {
      expandedDetailsIndices.remove(index);
    } else {
      expandedDetailsIndices.add(index);
    }
  }

  bool isDetailsExpanded(int index) {
    return expandedDetailsIndices.contains(index);
  }

  Rx<double> record_payment_amout = 0.0.obs;
  Rx<String> record_payment_type = 'UPI'.obs;
  Rx<String> record_payment_settlement = 'Full Payment'.obs;

  void onInit() async {
    orderPlacedDataSourceImpl = OrderPlacedDataSourceImpl();
    await getOrderPlacedList();
    super.onInit();
  }

  @override
  void dispose() {
    totalAmount.value = 0.0;
    pendingAmount.value = 0.0;
    paidAmount.value = 0.0;
    currentCardId.value = '';
  }

  Future<void> getOrderPlacedList() async {
    detailLoading(true);
    final response = await orderPlacedDataSourceImpl.getOrderPlacedData();
    detailLoading.value = false;
    response.fold((failure) {
      detailLoading(false);
      orderPlacedList.value = [];
      // print(failure.message+'jmm,n,,mnm');
    }, (resData) {
      orderPlacedList.value = resData;
      for (int i = 0; i < orderPlacedList.length; i++) {
        if (orderPlacedList[i].orderStatus == 0) {
          pendingOrderList.add(orderPlacedList[i]);
          pendingAmount.value +=
              double.parse(orderPlacedList[i].totalAmount.toString());
        } else if (orderPlacedList[i].orderStatus == 1) {
          paidOrderList.add(orderPlacedList[i]);
          paidAmount.value +=
              double.parse(orderPlacedList[i].totalAmount.toString());
        } else {
          cancelledOrderList.add(orderPlacedList[i]);
        }
        totalAmount.value +=
            double.parse(orderPlacedList[i].totalAmount.toString());
      }
    });
  }

  Future<PostResponseType> getOrderDetails(String id) async {
    orderDetailFetching.value = true;
    final response = await orderPlacedDataSourceImpl.getOrderDetails(id);
    log('id is : - $id');
    orderDetailFetching.value = false;
    PostResponseType res =
        PostResponseType(postResponseEnum: PostResponseEnum.alreadyAdded);
    response.fold((failure) {
      orderPlacedList.value = [];
      print(failure.message);
      res = PostResponseType(
          postResponseEnum: PostResponseEnum.failed, message: failure.message);
    }, (resData) {
      order.value = resData["order_detail"];
      prescription.value = resData["prescription_detail"];
      qc.currentorderpdf.value = resData["sales_order_pdf_url"];

      log('order payment type : - ${order.value.orderPayments![0].paymentType ?? ''}');

      showdes.clear();

      int length = order.value.orderItems?.length ?? 0;
      for (int i = 0; i < length; i++) {
        showdes.add(false);
      }

      res = PostResponseType(
          postResponseEnum: PostResponseEnum.success, message: "Success");
    });
    return res;
  }

  Future<PostResponseType> cancelOrder(String id) async {
    orderDetailFetching.value = true;
    final response = await orderPlacedDataSourceImpl.cancelOrder(id);
    orderDetailFetching.value = false;
    PostResponseType res =
        PostResponseType(postResponseEnum: PostResponseEnum.alreadyAdded);
    response.fold((failure) {
      orderPlacedList.value = [];
      print(failure.message);
      res = PostResponseType(
          postResponseEnum: PostResponseEnum.failed, message: failure.message);
    }, (resData) {
      print(resData);
      res = PostResponseType(
          postResponseEnum: PostResponseEnum.success, message: "Success");
    });
    return res;
  }

  Future<PostResponseType> createInvoice(String id) async {
    orderDetailFetching(true);
    final response = await orderPlacedDataSourceImpl.createInvoice(id);
    orderDetailFetching(false);
    PostResponseType res =
        PostResponseType(postResponseEnum: PostResponseEnum.alreadyAdded);
    response.fold((failure) {
      orderPlacedList.value = [];
      print(failure.message);
      res = PostResponseType(
          postResponseEnum: PostResponseEnum.failed, message: failure.message);
    }, (resData) {
      log('res data is :-$resData');
      res = PostResponseType(
          postResponseEnum: PostResponseEnum.success,
          message: jsonEncode(resData.toString()));
    });
    return res;
  }

  Future<PostResponseType> recordPayment(String id) async {
    orderDetailFetching.value = true;
    final response = await orderPlacedDataSourceImpl.recordPayment(
        id,
        record_payment_amout.value,
        record_payment_type.value,
        record_payment_settlement.value);
    orderDetailFetching.value = false;
    PostResponseType res =
        PostResponseType(postResponseEnum: PostResponseEnum.alreadyAdded);
    response.fold((failure) {
      orderPlacedList.value = [];
      print(failure.message);
      res = PostResponseType(
          postResponseEnum: PostResponseEnum.failed, message: failure.message);
    }, (resData) {
      print(resData);
      res = PostResponseType(
          postResponseEnum: PostResponseEnum.success,
          message: jsonEncode(resData.toString()));
    });
    return res;
  }
}
