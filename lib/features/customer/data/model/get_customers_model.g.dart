// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'get_customers_model.dart';

// // **************************************************************************
// // JsonSerializableGenerator
// // **************************************************************************

// CustomersModel _$CustomersModelFromJson(Map<String, dynamic> json) =>
//     CustomersModel(
//       id: json['id'] as int?,
//       billing: json['billing'] == null
//           ? null
//           : BillingModel.fromJson(json['billing'] as Map<String, dynamic>),
//       company_name: json['company_name'] as String?,
//       email: json['email'] as String?,
//       gstin: json['gstin'] as String?,
//       name: json['name'] as String?,
//       phone: json['phone'] as String?,
//       opening_balance: json['opening_balance'] as int?,
//       shipping: json['shipping'] == null
//           ? null
//           : ShippingModel.fromJson(json['shipping'] as Map<String, dynamic>),
//       customer_id: json['customer_id'] as String?,
//     );

// Map<String, dynamic> _$CustomersModelToJson(CustomersModel instance) =>
//     <String, dynamic>{
//       'id': instance.id,
//       'billing': instance.billing,
//       'company_name': instance.company_name,
//       'email': instance.email,
//       'gstin': instance.gstin,
//       'name': instance.name,
//       'phone': instance.phone,
//       'opening_balance': instance.opening_balance,
//       'shipping': instance.shipping,
//       'customer_id': instance.customer_id,
//     };

// BillingModel _$BillingModelFromJson(Map<String, dynamic> json) => BillingModel(
//       id: json['id'] as int?,
//       address_1: json['address_1'] as String?,
//       address_2: json['address_2'] as String?,
//       city: json['city'] as String?,
//       pincode: json['pincode'] as int?,
//       state: json['state'] as String?,
//     );

// Map<String, dynamic> _$BillingModelToJson(BillingModel instance) =>
//     <String, dynamic>{
//       'id': instance.id,
//       'address_1': instance.address_1,
//       'address_2': instance.address_2,
//       'city': instance.city,
//       'pincode': instance.pincode,
//       'state': instance.state,
//     };

// ShippingModel _$ShippingModelFromJson(Map<String, dynamic> json) =>
//     ShippingModel(
//       id: json['id'] as int?,
//       address_1: json['address_1'] as String?,
//       address_2: json['address_2'] as String?,
//       city: json['city'] as String?,
//       pincode: json['pincode'] as int?,
//       is_same: json['is_same'] as String?,
//       state: json['state'] as String?,
//     );

// Map<String, dynamic> _$ShippingModelToJson(ShippingModel instance) =>
//     <String, dynamic>{
//       'id': instance.id,
//       'address_1': instance.address_1,
//       'address_2': instance.address_2,
//       'city': instance.city,
//       'pincode': instance.pincode,
//       'is_same': instance.is_same,
//       'state': instance.state,
//     };
