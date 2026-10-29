// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PostProductsModel {
  String? name;
  String? stock_price;
  String? barcode;
  String? description;
  int? tax;
  String? mrp;
  String? gst;
  String? hsn;
  int? product_category_id;
  int? item_type_id;
  PostProductsModel({
    this.name,
    this.stock_price,
    this.barcode,
    this.description,
    this.tax,
    this.mrp,
    this.gst,
    this.hsn,
    this.product_category_id,
    this.item_type_id,
  });

  PostProductsModel copyWith({
    String? name,
    String? stock_price,
    String? barcode,
    String? description,
    int? tax,
    String? mrp,
    String? hsn,
    int? product_category_id,
    int? item_type_id,
  }) {
    return PostProductsModel(
      name: name ?? this.name,
      stock_price: stock_price ?? this.stock_price,
      barcode: barcode ?? this.barcode,
      description: description ?? this.description,
      tax: tax ?? this.tax,
      mrp: mrp ?? this.mrp,
      gst: mrp ?? this.gst,
      hsn: hsn ?? this.hsn,
      product_category_id: product_category_id ?? this.product_category_id,
      item_type_id: item_type_id ?? this.item_type_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'stock_price': stock_price,
      'barcode': barcode,
      'description': description,
      'tax': tax,
      'mrp': mrp,
      'hsn': hsn,
      'product_category_id': product_category_id,
      'item_type_id': item_type_id,
    };
  }

  factory PostProductsModel.fromMap(Map<String, dynamic> map) {
    return PostProductsModel(
      name: map['name'] != null ? map['name'] as String : null,
      stock_price:
          map['stock_price'] != null ? map['stock_price'] as String : null,
      barcode: map['barcode'] != null ? map['barcode'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      tax: map['tax'] != null ? map['tax'] as int : null,
      gst: map['gst'] != null ? map['gst'] as String : null,
      mrp: map['mrp'] != null ? map['mrp'] as String : null,
      hsn: map['hsn'] != null ? map['hsn'] as String : null,
      product_category_id: map['product_category_id'] != null
          ? map['product_category_id'] as int
          : null,
      item_type_id:
          map['item_type_id'] != null ? map['item_type_id'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostProductsModel.fromJson(String source) =>
      PostProductsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostProductsModel(name: $name, stock_price: $stock_price, barcode: $barcode, description: $description, tax: $tax, mrp: $mrp, hsn: $hsn,gst: $gst, product_category_id: $product_category_id, item_type_id: $item_type_id)';
  }

  @override
  bool operator ==(covariant PostProductsModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.stock_price == stock_price &&
        other.barcode == barcode &&
        other.description == description &&
        other.tax == tax &&
        other.mrp == mrp &&
        other.gst == gst &&
        other.hsn == hsn &&
        other.product_category_id == product_category_id &&
        other.item_type_id == item_type_id;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        stock_price.hashCode ^
        barcode.hashCode ^
        description.hashCode ^
        tax.hashCode ^
        mrp.hashCode ^
        gst.hashCode ^
        hsn.hashCode ^
        product_category_id.hashCode ^
        item_type_id.hashCode;
  }
}
