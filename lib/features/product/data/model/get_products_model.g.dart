// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_products_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductsModel _$ProductsModelFromJson(Map<String, dynamic> json) =>
    ProductsModel(
          id: json['id'] as int?,
          avgPurchasePrice: (json['avg_purchase_price'] as num?)?.toDouble(),
          barcodeId: json['barcode_id'] as String?,
          description: json['description'] as String?,
          discount: (json['discount'] as num?)?.toDouble(),
          freeQty: json['free_qty'] as int?,
          hsnCode: json['hsn_code'] as String?,
          image: json['image'] as String?,
          isPriceWithTax: json['is_price_with_tax'] as int?,
          priceWithTax: (json['price_with_tax'] as num?)?.toDouble(),
          price: (json['price'] as num?)?.toDouble(),
          productCategory: json['product_category'] as String?,
          productId: json['product_id'] as int?,
          productName: json['product_name'] as String?,
          productType: json['product_type'] as String?,
          qty: (json['qty'] as num?)?.toDouble(),
          showOnline: json['show_online'] as int?,
          tax: (json['tax'] as num?)?.toDouble(),
          purchasePrice: (json['purchase_price'] as num?)?.toDouble(),
          isSelected: json['isSelected'] as String?,
          selectedQty: (json['selectedQty'] as num?)?.toDouble(),
          totalPrice: (json['totalPrice'] as num?)?.toDouble(),
          totalTax: (json['totalTax'] as num?)?.toDouble(),
          totalDiscount: (json['totalDiscount'] as num?)?.toDouble(),
          netAmount: (json['netAmount'] as num?)?.toDouble(),
          unit: json['unit'] as String?,
          url: json['url'] as String?,
          unitPrice: (json['unitPrice'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ProductsModelToJson(ProductsModel instance) =>
    <String, dynamic>{
          'id': instance.id,
          'avg_purchase_price': instance.avgPurchasePrice,
          'barcode_id': instance.barcodeId,
          'description': instance.description,
          'discount': instance.discount,
          'free_qty': instance.freeQty,
          'hsn_code': instance.hsnCode,
          'image': instance.image,
          'is_price_with_tax': instance.isPriceWithTax,
          'price_with_tax': instance.priceWithTax,
          'price': instance.price,
          'product_category': instance.productCategory,
          'product_id': instance.productId,
          'product_name': instance.productName,
          'product_type': instance.productType,
          'qty': instance.qty,
          'show_online': instance.showOnline,
          'tax': instance.tax,
          'purchase_price': instance.purchasePrice,
          'isSelected': instance.isSelected,
          'selectedQty': instance.selectedQty,
          'totalPrice': instance.totalPrice,
          'totalTax': instance.totalTax,
          'totalDiscount': instance.totalDiscount,
          'netAmount': instance.netAmount,
          'unit': instance.unit,
          'url': instance.url,
          'unitPrice': instance.unitPrice,
    };