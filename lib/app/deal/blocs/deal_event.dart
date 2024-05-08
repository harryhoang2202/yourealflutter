part of 'deal_bloc.dart';

abstract class DealEvent extends Equatable {
  const DealEvent();

  @override
  List<Object> get props => [];
}

class RefreshMyDealEvent extends DealEvent {
  const RefreshMyDealEvent();

  @override
  List<Object> get props => [];
}

class LoadDealRecentlyEvent extends DealEvent {
  final int numPage;
  final int sessionId;

  const LoadDealRecentlyEvent({required this.numPage, required this.sessionId});

  @override
  List<Object> get props => [numPage, sessionId];
}

class LoadMyDealEvent extends DealEvent {
  final int numPage;
  final int sessionId;
  final int pageSize;
  const LoadMyDealEvent(
      {required this.numPage, required this.sessionId, this.pageSize = 10});

  @override
  List<Object> get props => [numPage, sessionId, pageSize];
}

class LoadMyDealAppraisalEvent extends DealEvent {
  final int numPage;
  final int sessionId;

  const LoadMyDealAppraisalEvent(
      {required this.numPage, required this.sessionId});

  @override
  List<Object> get props => [numPage, sessionId];
}
