import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:youreal/app/deal/model/deal.dart';

import 'package:youreal/services/services_api.dart';

part 'approving_deal_event.dart';
part 'approving_deal_state.dart';

class ApprovingDealBloc extends Bloc<ApprovingDealEvent, ApprovingDealState> {
  ApprovingDealBloc() : super(ApprovingDealInitial()) {
    on<LoadDealApprovingEvent>(((event, emit) async {
      emit(LoadingDealApprovingState());
      dealsApproving = await _services.getListDealApproving(
        page: int.parse(event.props[0].toString()),
        sessionId: int.parse(event.props[1].toString()),
      );
      if (dealsApproving != null) {
        emit(LoadedDealApprovingState(deals: dealsApproving!));
      } else {
        emit(LoadedDealApprovingErrorState());
      }
    }));
    on<LoadDetailDealApprovingEvent>((event, emit) async {
      emit(LoadingDetailDealApprovingState());
      Deal? deal = await _services.getDealById(dealId: event.props[0]);
      if (deal != null) {
        emit(LoadedDetailDealApprovingState(deal: deal));
      } else {
        emit(LoadedDetailDealApprovingErrorState());
      }
    });
  }
  final APIServices _services = APIServices();
  List<Deal>? dealsApproving;
}
