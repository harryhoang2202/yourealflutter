part of 'appraiser_bloc.dart';

@freezed
class AppraiserEvent with _$AppraiserEvent {
  const factory AppraiserEvent.moreLoaded({
    required PageKey page,
  }) = AppraiserMoreLoaded;
  const factory AppraiserEvent.onRefreshed() = AppraiserRefreshed;
}
