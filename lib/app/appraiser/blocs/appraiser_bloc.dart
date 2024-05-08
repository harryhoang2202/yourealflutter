import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/common/model/page_key.dart';
import 'package:youreal/common/tools.dart';

import 'package:youreal/services/services_api.dart';

part 'appraiser_bloc.freezed.dart';
part 'appraiser_event.dart';
part 'appraiser_state.dart';

class AppraiserBloc extends Bloc<AppraiserEvent, AppraiserState> {
  AppraiserBloc() : super(AppraiserState.initial()) {
    _mapEventToState();
    dealController.addPageRequestListener((pageKey) {
      add(AppraiserMoreLoaded(page: pageKey));
    });
  }

  final _services = APIServices();
  final _pageSize = 6;
  final dealController = PagingController<PageKey, Deal>(
      firstPageKey: PageKey(page: 1, sessionId: Utils.newSessionId));
  final dealController1 = PagingController<PageKey, Deal>(
      firstPageKey: PageKey(page: 2, sessionId: Utils.newSessionId));

  _mapEventToState() {
    on<AppraiserMoreLoaded>(_moreLoadedToState);
    on<AppraiserRefreshed>(_refreshedToState);
  }

  FutureOr<void> _moreLoadedToState(
      AppraiserMoreLoaded event, Emitter<AppraiserState> emit) async {
    final page = event.page;

    try {
      if (page.page == 2) {
        dealController.value = PagingState(itemList: state.AppraiserDeals);
        dealController1.value = PagingState(itemList: state.appraisedDeals);
        return;
      }
      final deals =
          await _services.getDealAssignedToValuate(statusIds: [1]) ?? [];

      final dealsAppraised =
          await _services.getDealAssignedToValuate(statusIds: [3]) ?? [];

      emit(state.copyWith(
          AppraiserDeals: [...state.AppraiserDeals, ...deals],
          appraisedDeals: [...state.appraisedDeals, ...dealsAppraised]));
      if (deals.isEmpty) {
        dealController.value = PagingState(itemList: state.AppraiserDeals);
      } else {
        dealController.value = PagingState(
          itemList: state.AppraiserDeals,
          nextPageKey: page.increasePage(),
        );
      }
      if (dealsAppraised.isEmpty) {
        dealController1.value = PagingState(itemList: state.appraisedDeals);
      } else {
        dealController1.value = PagingState(
          itemList: state.appraisedDeals,
          nextPageKey: page.increasePage(),
        );
      }
    } catch (e) {
      dealController.value = PagingState(
        error: "Đã có lỗi xảy ra!",
        nextPageKey: page,
      );
      dealController1.value = PagingState(
        error: "Đã có lỗi xảy ra!",
        nextPageKey: page,
      );
      printLog("AppraiserBloc.MoreLoaded ${e.toString()}");
    }
  }

  FutureOr<void> _refreshedToState(
      AppraiserRefreshed event, Emitter<AppraiserState> emit) {
    emit(state.copyWith(AppraiserDeals: [], appraisedDeals: []));
    dealController.value = PagingState(
      nextPageKey: PageKey(
        page: 1,
        sessionId: Utils.newSessionId,
      ),
    );
    dealController1.value = PagingState(
      nextPageKey: PageKey(
        page: 1,
        sessionId: Utils.newSessionId,
      ),
    );
  }
}
