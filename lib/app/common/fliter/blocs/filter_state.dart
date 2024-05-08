part of 'filter_bloc.dart';

@freezed
class FilterState with _$FilterState {
  const factory FilterState({
    @Default(IdleState()) StatusState status,
    @Default(IdleState()) StatusState sendStatus,
    @Default(LeaderState()) LeaderState leaderState,
    @Default(SoilTypesState()) SoilTypesState soilTypesState,
    Province? provinceSelected,
    @Default(InvestmentLimitState()) InvestmentLimitState investmentLimitState,
  }) = _FilterState;

  factory FilterState.initial() => const FilterState();
}

@freezed
class LeaderState with _$LeaderState {
  const factory LeaderState({
    @Default(IdleState()) StatusState status,
    @Default([]) List<OtpCheckModel> selected,
    @Default([]) List<OtpCheckModel> listLeader1,
    @Default([]) List<OtpCheckModel> listLeader2,
  }) = _LeaderState;

  factory LeaderState.initial() => const LeaderState();
}

@freezed
class SoilTypesState with _$SoilTypesState {
  const factory SoilTypesState({
    @Default(IdleState()) StatusState status,
    @Default([]) List<OtpCheckModel> selected,
    @Default([]) List<OtpCheckModel> listSoilType1,
    @Default([]) List<OtpCheckModel> listSoilType2,
  }) = _SoilTypesState;

  factory SoilTypesState.initial() => const SoilTypesState();
}

@freezed
class InvestmentLimitState with _$InvestmentLimitState {
  const factory InvestmentLimitState({
    @Default(IdleState()) StatusState status,
    @Default(0) double lowerValue,
    @Default(0) double upperValue,
  }) = _InvestmentLimitState;

  factory InvestmentLimitState.initial() => const InvestmentLimitState();
}
