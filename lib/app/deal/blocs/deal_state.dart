part of 'deal_bloc.dart';

abstract class DealState extends Equatable {
  const DealState();

  @override
  List<Object> get props => [];
}

class DealInitial extends DealState {}

class LoadingDealSuggestState extends DealState {}

class LoadedDealSuggestState extends DealState {
  final List<Deal> deals;

  const LoadedDealSuggestState({required this.deals});
}

class LoadedDealSuggestErrorState extends DealState {}

class LoadingDealRecentlyState extends DealState {}

class LoadedDealRecentlyState extends DealState {
  final List<Deal> deals;

  const LoadedDealRecentlyState({required this.deals});
}

class LoadedDealRecentlyErrorState extends DealState {}

class LoadingDealInvestedState extends DealState {}

class LoadedDealInvestedState extends DealState {
  final List<Deal> deals;

  const LoadedDealInvestedState({required this.deals});
}

class LoadedDealInvestedErrorState extends DealState {}

class LoadingDetailDealState extends DealState {}

class LoadedDetailDealState extends DealState {
  final Deal? deal;

  const LoadedDetailDealState({required this.deal});
}

class LoadingRefreshDetailDealState extends DealState {}

class RefreshDetailDealState extends DealState {
  final Deal? deal;
  const RefreshDetailDealState({required this.deal});
}

class LoadedDetailDealErrorState extends DealState {}

class LoadingJoinDealState extends DealState {}

class JoinedDealState extends DealState {}

class JoinedErrorDealState extends DealState {
  final String? errorMessage;
  const JoinedErrorDealState({this.errorMessage});
}

class LoadingMyDealState extends DealState {}

class LoadedMyDealState extends DealState {
  final List<Deal> deals;

  const LoadedMyDealState({required this.deals});
}

class LoadedMyDealErrorState extends DealState {}

class LoadingMyDealAppraisalState extends DealState {}

class LoadedMyDealAppraisalState extends DealState {
  final List<Deal> deals;

  const LoadedMyDealAppraisalState({required this.deals});
}

class LoadedMyDealAppraisalErrorState extends DealState {}
