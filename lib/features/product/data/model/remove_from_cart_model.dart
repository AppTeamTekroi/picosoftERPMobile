import 'dart:convert';
import 'dart:ffi';

class RemoveFromCartModel {
  String? productId;
  String? customerId;
  int? status;
  RemoveFromCartModel({
    this.productId,
    this.customerId,
    this.status,
  });

  RemoveFromCartModel copyWith({
    String? productId,
    String? customerId,
    int? status,
  }) {
    return RemoveFromCartModel(
      productId: productId ?? this.productId,
      customerId: customerId ?? this.customerId,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productId': productId,
      'customerId': customerId,
      'status': status,
    };
  }

  factory RemoveFromCartModel.fromMap(Map<String, dynamic> map) {
    return RemoveFromCartModel(
      productId: map['product_Id'] != null ? map['product_Id'] as String : null,
      customerId: map['customer_Id'] != null ? map['customer_Id'] as String : null,
      status: map['status']??null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RemoveFromCartModel.fromJson(String source) => RemoveFromCartModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'RemoveFromCartModel(product_Id: $productId, customer_Id: $customerId, status: $status)';

  @override
  bool operator ==(covariant RemoveFromCartModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.productId == productId &&
      other.customerId == customerId &&
      other.status == status;
  }

  @override
  int get hashCode => productId.hashCode ^ customerId.hashCode ^ status.hashCode;
}
