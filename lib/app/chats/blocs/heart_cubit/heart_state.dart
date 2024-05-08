part of 'heart_cubit.dart';

@freezed
class HeartState with _$HeartState {
  const factory HeartState.initial() = HeartInitial;
  const factory HeartState.forwarding() = HeartForwardingAnimation;
  const factory HeartState.reversing(ValueChanged<double> scaleCallback) =
      HeartReversingAnimation;
}
