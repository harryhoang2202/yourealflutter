part of 'admin_search_deal_cubit.dart';

@freezed
class AdminSearchDealState with _$AdminSearchDealState {
  const factory AdminSearchDealState.success(List<Deal> result) =
      AdminSearchDealSuccess;
  const factory AdminSearchDealState.failed(String error) =
      AdminSearchDealFailed;
  const factory AdminSearchDealState.empty() = AdminSearchDealEmpty;
  const factory AdminSearchDealState.loading() = AdminSearchDealLoading;
  const factory AdminSearchDealState.initial() = AdminSearchDealInitial;
}
