// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class getProductDataModel {
  int? id;
  String? name;
  String? stock_price;
  String? barcode;
  String? description;
  int? tax;
  String? mrp;
  String? hsn;
  int? product_category_id;
  int? item_type_id;
  double? selectedQty;
  getProductDataModel({
    this.id,
    this.name,
    this.stock_price,
    this.barcode,
    this.description,
    this.tax,
    this.mrp,
    this.hsn,
    this.product_category_id,
    this.item_type_id,
    this.selectedQty,
  });
  

  getProductDataModel copyWith({
    int? id,
    String? name,
    String? stock_price,
    String? barcode,
    String? description,
    int? tax,
    String? mrp,
    String? hsn,
    int? product_category_id,
    int? item_type_id,
    double? selectedQty,
  }) {
    return getProductDataModel(
      id: id ?? this.id,
      name: name ?? this.name,
      stock_price: stock_price ?? this.stock_price,
      barcode: barcode ?? this.barcode,
      description: description ?? this.description,
      tax: tax ?? this.tax,
      mrp: mrp ?? this.mrp,
      hsn: hsn ?? this.hsn,
      product_category_id: product_category_id ?? this.product_category_id,
      item_type_id: item_type_id ?? this.item_type_id,
      selectedQty: selectedQty ?? this.selectedQty,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'stock_price': stock_price,
      'barcode': barcode,
      'description': description,
      'tax': tax,
      'mrp': mrp,
      'hsn': hsn,
      'product_category_id': product_category_id,
      'item_type_id': item_type_id,
      'selectedQty': selectedQty,
    };
  }

  factory getProductDataModel.fromMap(Map<String, dynamic> map) {
    return getProductDataModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      stock_price: map['stock_price'] != null ? map['stock_price'] as String : null,
      barcode: map['barcode'] != null ? map['barcode'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      tax: map['tax'] != null ? map['tax'] as int : null,
      mrp: map['mrp'] != null ? map['mrp'] as String : null,
      hsn: map['hsn'] != null ? map['hsn'] as String : null,
      product_category_id: map['product_category_id'] != null ? map['product_category_id'] as int : null,
      item_type_id: map['item_type_id'] != null ? map['item_type_id'] as int : null,
      selectedQty: map['selectedQty'] != null ? map['selectedQty'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory getProductDataModel.fromJson(String source) => getProductDataModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'getProductDataModel(id: $id, name: $name, stock_price: $stock_price, barcode: $barcode, description: $description, tax: $tax, mrp: $mrp, hsn: $hsn, product_category_id: $product_category_id, item_type_id: $item_type_id, selectedQty: $selectedQty)';
  }

  @override
  bool operator ==(covariant getProductDataModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.stock_price == stock_price &&
      other.barcode == barcode &&
      other.description == description &&
      other.tax == tax &&
      other.mrp == mrp &&
      other.hsn == hsn &&
      other.product_category_id == product_category_id &&
      other.item_type_id == item_type_id &&
      other.selectedQty == selectedQty;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      stock_price.hashCode ^
      barcode.hashCode ^
      description.hashCode ^
      tax.hashCode ^
      mrp.hashCode ^
      hsn.hashCode ^
      product_category_id.hashCode ^
      item_type_id.hashCode ^
      selectedQty.hashCode;
  }
}
