part of 'cost_incurred_bloc.dart';

@freezed
class CostIncurredEvent with _$CostIncurredEvent {
  const factory CostIncurredEvent.feeChanged({required List<DealFee> fees}) =
      CostIncurredNewFeeChanged;
  const factory CostIncurredEvent.onFeeUpdated(
          {required void Function(String? error) onComplete}) =
      CostIncurredFeeUpdated;
  const factory CostIncurredEvent.getFees() = CostIncurredGetFees;
}
