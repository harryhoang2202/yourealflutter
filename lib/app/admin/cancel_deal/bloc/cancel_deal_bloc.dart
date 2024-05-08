import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/common/tools.dart';
import 'package:youreal/services/services_api.dart';

part 'cancel_deal_event.dart';
part 'cancel_deal_state.dart';
part 'cancel_deal_bloc.freezed.dart';

class CancelDealBloc extends Bloc<CancelDealEvent, CancelDealState> {
  final APIServices _services = APIServices();
  CancelDealBloc() : super(const CancelDealState.initial()) {
    on<CancelDealLoadDealEvent>(_onCancelDealBlocEvent);
    on<CancelDealLoadDetailEvent>(_onCancelDealLoadDetail);
  }

  void _onCancelDealBlocEvent(
    CancelDealEvent event,
    Emitter<CancelDealState> emitter,
  ) async {
    final result = await _services.getListDealCancelledOrRejected(
      page: 1,
      sessionId: Utils.newSessionId,
    );
    emitter(CancelDealState.loaded(result ?? []));
  }

  void _onCancelDealLoadDetail(
    CancelDealLoadDetailEvent event,
    Emitter<CancelDealState> emitter,
  ) async {
    Deal? deal = await _services.getDealById(dealId: event.id);
    if (deal != null) {
      emitter(CancelDealState.loadDetailSuccess(deal));
    } else {
      emitter(const CancelDealState.loadDetalError());
    }
  }
}
