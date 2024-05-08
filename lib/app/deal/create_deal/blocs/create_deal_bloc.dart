import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import "package:google_maps_flutter/google_maps_flutter.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/app/deal/model/deal_document.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/common/model/address.dart';
import 'package:youreal/common/model/country.dart';
import 'package:youreal/common/model/status_state.dart';
import 'package:youreal/common/tools.dart';

import 'package:youreal/services/services_api.dart';
import 'package:youreal/view_models/app_model.dart';

part 'create_deal_event.dart';
part 'create_deal_state.dart';
part 'create_deal_bloc.freezed.dart';

class CreateDealBloc extends Bloc<CreateDealEvent, CreateDealState> {
  CreateDealBloc({
    required this.appModel,
    Deal? draftDeal,
    required this.services,
  }) : super(CreateDealState.initial()) {
    _mapEventToState();
    add(CreateDealInitialLoaded(draftDeal));
  }
  final AppModel appModel;
  final APIServices services;

  void _mapEventToState() {
    on<CreateDealInitialLoaded>(_initialLoadedToState);
    on<CreateDealRealEstateTypeChanged>(_realEstateTypeChangedToState);
    on<CreateDealProvinceSelected>(_provinceSelectedToState);
    on<CreateDealDistrictSelected>(_districtSelectedToState);
    on<CreateDealWardSelected>(_wardSelectedToState);
    on<CreateDealAddressChanged>(
      _addressChangedToState,
      transformer: Utils.debounce(
        const Duration(milliseconds: 300),
      ),
    );
    on<CreateDealHasFloorChanged>(_hasFloorChangedToState);
    on<CreateDealInvestmentLimitChanged>(_investmentLimitChangedToState);
    on<CreateDealInvestmentMaxChanged>(_investmentMaxChangedToState);
    on<CreateDealDealImageChanged>(_dealImageChangedToState);
    on<CreateDealDocumentImageChanged>(_documentImageChangedToState);
    on<CreateDealDocumentFileChanged>(_documentFileChangedToState);
    on<CreateDealAppraisalStatusChanged>(_appraisalStatusChangedToState);
    on<CreateDealAcceptRuleChanged>(_acceptRuleChangedToState);
    on<CreateDealAppraisalFileChanged>(_appraisalFileChangedToState);
    on<CreateDealAppraisalFileRemoved>(_appraisalFileRemovedToState);
    on<CreateDealBackTapped>(
      _backTappedToState,
      transformer: Utils.debounce(
        const Duration(milliseconds: 500),
      ),
    );
    on<CreateDealContinueTapped>(
      _continueTappedToState,
      transformer: Utils.debounce(
        const Duration(milliseconds: 500),
      ),
    );
    on<CreateDealSubmitted>(_submittedToState);
    on<CreateDealLocationChanged>(
      _locationChangedToState,
      transformer: Utils.debounce(
        const Duration(milliseconds: 300),
      ),
    );
    on<CreateDealOwnerDocTypeChanged>(_ownerDocTypeChangedToState);

    on<CreateDealRealDocTypeChanged>(_realDocTypeChangedToState);
  }

  //#region map event to state

  FutureOr<void> _realEstateTypeChangedToState(
      CreateDealRealEstateTypeChanged event, Emitter<CreateDealState> emit) {
    emit(state.copyWith(
      realEstateType: event.type,
    ));
  }

  FutureOr<void> _provinceSelectedToState(
      CreateDealProvinceSelected event, Emitter<CreateDealState> emit) async {
    emit(
      state.copyWith(
        selectedProvince: event.province,
        selectedDistrict: null,
        selectedWard: null,
        districts: [],
        wards: [],
      ),
    );

    final districts = await appModel.loadDistricts(event.province);
    emit(
      state.copyWith(
        districts: districts,
      ),
    );
  }

  FutureOr<void> _initialLoadedToState(
      CreateDealInitialLoaded event, Emitter<CreateDealState> emit) async {
    emitLoading(emit);
    try {
      var deal = event.deal;

      final provinces = await appModel.loadProvinces();
      List<District> districts = [];
      List<Ward> wards = [];
      Province? selectedProvince;
      District? selectedDistrict;
      Ward? selectedWard;
      CreateDealState? draftState;
      if (deal != null) {
        deal = await services.getDealById(dealId: deal.id);
        draftState = CreateDealState.fromDraftDeal(deal!);
      }

      final rawProvince = deal?.realEstate?.province?.content;
      if (rawProvince != null) {
        //#region load province
        selectedProvince =
            provinces.firstWhere((element) => element.id == rawProvince);
        //#endregion

        //#region load district
        final rawDistrict = deal?.realEstate?.district?.content;
        if (rawDistrict != null) {
          districts = await appModel.loadDistricts(selectedProvince);
          selectedDistrict =
              districts.firstWhere((element) => element.id == rawDistrict);
        }
        //#endregion

        //#region load ward
        final rawWard = deal?.realEstate?.ward?.content;
        if (rawWard != null && selectedDistrict != null) {
          wards = await appModel.loadWards(selectedProvince, selectedDistrict);
          selectedWard = wards.firstWhere((element) => element.id == rawWard);
        }
        //#endregion

        draftState = draftState!.copyWith(
          provinces: provinces,
          districts: districts,
          wards: wards,
          selectedProvince: selectedProvince,
          selectedDistrict: selectedDistrict,
          selectedWard: selectedWard,
        );
      } else {
        final prefs = await SharedPreferences.getInstance();

        final idProvince = prefs.getString("LocationSelected") ?? "50";
        selectedProvince = provinces.firstWhere(
          (element) => element.id == idProvince,
          orElse: () {
            return provinces.first;
          },
        );
        add(CreateDealProvinceSelected(selectedProvince));
      }
      if (draftState != null) {
        emit(draftState.copyWith(
          status: const IdleState(),
        ));
      } else {
        emit(state.copyWith(
          status: const IdleState(),
          provinces: provinces,
        ));
      }
    } catch (e, trace) {
      printLog("$e $trace");
      emit(state.copyWith(
          status: const ErrorState(
              error: "Đã có lỗi xảy ra vui lòng thử lại sau")));
    }
  }

  FutureOr<void> _districtSelectedToState(
      CreateDealDistrictSelected event, Emitter<CreateDealState> emit) async {
    if (state.selectedProvince == null) return;

    emit(
      state.copyWith(
        selectedDistrict: event.district,
        selectedWard: null,
        wards: [],
      ),
    );

    final wards =
        await appModel.loadWards(state.selectedProvince!, event.district);
    emit(
      state.copyWith(
        wards: wards,
      ),
    );
  }

  FutureOr<void> _wardSelectedToState(
      CreateDealWardSelected event, Emitter<CreateDealState> emit) async {
    if (state.selectedProvince == null || state.selectedDistrict == null) {
      return;
    }

    emit(
      state.copyWith(selectedWard: event.ward),
    );
  }

  FutureOr<void> _addressChangedToState(
      CreateDealAddressChanged event, Emitter<CreateDealState> emit) async {
    //TODO: handle auto complete, get lat lng
  }

  FutureOr<void> _hasFloorChangedToState(
      CreateDealHasFloorChanged event, Emitter<CreateDealState> emit) async {
    if (event.value == false) {
      state.numberOfFloors.clear();
    }
    emit(state.copyWith(hasFloor: event.value));
  }

  FutureOr<void> _investmentLimitChangedToState(
      CreateDealInvestmentLimitChanged event,
      Emitter<CreateDealState> emit) async {
    double investmentLimitUpperBound = state.investmentLimitUpperBound;

    emit(
      state.copyWith(
        minInvestValue: event.low,
        maxInvestValue: event.high,
        investmentLimitUpperBound: investmentLimitUpperBound,
      ),
    );
  }

  FutureOr<void> _investmentMaxChangedToState(
      CreateDealInvestmentMaxChanged event,
      Emitter<CreateDealState> emit) async {
    double investmentLimitUpperBound = event.value;

    emit(
      state.copyWith(
        investmentLimitUpperBound: investmentLimitUpperBound,
      ),
    );
  }

  FutureOr<void> _dealImageChangedToState(
      CreateDealDealImageChanged event, Emitter<CreateDealState> emit) async {
    emit(
      state.copyWith(
        dealImages:
            state.dealImages.copyWith(imagePathOrUrls: event.imagePaths),
      ),
    );
  }

  FutureOr<void> _documentImageChangedToState(
      CreateDealDocumentImageChanged event,
      Emitter<CreateDealState> emit) async {
    final documentClone = {...state.dealDocuments};
    documentClone[event.type] =
        documentClone[event.type]!.copyWith(imagePathOrUrls: event.paths);
    emit(
      state.copyWith(
        dealDocuments: documentClone,
      ),
    );
  }

  FutureOr<void> _documentFileChangedToState(
      CreateDealDocumentFileChanged event,
      Emitter<CreateDealState> emit) async {
    final documentClone = {...state.dealDocuments};
    documentClone[event.type] =
        documentClone[event.type]!.copyWith(filePathOrUrls: event.paths);
    emit(
      state.copyWith(
        dealDocuments: Map.from(documentClone),
      ),
    );
  }

  FutureOr<void> _appraisalStatusChangedToState(
      CreateDealAppraisalStatusChanged event,
      Emitter<CreateDealState> emit) async {
    emit(state.copyWith(
      isAppraised: event.value,
    ));
  }

  FutureOr<void> _acceptRuleChangedToState(
      CreateDealAcceptRuleChanged event, Emitter<CreateDealState> emit) async {
    emit(state.copyWith(
      isRuleAccepted: event.value,
    ));
  }

  FutureOr<void> _appraisalFileChangedToState(
      CreateDealAppraisalFileChanged event,
      Emitter<CreateDealState> emit) async {
    emit(state.copyWith(
      appraisalFiles: event.paths,
    ));
  }

  FutureOr<void> _backTappedToState(
      CreateDealBackTapped event, Emitter<CreateDealState> emit) async {
    emitLoading(emit);
    try {
      int draftDealId = await _createOrUpdateDraftDeal();
      emit(
        state.copyWith(
          status: const CreateDealPopBack(),
          draftDealId: draftDealId,
        ),
      );
      emit(
        state.copyWith(
          status: const IdleState(),
        ),
      );
    } on DioError catch (e, trace) {
      printLog("[$runtimeType][_draftDealUpdatedToState] Error $e \n$trace");
      emitError(emit, "Đã có lỗi xảy ra, vui lòng thử lại sau");
    } catch (e, trace) {
      printLog("[$runtimeType][_draftDealUpdatedToState] Error $e \n$trace");
      emitError(emit, "Đã có lỗi xảy ra, vui lòng thử lại sau");
    }
  }

  FutureOr<void> _continueTappedToState(
      CreateDealContinueTapped event, Emitter<CreateDealState> emit) async {
    emitLoading(emit);
    final validateResult = state.validateScreen1Data();

    //Has error
    if (validateResult != null) {
      return emitError(emit, validateResult);
    }
    try {
      final draftDealId = await _createOrUpdateDraftDeal();
      emit(
        state.copyWith(
          status: const CreateDeal1Success(),
          draftDealId: draftDealId,
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      emitIdle(emit);
    } on DioError catch (e, trace) {
      emitError(emit, "Đã có lỗi xảy ra, vui lòng thử lại sau");
      printLog("[$runtimeType][_continueTappedToState] Error: $e\n$trace");
    } catch (e, trace) {
      printLog("[$runtimeType][_draftDealUpdatedToState] Error $e \n$trace");
      emitError(emit, "Đã có lỗi xảy ra, vui lòng thử lại sau");
    }
  }

  FutureOr<void> _submittedToState(
      CreateDealSubmitted event, Emitter<CreateDealState> emit) async {
    emitLoading(emit);
    final validateResult = state.validateScreen2Data();

    //Has error
    if (validateResult != null) {
      return emitError(emit, validateResult);
    }

    try {
      late int draftDealId;
      if (state.isAppraised) {
        draftDealId = await _createOrUpdateDraftDeal(3);
      } else {
        draftDealId = await _createOrUpdateDraftDeal(2);
      }
      emit(
        state.copyWith(
          status: const CreateDeal2Success(),
          draftDealId: draftDealId,
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      emitIdle(emit);
    } on DioError catch (e, trace) {
      emitError(emit, "Đã có lỗi xảy ra, vui lòng thử lại sau");
      printLog("[$runtimeType][_submittedToState] Error: $e\n$trace");
    } catch (e, trace) {
      printLog("[$runtimeType][_draftDealUpdatedToState] Error $e \n$trace");
      emitError(emit, "Đã có lỗi xảy ra, vui lòng thử lại sau");
    }
  }

  FutureOr<void> _locationChangedToState(
      CreateDealLocationChanged event, Emitter<CreateDealState> emit) {
    emit(state.copyWith(
      location: event.newLocation,
    ));
  }

  FutureOr<void> _ownerDocTypeChangedToState(
      CreateDealOwnerDocTypeChanged event, Emitter<CreateDealState> emit) {
    emit(state.copyWith(
      ownerDocType: event.type,
    ));
  }

  FutureOr<void> _realDocTypeChangedToState(
      CreateDealRealDocTypeChanged event, Emitter<CreateDealState> emit) {
    emit(state.copyWith(
      realDocType: event.type,
    ));
  }
  //#endregion

  Future<int> _createOrUpdateDraftDeal([int dealStatusId = 1]) async {
    if (!state.isDraftDeal) {
      final data = await state.getCreateDealData(dealStatusId: 1);

      //New deal
      int createdDealId = (await services.createDeal(data: data))!;
      return createdDealId;
    } else {
      final data = await state.getCreateDealData(dealStatusId: dealStatusId);
      //already had deal id ==> draft deal
      int draftDealId = (await services.updateDeal(data: data)) ?? 0;
      return draftDealId;
    }
  }

  void emitError(Emitter emit, String error) {
    emit(
      state.copyWith(
        status: ErrorState(error: error),
      ),
    );
    emitIdle(emit);
  }

  Future<void> emitSuccess(Emitter emit, SuccessState success) async {
    emit(
      state.copyWith(
        status: success,
      ),
    );
    await Future.delayed(const Duration(seconds: 2));
    emitIdle(emit);
  }

  void emitLoading(Emitter emit) {
    emit(
      state.copyWith(
        status: const LoadingState(),
      ),
    );
  }

  void emitIdle(Emitter emit) {
    emit(
      state.copyWith(
        status: const IdleState(),
      ),
    );
  }

  FutureOr<void> _appraisalFileRemovedToState(
      CreateDealAppraisalFileRemoved event, Emitter<CreateDealState> emit) {
    final temp = [...state.appraisalFiles];
    temp.removeAt(event.index);
    emit(state.copyWith(appraisalFiles: temp));
  }
}
