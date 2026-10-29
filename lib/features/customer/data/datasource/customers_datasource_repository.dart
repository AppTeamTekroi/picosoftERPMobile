import 'package:dartz/dartz.dart';
import 'package:mobile_erp/features/customer/data/model/get_customer_model.dart';
import 'package:mobile_erp/features/customer/data/model/post_cutomers_model.dart';

import '../../../../core/enum/post_enum_response.dart';
import '../../../../core/error/failure.dart';

abstract class CustomerSourceRepository {
  Future<Either<Failure, PostResponseType>> postCustomerData(PostCustomersModel data);

  // Future<Either<Failure, List<CustomersModel>>> getCustomerData();
  Future<Either<Failure, List<CustomersModel>>> getCustomerData();
}
