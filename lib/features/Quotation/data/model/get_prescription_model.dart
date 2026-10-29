// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GetCustomerPrescriptionModel {
  int? id;
  int? customer_id;
  int? l_sph;
  int? l_cyl;
  int? l_axis;
  int? l_vision;
  int? r_sph;
  int? r_cyl;
  int? r_axis;
  int? r_vision;
  int? add;
  int? pd;
  String? optometrics;
  GetCustomerPrescriptionModel({
    this.id,
    this.customer_id,
    this.l_sph,
    this.l_cyl,
    this.l_axis,
    this.l_vision,
    this.r_sph,
    this.r_cyl,
    this.r_axis,
    this.r_vision,
    this.add,
    this.pd,
    this.optometrics,
  });

  GetCustomerPrescriptionModel copyWith({
    int? id,
    int? customer_id,
    int? l_sph,
    int? l_cyl,
    int? l_axis,
    int? l_vision,
    int? r_sph,
    int? r_cyl,
    int? r_axis,
    int? r_vision,
    int? add,
    int? pd,
    String? optometrics,
  }) {
    return GetCustomerPrescriptionModel(
      id: id ?? this.id,
      customer_id: customer_id ?? this.customer_id,
      l_sph: l_sph ?? this.l_sph,
      l_cyl: l_cyl ?? this.l_cyl,
      l_axis: l_axis ?? this.l_axis,
      l_vision: l_vision ?? this.l_vision,
      r_sph: r_sph ?? this.r_sph,
      r_cyl: r_cyl ?? this.r_cyl,
      r_axis: r_axis ?? this.r_axis,
      r_vision: r_vision ?? this.r_vision,
      add: add ?? this.add,
      pd: pd ?? this.pd,
      optometrics: optometrics ?? this.optometrics,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'customer_id': customer_id,
      'l_sph': l_sph,
      'l_cyl': l_cyl,
      'l_axis': l_axis,
      'l_vision': l_vision,
      'r_sph': r_sph,
      'r_cyl': r_cyl,
      'r_axis': r_axis,
      'r_vision': r_vision,
      'add': add,
      'pd': pd,
      'optometrics': optometrics,
    };
  }

  factory GetCustomerPrescriptionModel.fromMap(Map<String, dynamic> map) {
    return GetCustomerPrescriptionModel(
      id: map['id'] != null ? map['id'] as int : null,
      customer_id: map['customer_id'] != null ? map['customer_id'] as int : null,
      l_sph: map['l_sph'] != null ? map['l_sph'] as int : null,
      l_cyl: map['l_cyl'] != null ? map['l_cyl'] as int : null,
      l_axis: map['l_axis'] != null ? map['l_axis'] as int : null,
      l_vision: map['l_vision'] != null ? map['l_vision'] as int : null,
      r_sph: map['r_sph'] != null ? map['r_sph'] as int : null,
      r_cyl: map['r_cyl'] != null ? map['r_cyl'] as int : null,
      r_axis: map['r_axis'] != null ? map['r_axis'] as int : null,
      r_vision: map['r_vision'] != null ? map['r_vision'] as int : null,
      add: map['add'] != null ? map['add'] as int : null,
      pd: map['pd'] != null ? map['pd'] as int : null,
      optometrics: map['optometrics'] != null ? map['optometrics'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GetCustomerPrescriptionModel.fromJson(String source) => GetCustomerPrescriptionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GetCustomerPrescriptionModel(id: $id, customer_id: $customer_id, l_sph: $l_sph, l_cyl: $l_cyl, l_axis: $l_axis, l_vision: $l_vision, r_sph: $r_sph, r_cyl: $r_cyl, r_axis: $r_axis, r_vision: $r_vision, add: $add, pd: $pd, optometrics: $optometrics)';
  }

  @override
  bool operator ==(covariant GetCustomerPrescriptionModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.customer_id == customer_id &&
      other.l_sph == l_sph &&
      other.l_cyl == l_cyl &&
      other.l_axis == l_axis &&
      other.l_vision == l_vision &&
      other.r_sph == r_sph &&
      other.r_cyl == r_cyl &&
      other.r_axis == r_axis &&
      other.r_vision == r_vision &&
      other.add == add &&
      other.pd == pd &&
      other.optometrics == optometrics;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      customer_id.hashCode ^
      l_sph.hashCode ^
      l_cyl.hashCode ^
      l_axis.hashCode ^
      l_vision.hashCode ^
      r_sph.hashCode ^
      r_cyl.hashCode ^
      r_axis.hashCode ^
      r_vision.hashCode ^
      add.hashCode ^
      pd.hashCode ^
      optometrics.hashCode;
  }
}
