part of 'cancel_deal_bloc.dart';

@freezed
class CancelDealEvent with _$CancelDealEvent {
  const factory CancelDealEvent.loadDeal() = CancelDealLoadDealEvent;
  const factory CancelDealEvent.loadDetail(String id) =
      CancelDealLoadDetailEvent;
}
