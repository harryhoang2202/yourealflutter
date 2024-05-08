part of 'assign_deal_bloc.dart';

@freezed
class AssignDealState with _$AssignDealState {
  const factory AssignDealState.initial() = AssignDealInitial;
  const factory AssignDealState.loaded(List<Deal> deals) = AssignDealLoaded;
  const factory AssignDealState.loading() = AssignDealLoading;
  const factory AssignDealState.loadDetailSuccess(Deal? deal) =
      AssignDealLoadDetailSuccess;
  const factory AssignDealState.loadDetalError() = AssignDealLoadDetailError;
}
