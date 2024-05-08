import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/services/services_api.dart';

part 'assign_deal_event.dart';
part 'assign_deal_state.dart';
part 'assign_deal_bloc.freezed.dart';

class AssignDealBloc extends Bloc<AssignDealEvent, AssignDealState> {
  final APIServices _services = APIServices();
  AssignDealBloc() : super(const AssignDealState.initial()) {
    on<_AssignDealLoadDealEvent>(_onCancelDealBlocEvent);
    on<_AssignDealLoadDetailEvent>(_onCancelDealLoadDetail);
  }

  void _onCancelDealBlocEvent(
    AssignDealEvent event,
    Emitter<AssignDealState> emitter,
  ) async {
    final result = await _services.getDealUnvaluated(
      lastId: 0,
      pageSize: 10,
    );
    emitter(AssignDealState.loaded(result ?? []));
  }

  void _onCancelDealLoadDetail(
    _AssignDealLoadDetailEvent event,
    Emitter<AssignDealState> emitter,
  ) async {
    Deal? deal = await _services.getDealById(dealId: event.id);
    if (deal != null) {
      emitter(AssignDealState.loadDetailSuccess(deal));
    } else {
      emitter(const AssignDealState.loadDetalError());
    }
  }
}
