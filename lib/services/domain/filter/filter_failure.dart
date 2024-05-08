import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter_failure.freezed.dart';

@freezed
class FilterFailure with _$FilterFailure {
  const factory FilterFailure.unknown() = FailterFailureUnknown;
}
