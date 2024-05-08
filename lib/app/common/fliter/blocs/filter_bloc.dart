import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:youreal/app/common/fliter/index.dart';

import 'package:youreal/app/setup_profile/widgets/opt_check.dart';
import 'package:youreal/common/model/country.dart';
import 'package:youreal/common/model/status_state.dart';

part 'filter_state.dart';
part 'filter_event.dart';
part 'filter_bloc.freezed.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterService service = FilterService();
  FilterBloc() : super(FilterState.initial()) {
    on<FilterEventInitial>((event, emit) async {
      emit(state.copyWith(status: const LoadingState()));
      var listLeader = await service.getListLeader();
      var listSoilType = await service.getListSoilType();
      emit(state.copyWith(
          soilTypesState: state.soilTypesState.copyWith(
              listSoilType1: listSoilType.item1,
              listSoilType2: listSoilType.item2)));
      var dataFilter = await service.getFilter();

      if (dataFilter != null) {
        for (var item in dataFilter["data"]) {
          switch (item["criteriaId"]) {
            case 1:
              var p = jsonDecode(item["value"]);

              emit(state.copyWith(
                  provinceSelected: Province(id: p["id"], name: p["name"])));
              break;
            case 2:
              var soilType = item["value"].toString().split(",");
              var list = <OtpCheckModel>[];
              for (var element in soilType) {
                var i1 = state.soilTypesState.listSoilType1
                    .indexWhere((e) => e.name == element);
                var i2 = state.soilTypesState.listSoilType2
                    .indexWhere((e) => e.name == element);
                if (i1 != -1) {
                  list.add(state.soilTypesState.listSoilType1[i1]);
                } else if (i2 != -1) {
                  list.add(state.soilTypesState.listSoilType2[i2]);
                }
              }
              emit(state.copyWith(
                  soilTypesState:
                      state.soilTypesState.copyWith(selected: list)));
              break;
            case 3:
              var investmentLimit = item["value"].toString();

              emit(
                state.copyWith(
                  investmentLimitState: state.investmentLimitState.copyWith(
                    lowerValue: double.parse(investmentLimit.split(",")[0]),
                    upperValue: double.parse(investmentLimit.split(",")[1]),
                  ),
                ),
              );
              break;
            default:
          }
        }
      }
    });
    on<ChangeProvince>(
      (event, emit) {
        emit(state.copyWith(provinceSelected: event.p));
        add(SendFilter());
      },
    );
    on<ChangedInvestmentLimit>((event, emit) {
      emit(state.copyWith(
          investmentLimitState: state.investmentLimitState
              .copyWith(lowerValue: event.lower, upperValue: event.upper)));
    });
    on<SelectedSolid>((event, emit) {
      var list = state.soilTypesState.selected.toList();
      final index = list.indexOf(event.solid);
      if (index == -1) {
        list.add(event.solid);
      } else {
        list.remove(event.solid);
      }
      emit(state.copyWith(
          soilTypesState: state.soilTypesState.copyWith(selected: list)));
    });
    on<SelectedLeader>((event, emit) {
      var list = state.leaderState.selected.toList();
      final index = list.indexOf(event.leader);
      if (index == -1) {
        list.add(event.leader);
      } else {
        list.remove(event.leader);
      }
      emit(state.copyWith(
          leaderState: state.leaderState.copyWith(selected: list)));
    });
    on<SendFilter>((event, emit) async {
      emit(state.copyWith(sendStatus: const LoadingState()));

      await service.sendCriteria(
        position: state.provinceSelected ?? const Province(id: '', name: ''),
        soilType: state.soilTypesState.selected,
        investmentMin: state.investmentLimitState.lowerValue,
        investmentMax: state.investmentLimitState.upperValue,
      );

      emit(state.copyWith(sendStatus: const SuccessState()));
      emit(state.copyWith(sendStatus: const IdleState()));
    });
  }

  initial() {
    add(FilterEventInitial());
  }

  changedInvestmentLimit(lower, upper) {
    add(ChangedInvestmentLimit(lower, upper));
  }

  selectSolid(OtpCheckModel solid) {
    add(SelectedSolid(solid));
  }

  selectLeader(OtpCheckModel leader) {
    add(SelectedLeader(leader));
  }

  changeProvince(Province p) {
    add(ChangeProvince(p));
  }

  sendFilter() {
    add(SendFilter());
  }
}
