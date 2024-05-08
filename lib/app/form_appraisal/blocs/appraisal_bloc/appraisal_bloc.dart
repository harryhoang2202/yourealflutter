import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:youreal/app/form_appraisal/model/analysis_and_adjustment/appraisal_adjustment_data.dart';
import 'package:youreal/app/form_appraisal/model/analysis_and_adjustment/appraisal_analysis_data.dart';
import 'package:youreal/app/form_appraisal/model/survey_data.dart';

import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/constants/general.dart';

import 'package:youreal/services/services_api.dart';

part 'appraisal_event.dart';
part 'appraisal_state.dart';

class AppraisalBloc extends Bloc<AppraisalEvent, AppraisalState> {
  AppraisalBloc() : super(AppraisalState()) {
    on<AppraisalDocTypeChanged>(((event, emit) {
      emit(state.docTypeChanged(event.type));
    }));
    on<AppraisalLandTypeChanged>((event, emit) {
      emit(state.landTypeChanged(event.type));
    });
    on<AppraisalSent>(_mapAppraisalSentToState);
    on<AppraisalComparisonAdded>(_mapAppraisalComparisonAddedToState);
    on<AppraisalComparisonDeleted>(_mapAppraisalComparisonDeletedToState);
    on<AppraisalComparisonUpdated>(_mapAppraisalComparisonUpdatedToState);
    on<AppraisalAnalysisUpdated>(_mapAppraisalAnalysisUpdatedToState);
    on<AppraisalAdjustmentUpdated>(_mapAppraisalAdjustmentUpdatedToState);
  }

  ///region [TextEditingController]

  //form1
  final appraisalProposer = TextEditingController();
  final propertyOwner = TextEditingController();
  final appraisalPurpose = TextEditingController();
  final appraisalAcceptedTime = TextEditingController();
  final realEstateAddress = TextEditingController();
  final realEstateDetailLocation = TextEditingController();

  //form2
  final landUsagePurpose = TextEditingController();
  final landUsageOrigin = TextEditingController();
  final landUsageExpiredDate = TextEditingController();
  final actualLength1 = TextEditingController();
  final actualWidth1 = TextEditingController();
  final actualLength2 = TextEditingController();
  final actualWidth2 = TextEditingController();
  final recognizedLength1 = TextEditingController();
  final recognizedWidth1 = TextEditingController();
  final recognizedLength2 = TextEditingController();
  final recognizedWidth2 = TextEditingController();
  final acreage1 = TextEditingController();
  final acreage2 = TextEditingController();

  final constructionItems = TextEditingController();
  final yearBuilt = TextEditingController();
  final convenience = TextEditingController();
  final numberFloors = TextEditingController();
  final wall = TextEditingController();
  final roof = TextEditingController();
  final floor = TextEditingController();
  final actualLength3 = TextEditingController();
  final actualWidth3 = TextEditingController();
  final lengthGCNQSH = TextEditingController();
  final widthGCNQSH = TextEditingController();
  final lengthGPXD = TextEditingController();
  final widthGPXD = TextEditingController();
  final lengthOverGPXD = TextEditingController();
  final widthOverGPXD = TextEditingController();

  final realEstateCurrentStatus = TextEditingController();
  final relationship = TextEditingController();

  //form 5

  final donGiaUBND1 = TextEditingController();
  final donGiaThamDinh1 = TextEditingController();
  final heSoK1 = TextEditingController();
  final dienTich1 = TextEditingController();
  final thanhTien1 = TextEditingController();

  final donGiaUBND2 = TextEditingController();
  final donGiaThamDinh2 = TextEditingController();
  final heSoK2 = TextEditingController();
  final dienTich2 = TextEditingController();
  final thanhTien2 = TextEditingController();

  final donGiaUBND3 = TextEditingController();
  final donGiaThamDinh3 = TextEditingController();
  final heSoK3 = TextEditingController();
  final dienTich3 = TextEditingController();
  final thanhTien3 = TextEditingController();

  final donGiaUBND4 = TextEditingController();
  final donGiaThamDinh4 = TextEditingController();
  final heSoK4 = TextEditingController();
  final dienTich4 = TextEditingController();
  final thanhTien4 = TextEditingController();

  final tongTienSo = MoneyMaskedTextController(
      thousandSeparator: ",", decimalSeparator: "", precision: 0);
  final tongTienChu = TextEditingController();

  Stream<AppraisalState> _mapAppraisalSentToState(
      AppraisalSent event, Emitter<AppraisalState> emit) async* {
    Map<String, dynamic> appraisalForm = {
      "statusId": 1,
      "info": appraisalFormRowInfo,
    };
    try {
      int? result = await APIServices().createAppraisalForm(appraisalForm);

      yield state.appraisalSentStatus(true, valuationFormId: result);
      yield newForm();
    } on DioError catch (e) {
      printLog(
          "[ERROR][$runtimeType][_mapAppraisalSentToState] $e ${e.response}");
      yield state.appraisalSentStatus(false);
    }
  }

  _mapAppraisalComparisonUpdatedToState(
      AppraisalComparisonUpdated event, Emitter<AppraisalState> emit) async {
    final survey = {...state.survey};
    int? index = survey[event.type]
        ?.comparisons
        .indexWhere((element) => element.id == event.data.id);
    survey[event.type]!.comparisons[index!] = event.data;
    survey[event.type] = survey[event.type]!.copyWith();
    emit(state.surveyChangeSuccess(survey));
  }

  _mapAppraisalComparisonDeletedToState(
      AppraisalComparisonDeleted event, Emitter<AppraisalState> emit) async {
    final survey = {...state.survey};
    final newComparisons = [...survey[event.type]!.comparisons];

    newComparisons.removeWhere((e) => e.id == event.data.id);

    survey[event.type] =
        survey[event.type]!.copyWith(comparisons: [...newComparisons]);
    final newState = state.surveyChangeSuccess(survey);

    emit(newState);
  }

  _mapAppraisalComparisonAddedToState(
      AppraisalComparisonAdded event, Emitter<AppraisalState> emit) async {
    final survey = {...state.survey};
    survey[event.type] = survey[event.type]!.copyWith(
        comparisons: [...survey[event.type]!.comparisons, event.data]);

    emit(state.surveyChangeSuccess(survey));
  }

  _mapAppraisalAnalysisUpdatedToState(
      AppraisalAnalysisUpdated event, Emitter<AppraisalState> emit) async {
    state.analyses[event.type] = event.data;

    emit(state);
  }

  _mapAppraisalAdjustmentUpdatedToState(
      AppraisalAdjustmentUpdated event, Emitter<AppraisalState> emit) async {
    state.adjustments[event.type] = event.data;

    emit(state);
  }

  // @override
  // Stream<Transition<AppraisalEvent, AppraisalState>> transformEvents(
  //     Stream<AppraisalEvent> events,
  //     TransitionFunction<AppraisalEvent, AppraisalState> transitionFn) {
  //   final nonDebounceStream = events.where((event) =>
  //       !(event is AppraisalComparisonUpdated ||
  //           event is AppraisalAnalysisUpdated ||
  //           event is AppraisalAdjustmentUpdated));

  //   final debounceStream = events
  //       .where((event) =>
  //           event is AppraisalComparisonUpdated ||
  //           event is AppraisalAnalysisUpdated ||
  //           event is AppraisalAdjustmentUpdated)
  //       .debounceTime(const Duration(milliseconds: 300));

  //   return super.transformEvents(
  //       MergeStream([nonDebounceStream, debounceStream]), transitionFn);
  // }

  //region getter
  String get actualAcreage => "${actualLength1.number};${actualWidth1.number};"
      "${actualLength2.number};${actualWidth2.number}";

  String get actualLandPropertyAcreage =>
      "${actualLength3.number};${actualWidth3.number}";

  String get AcreageGCNQSH => "${lengthGCNQSH.number};${widthGCNQSH.number}";

  String get AcreageGPXD => "${lengthGPXD.number};${widthGPXD.number}";

  String get AcreageOverGPXD =>
      "${lengthOverGPXD.number};${widthOverGPXD.number}";

  String get recognizedAcreage =>
      "${recognizedLength1.number};${recognizedWidth1.number};"
      "${recognizedLength2.number};${recognizedWidth2.number}";

  String get structure =>
      "${numberFloors.number};${wall.number};${roof.number};${floor.number}";

  Map<String, dynamic> get usableAcreage {
    late final int id;
    if (state.landType == AppraisalLandType.Residential) {
      id = 22;
    } else if (state.landType == AppraisalLandType.Agricultural) {
      id = 23;
    } else {
      id = 24;
    }
    return {
      "rowId": id,
      "content": "${acreage1.number};${acreage2.number}",
    };
  }

  Map<String, dynamic> get landUsagePrivilegeValue {
    late final int id;
    if (state.landType == AppraisalLandType.Residential) {
      id = 73;
    } else if (state.landType == AppraisalLandType.Agricultural) {
      id = 74;
    } else {
      id = 75;
    }
    return {
      "rowId": id,
      "content":
          "${donGiaUBND1.number};${heSoK1.number};${donGiaThamDinh1.number};"
              "${dienTich1.number};${thanhTien1.number}",
    };
  }

  //endregion
  List<Map<String, dynamic>> get appraisalFormRowInfo {
    return [
      {
        "rowId": 1,
        "content": realEstateAddress.tText,
      },
      {
        "rowId": 2,
        "content": realEstateDetailLocation.tText,
      },
      {
        "rowId": 3,
        "content": state.docType.name,
      },
      {
        "rowId": 4,
        "content": landUsagePurpose.tText,
      },
      {
        "rowId": 5,
        "content": landUsageOrigin.tText,
      },
      {
        "rowId": 6,
        "content": landUsageExpiredDate.tText,
      },
      {
        "rowId": 7,
        "content": actualAcreage,
      },
      {
        "rowId": 8,
        "content": recognizedAcreage,
      },
      {
        "rowId": 9,
        "content": state.landType.name,
      },
      // {
      //   "rowId": 10,
      //   "content": acreage1.tText,
      // },
      // {
      //   "rowId": 11,
      //   "content": acreage2.tText,
      // },
      // {
      //   "rowId": 12,
      //   "content": constructionItems.tText,
      // },
      {
        "rowId": 13,
        "content": yearBuilt.tText,
      },
      // {
      //   "rowId": 14,
      //   "content": convenience.tText,
      // },
      {
        "rowId": 15,
        "content": structure,
      },
      {
        "rowId": 16,
        "content": realEstateCurrentStatus.tText,
      },
      {
        "rowId": 17,
        "content": relationship.tText,
      },
      {
        "rowId": 18,
        "content": appraisalProposer.tText,
      },
      {
        "rowId": 19,
        "content": propertyOwner.tText,
      },
      {
        "rowId": 20,
        "content": appraisalPurpose.tText,
      },
      {
        "rowId": 21,
        "content": appraisalAcceptedTime.tText,
      },
      //row 22=>24
      usableAcreage,
      {
        "rowId": 25,
        "content": constructionItems.tText,
      },
      {
        "rowId": 26,
        "content": convenience.tText,
      },
      {
        "rowId": 27,
        "content": actualLandPropertyAcreage,
      },
      {
        "rowId": 28,
        "content": AcreageGCNQSH,
      },
      {
        "rowId": 29,
        "content": AcreageGPXD,
      },
      {
        "rowId": 30,
        "content": AcreageOverGPXD,
      },
      //row 31->54
      for (SurveyData val in state.survey.values) val.toMap(),
      //row 55->60
      for (AppraisalAnalysisData val in state.analyses.values) val.toMap(),
      //row 61->71
      for (AppraisalAdjustmentData val in state.adjustments.values) val.toMap(),
      //row 73->75
      landUsagePrivilegeValue,
      {
        "rowId": 77,
        "content":
            "${donGiaUBND2.number};${heSoK2.number};${donGiaThamDinh2.number};"
                "${dienTich2.number};${thanhTien2.number}",
      },
      {
        "rowId": 78,
        "content":
            "${donGiaUBND3.number};${heSoK3.number};${donGiaThamDinh3.number};"
                "${dienTich3.number};${thanhTien3.number}",
      },
      {
        "rowId": 79,
        "content":
            "${donGiaUBND4.number};${heSoK4.number};${donGiaThamDinh4.number};"
                "${dienTich4.number};${thanhTien4.number}",
      },
      {
        "rowId": 80,
        "content": tongTienSo.number,
      },
    ];
  }

  AppraisalState newForm() {
    _clearTextField();
    return AppraisalState();
  }

  void _clearTextField() {
    appraisalProposer.clear();
    propertyOwner.clear();
    appraisalPurpose.clear();
    appraisalAcceptedTime.clear();
    realEstateAddress.clear();
    realEstateDetailLocation.clear();
    landUsagePurpose.clear();
    landUsageOrigin.clear();
    landUsageExpiredDate.clear();
    actualLength1.clear();
    actualWidth1.clear();
    actualLength2.clear();
    actualWidth2.clear();
    recognizedLength1.clear();
    recognizedWidth1.clear();
    recognizedLength2.clear();
    recognizedWidth2.clear();
    acreage1.clear();
    acreage2.clear();
    constructionItems.clear();
    yearBuilt.clear();
    convenience.clear();
    numberFloors.clear();
    wall.clear();
    roof.clear();
    floor.clear();
    actualLength3.clear();
    actualWidth3.clear();
    lengthGCNQSH.clear();
    widthGCNQSH.clear();
    lengthGPXD.clear();
    widthGPXD.clear();
    lengthOverGPXD.clear();
    widthOverGPXD.clear();
    realEstateCurrentStatus.clear();
    relationship.clear();

    donGiaUBND1.clear();
    donGiaThamDinh1.clear();
    heSoK1.clear();
    dienTich1.clear();
    thanhTien1.clear();
    donGiaUBND2.clear();
    donGiaThamDinh2.clear();
    heSoK2.clear();
    dienTich2.clear();
    thanhTien2.clear();
    donGiaUBND3.clear();
    donGiaThamDinh3.clear();
    heSoK3.clear();
    dienTich3.clear();
    thanhTien3.clear();
    donGiaUBND4.clear();
    donGiaThamDinh4.clear();
    heSoK4.clear();
    dienTich4.clear();
    thanhTien4.clear();
    tongTienSo.clear();
    tongTienChu.clear();
  }

  @override
  Future<void> close() {
    appraisalProposer.dispose();
    propertyOwner.dispose();
    appraisalPurpose.dispose();
    appraisalAcceptedTime.dispose();
    realEstateAddress.dispose();
    realEstateDetailLocation.dispose();
    landUsagePurpose.dispose();
    landUsageOrigin.dispose();
    landUsageExpiredDate.dispose();
    actualLength1.dispose();
    actualWidth1.dispose();
    actualLength2.dispose();
    actualWidth2.dispose();
    recognizedLength1.dispose();
    recognizedWidth1.dispose();
    recognizedLength2.dispose();
    recognizedWidth2.dispose();
    acreage1.dispose();
    acreage2.dispose();
    constructionItems.dispose();
    yearBuilt.dispose();
    convenience.dispose();
    numberFloors.dispose();
    wall.dispose();
    roof.dispose();
    floor.dispose();
    actualLength3.dispose();
    actualWidth3.dispose();
    lengthGCNQSH.dispose();
    widthGCNQSH.dispose();
    lengthGPXD.dispose();
    widthGPXD.dispose();
    lengthOverGPXD.dispose();
    widthOverGPXD.dispose();
    realEstateCurrentStatus.dispose();
    relationship.dispose();

    donGiaUBND1.dispose();
    donGiaThamDinh1.dispose();
    heSoK1.dispose();
    dienTich1.dispose();
    thanhTien1.dispose();
    donGiaUBND2.dispose();
    donGiaThamDinh2.dispose();
    heSoK2.dispose();
    dienTich2.dispose();
    thanhTien2.dispose();
    donGiaUBND3.dispose();
    donGiaThamDinh3.dispose();
    heSoK3.dispose();
    dienTich3.dispose();
    thanhTien3.dispose();
    donGiaUBND4.dispose();
    donGiaThamDinh4.dispose();
    heSoK4.dispose();
    dienTich4.dispose();
    thanhTien4.dispose();
    tongTienSo.dispose();
    tongTienChu.dispose();
    return super.close();
  }
}
