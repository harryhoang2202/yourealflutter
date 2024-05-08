import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:youreal/app/deal/model/deal.dart';

import 'package:youreal/services/services_api.dart';

part 'deal_event.dart';
part 'deal_state.dart';

class DealBloc extends Bloc<DealEvent, DealState> {
  DealBloc() : super(DealInitial()) {
    on<LoadMyDealEvent>(_loadMyDealEvent);
    on<LoadMyDealAppraisalEvent>(_loadMyDealAppraisalEvent);
  }
  final APIServices _services = APIServices();
  List<Deal>? dealsSuggest;

  List<Deal>? myDeal;
  List<Deal>? myAppraisalDeal;

  _loadMyDealEvent(LoadMyDealEvent event, Emitter<DealState> emit) async {
    emit(LoadingMyDealState());
    myDeal = await _services.getDealOfUser(
      page: int.parse(event.props[0].toString()),
      sessionId: int.parse(event.props[1].toString()),
      pageSize: int.parse(event.props[2].toString()),
    );
    if (myDeal != null) {
      emit(LoadedMyDealState(deals: myDeal!));
    } else {
      emit(LoadedMyDealErrorState());
    }
  }

  _loadMyDealAppraisalEvent(
      LoadMyDealAppraisalEvent event, Emitter<DealState> emit) async {
    emit(LoadingMyDealAppraisalState());
    myAppraisalDeal = await _services.getDealAppraisalOfUser(
      page: int.parse(event.props[0].toString()),
      sessionId: int.parse(event.props[1].toString()),
    );
    if (myAppraisalDeal != null) {
      emit(LoadedMyDealAppraisalState(deals: myAppraisalDeal!));
    } else {
      emit(LoadedMyDealAppraisalErrorState());
    }
  }
}
