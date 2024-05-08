part of 'update_info_bloc.dart';

@freezed
class UpdateInfoEvent with _$UpdateInfoEvent {
  const factory UpdateInfoEvent.initialLoaded(User user) =
      UpdateInfoInitialLoaded;

  const factory UpdateInfoEvent.provinceChanged(Province province) =
      UpdateInfoProvinceChanged;

  const factory UpdateInfoEvent.districtChanged(
      Province province, District district) = UpdateInfoDistrictChanged;

  const factory UpdateInfoEvent.wardChanged(Ward ward) = UpdateInfoWardChanged;

  const factory UpdateInfoEvent.firstNameChanged(String name) =
      UpdateInfoFirstNameChanged;
  const factory UpdateInfoEvent.lastNameChanged(String name) =
      UpdateInfoLastNameChanged;

  const factory UpdateInfoEvent.dobChanged(String dob) = UpdateInfoDobChanged;
  const factory UpdateInfoEvent.addressChanged(String address) =
      UpdateInfoAddressChanged;

  const factory UpdateInfoEvent.onSubmitted(
      {required void Function(String? error) onComplete}) = UpdateInfoSubmitted;
}
