import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/common/tools.dart';
import 'package:youreal/services/services_api.dart';

part 'new_deal_event.dart';
part 'new_deal_state.dart';
part 'new_deal_bloc.freezed.dart';

class NewDealBloc extends Bloc<NewDealEvent, NewDealState> {
  final APIServices _services = APIServices();
  NewDealBloc() : super(const NewDealState.initial()) {
    on<_NewDealLoadDealEvent>(_onCancelDealBlocEvent);
    on<_NewDealLoadDetailEvent>(_onCancelDealLoadDetail);
  }

  void _onCancelDealBlocEvent(
    NewDealEvent event,
    Emitter<NewDealState> emitter,
  ) async {
    final result = await _services.getListDealNew(
      page: 1,
      sessionId: Utils.newSessionId,
    );
    emitter(NewDealState.loaded(result ?? []));
  }

  void _onCancelDealLoadDetail(
    _NewDealLoadDetailEvent event,
    Emitter<NewDealState> emitter,
  ) async {
    Deal? deal = await _services.getDealById(dealId: event.id);
    if (deal != null) {
      emitter(NewDealState.loadDetailSuccess(deal));
    } else {
      emitter(const NewDealState.loadDetalError());
    }
  }
}
