part of 'deal_detail_bloc.dart';

@freezed
class DealDetailEvent with _$DealDetailEvent {
  const factory DealDetailEvent.initial(String id) = _Initial;
  const factory DealDetailEvent.rejectDeal(String id, String mess) =
      _RejectDeal;
  const factory DealDetailEvent.approvedDeal(String id) = _ApprovedDeal;
  const factory DealDetailEvent.assignAppraiser(
      String realEstateId, String valuationUnitId) = _AssignAppraiser;
  const factory DealDetailEvent.joinDeal(
      String dealId, String allocation, String payment) = _JoinDeal;
  const factory DealDetailEvent.voteLeaderDeal(String dealId, String userId) =
      _VoteLeaderDeal;
  const factory DealDetailEvent.updateEventDeal(
      String dealId, String eventTypeId) = _UpdateEventDeal;
  const factory DealDetailEvent.closeDeal(String dealId) = _CloseDeal;
  const factory DealDetailEvent.updatePayment(
          String dealId, String allocationId, String paymentStatusId) =
      _UpdatePayment;
  const factory DealDetailEvent.reOpenDeal(
      String dealId, int extendTimeInSecond, String reason) = _ReOpenDeal;
}
