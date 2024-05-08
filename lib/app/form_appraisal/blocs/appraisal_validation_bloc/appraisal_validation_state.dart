part of 'appraisal_validation_bloc.dart';

@immutable
abstract class AppraisalValidationState extends Equatable {}

class AppraisalValidationInitial extends AppraisalValidationState {
  @override
  List<Object?> get props => [];
}

class AppraisalScreen1ValidationSuccess extends AppraisalValidationState {
  @override
  List<Object?> get props => [];
}

class AppraisalScreen1ValidationFailure extends AppraisalValidationState {
  final String reason;

  AppraisalScreen1ValidationFailure(this.reason);
  @override
  List<Object?> get props => [reason];
}
