part of 'appraisal_bloc.dart';

abstract class AppraisalEvent extends Equatable {
  const AppraisalEvent();
}

class AppraisalDocTypeChanged extends AppraisalEvent {
  final AppraisalDocType type;

  const AppraisalDocTypeChanged(this.type);
  @override
  List<Object?> get props => [type];
}

class AppraisalLandTypeChanged extends AppraisalEvent {
  final AppraisalLandType type;

  const AppraisalLandTypeChanged(this.type);
  @override
  List<Object?> get props => [type];
}

class AppraisalSent extends AppraisalEvent {
  const AppraisalSent();
  @override
  List<Object?> get props => [];
}

class AppraisalComparisonAdded extends AppraisalEvent {
  final SurveyType type;
  final SurveyComparison data;
  const AppraisalComparisonAdded(this.type, this.data);
  @override
  List<Object?> get props => [data, type];
}

class AppraisalComparisonUpdated extends AppraisalEvent {
  final SurveyType type;
  final SurveyComparison data;
  const AppraisalComparisonUpdated(this.type, this.data);
  @override
  List<Object?> get props => [data, type];
}

class AppraisalComparisonDeleted extends AppraisalEvent {
  final SurveyType type;
  final SurveyComparison data;
  const AppraisalComparisonDeleted(this.type, this.data);
  @override
  List<Object?> get props => [data, type];
}

class AppraisalAnalysisUpdated extends AppraisalEvent {
  const AppraisalAnalysisUpdated(this.type, this.data);

  @override
  List<Object?> get props => [type, data];
  final AnalysisType type;
  final AppraisalAnalysisData data;
}

class AppraisalAdjustmentUpdated extends AppraisalEvent {
  const AppraisalAdjustmentUpdated(this.type, this.data);

  @override
  List<Object?> get props => [type, data];
  final AdjustmentType type;
  final AppraisalAdjustmentData data;
}
