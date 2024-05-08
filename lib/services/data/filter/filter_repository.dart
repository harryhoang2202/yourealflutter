import 'package:injectable/injectable.dart';
import 'package:youreal/services/data/api_remote.dart';
import 'package:youreal/services/domain/filter/filter_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:youreal/services/domain/filter/i_filter_repository.dart';

@LazySingleton(as: IFilterRepository)
class FilterRepository implements IFilterRepository {
  final ApiRemote _apiRemote;
  FilterRepository(this._apiRemote);

  @override
  Future<Either<FilterFailure, Unit>> filter() async {
    try {
      final resp = await _apiRemote.get('filter');
      return right(unit);
    } catch (e) {
      return left(const FilterFailure.unknown());
    }
  }
}
