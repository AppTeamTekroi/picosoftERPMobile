// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PutCustomersModel {
  String? company_name;
  String? email;
  String? gstin;
  String? name;
  String? phone;
  String? opening_balance;
  BillingAddressModel? billing_address;
  ShippingAddressModel? shipping_address;
  PutCustomersModel({
    this.company_name,
    this.email,
    this.gstin,
    this.name,
    this.phone,
    this.opening_balance,
    this.billing_address,
    this.shipping_address,
  });


  PutCustomersModel copyWith({
    String? company_name,
    String? email,
    String? gstin,
    String? name,
    String? phone,
    String? opening_balance,
    BillingAddressModel? billing_address,
    ShippingAddressModel? shipping_address,
  }) {
    return PutCustomersModel(
      company_name: company_name ?? this.company_name,
      email: email ?? this.email,
      gstin: gstin ?? this.gstin,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      opening_balance: opening_balance ?? this.opening_balance,
      billing_address: billing_address ?? this.billing_address,
      shipping_address: shipping_address ?? this.shipping_address,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'company_name': company_name,
      'email': email,
      'gstin': gstin,
      'name': name,
      'phone': phone,
      'opening_balance': opening_balance,
      'billing_address': billing_address?.toMap(),
      'shipping_address': shipping_address?.toMap(),
    };
  }

  factory PutCustomersModel.fromMap(Map<String, dynamic> map) {
    return PutCustomersModel(
      company_name: map['company_name'] != null ? map['company_name'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      gstin: map['gstin'] != null ? map['gstin'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      opening_balance: map['opening_balance'] != null ? map['opening_balance'] as String : null,
      billing_address: map['billing_address'] != null ? BillingAddressModel.fromMap(map['billing_address'] as Map<String,dynamic>) : null,
      shipping_address: map['shipping_address'] != null ? ShippingAddressModel.fromMap(map['shipping_address'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PutCustomersModel.fromJson(String source) => PutCustomersModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostCustomersModel(company_name: $company_name, email: $email, gstin: $gstin, name: $name, phone: $phone, opening_balance: $opening_balance, billing_address: $billing_address, shipping_address: $shipping_address)';
  }

  @override
  bool operator ==(covariant PutCustomersModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.company_name == company_name &&
      other.email == email &&
      other.gstin == gstin &&
      other.name == name &&
      other.phone == phone &&
      other.opening_balance == opening_balance &&
      other.billing_address == billing_address &&
      other.shipping_address == shipping_address;
  }

  @override
  int get hashCode {
    return company_name.hashCode ^
      email.hashCode ^
      gstin.hashCode ^
      name.hashCode ^
      phone.hashCode ^
      opening_balance.hashCode ^
      billing_address.hashCode ^
      shipping_address.hashCode;
  }
}

class BillingAddressModel {
    String? type;
    String? address_1;
    String? address_2;
    String? city;
    String? pincode;
    String? state;
    String? is_billing;
    String? is_shipping;
  BillingAddressModel({
    this.type,
    this.address_1,
    this.address_2,
    this.city,
    this.pincode,
    this.state,
    this.is_billing,
    this.is_shipping,
  });


  BillingAddressModel copyWith({
    String? type,
    String? address_1,
    String? address_2,
    String? city,
    String? pincode,
    String? state,
    String? is_billing,
    String? is_shipping,
  }) {
    return BillingAddressModel(
      type: type ?? this.type,
      address_1: address_1 ?? this.address_1,
      address_2: address_2 ?? this.address_2,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      state: state ?? this.state,
      is_billing: is_billing ?? this.is_billing,
      is_shipping: is_shipping ?? this.is_shipping,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'address_1': address_1,
      'address_2': address_2,
      'city': city,
      'pincode': pincode,
      'state': state,
      'is_billing': is_billing,
      'is_shipping': is_shipping,
    };
  }

  factory BillingAddressModel.fromMap(Map<String, dynamic> map) {
    return BillingAddressModel(
      type: map['type'] != null ? map['type'] as String : null,
      address_1: map['address_1'] != null ? map['address_1'] as String : null,
      address_2: map['address_2'] != null ? map['address_2'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      pincode: map['pincode'] != null ? map['pincode'] as String : null,
      state: map['state'] != null ? map['state'] as String : null,
      is_billing: map['is_billing'] != null ? map['is_billing'] as String : null,
      is_shipping: map['is_shipping'] != null ? map['is_shipping'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BillingAddressModel.fromJson(String source) => BillingAddressModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BillingAddressModel(type: $type, address_1: $address_1, address_2: $address_2, city: $city, pincode: $pincode, state: $state, is_billing: $is_billing, is_shipping: $is_shipping)';
  }

  @override
  bool operator ==(covariant BillingAddressModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.type == type &&
      other.address_1 == address_1 &&
      other.address_2 == address_2 &&
      other.city == city &&
      other.pincode == pincode &&
      other.state == state &&
      other.is_billing == is_billing &&
      other.is_shipping == is_shipping;
  }

  @override
  int get hashCode {
    return type.hashCode ^
      address_1.hashCode ^
      address_2.hashCode ^
      city.hashCode ^
      pincode.hashCode ^
      state.hashCode ^
      is_billing.hashCode ^
      is_shipping.hashCode;
  }
}

class ShippingAddressModel {
    String? type;
    String? address_1;
    String? address_2;
    String? city;
    String? pincode;
    String? state;
    String? is_billing;
    String? is_shipping;
  ShippingAddressModel({
    this.type,
    this.address_1,
    this.address_2,
    this.city,
    this.pincode,
    this.state,
    this.is_billing,
    this.is_shipping,
  });

  ShippingAddressModel copyWith({
    String? type,
    String? address_1,
    String? address_2,
    String? city,
    String? pincode,
    String? state,
    String? is_billing,
    String? is_shipping,
  }) {
    return ShippingAddressModel(
      type: type ?? this.type,
      address_1: address_1 ?? this.address_1,
      address_2: address_2 ?? this.address_2,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      state: state ?? this.state,
      is_billing: is_billing ?? this.is_billing,
      is_shipping: is_shipping ?? this.is_shipping,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'address_1': address_1,
      'address_2': address_2,
      'city': city,
      'pincode': pincode,
      'state': state,
      'is_billing': is_billing,
      'is_shipping': is_shipping,
    };
  }

  factory ShippingAddressModel.fromMap(Map<String, dynamic> map) {
    return ShippingAddressModel(
      type: map['type'] != null ? map['type'] as String : null,
      address_1: map['address_1'] != null ? map['address_1'] as String : null,
      address_2: map['address_2'] != null ? map['address_2'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      pincode: map['pincode'] != null ? map['pincode'] as String : null,
      state: map['state'] != null ? map['state'] as String : null,
      is_billing: map['is_billing'] != null ? map['is_billing'] as String : null,
      is_shipping: map['is_shipping'] != null ? map['is_shipping'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShippingAddressModel.fromJson(String source) => ShippingAddressModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ShippingAddressModel(type: $type, address_1: $address_1, address_2: $address_2, city: $city, pincode: $pincode, state: $state, is_billing: $is_billing, is_shipping: $is_shipping)';
  }

  @override
  bool operator ==(covariant ShippingAddressModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.type == type &&
      other.address_1 == address_1 &&
      other.address_2 == address_2 &&
      other.city == city &&
      other.pincode == pincode &&
      other.state == state &&
      other.is_billing == is_billing &&
      other.is_shipping == is_shipping;
  }

  @override
  int get hashCode {
    return type.hashCode ^
      address_1.hashCode ^
      address_2.hashCode ^
      city.hashCode ^
      pincode.hashCode ^
      state.hashCode ^
      is_billing.hashCode ^
      is_shipping.hashCode;
  }
}
