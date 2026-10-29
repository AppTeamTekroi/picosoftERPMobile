import 'package:dartz/dartz.dart';
import 'package:mobile_erp/features/product/data/model/add_to_cart_model.dart';
import 'package:mobile_erp/features/product/data/model/barcode_search_model.dart';
import 'package:mobile_erp/features/product/data/model/cart_item_model.dart';
import 'package:mobile_erp/features/product/data/model/get_barcode_search_model.dart';
import 'package:mobile_erp/features/product/data/model/get_product_data_model.dart';
import 'package:mobile_erp/features/product/data/model/remove_from_cart_model.dart';

import '../../../../core/enum/post_enum_response.dart';
import '../../../../core/error/failure.dart';
import '../model/post_products_model.dart';

abstract class ProductSourceRepository {
  Future<Either<Failure, PostResponseType>> postProductData(
      PostProductsModel data);
  Future<Either<Failure, List<getProductDataModel>>> getProductFromBarcode(
      BarcodeSearchModel data);
  Future<Either<Failure, PostResponseType>> postAddToCart(
      AddToCartModel data);
  Future<Either<Failure, PostResponseType>> postRemovefromCart(
      RemoveFromCartModel data);
      Future<Either<Failure,List<getProductDataModel>>> getProductDetailsData();
      Future<Either<Failure,List<CartItemModel>>> cartItemDetailsData(String id);
}
