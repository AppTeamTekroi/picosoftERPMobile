// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CartItemModel {
  int? id;
  int? product_id;
  String? product_name;
  int? customer_id;
  int? prescription_id;
  int? cart_lenses_id;
  String? quantities;
  String? discount;
  String? price;
  String? gst_amount;
  String? total_amount;
  num? gst_percentage;

  CartItemModel({
    this.id,
    this.product_id,
    this.product_name,
    this.customer_id,
    this.prescription_id,
    this.cart_lenses_id,
    this.quantities,
    this.discount,
    this.price,
    this.gst_amount,
    this.total_amount,
    this.gst_percentage,
  });

  CartItemModel copyWith({
    int? id,
    int? product_id,
    String? product_name,
    int? customer_id,
    int? prescription_id,
    int? cart_lenses_id,
    String? quantities,
    String? discount,
    String? price,
    String? gst_amount,
    String? total_amount,
    num? gst_percentage,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      product_id: product_id ?? this.product_id,
      product_name: product_name ?? this.product_name,
      customer_id: customer_id ?? this.customer_id,
      prescription_id: prescription_id ?? this.prescription_id,
      cart_lenses_id: cart_lenses_id ?? this.cart_lenses_id,
      quantities: quantities ?? this.quantities,
      discount: discount ?? this.discount,
      price: price ?? this.price,
      gst_amount: gst_amount ?? this.gst_amount,
      total_amount: total_amount ?? this.total_amount,
      gst_percentage: gst_percentage ?? this.gst_percentage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'product_id': product_id,
      'product_name': product_name,
      'customer_id': customer_id,
      'prescription_id': prescription_id,
      'cart_lenses_id': cart_lenses_id,
      'quantities': quantities,
      'discount': discount,
      'price': price,
      'gst_amount': gst_amount,
      'total_amount': total_amount,
      'gst_percentage': gst_percentage,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['id'] != null ? map['id'] as int : null,
      product_id: map['product_id'] != null ? map['product_id'] as int : null,
      product_name: map['product_name'] != null ? map['product_name'] as String : null,
      customer_id: map['customer_id'] != null ? map['customer_id'] as int : null,
      prescription_id: map['prescription_id'] != null ? map['prescription_id'] as int : null,
      cart_lenses_id: map['cart_lenses_id'] != null ? map['cart_lenses_id'] as int : null,
      quantities: map['quantities'] != null ? map['quantities'] as String : null,
      discount: map['discount'] != null ? map['discount'] as String : null,
      price: map['price'] != null ? map['price'] as String : null,
      gst_amount: map['gst_amount'] != null ? map['gst_amount'] as String : null,
      total_amount: map['total_amount'] != null ? map['total_amount'] as String : null,
      gst_percentage: map['gst_percentage'] != null ? map['gst_percentage'] as num : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItemModel.fromJson(String source) =>
      CartItemModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CartItemModel(id: $id, product_id: $product_id, product_name: $product_name, customer_id: $customer_id, prescription_id: $prescription_id, cart_lenses_id: $cart_lenses_id, quantities: $quantities, discount: $discount, price: $price, gst_amount: $gst_amount, total_amount: $total_amount, gst_percentage: $gst_percentage)';
  }

  @override
  bool operator ==(covariant CartItemModel other) {
    if (identical(this, other)) return true;

    return 
      other.id == id &&
      other.product_id == product_id &&
      other.product_name == product_name &&
      other.customer_id == customer_id &&
      other.prescription_id == prescription_id &&
      other.cart_lenses_id == cart_lenses_id &&
      other.quantities == quantities &&
      other.discount == discount &&
      other.price == price &&
      other.gst_amount == gst_amount &&
      other.total_amount == total_amount &&
      other.gst_percentage == gst_percentage;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      product_id.hashCode ^
      product_name.hashCode ^
      customer_id.hashCode ^
      prescription_id.hashCode ^
      cart_lenses_id.hashCode ^
      quantities.hashCode ^
      discount.hashCode ^
      price.hashCode ^
      gst_amount.hashCode ^
      total_amount.hashCode ^
      gst_percentage.hashCode;
  }
}