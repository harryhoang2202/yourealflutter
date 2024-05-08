part of 'appraisal_validation_bloc.dart';

abstract class AppraisalValidationEvent extends Equatable {
  const AppraisalValidationEvent();
}

class AppraisalScreen1Validated extends AppraisalValidationEvent {
  const AppraisalScreen1Validated({
    required this.appraisalProposer,
    required this.propertyOwner,
    required this.appraisalPurpose,
    required this.appraisalAcceptedTime,
  });

  @override
  List<Object?> get props => [
        appraisalProposer,
        propertyOwner,
        appraisalPurpose,
        appraisalAcceptedTime,
      ];

  final String appraisalProposer;
  final String propertyOwner;
  final String appraisalPurpose;
  final String appraisalAcceptedTime;
}
