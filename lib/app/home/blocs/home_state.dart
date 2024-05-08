part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(IdleState()) StatusState initialStatus,
    @Default(LoadedFilterState()) LoadedFilterState filterState,
    @Default(LoadedInvestedDealState())
        LoadedInvestedDealState investedDealState,
    @Default(LoadedSuggestDealState()) LoadedSuggestDealState suggestDealState,
    @Default(LoadedNewDealState()) LoadedNewDealState newDealState,
  }) = _HomeState;
  factory HomeState.initial() => const HomeState();
}

@freezed
class LoadedFilterState with _$LoadedFilterState {
  const factory LoadedFilterState({
    @Default(IdleState()) StatusState initialStatus,
  }) = _LoadedFilterState;
  factory LoadedFilterState.initial() => const LoadedFilterState();
}

@freezed
class LoadedNewDealState with _$LoadedNewDealState {
  const factory LoadedNewDealState({
    @Default(IdleState()) StatusState initialStatus,
    @Default([]) List<Deal> data,
  }) = _LoadedNewDealState;
  factory LoadedNewDealState.initial() => const LoadedNewDealState();
}

@freezed
class LoadedInvestedDealState with _$LoadedInvestedDealState {
  const factory LoadedInvestedDealState({
    @Default(IdleState()) StatusState initialStatus,
    @Default([]) List<Deal> data,
  }) = _LoadedInvestedDealState;
  factory LoadedInvestedDealState.initial() => const LoadedInvestedDealState();
}

@freezed
class LoadedSuggestDealState with _$LoadedSuggestDealState {
  const factory LoadedSuggestDealState({
    @Default(IdleState()) StatusState initialStatus,
    @Default([]) List<Deal> data,
  }) = _LoadedSuggestDealState;
  factory LoadedSuggestDealState.initial() => const LoadedSuggestDealState();
}
