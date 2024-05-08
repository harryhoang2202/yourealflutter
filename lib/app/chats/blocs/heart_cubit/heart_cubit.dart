import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

part 'heart_cubit.freezed.dart';
part 'heart_state.dart';

class HeartCubit extends Cubit<HeartState> {
  HeartCubit() : super(const HeartInitial());

  void forwarded() {
    emit(const HeartForwardingAnimation());
  }

  void reversed(ValueChanged<double> scaleCallback) {
    emit(HeartReversingAnimation(scaleCallback));
  }
}
