part of 'create_deal_bloc.dart';

class CreateDeal1Success extends SuccessState {
  const CreateDeal1Success();
}

class CreateDeal2Success extends SuccessState {
  const CreateDeal2Success();
}

class CreateDealPopBack extends SuccessState {
  const CreateDealPopBack();
}

@freezed
class CreateDealState with _$CreateDealState {
  const CreateDealState._();
  const factory CreateDealState({
    int? draftDealId,
    required RealEstateType realEstateType,
    Province? selectedProvince,
    District? selectedDistrict,
    Ward? selectedWard,
    required TextEditingController addressDetail,
    LatLng? location,
    required TextEditingController totalAcreage,
    required TextEditingController length,
    required TextEditingController width,
    required bool hasFloor,
    required TextEditingController numberOfFloors,
    required TextEditingController depositMonth,
    required TextEditingController depositPrice,
    required TextEditingController realEstateValuatedValue,
    required double minInvestValue,
    required double maxInvestValue,
    required DealDocument dealImages,
    required Map<DealDocumentType, DealDocument> dealDocuments,
    required TextEditingController dealOverview,
    required bool isAppraised,
    required List<String> appraisalFiles,
    required bool isRuleAccepted,
    required List<Province> provinces,
    required List<District> districts,
    required double investmentLimitUpperBound,
    required List<Ward> wards,
    @Default(DealDocumentType.CMND) DealDocumentType ownerDocType,
    @Default(DealDocumentType.SoDo) DealDocumentType realDocType,
    @Default(IdleState()) StatusState status,
  }) = _CreateDealState;

  bool get canPickImage => dealImages.imagePathOrUrls.length < 5;

  int get maxAssets => 5 - dealImages.imagePathOrUrls.length;

  factory CreateDealState.initial() {
    final initialDealDocuments = {
      for (var dealImageType in DealDocumentType.values)
        dealImageType: const DealDocument(imagePathOrUrls: []),
    };
    return CreateDealState(
      realEstateType: RealEstateType.initial,
      addressDetail: TextEditingController(),
      totalAcreage: TextEditingController(),
      length: TextEditingController(),
      width: TextEditingController(),
      hasFloor: false,
      numberOfFloors: TextEditingController(),
      depositMonth: TextEditingController(),
      depositPrice: TextEditingController(),
      minInvestValue: kDefaultMinDepositPrice,
      maxInvestValue: kDefaultMaxDepositPrice,
      investmentLimitUpperBound: kDefaultInvestmentLimit,
      dealImages: const DealDocument(),
      dealDocuments: initialDealDocuments,
      dealOverview: TextEditingController(),
      isAppraised: false,
      appraisalFiles: [],
      isRuleAccepted: false,
      districts: [],
      provinces: [],
      wards: [],
      realEstateValuatedValue: TextEditingController(),
    );
  }

  factory CreateDealState.fromDraftDeal(Deal deal) {
    final realEstateType = RealEstateTypeExtension.fromId(
            deal.realEstate?.realEstateTypeId ?? -1) ??
        RealEstateType.house;

    final addressDetail =
        deal.realEstate?.fullAddress?.content?.split(",").first ?? "";
    final size = deal.realEstate?.size?.content?.split(",") ?? ["", "", ""];
    final noFloors = deal.realEstate?.numberOfFloors?.content ?? "";
    final depositPrice =
        Tools().convertMoneyToSymbolMoney(deal.price ?? "0") ?? "0";
    final depositMonth = deal.realEstate?.depositTime?.content ?? "";
    final minInvestment =
        (double.tryParse(deal.minAllocation ?? "") ?? kDefaultMinDepositPrice);
    final maxInvestment =
        (double.tryParse(deal.maxAllocation ?? "") ?? kDefaultMaxDepositPrice);

    //#region load deal document
    final dealDocs = {
      for (var dealImageType in DealDocumentType.values)
        dealImageType: const DealDocument(imagePathOrUrls: []),
    };
    Map<DealDocumentType, List<String>> temp = {
      DealDocumentType.CMND:
          deal.realEstate?.cmnd?.content?.trim().split(",") ?? [],
      DealDocumentType.CanCuocCD:
          deal.realEstate?.cccd?.content?.trim().split(",") ?? [],
      DealDocumentType.SoHoKhau:
          deal.realEstate?.soHK?.content?.trim().split(",") ?? [],
      DealDocumentType.Passport:
          deal.realEstate?.passport?.content?.trim().split(",") ?? [],
      DealDocumentType.BHYT:
          deal.realEstate?.bhyt?.content?.trim().split(",") ?? [],
      DealDocumentType.SoDo:
          deal.realEstate?.soDo?.content?.trim().split(",") ?? [],
      DealDocumentType.HopDongMuaBan:
          deal.realEstate?.hopDongMuaBan?.content?.trim().split(",") ?? [],
      DealDocumentType.HopDongGopVon:
          deal.realEstate?.hopDongMuaBan?.content?.trim().split(",") ?? [],
      DealDocumentType.QuyetDinhPheDuyet:
          deal.realEstate?.quyetDinhPheDuyet?.content?.trim().split(",") ?? [],
      DealDocumentType.ChungTuKhac:
          deal.realEstate?.chungTuKhac?.content?.trim().split(",") ?? [],
      DealDocumentType.BanTKCT:
          deal.realEstate?.banTKTC?.content?.trim().split(",") ?? [],
      DealDocumentType.GPXD:
          deal.realEstate?.GPXD?.content?.trim().split(",") ?? [],
    };

    for (final entry in temp.entries) {
      List<String> files = [];
      List<String> images = [];
      for (final path in entry.value) {
        final temp = path.split(".");
        if (temp.isNotEmpty) {
          final fileExt = temp.last;
          if (kSupportFileTypes.contains(fileExt)) {
            files.add(path);
          } else if (kSupportImageTypes.contains(fileExt)) {
            images.add(path);
          }
        }
      }
      dealDocs[entry.key] =
          DealDocument(filePathOrUrls: files, imagePathOrUrls: images);
    }

    //#endregion

    final overview = deal.realEstate!.note?.content ?? "";

    final dealImages =
        deal.realEstate?.realEstateImages?.content?.split(",") ?? [];
    dealImages.removeWhere((element) => element == "null");

    final appraisalFiles =
        deal.realEstate?.appraisalFile?.content?.split(",") ?? [];
    final rawLocation = deal.realEstate?.position?.content?.split(",");
    LatLng? location;
    if (rawLocation != null && rawLocation.length == 2) {
      try {
        location = LatLng(
          double.parse(rawLocation[0]),
          double.parse(rawLocation[1]),
        );
      } catch (e, trace) {
        printLog("[CreateDealState.fromDraftDeal] Error $e $trace");
      }
    }

    return CreateDealState(
      draftDealId: deal.id,
      realEstateType: realEstateType,
      addressDetail: TextEditingController()..text = addressDetail,
      totalAcreage: TextEditingController()..text = size[0],
      length: TextEditingController()..text = size[1],
      width: TextEditingController()..text = size[2],
      hasFloor: noFloors.isNotEmpty,
      numberOfFloors: TextEditingController()..text = noFloors,
      depositMonth: TextEditingController()..text = depositMonth,
      depositPrice: TextEditingController()..text = depositPrice,
      minInvestValue: minInvestment,
      maxInvestValue: maxInvestment,
      dealImages: DealDocument(imagePathOrUrls: dealImages),
      dealDocuments: dealDocs,
      dealOverview: TextEditingController()..text = overview,
      isAppraised: appraisalFiles.isNotEmpty,
      appraisalFiles: appraisalFiles,
      isRuleAccepted: false,
      location: location,
      districts: [],
      provinces: [],
      wards: [],
      //TODO: load real estate valuated value
      realEstateValuatedValue: TextEditingController(),
      investmentLimitUpperBound: maxInvestment,
    );
  }

  Future<List<Map<String, dynamic>>> _getCreateDealRowInfo() async {
    final size =
        "${totalAcreage.text.trim()},${length.text.trim()},${width.text.trim()}";
    final depositTime = depositMonth.text.trim();

    final apiResults = ([
      await uploadFiles(dealImages.imagePathOrUrls, isImage: true),
      await _uploadDealDocument(DealDocumentType.SoHoKhau),
      await _uploadDealDocument(DealDocumentType.CMND),
      await _uploadDealDocument(DealDocumentType.CanCuocCD),
      await _uploadDealDocument(DealDocumentType.Passport),
      await _uploadDealDocument(DealDocumentType.BHYT),
      await _uploadDealDocument(DealDocumentType.SoDo),
      await _uploadDealDocument(DealDocumentType.HopDongMuaBan),
      await _uploadDealDocument(DealDocumentType.HopDongGopVon),
      await _uploadDealDocument(DealDocumentType.QuyetDinhPheDuyet),
      await _uploadDealDocument(DealDocumentType.ChungTuKhac),
      await _uploadDealDocument(DealDocumentType.BanTKCT),
      await _uploadDealDocument(DealDocumentType.GPXD),
      await uploadFiles(appraisalFiles, isImage: false),
    ]);
    final realImage = (apiResults[0] as List<String>).join(",").trim();
    final soHoKhau = apiResults[1];
    final cmnd = apiResults[2];
    final canCuocCD = apiResults[3];
    final passport = apiResults[4];
    final bhyt = apiResults[5];
    final soDo = apiResults[6];
    final hopDongMuaBan = apiResults[7];
    final hopDongGopVon = apiResults[8];
    final quyetDinhPheDuyet = apiResults[9];
    final chungTuKhac = apiResults[10];
    final banTKCT = apiResults[11];
    final gpxd = apiResults[12];
    final appraisalFilesStr = (apiResults[13] as List<String>).join(",").trim();

    final String? addrsDetail = selectedProvince == null ||
            selectedDistrict == null
        ? null
        : "${addressDetail.text.isNotEmpty ? '${addressDetail.text}, ' : ''}"
            "${selectedWard != null ? '${selectedWard!.id},' : ''} "
            "${selectedDistrict?.id}, "
            "${selectedProvince?.id}";
    List<Map<String, dynamic>> result = [
      {
        "rowId": 1,
        "content":
            "${totalAcreage.text.isNotEmpty ? double.parse(totalAcreage.text) : 0}"
      },
      {
        "rowId": 5,
        "content": addrsDetail ?? "",
      },
      {"rowId": 6, "content": dealOverview.text},
      {"rowId": 7, "content": selectedProvince?.id ?? ""},
      {"rowId": 8, "content": selectedWard?.id ?? ""},
      {"rowId": 9, "content": selectedDistrict?.id ?? ""},
      {"rowId": 10, "content": selectedProvince?.id ?? ""},
      {
        "rowId": 11,
        "content": location != null
            ? "${location!.latitude},${location!.longitude}"
            : ""
      },
      {"rowId": 12, "content": soHoKhau},
      {"rowId": 13, "content": cmnd},
      {"rowId": 14, "content": canCuocCD},
      {"rowId": 15, "content": passport},
      {"rowId": 16, "content": bhyt},
      {"rowId": 18, "content": size},
      {"rowId": 19, "content": hasFloor ? numberOfFloors.text.trim() : null},
      {"rowId": 20, "content": realImage.isEmpty ? null : realImage},
      {"rowId": 21, "content": depositTime},
      {
        "rowId": 22,
        "content": double.tryParse(depositPrice.text.replaceAll('.', '')) ?? 0
      },
      {"rowId": 23, "content": soDo},
      {"rowId": 1027, "content": hopDongMuaBan},
      {"rowId": 1028, "content": hopDongGopVon},
      {"rowId": 1029, "content": quyetDinhPheDuyet},
      {
        "rowId": 1031,
        "content": chungTuKhac,
      },
      {"rowId": 25, "content": banTKCT},
      {"rowId": 26, "content": gpxd},
      {"rowId": 27, "content": appraisalFilesStr},
      {
        "rowId": 1032,
        "content":
            double.tryParse(realEstateValuatedValue.text.replaceAll('.', '')) ??
                0
      }
    ];

    return result;
  }

  Future<Map<String, dynamic>> getCreateDealData({
    required int dealStatusId,
  }) async {
    final result = {
      "dealStatusId": dealStatusId,
      "dealCode": null,
      "realEstate": {
        "realEstateTypeId": realEstateType.id,
        "info": await _getCreateDealRowInfo()
      },
      "valuationUnit": {"id": "0"},
      "price": double.tryParse(depositPrice.text.replaceAll('.', '')) ?? 0,
      "minAllocation": minInvestValue,
      "maxAllocation": maxInvestValue,
      if (draftDealId != null) "id": draftDealId,
    };
    final temp = jsonEncode(result);
    return result;
  }

  Future<String?> _uploadDealDocument(DealDocumentType type) async {
    String linkImages = "";
    final imagePaths = dealDocuments[type]!.imagePathOrUrls;
    final filePaths = dealDocuments[type]!.filePathOrUrls;
    List<String?> urls = [];
    List<Future<List<String?>>> upFileFutures = [];

    try {
      if (imagePaths.isNotEmpty) {
        upFileFutures.add(uploadFiles(imagePaths, isImage: true));
      }
      if (filePaths.isNotEmpty) {
        upFileFutures.add(uploadFiles(filePaths, isImage: false));
      }
      final upFileResult = await Future.wait(upFileFutures);
      for (final result in upFileResult) {
        urls.addAll(result);
      }
      linkImages = urls.join(',');

      return linkImages;
    } catch (e) {
      return null;
    }
  }

  String? validateScreen1Data() {
    if (realEstateType == RealEstateType.initial) {
      return "Bạn chưa chọn loại bất động sản.";
    }
    if (selectedDistrict == null && selectedProvince == null) {
      return "Bạn chưa nhập thông tin địa chỉ.\n Vui lòng kiểm tra lại!";
    } else {
      if (selectedProvince == null) {
        return "Bạn chưa nhập thông tin Tỉnh/Thành phố trung ương. Vui lòng kiểm tra lại!";
      }
      if (selectedDistrict == null) {
        return "Bạn chưa nhập thông tin Thành phố/Quận/Huyện. Vui lòng kiểm tra lại!";
      }
    }
    if (totalAcreage.isEmpty) {
      return "Thông tin Tổng diện tích không đúng hoặc thiếu. Vui lòng kiểm tra lại!";
    }
    if (length.isEmpty) {
      return "Thông tin Chiều dài không đúng hoặc thiếu. Vui lòng kiểm tra lại!";
    }
    if (width.isEmpty) {
      return "Thông tin Chiều rộng không đúng hoặc thiếu. Vui lòng kiểm tra lại!";
    }
    if (hasFloor && numberOfFloors.isEmpty) {
      return "Thông tin Số tầng không đúng hoặc thiếu. Vui lòng kiểm tra lại";
    }
    if (depositPrice.isEmpty) {
      return "Thông tin Giá ký gửi không đúng hoặc thiếu. Vui lòng kiểm tra lại!";
    }
    // if (minInvestValue >= investmentLimitUpperBound * 0.1) {
    //   return "Thông tin Hạn mức đầu tư không đúng hoặc thiếu.\n Vui lòng kiểm tra lại!";
    // }
    if (maxInvestValue <= 0) {
      return "Thông tin Hạn mức đầu tư tối đa không đúng hoặc thiếu. Vui lòng kiểm tra lại!";
    }
    if (dealImages.isEmpty) {
      return "Bạn phải chọn ít nhất 1 hình ảnh bất động sản.";
    }
    return null;
  }

  String? validateScreen2Data() {
    if (dealDocuments[DealDocumentType.SoDo]!.isEmpty &&
        dealDocuments[DealDocumentType.HopDongMuaBan]!.isEmpty &&
        dealDocuments[DealDocumentType.HopDongGopVon]!.isEmpty) {
      return "Bạn phải chọn ít nhất 1 hình ảnh hoặc tài liệu  của ít nhất 1 trong các tài liệu liên quan đến bất động sản có đánh dấu * ";
    }
    if (dealDocuments[DealDocumentType.CMND]!.isEmpty &&
        dealDocuments[DealDocumentType.CanCuocCD]!.isEmpty) {
      return "Bạn phải chọn ít nhất 1 hình ${DealDocumentType.CMND.name} hoặc ${DealDocumentType.CanCuocCD.name}";
    }
    if (dealOverview.text.isEmpty) {
      return "Bạn phải nhập thông tin tổng quan bất động sản";
    }
    if (isAppraised) {
      if (appraisalFiles.isEmpty) {
        return "Bạn phải tải lên ít nhất 1 tài liệu thẩm định";
      }
      if (realEstateValuatedValue.isEmpty) {
        return "Bạn phải nhập mức giá thẩm định";
      } else {
        final v =
            double.tryParse(realEstateValuatedValue.text.replaceAll('.', '')) ??
                0;
        if (v <= 0) {
          return "Mức giá thẩm định không hợp lệ.";
        }
      }
    }
    if (!isRuleAccepted) {
      return "Bạn cần xác nhận nội dung hợp đồng thỏa thuận.";
    }
    return null;
  }

  Address get addressNotIncludeStreet => Address(
        selectedProvince?.name,
        selectedDistrict?.name,
        selectedWard?.name,
        "",
      );

  bool get isDraftDeal => draftDealId != null;
}
