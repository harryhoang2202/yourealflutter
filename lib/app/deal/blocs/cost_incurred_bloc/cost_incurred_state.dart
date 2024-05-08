part of 'cost_incurred_bloc.dart';

@freezed
class CostIncurredState with _$CostIncurredState {
  const factory CostIncurredState({
    @Default([]) List<DealFee> dealFees,
    @Default([]) List<DealFee> newFees,
    required Deal currentDeal,
  }) = _CostIncurredState;
}
