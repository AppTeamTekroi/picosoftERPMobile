import 'package:dartz/dartz.dart';
import 'package:mobile_erp/features/Quotation/data/model/get_prescription_model.dart';
import 'package:mobile_erp/features/Quotation/data/model/post_quotation_model.dart';

import '../../../../core/enum/post_enum_response.dart';
import '../../../../core/error/failure.dart';

abstract class QuotationSourceRepository {
  Future<Either<Failure, PostResponseType>> postQuotationDetails(PostQuotationModel data);
  Future<Either<Failure, List<GetCustomerPrescriptionModel>>> getCustomerPrescriptionData(String c_id,List<String> presId);
}
