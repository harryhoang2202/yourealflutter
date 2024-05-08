part of 'appraiser_bloc.dart';

@freezed
class AppraiserState with _$AppraiserState {
  const AppraiserState._();
  const factory AppraiserState({
    required List<Deal> AppraiserDeals,
    required List<Deal> appraisedDeals,
  }) = _AppraiserState;

  factory AppraiserState.initial() =>
      const AppraiserState(AppraiserDeals: [], appraisedDeals: []);
}
