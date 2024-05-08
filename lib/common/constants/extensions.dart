import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:tvt_button/tvt_button.dart';
import 'package:youreal/common/model/status_state.dart';
import 'package:youreal/common/tools.dart';
import 'package:youreal/common/utils/default_extension_map.dart';

import 'enums.dart';

extension WidgetExt on Widget {
  SliverToBoxAdapter toSliver() {
    return SliverToBoxAdapter(
      child: this,
    );
  }
}

extension InputDecorationExtension on InputDecoration {
  InputDecoration allBorder(InputBorder border) {
    return copyWith(
      enabledBorder: border,
      border: border,
      disabledBorder: border,
      errorBorder: border,
      focusedBorder: border,
      focusedErrorBorder: border,
    );
  }
}

extension DoubleExt on double {
  String get money {
    return Utils.thousandFormatter.format(this);
  }
}

extension NumberExt on num {
  Widget get horSp => SizedBox(
        width: w,
      );
  Widget get verSp => SizedBox(
        height: h,
      );
}

extension StringExtension on String {
  String get MMddyyyy {
    final formatter = DateFormat("dd/MM/yyyy");
    final date = formatter.parseStrict(this);
    final result = "${date.month}/${date.day}/${date.year}";
    return result;
  }

  bool get isPhoneNumber {
    return RegExp(r"^[0-9]{8,11}$").hasMatch(this);
  }

  bool get isPassword {
    return RegExp(
            r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{6,}$")
        .hasMatch(this);
  }

  bool get isImageUrl {
    return RegExp(r"(http(s?):)([/|.|\w|\s|\-|:])*\.(?:jpg|gif|png|jpeg|heic)")
        .hasMatch(toLowerCase());
  }

  bool get isHttpUrl => contains("http");

  bool get isEmail {
    return RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(this);
  }

  bool get isValidDate {
    try {
      final res = DateFormat("dd/MM/yyyy").parseStrict(this);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool isFileWithType(List<String> types) {
    final mimetype = lookupMimeType(this);

    for (final type in types) {
      if (defaultExtensionMap[type] == mimetype) {
        return true;
      }
    }
    return false;
  }

  String shortFor({int shortForLength = 20}) {
    assert(shortForLength >= 3);
    if (length <= shortForLength - 3) {
      return this;
    }
    final cutIndex = shortForLength ~/ 2;
    final remainingChar = shortForLength - cutIndex;
    return "${substring(0, cutIndex)}...${substring(length - remainingChar + 3)}";
  }
}

extension DealImageTypeExtension on DealDocumentType {
  static const names = {
    DealDocumentType.SoDo: "Sổ đỏ/Sổ hồng*",
    // DealImageType.SoHong: "Sổ hồng*",
    // DealImageType.GiayChungNhan: "Giấy chứng nhận*",
    DealDocumentType.HopDongMuaBan: "Hợp đồng mua bán, chuyển nhượng*",
    DealDocumentType.HopDongGopVon: "Hợp đồng góp vốn*",
    DealDocumentType.BanTKCT: "Bản thiết kế công trình",
    DealDocumentType.GPXD: "Giấy phép xây dựng",
    DealDocumentType.QuyetDinhPheDuyet:
        "Quyết định phê duyệt quy hoạch chi tiết 1/500",
    DealDocumentType.ChungTuKhac: "Chứng từ khác",
    DealDocumentType.CMND: "CMND",
    DealDocumentType.CanCuocCD: "Căn cước công dân",
    DealDocumentType.SoHoKhau: "Sổ hộ khẩu",

    DealDocumentType.Passport: "Passport",
    DealDocumentType.BHYT: "Thẻ BHYT",
  };

  String get name {
    if (names[this] == null) {
      throw "Invalid Image Type";
    }
    return names[this]!;
  }
}

extension AppraisalDocTypeExtension on AppraisalDocType {
  static const names = {
    AppraisalDocType.InternalDocument: "Chứng từ nội bộ",
    AppraisalDocType.LegalDocument: "Chứng từ pháp lý",
  };

  String get name {
    if (names[this] == null) {
      throw "Invalid Appraisal Document Type";
    }
    return names[this]!;
  }
}

extension AppraisalLandTypeExtension on AppraisalLandType {
  static const names = {
    AppraisalLandType.Residential: "Đất thổ cư",
    AppraisalLandType.Agricultural: "Đất nông nghiệp",
    AppraisalLandType.Business: "SXKD",
  };

  String get name {
    if (names[this] == null) {
      throw "Invalid Appraisal Land Type";
    }
    return names[this]!;
  }
}

extension GetTrimmedText on TextEditingController {
  String get tText => text.trim();

  double get number => double.tryParse(tText) ?? 0;

  bool get isEmpty => tText.isEmpty;
}

extension SurveyTypeExtension on SurveyType {
  static const names = {
    SurveyType.InfoSource: "Nguồn thông tin",
    SurveyType.InfoStatus: "Trạng thái thông tin",
    SurveyType.TimeAcquired: "Thời điểm thu thập",
    SurveyType.HouseNumber: "Số nhà",
    SurveyType.StreetWardDistrict: "Tên đường, phường, quận",
    SurveyType.Legal: "Pháp lý",
    SurveyType.Location: "Vị trí",
    SurveyType.RemainingUsageTime: "Thời hạn sử dụng còn lại",
    SurveyType.LandUsageOrigin: "Nguồn gốc sử dụng đất",
    SurveyType.Acreage: "Diện tích",
    SurveyType.Length: "Chiều dài",
    SurveyType.Width: "Chiều rộng",
    SurveyType.ResidentialLandAcreage: "Diện tích đất thổ cư",
    SurveyType.AgriculturalLandAcreage: "Diện tích đất nông nghiệp",
    SurveyType.BusinessLandAcreage: "Diện tích đất SXKD",
    SurveyType.HouseAcreage: "Diện tích nhà",
    SurveyType.Structure: "Kết cấu",
    SurveyType.SellPrice: "Giá rao bán",
    SurveyType.TransactedPrice: "Giá thương lượng, giá giao dịch thành công",
    SurveyType.BuildValue: "Giá trị xây dựng",
    SurveyType.BuildPrice: "Đơn giá xây dựng",
    SurveyType.ResidentialLandPrice: "Đơn giá đất thổ cư",
    SurveyType.AgricultureLandPrice: "Đơn giá đất nông nghiệp",
    SurveyType.BusinessLandPrice: "Đơn giá đất SXKD",
  };
  static const ids = {
    SurveyType.InfoSource: 31,
    SurveyType.InfoStatus: 32,
    SurveyType.TimeAcquired: 33,
    SurveyType.HouseNumber: 34,
    SurveyType.StreetWardDistrict: 35,
    SurveyType.Legal: 36,
    SurveyType.Location: 37,
    SurveyType.RemainingUsageTime: 38,
    SurveyType.LandUsageOrigin: 39,
    SurveyType.Acreage: 40,
    SurveyType.Length: 41,
    SurveyType.Width: 42,
    SurveyType.ResidentialLandAcreage: 43,
    SurveyType.AgriculturalLandAcreage: 44,
    SurveyType.BusinessLandAcreage: 45,
    SurveyType.HouseAcreage: 46,
    SurveyType.Structure: 47,
    SurveyType.SellPrice: 48,
    SurveyType.TransactedPrice: 49,
    SurveyType.BuildValue: 50,
    SurveyType.BuildPrice: 51,
    SurveyType.ResidentialLandPrice: 52,
    SurveyType.AgricultureLandPrice: 53,
    SurveyType.BusinessLandPrice: 54,
  };

  String get name {
    if (names[this] == null) {
      throw "Invalid Survey Type";
    }
    return names[this]!;
  }

  int get id {
    if (ids[this] == null) {
      throw "Invalid Survey Type";
    }
    return ids[this]!;
  }
}

extension AdjustmentTypeExtension on AdjustmentType {
  static const names = {
    AdjustmentType.ResidentialLandPriceBeforeAdjustment:
        "Đơn giá đất Thổ cư trước khi điều chỉnh (đồng/m2)",
    AdjustmentType.Legal: "Pháp lý (%)",
    AdjustmentType.ScaleAndSize: "Quy mô, kích thước (%)",
    AdjustmentType.Shape: "Hình dáng (%)",
    AdjustmentType.Traffic: "Giao thông (%)",
    AdjustmentType.BusinessAdvantage: "Lợi thế kinh doanh (%)",
    AdjustmentType.EnvironmentAndSecurity: "Môi trường, an ninh (%)",
    AdjustmentType.TotalAdjustmentPercentages: "Tổng tỉ lệ điều chỉnh (%)",
    AdjustmentType.AdjustmentFactor: "Hệ số điều chỉnh (%)",
    AdjustmentType.LandPriceAfterAdjustment:
        "Đơn giá đất sau khi điều chỉnh (đồng/m2)",
    AdjustmentType.AverageAppraisalLandPrice:
        "Đơn giá đất thẩm định bình quân (%)",
  };
  static const ids = {
    AdjustmentType.ResidentialLandPriceBeforeAdjustment: 61,
    AdjustmentType.Legal: 62,
    AdjustmentType.ScaleAndSize: 63,
    AdjustmentType.Shape: 64,
    AdjustmentType.Traffic: 65,
    AdjustmentType.BusinessAdvantage: 66,
    AdjustmentType.EnvironmentAndSecurity: 67,
    AdjustmentType.TotalAdjustmentPercentages: 68,
    AdjustmentType.AdjustmentFactor: 69,
    AdjustmentType.LandPriceAfterAdjustment: 70,
    AdjustmentType.AverageAppraisalLandPrice: 71,
  };

  int get id {
    if (ids[this] == null) {
      throw "Invalid Adjustment Type";
    }
    return ids[this]!;
  }

  String get name {
    if (names[this] == null) {
      throw "Invalid Adjustment Type";
    }
    return names[this]!;
  }

  String get someString => "Tỉ lệ điều chỉnh";
}

extension AnalysisTypeExtension on AnalysisType {
  static const names = {
    AnalysisType.Legal: "Pháp lý",
    AnalysisType.ScaleAndSize: "Quy mô, kích thước",
    AnalysisType.Shape: "Hình dáng",
    AnalysisType.Traffic: "Giao thông",
    AnalysisType.BusinessAdvantage: "Lợi thế kinh doanh",
    AnalysisType.EnvironmentAndSecurity: "Môi trường, an ninh",
  };
  static const ids = {
    AnalysisType.Legal: 55,
    AnalysisType.ScaleAndSize: 56,
    AnalysisType.Shape: 57,
    AnalysisType.Traffic: 58,
    AnalysisType.BusinessAdvantage: 59,
    AnalysisType.EnvironmentAndSecurity: 60,
  };

  String get name {
    if (names[this] == null) {
      throw "Invalid Analysis Type";
    }
    return names[this]!;
  }

  int get id {
    if (ids[this] == null) {
      throw "Invalid Analysis Type";
    }
    return ids[this]!;
  }

  String get someString => "BĐS so sánh";
}

extension GenderExtension on Gender {
  static final names = {
    Gender.Male: "Nam",
    Gender.Female: "Nữ",
  };

  String get name {
    return names[this]!;
  }
}

extension RealEstateTypeExtension on RealEstateType {
  static const names = {
    RealEstateType.house: "Nhà riêng",
    RealEstateType.project: "Đất dự án",
    RealEstateType.ground: "Đất nền",
    RealEstateType.villa: "Biệt thự",
    RealEstateType.apartment: "Chung cư",
    RealEstateType.other: "Khác",
    RealEstateType.initial: "Chưa chọn",
  };
  static const images = {
    RealEstateType.house: "House.png",
    RealEstateType.project: "apartment2.png",
    RealEstateType.ground: "apartment1.png",
    RealEstateType.villa: "villa.png",
    RealEstateType.apartment: "apartment.png",
    RealEstateType.other: "Khác",
    RealEstateType.initial: "Chưa chọn",
  };
  static RealEstateType? fromId(int id) {
    return inverseId[id];
  }

  static const inverseId = {
    0: RealEstateType.initial,
    1: RealEstateType.apartment,
    2: RealEstateType.house,
    3: RealEstateType.villa,
    4: RealEstateType.project,
    5: RealEstateType.ground,
    6: RealEstateType.other,
  };

  static const ids = {
    RealEstateType.initial: 0,
    RealEstateType.apartment: 1,
    RealEstateType.house: 2,
    RealEstateType.villa: 3,
    RealEstateType.project: 4,
    RealEstateType.ground: 5,
    RealEstateType.other: 6,
  };

  String get name => names[this]!;
  String get image => images[this]!;

  int get id => ids[this]!;
}

extension FileUploadTypeExtension on FileUploadType {
  static const urls = {
    FileUploadType.Documents: "documents",
    FileUploadType.Images: "images",
    FileUploadType.Roles: "user_data",
    FileUploadType.ValuationForms: "valuation_forms",
  };

  String get url => urls[this]!;
}

extension ListExt on List? {
  bool get isNullOrEmpty => this == null || (this?.isEmpty ?? true);
}

extension DateTimeExt on DateTime {
  String get ddMMyyyy {
    return DateFormat("dd/MM/yyyy").format(this);
  }
}

extension DioErrorExt on DioError {
  String get errorMessage {
    final result = response?.data;
    return result?.toString() ?? toString();
  }
}

extension StatusStateExt on StatusState {
  ButtonStatus get buttonStatus {
    if (this is LoadingState) {
      return ButtonStatus.loading;
    } else if (this is ErrorState) {
      return ButtonStatus.fail;
    } else if (this is SuccessState) {
      return ButtonStatus.success;
    }

    return ButtonStatus.idle;
  }
}
