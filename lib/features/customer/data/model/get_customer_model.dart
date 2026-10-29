// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class CustomersModel {
  int? id;
  String? company_name;
  String? email;
  String? gstin;
  String? name;
  String? phone;
  int? opening_balance;
  int? address_id;
  int? store_id;
  List<GetAddressModel?>? address;
  CustomersModel({
    this.id,
    this.company_name,
    this.email,
    this.gstin,
    this.name,
    this.phone,
    this.opening_balance,
    this.address_id,
    this.store_id,
    this.address,
  });

  CustomersModel copyWith({
    int? id,
    String? company_name,
    String? email,
    String? gstin,
    String? name,
    String? phone,
    int? opening_balance,
    int? address_id,
    int? store_id,
    List<GetAddressModel?>? address,
  }) {
    return CustomersModel(
      id: id ?? this.id,
      company_name: company_name ?? this.company_name,
      email: email ?? this.email,
      gstin: gstin ?? this.gstin,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      opening_balance: opening_balance ?? this.opening_balance,
      address_id: address_id ?? this.address_id,
      store_id: store_id ?? this.store_id,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'company_name': company_name,
      'email': email,
      'gstin': gstin,
      'name': name,
      'phone': phone,
      'opening_balance': opening_balance,
      'address_id': address_id,
      'store_id': store_id,
      'address': address?.map((x) => x?.toMap()).toList(),
    };
  }

  factory CustomersModel.fromMap(Map<String, dynamic> map) {
    return CustomersModel(
      id: map['id'] != null ? map['id'] as int : null,
      company_name: map['company_name'] != null ? map['company_name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      gstin: map['gstin'] != null ? map['gstin'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      opening_balance: map['opening_balance'] != null ? map['opening_balance'] as int : null,
      address_id: map['address_id'] != null ? map['address_id'] as int : null,
      store_id: map['store_id'] != null ? map['store_id'] as int : null,
      address: map['address'] != null ? List<GetAddressModel>.from((map['address'] as List<dynamic>).map<GetAddressModel?>((x) => GetAddressModel.fromMap(x as Map<String,dynamic>),),) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomersModel.fromJson(String source) => CustomersModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CustomersModel(id: $id, company_name: $company_name, email: $email, gstin: $gstin, name: $name, phone: $phone, opening_balance: $opening_balance, address_id: $address_id, store_id: $store_id, address: $address)';
  }

  @override
  bool operator ==(covariant CustomersModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.company_name == company_name &&
      other.email == email &&
      other.gstin == gstin &&
      other.name == name &&
      other.phone == phone &&
      other.opening_balance == opening_balance &&
      other.address_id == address_id &&
      other.store_id == store_id &&
      listEquals(other.address, address);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      company_name.hashCode ^
      email.hashCode ^
      gstin.hashCode ^
      name.hashCode ^
      phone.hashCode ^
      opening_balance.hashCode ^
      address_id.hashCode ^
      store_id.hashCode ^
      address.hashCode;
  }
}

class GetAddressModel {
  int? id;
  String? customer_id;
  String? type;
  String? address_1;
  String? address_2;
  String? is_billing;
  String? is_shipping;
  String? city;
  String? pincode;
  String? state;
  String? is_same;
  int? customer_vendor_id;
  GetAddressModel({
    this.id,
    this.customer_id,
    this.type,
    this.address_1,
    this.address_2,
    this.is_billing,
    this.is_shipping,
    this.city,
    this.pincode,
    this.state,
    this.is_same,
    this.customer_vendor_id,
  });

  GetAddressModel copyWith({
    int? id,
    String? customer_id,
    String? type,
    String? address_1,
    String? address_2,
    String? is_billing,
    String? is_shipping,
    String? city,
    String? pincode,
    String? state,
    String? is_same,
    int? customer_vendor_id,
  }) {
    return GetAddressModel(
      id: id ?? this.id,
      customer_id: customer_id ?? this.customer_id,
      type: type ?? this.type,
      address_1: address_1 ?? this.address_1,
      address_2: address_2 ?? this.address_2,
      is_billing: is_billing ?? this.is_billing,
      is_shipping: is_shipping ?? this.is_shipping,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      state: state ?? this.state,
      is_same: is_same ?? this.is_same,
      customer_vendor_id: customer_vendor_id ?? this.customer_vendor_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'customer_id': customer_id,
      'type': type,
      'address_1': address_1,
      'address_2': address_2,
      'is_billing': is_billing,
      'is_shipping': is_shipping,
      'city': city,
      'pincode': pincode,
      'state': state,
      'is_same': is_same,
      'customer_vendor_id': customer_vendor_id,
    };
  }

  factory GetAddressModel.fromMap(Map<String, dynamic> map) {
    return GetAddressModel(
      id: map['id'] != null ? map['id'] as int : null,
      customer_id: map['customer_id'] != null ? map['customer_id'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      address_1: map['address_1'] != null ? map['address_1'] as String : null,
      address_2: map['address_2'] != null ? map['address_2'] as String : null,
      is_billing: map['is_billing'] != null ? map['is_billing'] as String : null,
      is_shipping: map['is_shipping'] != null ? map['is_shipping'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      pincode: map['pincode'] != null ? map['pincode'] as String : null,
      state: map['state'] != null ? map['state'] as String : null,
      is_same: map['is_same'] != null ? map['is_same'] as String : null,
      customer_vendor_id: map['customer_vendor_id'] != null ? map['customer_vendor_id'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GetAddressModel.fromJson(String source) => GetAddressModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GetAddressModel(id: $id, customer_id: $customer_id, type: $type, address_1: $address_1, address_2: $address_2, is_billing: $is_billing, is_shipping: $is_shipping, city: $city, pincode: $pincode, state: $state, is_same: $is_same, customer_vendor_id: $customer_vendor_id)';
  }

  @override
  bool operator ==(covariant GetAddressModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.customer_id == customer_id &&
      other.type == type &&
      other.address_1 == address_1 &&
      other.address_2 == address_2 &&
      other.is_billing == is_billing &&
      other.is_shipping == is_shipping &&
      other.city == city &&
      other.pincode == pincode &&
      other.state == state &&
      other.is_same == is_same &&
      other.customer_vendor_id == customer_vendor_id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      customer_id.hashCode ^
      type.hashCode ^
      address_1.hashCode ^
      address_2.hashCode ^
      is_billing.hashCode ^
      is_shipping.hashCode ^
      city.hashCode ^
      pincode.hashCode ^
      state.hashCode ^
      is_same.hashCode ^
      customer_vendor_id.hashCode;
  }
}
