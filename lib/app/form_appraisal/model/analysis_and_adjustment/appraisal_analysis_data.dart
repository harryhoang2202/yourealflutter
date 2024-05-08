import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/extensions.dart';

class AppraisalAnalysisData extends Equatable {
  @override
  List<Object?> get props => [compareRealEstate, type];
  final List<String> compareRealEstate;
  final AnalysisType type;
//<editor-fold desc="Data Methods">

  const AppraisalAnalysisData({
    this.compareRealEstate = const ["", "", ""],
    required this.type,
  });

  @override
  String toString() {
    return 'AppraisalAnalysisData{' +
        ' compareRealEstate: $compareRealEstate,' +
        " type: $type," +
        '}';
  }

  AppraisalAnalysisData copyWith({
    List<String>? compareRealEstate,
    AnalysisType? type,
  }) {
    return AppraisalAnalysisData(
      compareRealEstate: compareRealEstate ?? this.compareRealEstate,
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
            "value": compareRealEstate[0],
          },
          {
            "id": 2,
            "value": compareRealEstate[1],
          },
          {
            "id": 3,
            "value": compareRealEstate[2],
          },
        ]
      })
    };
  }

//</editor-fold>
}
