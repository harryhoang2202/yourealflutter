import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/app/home/services/home_service.dart';
import 'package:youreal/common/model/status_state.dart';

part 'home_state.dart';
part 'home_event.dart';
part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState.initial()) {
    on<HomeEventInitial>(
      (event, emit) async {
        emit(state.copyWith(initialStatus: const LoadingState()));

        await Future.wait([
          _getDealSuggest(emit),
          _getDealNew(emit),
          _getDealInvested(emit),
        ]);
        emit(state.copyWith(initialStatus: const SuccessState()));
        emit(state.copyWith(initialStatus: const IdleState()));
      },
    );
  }

  Future<void> _getDealInvested(Emitter<HomeState> emit) async {
    try {
      await HomeService.getListDealInvesting(
              page: 1, sessionId: DateTime.now().microsecond, pSize: 3)
          .then((value) {
        emit(state.copyWith(
            investedDealState: state.investedDealState.copyWith(
                initialStatus: const SuccessState(), data: value ?? [])));
      }).whenComplete(
        () {
          emit(state.copyWith(
              investedDealState: state.investedDealState
                  .copyWith(initialStatus: const IdleState())));
        },
      );
    } catch (e) {
      emit(state.copyWith(
          investedDealState: state.investedDealState
              .copyWith(initialStatus: ErrorState(error: e.toString()))));
    } finally {
      emit(state.copyWith(
          investedDealState: state.investedDealState
              .copyWith(initialStatus: const IdleState())));
    }
  }

  Future<void> _getDealNew(Emitter<HomeState> emit) async {
    try {
      await HomeService.getListDealNew(
              page: 1, sessionId: DateTime.now().microsecond, pSize: 3)
          .then((value) {
        emit(state.copyWith(
            newDealState: state.newDealState.copyWith(
                initialStatus: const SuccessState(), data: value ?? [])));
      }).whenComplete(
        () {
          emit(state.copyWith(
              newDealState: state.newDealState
                  .copyWith(initialStatus: const IdleState())));
        },
      );
    } catch (e) {
      emit(state.copyWith(
          newDealState: state.newDealState
              .copyWith(initialStatus: ErrorState(error: e.toString()))));
    } finally {
      emit(state.copyWith(
          newDealState:
              state.newDealState.copyWith(initialStatus: const IdleState())));
    }
  }

  Future<void> _getDealSuggest(Emitter<HomeState> emit) async {
    try {
      await HomeService.getListDealSuggest(
        page: 1,
        sessionId: DateTime.now().microsecond,
      ).then((value) {
        emit(state.copyWith(
            suggestDealState: state.suggestDealState.copyWith(
                initialStatus: const SuccessState(), data: value ?? [])));
      }).whenComplete(
        () {
          emit(state.copyWith(
              suggestDealState: state.suggestDealState
                  .copyWith(initialStatus: const IdleState())));
        },
      );
    } catch (e) {
      emit(state.copyWith(
          suggestDealState: state.suggestDealState
              .copyWith(initialStatus: ErrorState(error: e.toString()))));
    } finally {
      emit(state.copyWith(
          suggestDealState: state.suggestDealState
              .copyWith(initialStatus: const IdleState())));
    }
  }

  initial() {
    add(HomeEvent.initial());
  }
}
