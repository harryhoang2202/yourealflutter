import 'package:freezed_annotation/freezed_annotation.dart';

enum DealDocumentType {
  SoDo,
  // SoHong,
  // GiayChungNhan,
  HopDongMuaBan,
  HopDongGopVon,
  QuyetDinhPheDuyet,
  ChungTuKhac,
  BanTKCT,
  GPXD,
  // GiaySDDat,
  CMND,
  CanCuocCD,
  SoHoKhau,
  Passport,
  BHYT,
}

enum DealDocumentCategory {
  Owner,
  RealEstate,
}

enum AppraisalDocType {
  LegalDocument,
  InternalDocument,
}

enum AppraisalLandType {
  Residential,
  Agricultural,
  Business,
}

enum SurveyType {
  InfoSource,
  InfoStatus,
  TimeAcquired,
  HouseNumber,
  StreetWardDistrict,
  Legal,
  Location,
  RemainingUsageTime,
  LandUsageOrigin,
  Acreage,
  Length,
  Width,
  ResidentialLandAcreage,
  AgriculturalLandAcreage,
  BusinessLandAcreage,
  HouseAcreage,
  Structure,
  SellPrice,
  TransactedPrice,
  BuildValue,
  BuildPrice,
  ResidentialLandPrice,
  AgricultureLandPrice,
  BusinessLandPrice,
}

enum AnalysisType {
  Legal,
  ScaleAndSize,
  Shape,
  Traffic,
  BusinessAdvantage,
  EnvironmentAndSecurity,
}

enum AdjustmentType {
  ResidentialLandPriceBeforeAdjustment,
  Legal,
  ScaleAndSize,
  Shape,
  Traffic,
  BusinessAdvantage,
  EnvironmentAndSecurity,
  TotalAdjustmentPercentages,
  AdjustmentFactor,
  LandPriceAfterAdjustment,
  AverageAppraisalLandPrice,
}

enum Gender {
  Male,
  Female,
}

enum RealEstateType {
  @JsonValue(2)
  house,
  @JsonValue(4)
  project,
  @JsonValue(5)
  ground,
  @JsonValue(3)
  villa,
  @JsonValue(1)
  apartment,
  @JsonValue(0)
  initial,
  other,
}

enum InputOption {
  Add,
  Location,
  Camera,
  Picture,
  Emoji,
  Idle,
}

enum DealOptionType {
  Modify,
  VoteLeader,
}

enum MessagePosition {
  First,
  Middle,
  Last,
  Single,
}

enum SlidingPanelState {
  Opened,
  Closed,
  Shown,
  Hidden,
}

enum FileUploadType {
  Images,
  Documents,
  Roles,
  ValuationForms,
}

enum ShowDialogType {
  Confirm,
  Waiting,
  Idle,
}

enum NotificationTargetType {
  none,

  Deal,
}

enum NotificationType {
  none,
  newNotification,

  investorClosed,
  none1,

  newMessage,

  newDeal,

  dealAppraised,

  newAppraisalRequest,

  representativeChosen,

  totallyPaid,

  changeOwner,

  contractSigned,
}

extension NotificationTypeExt on NotificationType {
  String get id {
    switch (this) {
      case NotificationType.newNotification:
        return "1";
      case NotificationType.investorClosed:
        return "2";
      case NotificationType.newMessage:
        return "4";
      case NotificationType.newDeal:
        return "5";
      case NotificationType.dealAppraised:
        return "6";
      case NotificationType.newAppraisalRequest:
        return "7";
      case NotificationType.representativeChosen:
        return "8";
      case NotificationType.totallyPaid:
        return "9";
      case NotificationType.changeOwner:
        return "10";
      case NotificationType.contractSigned:
        return "11";
      default:
        return "-1";
    }
  }
}

enum RolesType { User, SuperAdmin, Admin, DealLeader, Appraiser }

enum EventType {
  None,
  CloseTransaction, //đóng deal

  ProrfomTheNameRegistration,
  FullPayment,
  SigningContract,
  FinishInvestment,
  SendProposal,
  ValidationDone,
  SellingDealAppraisal,
  CreateSuccessfullDeal,
  VoteDealLeader,
  SignPropertyPurchaseContract
}

enum DealStatus {
  None(0),

  Draft(1),
  WaitingVerification(2),
  WaitingApproval(3),
  WaitingMainInvestor(4),
  WaitingSubInvestor(5),
  FinishedInvestors(6),

  Cancelled(7),
  Done(8),
  Rejected(9);

  final int value;
  const DealStatus(this.value);
}
