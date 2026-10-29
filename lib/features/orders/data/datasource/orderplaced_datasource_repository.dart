import 'package:dartz/dartz.dart';
import 'package:mobile_erp/features/orders/data/model/getOrderDetails.dart';
import 'package:mobile_erp/features/orders/data/model/getOrderPlacedModel.dart';
import '../../../../core/error/failure.dart';

abstract class OrderPlacedSourceRepository {
  Future<Either<Failure, List<GetOrderPlacedModel>>> getOrderPlacedData();
  Future<Either<Failure, Map<String, dynamic>>> getOrderDetails(String currentcardid);
}
