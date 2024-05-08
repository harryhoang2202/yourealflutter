part of 'new_deal_bloc.dart';

@freezed
class NewDealState with _$NewDealState {
  const factory NewDealState.initial() = NewDealInitial;
  const factory NewDealState.loaded(List<Deal> deals) = NewDealLoaded;
  const factory NewDealState.loading() = NewDealLoading;
  const factory NewDealState.loadDetailSuccess(Deal? deal) =
      NewDealLoadDetailSuccess;
  const factory NewDealState.loadDetalError() = NewDealLoadDetailError;
}
