import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/extensions.dart';

class SurveyData extends Equatable {
  final SurveyType type;
  final List<SurveyComparison> comparisons;

  @override
  List<Object?> get props => [type, comparisons];

//<editor-fold desc="Data Methods">

  const SurveyData({
    required this.type,
    required this.comparisons,
  });

  @override
  String toString() {
    return 'SurveyData{' +
        ' type: $type,' +
        ' comparisons: $comparisons,' +
        '}';
  }

  SurveyData copyWith({
    SurveyType? type,
    List<SurveyComparison>? comparisons,
  }) {
    return SurveyData(
      type: type ?? this.type,
      comparisons: comparisons ?? this.comparisons,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "rowId": type.id,
      "content": jsonEncode({
        "data": comparisons
            .map((e) => {
                  "id": type.id,
                  ...e.toMap(),
                })
            .toList()
      }),
    };
  }

//</editor-fold>
}

class SurveyComparison extends Equatable {
  @override
  List<Object?> get props => [price, realEstateName];
  final String realEstateName;
  final double price;
  final String id;

//<editor-fold desc="Data Methods">

  const SurveyComparison({
    required this.id,
    required this.realEstateName,
    required this.price,
  });

  @override
  String toString() {
    return 'SurveyComparison{' +
        ' realEstateName: $realEstateName,' +
        ' price: $price,' +
        "id: $id," +
        '}';
  }

  SurveyComparison copyWith({
    String? realEstateName,
    double? price,
  }) {
    return SurveyComparison(
      realEstateName: realEstateName ?? this.realEstateName,
      price: price ?? this.price,
      id: id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': realEstateName,
      'priceCompare': price,
    };
  }

//</editor-fold>
}
