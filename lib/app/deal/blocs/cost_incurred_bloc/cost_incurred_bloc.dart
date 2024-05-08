import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/app/deal/model/deal_fee.dart';

import 'package:youreal/common/constants/general.dart';

import 'package:youreal/services/services_api.dart';

part 'cost_incurred_bloc.freezed.dart';

part 'cost_incurred_event.dart';

part 'cost_incurred_state.dart';

class CostIncurredBloc extends Bloc<CostIncurredEvent, CostIncurredState> {
  CostIncurredBloc({required Deal deal})
      : super(CostIncurredState(currentDeal: deal, dealFees: deal.dealFees)) {
    _mapEventToState();
  }
  final APIServices _services = APIServices();
  _mapEventToState() {
    on<CostIncurredGetFees>((event, emit) async {
      var deal = await _services.getDealById(dealId: state.currentDeal.id);
      if (deal != null) {
        emit(state.copyWith(dealFees: deal.dealFees, currentDeal: deal));
      }
    });
    on<CostIncurredNewFeeChanged>((event, emit) async {
      emit(state.copyWith(newFees: [...event.fees]));
    });
    on<CostIncurredFeeUpdated>((event, emit) async {
      try {
        for (final fee in state.newFees) {
          if (!fee.validate()) throw "Phí không hợp lệ";
        }
        await Future.wait([
          for (final fee in state.newFees)
            APIServices().addDealFee(
              dealId: state.currentDeal.id.toString(),
              type: fee.feeType,
              value: fee.value,
              note: fee.note,
            )
        ]);
        event.onComplete(null);
      } catch (e) {
        if (e is DioError) {
          printLog("Add Fee error: ${e.response?.data}");
        } else {
          printLog("Add Fee error: $e");
        }
        event.onComplete("Đã có lỗi xảy ra");
      }
    });
  }
}
