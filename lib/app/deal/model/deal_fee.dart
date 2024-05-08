import 'package:freezed_annotation/freezed_annotation.dart';

part 'deal_fee.freezed.dart';

part 'deal_fee.g.dart';

@freezed
class DealFee with _$DealFee {
  const DealFee._();
  @JsonSerializable(explicitToJson: true)
  // @Assert('feeType==FeeType.Others? note!=null:true',
  //     "Note must not be null if FeeType is Others")
  const factory DealFee({
    required int id,
    @JsonKey(name: "feeTypeId") required FeeType feeType,
    required double value,
    String? note,
    required String feeTypeName,
  }) = _DealFee;
  static DealFee geDefault() => DealFee(
      value: 0,
      feeType: FeeType.Others,
      feeTypeName: FeeType.Others.name,
      id: -1);
  bool validate() {
    if (value <= 0 || (feeType == FeeType.Others && note == null)) {
      return false;
    }
    return true;
  }

  factory DealFee.fromJson(Map<String, dynamic> json) =>
      _$DealFeeFromJson(json);
}

enum FeeType {
  @JsonValue(1)
  Fee1,
  @JsonValue(2)
  Fee2,
  @JsonValue(3)
  Fee3,
  @JsonValue(4)
  Others,
}

extension FeeTypeExt on FeeType {
  int get id {
    final ids = {
      FeeType.Fee1: 1,
      FeeType.Fee2: 2,
      FeeType.Fee3: 3,
      FeeType.Others: 4,
    };
    return ids[this]!;
  }

  String get name {
    final names = {
      FeeType.Fee1: "Phí 1",
      FeeType.Fee2: "Phí 2",
      FeeType.Fee3: "Phí 3",
      FeeType.Others: "Phí khác",
    };
    return names[this]!;
  }
}
