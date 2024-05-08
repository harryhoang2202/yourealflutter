part of 'update_info_bloc.dart';

@freezed
class UpdateInfoState with _$UpdateInfoState {
  const UpdateInfoState._();
  const factory UpdateInfoState({
    @Default([]) List<Province> provinces,
    @Default([]) List<District> districts,
    @Default([]) List<Ward> wards,
    Province? selectedProvince,
    District? selectedDistrict,
    Ward? selectedWard,
    @Default("") String address,
    @Default("") String firstName,
    @Default("") String lastName,
    // @Default("") String email,
    @Default("") String phone,
    @Default("") String dob,
    @Default(ButtonStatus.idle) ButtonStatus status,
  }) = _UpdateInfoState;

  String? validate() {
    if (
        //email.isEmpty ||
        firstName.isEmpty ||
            lastName.isEmpty ||
            dob.isEmpty ||
            selectedProvince == null ||
            selectedDistrict == null ||
            selectedWard == null ||
            address.isEmpty) {
      return "Không đủ thông tin yêu cầu. Vui lòng kiểm tra lại!";
    }

    // if (!email.isEmail) return "Email không hợp lệ";
    if (!dob.isValidDate) return "Ngày sinh không hợp lệ";
    return null;
  }
}
