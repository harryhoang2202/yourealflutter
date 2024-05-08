part of 'deal_document_bloc.dart';

@freezed
class DealDocumentState with _$DealDocumentState {
  const DealDocumentState._();

  const factory DealDocumentState({
    @Default(DealDocumentType.CMND) DealDocumentType ownerDocType,
    @Default(DealDocumentType.SoDo) DealDocumentType realDocType,
    required Map<DealDocumentType, DealDocument> docImages,
    required List<String> appraisalFiles,
  }) = _DealDocumentState;

  factory DealDocumentState.initial(Deal deal) {
    final realEstate = deal.realEstate;
    final initialImages = {
      DealDocumentType.CMND: DealDocument.fromAPI(
        realEstate?.cmnd?.content?.trim(),
      ),
      DealDocumentType.CanCuocCD: DealDocument.fromAPI(
        realEstate?.cccd?.content?.trim(),
      ),
      DealDocumentType.SoHoKhau: DealDocument.fromAPI(
        realEstate?.soHK?.content?.trim(),
      ),
      DealDocumentType.Passport: DealDocument.fromAPI(
        realEstate?.passport?.content?.trim(),
      ),
      DealDocumentType.BHYT: DealDocument.fromAPI(
        realEstate?.bhyt?.content?.trim(),
      ),
      DealDocumentType.SoDo: DealDocument.fromAPI(
        realEstate?.soDo?.content?.trim(),
      ),
      // DealImageType.SoHong: DealImage(
      //     pathOrUrls:
      //         deal.realEstate?.soHong?.content?.trim().split(",") ?? []),
      // DealImageType.GiayChungNhan: DealImage(
      //     pathOrUrls:
      //         deal.realEstate?.giayChungNhan?.content?.trim().split(",") ?? []),
      DealDocumentType.HopDongMuaBan: DealDocument.fromAPI(
        realEstate?.hopDongMuaBan?.content?.trim(),
      ),
      DealDocumentType.HopDongGopVon: DealDocument.fromAPI(
        realEstate?.hopDongGopVon?.content?.trim(),
      ),
      DealDocumentType.QuyetDinhPheDuyet: DealDocument.fromAPI(
        realEstate?.quyetDinhPheDuyet?.content?.trim(),
      ),
      DealDocumentType.ChungTuKhac: DealDocument.fromAPI(
        realEstate?.chungTuKhac?.content?.trim(),
      ),
      DealDocumentType.BanTKCT: DealDocument.fromAPI(
        realEstate?.banTKTC?.content?.trim(),
      ),
      DealDocumentType.GPXD: DealDocument.fromAPI(
        realEstate?.GPXD?.content?.trim(),
      ),
    };
    List<String> appraisalFiles = [];
    final rawDealAppraisalFile = realEstate?.appraisalFile?.content;
    if (rawDealAppraisalFile != null) {
      appraisalFiles = rawDealAppraisalFile.split(",");
    }
    return DealDocumentState(
        docImages: initialImages, appraisalFiles: appraisalFiles);
  }
}
