import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:youreal/common/model/status_state.dart';

part 'lazy_load_state.dart';
part 'lazy_load_event.dart';
part 'lazy_load_bloc.freezed.dart';

class LazyLoadBloc<T> extends Bloc<LazyLoadEvent<T>, LazyLoadState<T>> {
  final Future<List<T>?> Function(int page, String sessionId) fetchData;

  LazyLoadBloc(
    this.fetchData,
  ) : super(LazyLoadState.initial()) {
    on<LazyLoadInitial<T>>(((event, emit) async {
      emit(state.copyWith(
        statusInitial: const LoadingState(),
      ));
      List<T>? newItems = await fetchData(1, state.sessionId);
      if (newItems != null && newItems.isNotEmpty) {
        emit(state.copyWith(
          items: newItems,
          currentPage: 2,
          statusInitial: const SuccessState(),
        ));
      } else {
        emit(state.copyWith(
          currentPage: 2,
          items: [],
          statusInitial: const SuccessState(),
        ));
      }
      emit(state.copyWith(
        statusInitial: const IdleState(),
      ));
    }));
    on<LazyLoadLoadMore<T>>(((event, emit) async {
      emit(state.copyWith(
        statusLoadMore: const LoadingState(),
      ));
      List<T>? newItems = await fetchData(state.currentPage, state.sessionId);
      if (newItems != null && newItems.isNotEmpty) {
        emit(state.copyWith(
          items: [...state.items, ...newItems],
          statusLoadMore: const SuccessState(),
          currentPage: state.currentPage + 1,
        ));
      } else {
        emit(state.copyWith(
          statusLoadMore: const SuccessState(),
          currentPage: state.currentPage + 1,
        ));
      }
      emit(state.copyWith(
        statusLoadMore: const IdleState(),
      ));
    }));
    on<LazyLoadRefreshed<T>>(((event, emit) async {
      emit(state.copyWith(
        statusRefresh: const LoadingState(),
      ));
      List<T>? newItems = await fetchData(1, state.sessionId);
      if (newItems != null && newItems.isNotEmpty) {
        emit(state.copyWith(
          items: newItems,
          statusRefresh: const SuccessState(),
          currentPage: 2,
        ));
      } else {
        emit(state.copyWith(
          statusRefresh: const SuccessState(),
          currentPage: 2,
          items: [],
        ));
      }
      emit(state.copyWith(
        statusRefresh: const IdleState(),
      ));
    }));

    on<LazyLoadItemDeleted<T>>(((event, emit) {
      emit(state.copyWith(
        statusDelete: const LoadingState(),
      ));
      final temp = state.items.toList();
      temp.remove(event.item);
    }));
  }

  // _mapLazyLoadingItemDeletedToState(
  //     LazyLoadItemDeleted<T> event, Emitter<LazyLoadState<T>> emit) async {
  //   if (state.isLoading) {
  //     final temp = [...state.items];

  //     temp.remove(event.item);

  //     emit(state.copyWith(items: [...temp]));
  //     add(LazyLoadRefreshed());
  //   }
  // }
}
