part of 'setup_profile_bloc.dart';

abstract class SetupProfileEvent extends Equatable {
  const SetupProfileEvent();
}

class SetupProfileGenderChanged extends SetupProfileEvent {
  const SetupProfileGenderChanged(this.gender);

  @override
  List<Object?> get props => [gender];
  final Gender gender;
}

class SetupProfileInitialLoaded extends SetupProfileEvent {
  const SetupProfileInitialLoaded();

  @override
  List<Object?> get props => [];
}

class SetupProfileProvinceChanged extends SetupProfileEvent {
  const SetupProfileProvinceChanged(this.province);

  @override
  List<Object?> get props => [province];
  final Province province;
}

class SetupProfileDistrictChanged extends SetupProfileEvent {
  const SetupProfileDistrictChanged(this.province, this.district);

  @override
  List<Object?> get props => [province, district];
  final Province province;
  final District district;
}

class SetupProfileWardChanged extends SetupProfileEvent {
  const SetupProfileWardChanged(this.ward);

  @override
  List<Object?> get props => [ward];
  final Ward ward;
}

class SetupProfileLocationChanged extends SetupProfileEvent {
  const SetupProfileLocationChanged(this.location);

  @override
  List<Object?> get props => [location];
  final String location;
}

class SetupProfileDobChanged extends SetupProfileEvent {
  const SetupProfileDobChanged(this.dob);

  @override
  List<Object?> get props => [dob];
  final String dob;
}

class SetupProfileEmailChanged extends SetupProfileEvent {
  const SetupProfileEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
  final String email;
}

class SetupProfileFirstNameChanged extends SetupProfileEvent {
  const SetupProfileFirstNameChanged(this.name);

  @override
  List<Object?> get props => [name];
  final String name;
}

class SetupProfileLastNameChanged extends SetupProfileEvent {
  const SetupProfileLastNameChanged(this.name);

  @override
  List<Object?> get props => [name];
  final String name;
}

class SetupProfileInterestedRealTypeChanged extends SetupProfileEvent {
  const SetupProfileInterestedRealTypeChanged(this.types);

  @override
  List<Object?> get props => [types];
  final List<RealEstateType> types;
}

class SetupProfileAgreeRuleChanged extends SetupProfileEvent {
  const SetupProfileAgreeRuleChanged(this.value);

  @override
  List<Object?> get props => [value];
  final bool value;
}

class SetupProfileBudgetChanged extends SetupProfileEvent {
  const SetupProfileBudgetChanged(this.value);

  @override
  List<Object?> get props => [value];
  final RangeValues value;
}

class SetupProfileSubmitted extends SetupProfileEvent {
  const SetupProfileSubmitted();

  @override
  List<Object?> get props => [];
}

class SetupProfileAvatarChanged extends SetupProfileEvent {
  const SetupProfileAvatarChanged(this.url);
  final String url;
  @override
  List<Object?> get props => [url];
}
