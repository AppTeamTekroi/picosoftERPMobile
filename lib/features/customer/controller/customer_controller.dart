import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_erp/features/customer/data/model/post_cutomers_model.dart';
import 'package:mobile_erp/features/customer/data/model/put_customer_model.dart'
    as pc;

import '../../../core/enum/post_enum_response.dart';
import '../data/datasource/customers_datasource_impl.dart';
import '../data/model/get_customer_model.dart';

class CustomerController extends GetxController {
  late final CustomerDataSourceImpl customerDataSourceImpl;

  RxList<CustomersModel> customersList = <CustomersModel>[].obs;
  RxList<CustomersModel> searchedCustomerDetailList = <CustomersModel>[].obs;
  Rx<CustomersModel?> selectedCustomer = Rx<CustomersModel?>(null);

  var tds_aplicable = false.obs;

  var cust_name = "".obs;
  var dial_code = "".obs;
  var phoneNumber = "".obs;
  var email = "".obs;
  var gstNumber = "".obs;
  var companyName = "".obs;
  var postData = false.obs;
  var detailLoading = false.obs;

  var address_1_billing = "".obs;
  var address_2_billing = "".obs;
  var pincode_billing = "".obs;
  var city_billing = "".obs;
  var state_billing = "".obs;

  var address_1_shipping = "".obs;
  var address_2_shipping = "".obs;
  var pincode_shipping = "".obs;
  var city_shipping = "".obs;
  var state_shipping = "".obs;

  var searchCustomer = "".obs;

  @override
  void onInit() async {
    customerDataSourceImpl = CustomerDataSourceImpl();
    await getCustomerList();
    selectedCustomer = Rx<CustomersModel?>(null);
    super.onInit();
  }

  void initializeVariables({bool billing = false, bool shipping = false}) {
    if (billing) {
      address_1_billing.value = '';
      address_2_billing.value = '';
      pincode_billing.value = '';
      city_billing.value = '';
      state_billing.value = '';
    }
    if (shipping) {
      address_1_shipping.value = '';
      address_2_shipping.value = '';
      pincode_shipping.value = '';
      city_shipping.value = '';
      state_shipping.value = '';
    }
  }

  void initializeAddressInUpdate({CustomersModel? customer}) {
    if (customer?.address?.length == 2) {
      address_1_billing.value = customer?.address?[0]?.address_1 ?? '';
      address_2_billing.value = customer?.address?[0]?.address_2 ?? '';
      pincode_billing.value = customer?.address?[0]?.pincode.toString() ?? '';
      city_billing.value = customer?.address?[0]?.city ?? '';
      state_billing.value = customer?.address?[0]?.state ?? '';

      address_1_shipping.value = customer?.address?[1]?.address_1 ?? '';
      address_2_shipping.value = customer?.address?[1]?.address_2 ?? '';
      pincode_shipping.value = customer?.address?[1]?.pincode.toString() ?? '';
      city_shipping.value = customer?.address?[1]?.city ?? '';
      state_shipping.value = customer?.address?[1]?.state ?? '';
    } else if (customer?.address?.length == 1) {
      if (customer?.address?[0]?.type == "billing") {
        address_1_billing.value = customer?.address?[0]?.address_1 ?? '';
        address_2_billing.value = customer?.address?[0]?.address_2 ?? '';
        pincode_billing.value = customer?.address?[0]?.pincode.toString() ?? '';
        city_billing.value = customer?.address?[0]?.city ?? '';
        state_billing.value = customer?.address?[0]?.state ?? '';
      }
      if (customer?.address?[0]?.type == "shipping") {
        address_1_shipping.value = customer?.address?[0]?.address_1 ?? '';
        address_2_shipping.value = customer?.address?[0]?.address_2 ?? '';
        pincode_shipping.value =
            customer?.address?[0]?.pincode.toString() ?? '';
        city_shipping.value = customer?.address?[0]?.city ?? '';
        state_shipping.value = customer?.address?[0]?.state ?? '';
      }
    } else {
      initializeVariables(billing: true, shipping: true);
    }
  }

  void searchCustomerByNumber(String? num) {
    if (num == null || num.isEmpty) {
      // Reset the searched list to the original list
      searchedCustomerDetailList.assignAll(customersList);
      return;
    }
    print('nihal');
    searchedCustomerDetailList.clear();
    for (var customer in customersList) {
      if (customer.phone != null &&
          customer.phone!.toLowerCase().contains(num.toLowerCase())) {
        searchedCustomerDetailList.add(customer);
      }
    }
  }

  Future<void> getCustomerList() async {
    // print('nihal');
    detailLoading.value = true;
    final response = await customerDataSourceImpl.getCustomerData();
    detailLoading.value = false;
    response.fold((failure) {
      detailLoading.value = false;
      customersList.value = [];
      print(failure.message);
    }, (resData) {
      // print(resData[1].stock_price);
      customersList.value = resData;
      searchedCustomerDetailList.assignAll(customersList);
    });
  }

  Future<PostResponseType> postCustomerData() async {
    try {
      final custDetails = PostCustomersModel(
          name: cust_name.value,
          phone: phoneNumber.value,
          email: email.value,
          gstin: gstNumber.value,
          company_name: companyName.value,
          opening_balance: "123",
          billing_address: address_1_billing.value == '' &&
                  address_2_billing.value == '' &&
                  pincode_billing.value == '' &&
                  city_billing.value == '' &&
                  state_billing.value == ''
              ? BillingAddressModel(
                  type: 'billing',
                  address_1: '-',
                  address_2: '-',
                  city: '-',
                  pincode: '-',
                  state: '-',
                  is_billing: '1',
                  is_shipping: '0')
              : BillingAddressModel(
                  type: 'billing',
                  address_1: address_1_billing.value,
                  address_2: address_2_billing.value,
                  city: city_billing.value,
                  pincode: pincode_billing.value,
                  state: state_billing.value,
                  is_billing: '1',
                  is_shipping: '0'),
          shipping_address: address_1_shipping.value == '' &&
                  address_2_shipping.value == '' &&
                  pincode_shipping.value == '' &&
                  city_shipping.value == '' &&
                  state_shipping.value == ''
              ? ShippingAddressModel(
                  type: 'shipping',
                  address_1: '-',
                  address_2: '-',
                  city: '-',
                  pincode: '-',
                  state: '-',
                  is_billing: '0',
                  is_shipping: '1')
              : ShippingAddressModel(
                  type: 'shipping',
                  address_1: address_1_shipping.value,
                  address_2: address_2_shipping.value,
                  city: city_shipping.value,
                  pincode: pincode_shipping.value,
                  state: state_shipping.value,
                  is_billing: '0',
                  is_shipping: '1'));
      print('testing : ${custDetails.toString()}');
      final response =
          await customerDataSourceImpl.postCustomerData(custDetails);

      print('API Response: $response');

      // Return the appropriate PostResponseType based on the response
      if (response.isRight()) {
        // if (true) {
        getCustomerList();
        return PostResponseType(postResponseEnum: PostResponseEnum.success);
      } else {
        return PostResponseType(postResponseEnum: PostResponseEnum.failed);
      }
    } catch (e) {
      print('Error: $e');
      return PostResponseType(postResponseEnum: PostResponseEnum.failed);
    }
  }

  Future<PostResponseType> putCustomerData(
      String id, CustomersModel? customer) async {
    try {
      final custDetails = pc.PutCustomersModel(
          name: cust_name.value == '' ? customer?.name : cust_name.value,
          phone: phoneNumber.value == '' ? customer?.phone : phoneNumber.value,
          email: email.value == '' ? customer?.email : email.value,
          gstin: gstNumber.value == '' ? customer?.gstin : gstNumber.value,
          company_name: companyName.value == ''
              ? customer?.company_name
              : companyName.value,
          opening_balance: "123",
          billing_address: pc.BillingAddressModel(
              type: 'billing',
              address_1: address_1_billing.value,
              address_2: address_2_billing.value,
              city: city_billing.value,
              pincode: pincode_billing.value,
              state: state_billing.value,
              is_billing: '1',
              is_shipping: '0'),
          shipping_address: pc.ShippingAddressModel(
              type: 'shipping',
              address_1: address_1_shipping.value,
              address_2: address_2_shipping.value,
              city: city_shipping.value,
              pincode: pincode_shipping.value,
              state: state_shipping.value,
              is_billing: '0',
              is_shipping: '1')
          // type: "billing",
          // address_1: address_1_billing.value,
          // address_2: address_2_billing.value,
          // city: city_billing.value,
          // pincode: pincode_billing.value,
          // state: state_billing.value,
          // is_same: "Y"
          );
      print('testing : ${custDetails.toString()}');
      //TODO: Find from where we can get customer ID
      print(selectedCustomer.value?.id);
      final response =
          await customerDataSourceImpl.putCustomerData(custDetails, id);

      // print('API Response: $response');

      // Return the appropriate PostResponseType based on the response
      // if (true) {
      if (response.isRight()) {
        getCustomerList();
        return PostResponseType(postResponseEnum: PostResponseEnum.success);
      } else {
        return PostResponseType(postResponseEnum: PostResponseEnum.failed);
      }
    } catch (e) {
      print('Error: $e');
      return PostResponseType(postResponseEnum: PostResponseEnum.failed);
    }
  }

  void selectCustomer(CustomersModel customer) {
    
    selectedCustomer.value = customer;
    if (selectedCustomer.value != null) print('jdfnkdsfksjfnnjks');
    selectedCustomer.refresh();
    update();
    // refresh();
  }
}
