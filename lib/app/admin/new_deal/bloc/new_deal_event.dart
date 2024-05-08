part of 'new_deal_bloc.dart';

@freezed
class NewDealEvent with _$NewDealEvent {
  const factory NewDealEvent.loadDeal() = _NewDealLoadDealEvent;
  const factory NewDealEvent.loadDetail(String id) = _NewDealLoadDetailEvent;
}
