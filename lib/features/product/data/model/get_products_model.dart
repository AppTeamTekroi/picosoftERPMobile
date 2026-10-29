import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
part 'get_products_model.g.dart';

@JsonSerializable()
class ProductsModel {
  final int? id;
  final double? avgPurchasePrice;
  final String? barcodeId;
  final String? description;
  final double? discount;
  final int? freeQty;
  final String? hsnCode;
  final String? image;
  final int? isPriceWithTax;
  final double? priceWithTax;
  double? price;
  final String? productCategory;
  final int? productId;
  final String? productName;
  final String? productType;
  final double? qty;
  final int? showOnline;
  final double? tax;
  final double? purchasePrice;
  final String? isSelected;
  double? selectedQty;
  final double? totalPrice;
  final double? totalTax;
  final double? totalDiscount;
  final double? netAmount;
  final String? unit;
  final String? url;
  final double? unitPrice;

  ProductsModel({
    required this.id,
    required this.avgPurchasePrice,
    required this.barcodeId,
    required this.description,
    required this.discount,
    required this.freeQty,
    required this.hsnCode,
    required this.image,
    required this.isPriceWithTax,
    required this.priceWithTax,
    required this.price,
    required this.productCategory,
    required this.productId,
    required this.productName,
    required this.productType,
    required this.qty,
    required this.showOnline,
    required this.tax,
    required this.purchasePrice,
    required this.isSelected,
    required this.selectedQty,
    required this.totalPrice,
    required this.totalTax,
    required this.totalDiscount,
    required this.netAmount,
    required this.unit,
    required this.url,
    required this.unitPrice,
  });

  factory ProductsModel.fromJson(Map<String, dynamic> json) =>
      _$ProductsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsModelToJson(this);
}

