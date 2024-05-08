import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:youreal/app/admin/search/services/search_service.dart';
import 'package:youreal/app/deal/model/deal.dart';

part 'admin_search_deal_cubit.freezed.dart';
part 'admin_search_deal_state.dart';

class AdminSearchDealCubit extends Cubit<AdminSearchDealState> {
  AdminSearchDealCubit() : super(const AdminSearchDealState.initial());

  final _services = SearchService();

  void onSearched(String dealCode) async {
    emit(const AdminSearchDealLoading());
    try {
      final result = await _services.search(dealCode);

      if (result != null) {
        emit(AdminSearchDealSuccess(result));
      } else {
        emit(const AdminSearchDealEmpty());
      }
    } on DioError catch (err) {
      emit(AdminSearchDealFailed(
          err.response?.data.toString() ?? "Unknown error"));
    } catch (error) {
      emit(AdminSearchDealFailed(error.toString()));
    }
  }
}
