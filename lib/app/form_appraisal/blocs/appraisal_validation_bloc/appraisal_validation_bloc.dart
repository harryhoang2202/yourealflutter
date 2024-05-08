import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

part 'appraisal_validation_event.dart';

part 'appraisal_validation_state.dart';

class AppraisalValidationBloc
    extends Bloc<AppraisalValidationEvent, AppraisalValidationState> {
  AppraisalValidationBloc() : super(AppraisalValidationInitial()) {
    on<AppraisalScreen1Validated>(_mapAppraisalScreen1ValidatedToState);
  }

  _mapAppraisalScreen1ValidatedToState(AppraisalScreen1Validated event,
      Emitter<AppraisalValidationState> emit) async {
    if (state is AppraisalValidationInitial) {
      if (event.appraisalProposer.isEmpty ||
          event.propertyOwner.isEmpty ||
          event.appraisalPurpose.isEmpty ||
          event.appraisalAcceptedTime.isEmpty) {
        emit(AppraisalScreen1ValidationFailure(
            "Vui lòng nhập đầy đủ thông tin!"));
      } else {
        emit(AppraisalScreen1ValidationSuccess());
      }

      emit(AppraisalValidationInitial());
    }
  }

  // @override
  // Stream<Transition<AppraisalValidationEvent, AppraisalValidationState>>
  //     transformEvents(
  //         Stream<AppraisalValidationEvent> events,
  //         TransitionFunction<AppraisalValidationEvent, AppraisalValidationState>
  //             transitionFn) {
  //   return super.transformEvents(
  //       events.debounceTime(const Duration(milliseconds: 400)), transitionFn);
  // }
}
