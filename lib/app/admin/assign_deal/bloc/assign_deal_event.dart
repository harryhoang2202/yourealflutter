part of 'assign_deal_bloc.dart';

@freezed
class AssignDealEvent with _$AssignDealEvent {
  const factory AssignDealEvent.loadDeal() = _AssignDealLoadDealEvent;
  const factory AssignDealEvent.loadDetail(String id) =
      _AssignDealLoadDetailEvent;
}
