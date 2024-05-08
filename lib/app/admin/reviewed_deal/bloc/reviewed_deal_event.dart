part of 'reviewed_deal_bloc.dart';

@freezed
class ReviewedDealEvent with _$ReviewedDealEvent {
  const factory ReviewedDealEvent.loadDeal() = ReviewedDealLoadDealEvent;
  const factory ReviewedDealEvent.loadDetail(String id) =
      ReviewedDealLoadDetailEvent;
}
