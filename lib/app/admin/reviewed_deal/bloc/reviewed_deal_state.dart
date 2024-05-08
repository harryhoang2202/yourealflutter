part of 'reviewed_deal_bloc.dart';

@freezed
class ReviewedDealState with _$ReviewedDealState {
  const factory ReviewedDealState.initial() = ReviewedDealInitial;
  const factory ReviewedDealState.loaded(List<Deal> deals) = ReviewedDealLoaded;
  const factory ReviewedDealState.loading() = ReviewedDealLoading;
  const factory ReviewedDealState.loadDetailSuccess(Deal? deal) =
      ReviewedDealLoadDetailSuccess;
  const factory ReviewedDealState.loadDetalError() =
      ReviewedDealLoadDetailError;
}
