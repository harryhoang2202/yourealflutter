part of 'approving_deal_bloc.dart';

abstract class ApprovingDealState extends Equatable {
  const ApprovingDealState();

  @override
  List<Object> get props => [];
}

class ApprovingDealInitial extends ApprovingDealState {}

class LoadingDealApprovingState extends ApprovingDealState {}

class LoadedDealApprovingState extends ApprovingDealState {
  final List<Deal> deals;

  const LoadedDealApprovingState({required this.deals});
}

class LoadedDealApprovingErrorState extends ApprovingDealState {}

class LoadingDetailDealApprovingState extends ApprovingDealState {}

class LoadedDetailDealApprovingState extends ApprovingDealState {
  final Deal deal;

  const LoadedDetailDealApprovingState({required this.deal});
}

class LoadedDetailDealApprovingErrorState extends ApprovingDealState {}
