import 'package:dartz/dartz.dart';
import 'package:youreal/services/domain/filter/filter_failure.dart';

abstract class IFilterRepository {
  Future<Either<FilterFailure, Unit>> filter();
}
