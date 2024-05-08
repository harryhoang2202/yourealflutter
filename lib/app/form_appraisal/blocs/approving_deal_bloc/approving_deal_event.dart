part of 'approving_deal_bloc.dart';

abstract class ApprovingDealEvent extends Equatable {
  const ApprovingDealEvent();

  @override
  List<Object> get props => [];
}

class LoadDealApprovingEvent extends ApprovingDealEvent {
  final int numPage;
  final int sessionId;

  const LoadDealApprovingEvent(
      {required this.numPage, required this.sessionId});

  @override
  List<Object> get props => [numPage, sessionId];
}

class LoadDetailDealApprovingEvent extends ApprovingDealEvent {
  final String dealId;

  const LoadDetailDealApprovingEvent({required this.dealId});

  @override
  List<Object> get props => [dealId];
}
