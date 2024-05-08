part of 'deal_detail_bloc.dart';

@freezed
class DealDetailState with _$DealDetailState {
  const factory DealDetailState({
    @Default(IdleState()) StatusState initialStatus,
    Deal? deal,
    //Todo:  Status management when admin rejects deal
    @Default(IdleState()) StatusState rejectStatus,
    //Todo: Status management when admin approves deal
    @Default(IdleState()) StatusState approvedStatus,
    //Todo: Status management when admin assign appraiser for the deal
    @Default(IdleState()) StatusState assignAppraiserStatus,
    //Todo: Status management when investor want to join the deal
    @Default(IdleState()) StatusState joinDealStatus,
    //Todo: Status management when the investor votes to choose a leader to represent for the deal
    @Default(IdleState()) StatusState voteLeaderStatus,
    //Todo: Status management when the leader updates the status of the deal event
    @Default(IdleState()) StatusState updateEventStatus,
    //Todo: Status management when the leader closes the deal
    @Default(IdleState()) StatusState closeDealStatus,
    //Todo: Status management when the leader update the status payment of each investor
    @Default(IdleState()) StatusState updatePaymentStatus,
    //Todo: Status management when the admin want to reopen the deal
    @Default(IdleState()) StatusState reOpenStatus,
  }) = _DealDetailState;
  factory DealDetailState.initial() => const DealDetailState();
}
