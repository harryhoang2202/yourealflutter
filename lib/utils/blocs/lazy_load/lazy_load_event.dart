part of 'lazy_load_bloc.dart';

@freezed
class LazyLoadEvent<T> with _$LazyLoadEvent<T> {
  factory LazyLoadEvent.initial() = LazyLoadInitial<T>;
  factory LazyLoadEvent.loadMore() = LazyLoadLoadMore<T>;
  factory LazyLoadEvent.refresh() = LazyLoadRefreshed<T>;

  factory LazyLoadEvent.delete(T item) = LazyLoadItemDeleted<T>;
}
