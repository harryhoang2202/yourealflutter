import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/common/tools.dart';
import 'package:youreal/services/services_api.dart';

part 'reviewed_deal_event.dart';
part 'reviewed_deal_state.dart';
part 'reviewed_deal_bloc.freezed.dart';

class ReviewedDealBloc extends Bloc<ReviewedDealEvent, ReviewedDealState> {
  final APIServices _services = APIServices();
  ReviewedDealBloc() : super(const ReviewedDealState.initial()) {
    on<ReviewedDealLoadDealEvent>(_onReviewedDealBlocEvent);
    on<ReviewedDealLoadDetailEvent>(_onReviewedDealLoadDetail);
  }

  void _onReviewedDealBlocEvent(
    ReviewedDealEvent event,
    Emitter<ReviewedDealState> emitter,
  ) async {
    final result = await _services.getListDealReviewed(
      page: 1,
      sessionId: Utils.newSessionId,
    );
    emitter(ReviewedDealState.loaded(result ?? []));
  }

  void _onReviewedDealLoadDetail(
    ReviewedDealLoadDetailEvent event,
    Emitter<ReviewedDealState> emitter,
  ) async {
    Deal? deal = await _services.getDealById(dealId: event.id);
    if (deal != null) {
      emitter(ReviewedDealState.loadDetailSuccess(deal));
    } else {
      emitter(const ReviewedDealState.loadDetalError());
    }
  }
}
