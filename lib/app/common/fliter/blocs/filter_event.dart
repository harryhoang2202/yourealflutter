part of 'filter_bloc.dart';

@freezed
class FilterEvent with _$FilterEvent {
  factory FilterEvent.initial() = FilterEventInitial;
  factory FilterEvent.changedInvestmentLimit(lower, upper) =
      ChangedInvestmentLimit;
  factory FilterEvent.changeProvince(Province p) = ChangeProvince;
  factory FilterEvent.selectedSolid(OtpCheckModel solid) = SelectedSolid;
  factory FilterEvent.selectedLeader(OtpCheckModel leader) = SelectedLeader;
  factory FilterEvent.sendFilter() = SendFilter;
}
