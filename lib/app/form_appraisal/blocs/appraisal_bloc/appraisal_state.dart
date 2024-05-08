part of 'appraisal_bloc.dart';

class AppraisalState extends Equatable {
  @override
  List<Object?> get props => [
        docType,
        landType,
        sentAppraisalSuccess,
        valuationFormId,
        survey,
        analyses,
        adjustments,
      ];

  final AppraisalDocType docType;
  final AppraisalLandType landType;
  final bool? sentAppraisalSuccess;
  final int? valuationFormId;
  late final Map<SurveyType, SurveyData> survey;
  late final Map<AnalysisType, AppraisalAnalysisData> analyses;
  late final Map<AdjustmentType, AppraisalAdjustmentData> adjustments;

  AppraisalState({
    this.docType = AppraisalDocType.LegalDocument,
    this.landType = AppraisalLandType.Residential,
    this.sentAppraisalSuccess,
    this.valuationFormId,
    Map<SurveyType, SurveyData>? survey,
    Map<AnalysisType, AppraisalAnalysisData>? analyses,
    Map<AdjustmentType, AppraisalAdjustmentData>? adjustments,
  }) {
    this.survey = survey ??
        {
          for (var surveyType in SurveyType.values)
            surveyType: SurveyData(type: surveyType, comparisons: const []),
        };
    this.analyses = analyses ??
        {
          for (var type in AnalysisType.values)
            type: AppraisalAnalysisData(type: type),
        };
    this.adjustments = adjustments ??
        {
          for (var type in AdjustmentType.values)
            type: AppraisalAdjustmentData(type: type),
        };
  }

  AppraisalState docTypeChanged(AppraisalDocType value) =>
      copyWith(docType: value);

  AppraisalState landTypeChanged(AppraisalLandType value) =>
      copyWith(landType: value);

  AppraisalState surveyChangeSuccess(survey) => copyWith(survey: survey);

  AppraisalState appraisalSentStatus(bool result, {int? valuationFormId}) {
    if (result == true && valuationFormId == null ||
        result == false && valuationFormId != null) {
      throw "Appraisal Sent Status Error";
    }
    return AppraisalState(
        sentAppraisalSuccess: result, valuationFormId: valuationFormId);
  }

  AppraisalState copyWith({
    AppraisalDocType? docType,
    AppraisalLandType? landType,
    bool? sentAppraisalSuccess,
    int? valuationFormId,
    Map<SurveyType, SurveyData>? survey,
    Map<AnalysisType, AppraisalAnalysisData>? analyses,
    Map<AdjustmentType, AppraisalAdjustmentData>? adjustments,
  }) {
    return AppraisalState(
      docType: docType ?? this.docType,
      landType: landType ?? this.landType,
      sentAppraisalSuccess: sentAppraisalSuccess ?? this.sentAppraisalSuccess,
      valuationFormId: valuationFormId ?? this.valuationFormId,
      survey: survey ?? this.survey,
      analyses: analyses ?? this.analyses,
      adjustments: adjustments ?? this.adjustments,
    );
  }
}
