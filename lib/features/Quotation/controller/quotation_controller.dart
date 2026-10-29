import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_erp/features/Quotation/data/datasource/quotation_datasource_impl.dart';
import 'package:mobile_erp/features/Quotation/data/model/get_prescription_model.dart';
import 'package:mobile_erp/features/Quotation/data/model/post_quotation_model.dart';

import '../../../core/enum/post_enum_response.dart';

class QuotationController extends GetxController {
  var left_sph = ''.obs;
  var left_cyl = ''.obs;
  var left_axis = ''.obs;
  var left_vision = ''.obs;
  var right_sph = ''.obs;
  var right_cyl = ''.obs;
  var right_axis = ''.obs;
  var right_vision = ''.obs;
  var sph = ''.obs;
  var cyl = ''.obs;
  var axis = ''.obs;
  var vision = ''.obs;
  var paymentType = 'Cash'.obs;
  var currentorderpdf = "".obs;
  var largeAdvancePayment = false.obs;

  var showPresDetials=false.obs;
  var showfinalPresDetials=false.obs;
  var fullOrAdvancePayment='Full Payment'.obs;
  var add = ''.obs;
  var pd = ''.obs;
  var optometrics = ''.obs;
  var advanceAmount=0.0.obs;
  var selectedRadio=1.obs;

  RxDouble sheetHeight = 100.0.obs;

  late final QuotationDataSourceImpl quotationDataSourceImpl =
      QuotationDataSourceImpl();
  RxBool postData = false.obs;
  var detailLoading = false.obs;
  var selectPresId = '-1'.obs;
  RxList<GetCustomerPrescriptionModel> customersPrescriptionList =
      <GetCustomerPrescriptionModel>[].obs;
  RxList<String> presId = <String>[].obs;
  GetCustomerPrescriptionModel? selectedCustomerPrescription;

  Future<void> getCustomerPrescriptionList(String c_id) async {
    detailLoading.value = true;
    presId.clear();
    selectPresId.value = '';
    final response =
        await quotationDataSourceImpl.getCustomerPrescriptionData(c_id, presId);
    detailLoading.value = false;
    response.fold((failure) {
      detailLoading.value = false;
      customersPrescriptionList.value = [];
      print(failure.message);
    }, (resData) {
      // print(resData[1].stock_price);
      customersPrescriptionList.value = resData;
      selectPresId.value = presId[0];
      // print('temp length${customersPrescriptionList.length}');
      setSelectedCustomerPrescription();
    });
  }

  void setSelectedCustomerPrescription() {
    for (int i = 0; i < customersPrescriptionList.length; i++) {
      // print("Customer ID: ${customersPrescriptionList[i].id} Select ID: ${selectPresId.value}");
      if (customersPrescriptionList[i].id.toString() == selectPresId.value) {
        selectedCustomerPrescription = customersPrescriptionList[i];
        print(
            'nihal from setSelectedCustomerPrescription ${selectedCustomerPrescription?.l_cyl}');
        left_cyl.value = selectedCustomerPrescription?.l_cyl.toString() ?? '';
        left_sph.value = selectedCustomerPrescription?.l_sph.toString() ?? '';
        left_axis.value = selectedCustomerPrescription?.l_axis.toString() ?? '';
        left_vision.value =
            selectedCustomerPrescription?.l_vision.toString() ?? '';
        right_cyl.value = selectedCustomerPrescription?.r_cyl.toString() ?? '';
        right_sph.value = selectedCustomerPrescription?.r_sph.toString() ?? '';
        right_axis.value =
            selectedCustomerPrescription?.r_axis.toString() ?? '';
        right_vision.value =
            selectedCustomerPrescription?.r_vision.toString() ?? '';
        add.value = selectedCustomerPrescription?.add.toString() ?? '';
        pd.value = selectedCustomerPrescription?.pd.toString() ?? '';
        optometrics.value = selectedCustomerPrescription?.optometrics ?? '';

        print('Testing123: ${selectedCustomerPrescription?.customer_id}');
        break;
      }
    }
    // print("No data found");
  }

  Future<PostResponseType> postOrderPlace(
      int customerId,
      int userId,
      int storeId,
      double amount,
      String discount,
      int paymentType,
      int paymentSettlement,
      String lSph,
      String lCyl,
      String lAxis,
      String lVision,
      String rSph,
      String rCyl,
      String rAxis,
      String rVision,
      String add,
      String pd,
      String optometrics) async {
    try {
      final quotationDetails = PostQuotationModel(
          customerId: customerId,
          userId: userId,
          storeId: storeId,
          amount: amount,
          discount: discount,
          paymentType: paymentType,
          paymentSettlement: paymentSettlement,
          lSph: lSph,
          lCyl: lCyl,
          lAxis: lAxis,
          lVision: lVision,
          rSph: rSph,
          rCyl: rCyl,
          rAxis: rAxis,
          rVision: rVision,
          add: add,
          pd: pd,
          optometrics: optometrics);
      print('testing : ${quotationDetails.toJson()}');
      final response =
          await quotationDataSourceImpl.postQuotationDetails(quotationDetails);

      print('API Response: ${response}');

      // Return the appropriate PostResponseType based on the response
      if (response.isRight()) {
        return PostResponseType(postResponseEnum: PostResponseEnum.success, message: response.getOrElse(() => PostResponseType(postResponseEnum: PostResponseEnum.success)).message);
      } else {
        return PostResponseType(postResponseEnum: PostResponseEnum.failed);
      }
    } catch (e) {
      print('Error: $e');
      return PostResponseType(postResponseEnum: PostResponseEnum.failed);
    }
  }

  void updateSheetHeight(double newHeight) {
    sheetHeight.value = newHeight;
  }
   void onRadioChanged(int? value) {
    selectedRadio.value = value!;
  }
}
