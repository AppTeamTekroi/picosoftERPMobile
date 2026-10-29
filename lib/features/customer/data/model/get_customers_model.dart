// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:json_annotation/json_annotation.dart';
// part 'get_customers_model.g.dart';

// @JsonSerializable()
// class CustomersModel {
//   int? id;
//   BillingModel? billing;
//   String? company_name;
//   String? email;
//   String? gstin;
//   String? name;
//   String? phone;
//   int? opening_balance;
//   ShippingModel? shipping;
//   String? customer_id;
//   CustomersModel({
//     this.id,
//     this.billing,
//     this.company_name,
//     this.email,
//     this.gstin,
//     this.name,
//     this.phone,
//     this.opening_balance,
//     this.shipping,
//     this.customer_id,
//   });

//   factory CustomersModel.fromJson(Map<String, dynamic> json) =>
//       _$CustomersModelFromJson(json);

//   Map<String, dynamic> toJson() => _$CustomersModelToJson(this);
// }

// @JsonSerializable()
// class BillingModel {
//   int? id;
//   String? address_1;
//   String? address_2;
//   String? city;
//   int? pincode;
//   String? state;
//   BillingModel({
//     this.id,
//     this.address_1,
//     this.address_2,
//     this.city,
//     this.pincode,
//     this.state,
//   });

//   factory BillingModel.fromJson(Map<String, dynamic> json) =>
//       _$BillingModelFromJson(json);

//   Map<String, dynamic> toJson() => _$BillingModelToJson(this);
// }

// @JsonSerializable()
// class ShippingModel {
//   int? id;
//   String? address_1;
//   String? address_2;
//   String? city;
//   int? pincode;
//   String? is_same;
//   String? state;
//   ShippingModel({
//     this.id,
//     this.address_1,
//     this.address_2,
//     this.city,
//     this.pincode,
//     this.is_same,
//     this.state,
//   });

//   factory ShippingModel.fromJson(Map<String, dynamic> json) =>
//       _$ShippingModelFromJson(json);

//   Map<String, dynamic> toJson() => _$ShippingModelToJson(this);
// }
