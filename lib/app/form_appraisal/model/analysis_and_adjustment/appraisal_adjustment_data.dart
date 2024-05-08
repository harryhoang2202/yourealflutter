import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/extensions.dart';

class AppraisalAdjustmentData extends Equatable {
  @override
  List<Object?> get props => [adjustmentPercentages];
  final List<double> adjustmentPercentages;
  final AdjustmentType type;
//<editor-fold desc="Data Methods">

  const AppraisalAdjustmentData({
    this.adjustmentPercentages = const [0, 0, 0],
    required this.type,
  });

  @override
  String toString() {
    return 'AppraisalAnalysisData{' +
        ' compareRealEstate: $adjustmentPercentages,' +
        " type: $type," +
        '}';
  }

  AppraisalAdjustmentData copyWith({
    List<double>? compareRealEstate,
    AdjustmentType? type,
  }) {
    return AppraisalAdjustmentData(
      adjustmentPercentages: compareRealEstate ?? adjustmentPercentages,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "rowId": type.id,
      "content": jsonEncode({
        "data": [
          {
            "id": 1,
            "value": adjustmentPercentages[0],
          },
          {
            "id": 2,
            "value": adjustmentPercentages[1],
          },
          {
            "id": 3,
            "value": adjustmentPercentages[2],
          },
        ]
      })
    };
  }

//</editor-fold>
}
