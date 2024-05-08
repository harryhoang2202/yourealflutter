part of 'lazy_load_bloc.dart';

@freezed
class LazyLoadState<T> with _$LazyLoadState<T> {
  const LazyLoadState._();
  const factory LazyLoadState({
    @Default([]) List<T> items,
    // @Default(false) bool isEnd,
    // @Default(false) bool isLoading,
    @Default(1) int currentPage,
    @Default('') String sessionId,
    @Default(IdleState()) StatusState statusInitial,
    @Default(IdleState()) StatusState statusLoadMore,
    @Default(IdleState()) StatusState statusRefresh,
    @Default(IdleState()) StatusState statusDelete,
  }) = _LazyLoadState<T>;
  factory LazyLoadState.initial() => LazyLoadState<T>();
}
