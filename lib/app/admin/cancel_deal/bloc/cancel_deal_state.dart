part of 'cancel_deal_bloc.dart';

@freezed
class CancelDealState with _$CancelDealState {
  const factory CancelDealState.initial() = CancelDealInitial;
  const factory CancelDealState.loaded(List<Deal> deals) = CancelDealLoaded;
  const factory CancelDealState.loading() = CancelDealLoading;
  const factory CancelDealState.loadDetailSuccess(Deal? deal) =
      CancelDealLoadDetailSuccess;
  const factory CancelDealState.loadDetalError() = CancelDealLoadDetailError;
}
