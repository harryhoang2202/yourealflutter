part of 'setup_profile_bloc.dart';

class SetupProfileState extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final Gender gender;
  final String dob;
  final Province? selectedProvince;
  final District? selectedDistrict;
  final Ward? selectedWard;
  final String location;
  final double minBudget;
  final double maxBudget;
  final List<RealEstateType> interestedRealEstateTypes;
  final bool agreeRule;
  final List<Province> provinces;
  final List<District> districts;
  final List<Ward> wards;
  final ButtonStatus buttonStatus;
  final String error;
  final String avatarUrl;

  @override
  List<Object?> get props => [
        firstName,
        email,
        gender,
        dob,
        selectedProvince,
        selectedDistrict,
        selectedWard,
        location,
        minBudget,
        maxBudget,
        interestedRealEstateTypes,
        agreeRule,
        provinces,
        districts,
        wards,
        buttonStatus,
        error,
        avatarUrl,
        lastName,
      ];

  factory SetupProfileState.initial() => const SetupProfileState(
        firstName: "",
        email: "",
        gender: Gender.Male,
        dob: "",
        location: "",
        minBudget: 10,
        maxBudget: 40,
        interestedRealEstateTypes: [],
        agreeRule: false,
        districts: [],
        provinces: [],
        wards: [],
        buttonStatus: ButtonStatus.idle,
        error: '',
        avatarUrl: '',
        lastName: '',
      );

  String? validate() {
    if (email.isEmpty ||
        firstName.isEmpty ||
        dob.isEmpty ||
        selectedProvince == null ||
        selectedDistrict == null ||
        selectedWard == null ||
        location.isEmpty) {
      return "Không đủ thông tin yêu cầu. Vui lòng kiểm tra lại!";
    }
    if (interestedRealEstateTypes.length < 2) {
      return "Vui lòng chọn ít nhất 2 loại bất động sản bạn đang quan tâm";
    }
    if (!agreeRule) {
      return "Vui lòng đồng ý với các điều khoản và chính sách bảo mật";
    }
    if (!email.isEmail) return "Email không hợp lệ";
    if (!dob.isValidDate) return "Ngày sinh không hợp lệ";
    if (avatarUrl.isEmpty) return "Vui lòng chọn ảnh đại diện";
    return null;
  }

//<editor-fold desc="Data Methods">

  const SetupProfileState({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.dob,
    this.selectedProvince,
    this.selectedDistrict,
    this.selectedWard,
    required this.location,
    required this.minBudget,
    required this.maxBudget,
    required this.interestedRealEstateTypes,
    required this.agreeRule,
    required this.provinces,
    required this.districts,
    required this.wards,
    required this.buttonStatus,
    required this.error,
    required this.avatarUrl,
  });

  @override
  String toString() {
    return 'SetupProfileState{ firstName: $firstName, lastName: $lastName, email: $email, gender: $gender, dob: $dob, selectedProvince: $selectedProvince, selectedDistrict: $selectedDistrict, selectedWard: $selectedWard, location: $location, minBudget: $minBudget, maxBudget: $maxBudget, interestedRealEstateTypes: $interestedRealEstateTypes, agreeRule: $agreeRule, buttonStatus: $buttonStatus, error: $error, avatarUrl: $avatarUrl,}';
  }

  SetupProfileState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    Gender? gender,
    String? dob,
    Nullable<Province?>? selectedProvince,
    Nullable<District?>? selectedDistrict,
    Nullable<Ward?>? selectedWard,
    String? location,
    double? minBudget,
    double? maxBudget,
    List<RealEstateType>? interestedRealEstateTypes,
    bool? agreeRule,
    List<Province>? provinces,
    List<District>? districts,
    List<Ward>? wards,
    ButtonStatus? buttonStatus,
    String? error,
    String? avatarUrl,
  }) {
    return SetupProfileState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      selectedProvince: selectedProvince == null
          ? this.selectedProvince
          : selectedProvince.value,
      selectedDistrict: selectedDistrict == null
          ? this.selectedDistrict
          : selectedDistrict.value,
      selectedWard:
          selectedWard == null ? this.selectedWard : selectedWard.value,
      location: location ?? this.location,
      minBudget: minBudget ?? this.minBudget,
      maxBudget: maxBudget ?? this.maxBudget,
      interestedRealEstateTypes:
          interestedRealEstateTypes ?? this.interestedRealEstateTypes,
      agreeRule: agreeRule ?? this.agreeRule,
      provinces: provinces ?? this.provinces,
      districts: districts ?? this.districts,
      wards: wards ?? this.wards,
      buttonStatus: buttonStatus ?? this.buttonStatus,
      error: error ?? this.error,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'gender': gender,
      'dob': dob,
      'selectedProvince': selectedProvince,
      'selectedDistrict': selectedDistrict,
      'selectedWard': selectedWard,
      'location': location,
      'minBudget': minBudget,
      'maxBudget': maxBudget,
      'interestedRealEstateTypes': interestedRealEstateTypes,
      'agreeRule': agreeRule,
      'provinces': provinces,
      'districts': districts,
      'wards': wards,
      'buttonStatus': buttonStatus,
      'error': error,
      'avatarUrl': avatarUrl,
    };
  }

  factory SetupProfileState.fromMap(Map<String, dynamic> map) {
    return SetupProfileState(
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      gender: map['gender'] as Gender,
      dob: map['dob'] as String,
      selectedProvince: map['selectedProvince'] as Province,
      selectedDistrict: map['selectedDistrict'] as District,
      selectedWard: map['selectedWard'] as Ward,
      location: map['location'] as String,
      minBudget: map['minBudget'] as double,
      maxBudget: map['maxBudget'] as double,
      interestedRealEstateTypes:
          map['interestedRealEstateTypes'] as List<RealEstateType>,
      agreeRule: map['agreeRule'] as bool,
      provinces: map['provinces'] as List<Province>,
      districts: map['districts'] as List<District>,
      wards: map['wards'] as List<Ward>,
      buttonStatus: map['buttonStatus'] as ButtonStatus,
      error: map['error'] as String,
      avatarUrl: map['avatarUrl'] as String,
    );
  }

//</editor-fold>
}
