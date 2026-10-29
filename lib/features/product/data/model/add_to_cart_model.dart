// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AddToCartModel {
  String? productId;
  String? customerId;
  String? quantities;
  AddToCartModel({
    this.productId,
    this.customerId,
    this.quantities,
  });

  AddToCartModel copyWith({
    String? productId,
    String? customerId,
    String? quantities,
  }) {
    return AddToCartModel(
      productId: productId ?? this.productId,
      customerId: customerId ?? this.customerId,
      quantities: quantities ?? this.quantities,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productId': productId,
      'customerId': customerId,
      'quantities': quantities,
    };
  }

  factory AddToCartModel.fromMap(Map<String, dynamic> map) {
    return AddToCartModel(
      productId: map['productId'] != null ? map['productId'] as String : null,
      customerId: map['customerId'] != null ? map['customerId'] as String : null,
      quantities: map['quantities'] != null ? map['quantities'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddToCartModel.fromJson(String source) => AddToCartModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AddToCartModel(productId: $productId, customerId: $customerId, quantities: $quantities)';

  @override
  bool operator ==(covariant AddToCartModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.productId == productId &&
      other.customerId == customerId &&
      other.quantities == quantities;
  }

  @override
  int get hashCode => productId.hashCode ^ customerId.hashCode ^ quantities.hashCode;
}
