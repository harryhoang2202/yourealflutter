part of 'create_deal_bloc.dart';

@freezed
class CreateDealEvent with _$CreateDealEvent {
  const factory CreateDealEvent.initialLoaded(Deal? deal) =
      CreateDealInitialLoaded;

  const factory CreateDealEvent.realEstateTypeChanged(RealEstateType type) =
      CreateDealRealEstateTypeChanged;
  const factory CreateDealEvent.provinceSelected(Province province) =
      CreateDealProvinceSelected;
  const factory CreateDealEvent.districtSelected(District district) =
      CreateDealDistrictSelected;
  const factory CreateDealEvent.wardSelected(Ward ward) =
      CreateDealWardSelected;

  const factory CreateDealEvent.addressChanged(String value) =
      CreateDealAddressChanged;
  const factory CreateDealEvent.hasFloorChanged(bool value) =
      CreateDealHasFloorChanged;
  const factory CreateDealEvent.investmentLimitChanged(
      double low, double high) = CreateDealInvestmentLimitChanged;
  const factory CreateDealEvent.investmentMaxChanged(double value) =
      CreateDealInvestmentMaxChanged;
  const factory CreateDealEvent.dealImageChanged(List<String> imagePaths) =
      CreateDealDealImageChanged;
  const factory CreateDealEvent.documentImageChanged(
          List<String> paths, DealDocumentType type) =
      CreateDealDocumentImageChanged;
  const factory CreateDealEvent.documentFileChanged(
          List<String> paths, DealDocumentType type) =
      CreateDealDocumentFileChanged;
  const factory CreateDealEvent.appraisalStatusChanged(bool value) =
      CreateDealAppraisalStatusChanged;
  const factory CreateDealEvent.acceptRuleChanged(bool value) =
      CreateDealAcceptRuleChanged;
  const factory CreateDealEvent.appraisalFileChanged(List<String> paths) =
      CreateDealAppraisalFileChanged;

  const factory CreateDealEvent.backTapped() = CreateDealBackTapped;
  const factory CreateDealEvent.continueTapped() = CreateDealContinueTapped;
  const factory CreateDealEvent.submitted() = CreateDealSubmitted;
  const factory CreateDealEvent.locationChanged(LatLng newLocation) =
      CreateDealLocationChanged;

  const factory CreateDealEvent.ownerDocTypeChanged(DealDocumentType type) =
      CreateDealOwnerDocTypeChanged;
  const factory CreateDealEvent.realDocTypeChanged(DealDocumentType type) =
      CreateDealRealDocTypeChanged;
  const factory CreateDealEvent.appraisalFileRemoved(int index) =
      CreateDealAppraisalFileRemoved;
}
