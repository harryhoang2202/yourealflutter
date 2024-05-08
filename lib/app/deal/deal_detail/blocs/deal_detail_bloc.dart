import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:youreal/app/deal/deal_detail/services/deal_detail_service.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/common/model/status_state.dart';

part 'deal_detail_state.dart';
part 'deal_detail_event.dart';
part 'deal_detail_bloc.freezed.dart';

class DealDetailBloc extends Bloc<DealDetailEvent, DealDetailState> {
  DealDetailBloc() : super(DealDetailState.initial()) {
    on<_Initial>(_onInitial);
    on<_RejectDeal>(_onRejectDeal);
    on<_ApprovedDeal>(_onApprovedDeal);
    on<_AssignAppraiser>(_onAssignAppraiser);
    on<_JoinDeal>(_onJoinDeal);
    on<_VoteLeaderDeal>(_onVoteLeaderDeal);
    on<_UpdateEventDeal>(_onUpdateEventDeal);
    on<_CloseDeal>(_onCloseDeal);
    on<_UpdatePayment>(_onUpdatePayment);
    on<_ReOpenDeal>(_onReOpenDeal);
  }

  Future<void> _onInitial(_Initial event, Emitter<DealDetailState> emit) async {
    emit(state.copyWith(initialStatus: const LoadingState()));
    try {
      Deal? deal = await DealDetailService.getDealById(dealId: event.id);
      emit(state.copyWith(initialStatus: const SuccessState(), deal: deal));
    } catch (e) {
      emit(state.copyWith(initialStatus: ErrorState(error: e.toString())));
    } finally {
      emit(state.copyWith(initialStatus: const IdleState()));
    }
    emit(state.copyWith(initialStatus: const IdleState()));
  }

  Future<void> _onRejectDeal(
      _RejectDeal event, Emitter<DealDetailState> emit) async {
    emit(state.copyWith(rejectStatus: const LoadingState()));
    try {
      bool result = await DealDetailService.rejectDeal(
          dealId: event.id, message: event.mess);
      if (result) {
        emit(state.copyWith(rejectStatus: const SuccessState()));
      } else {
        emit(state.copyWith(
            rejectStatus:
                const ErrorState(error: "Có lỗi xảy ra! Vui lòng thử lại")));
      }
    } catch (e) {
      emit(state.copyWith(rejectStatus: ErrorState(error: e.toString())));
    } finally {
      emit(state.copyWith(rejectStatus: const IdleState()));
    }
    emit(state.copyWith(rejectStatus: const IdleState()));
  }

  Future<void> _onApprovedDeal(
      _ApprovedDeal event, Emitter<DealDetailState> emit) async {
    emit(state.copyWith(approvedStatus: const LoadingState()));
    try {
      bool result = await DealDetailService.approvedDeal(dealId: event.id);
      if (result) {
        emit(state.copyWith(approvedStatus: const SuccessState()));
      } else {
        emit(state.copyWith(
            approvedStatus:
                const ErrorState(error: "Có lỗi xảy ra! Vui lòng thử lại")));
      }
    } catch (e) {
      emit(state.copyWith(approvedStatus: ErrorState(error: e.toString())));
    } finally {
      emit(state.copyWith(approvedStatus: const IdleState()));
    }
    emit(state.copyWith(approvedStatus: const IdleState()));
  }

  Future<void> _onAssignAppraiser(
      _AssignAppraiser event, Emitter<DealDetailState> emit) async {
    emit(state.copyWith(assignAppraiserStatus: const LoadingState()));
    try {
      bool result = await DealDetailService.assignAppraiser(
          realEstateId: event.realEstateId,
          valuationUnitId: event.valuationUnitId);
      if (result) {
        emit(state.copyWith(assignAppraiserStatus: const SuccessState()));
      } else {
        emit(state.copyWith(
            assignAppraiserStatus:
                const ErrorState(error: "Có lỗi xảy ra! Vui lòng thử lại")));
      }
    } catch (e) {
      emit(state.copyWith(
          assignAppraiserStatus: ErrorState(error: e.toString())));
    } finally {
      emit(state.copyWith(assignAppraiserStatus: const IdleState()));
    }
    emit(state.copyWith(assignAppraiserStatus: const IdleState()));
  }

  Future<void> _onJoinDeal(
      _JoinDeal event, Emitter<DealDetailState> emit) async {
    try {
      emit(state.copyWith(joinDealStatus: const LoadingState()));
      if (event.dealId.isEmpty || event.allocation.isEmpty) {
        emit(state.copyWith(
            joinDealStatus:
                const ErrorState(error: "Vui lòng nhập phần trăm tham gia")));
      } else {
        final result = await DealDetailService.joinDeal(
            dealId: event.dealId,
            allocation: event.allocation,
            paymentMethodId: event.payment);
        if (result) {
          emit(state.copyWith(joinDealStatus: const SuccessState()));
        } else {
          emit(state.copyWith(
              joinDealStatus:
                  const ErrorState(error: "Có lỗi xảy ra! Vui lòng thử lại")));
        }
      }
    } catch (e) {
      emit(state.copyWith(joinDealStatus: ErrorState(error: e.toString())));
    } finally {
      emit(state.copyWith(joinDealStatus: const IdleState()));
    }
    emit(state.copyWith(joinDealStatus: const IdleState()));
  }

  Future<void> _onVoteLeaderDeal(
      _VoteLeaderDeal event, Emitter<DealDetailState> emit) async {
    try {
      emit(state.copyWith(voteLeaderStatus: const LoadingState()));
      final result = await DealDetailService.voteLeader(
        dealId: event.dealId,
        userId: event.userId,
      );
      if (result) {
        emit(state.copyWith(voteLeaderStatus: const SuccessState()));
      } else {
        emit(state.copyWith(
            voteLeaderStatus:
                const ErrorState(error: "Có lỗi xảy ra! Vui lòng thử lại")));
      }
    } catch (e) {
      emit(state.copyWith(voteLeaderStatus: ErrorState(error: e.toString())));
    } finally {
      emit(state.copyWith(voteLeaderStatus: const IdleState()));
    }
    emit(state.copyWith(voteLeaderStatus: const IdleState()));
  }

  Future<void> _onUpdateEventDeal(
      _UpdateEventDeal event, Emitter<DealDetailState> emit) async {
    try {
      emit(state.copyWith(updateEventStatus: const LoadingState()));
      final result = await DealDetailService.sendDealEvent(
        dealId: event.dealId,
        eventTypeId: event.eventTypeId,
      );
      if (result) {
        emit(state.copyWith(updateEventStatus: const SuccessState()));
      } else {
        emit(state.copyWith(
            updateEventStatus:
                const ErrorState(error: "Có lỗi xảy ra! Vui lòng thử lại")));
      }
    } catch (e) {
      emit(state.copyWith(updateEventStatus: ErrorState(error: e.toString())));
    } finally {
      emit(state.copyWith(updateEventStatus: const IdleState()));
    }
    emit(state.copyWith(updateEventStatus: const IdleState()));
  }

  Future<void> _onCloseDeal(
      _CloseDeal event, Emitter<DealDetailState> emit) async {
    try {
      emit(state.copyWith(closeDealStatus: const LoadingState()));
      final result = await DealDetailService.closeDeal(
        dealId: event.dealId,
      );
      if (result) {
        emit(state.copyWith(closeDealStatus: const SuccessState()));
      } else {
        emit(state.copyWith(
            closeDealStatus:
                const ErrorState(error: "Có lỗi xảy ra! Vui lòng thử lại")));
      }
    } catch (e) {
      emit(state.copyWith(closeDealStatus: ErrorState(error: e.toString())));
    } finally {
      emit(state.copyWith(closeDealStatus: const IdleState()));
    }
    emit(state.copyWith(closeDealStatus: const IdleState()));
  }

  Future<void> _onUpdatePayment(
      _UpdatePayment event, Emitter<DealDetailState> emit) async {
    try {
      emit(state.copyWith(updatePaymentStatus: const LoadingState()));
      final result = await DealDetailService.paymentStatus(
          dealId: event.dealId,
          allowcationId: event.allocationId,
          paymentStatusId: event.paymentStatusId);
      if (result) {
        emit(state.copyWith(updatePaymentStatus: const SuccessState()));
      } else {
        emit(state.copyWith(
            updatePaymentStatus:
                const ErrorState(error: "Có lỗi xảy ra! Vui lòng thử lại")));
      }
    } catch (e) {
      emit(
          state.copyWith(updatePaymentStatus: ErrorState(error: e.toString())));
    } finally {
      emit(state.copyWith(updatePaymentStatus: const IdleState()));
    }
    emit(state.copyWith(updatePaymentStatus: const IdleState()));
  }

  Future<void> _onReOpenDeal(
      _ReOpenDeal event, Emitter<DealDetailState> emit) async {
    try {
      emit(state.copyWith(reOpenStatus: const LoadingState()));
      final result = await DealDetailService.reOpenDeal(
          dealId: event.dealId,
          extendTimeInSecond: event.extendTimeInSecond,
          reason: event.reason);
      if (result) {
        emit(state.copyWith(reOpenStatus: const SuccessState()));
      } else {
        emit(state.copyWith(
            reOpenStatus:
                const ErrorState(error: "Có lỗi xảy ra! Vui lòng thử lại")));
      }
    } catch (e) {
      emit(state.copyWith(reOpenStatus: ErrorState(error: e.toString())));
    } finally {
      emit(state.copyWith(reOpenStatus: const IdleState()));
    }
    emit(state.copyWith(reOpenStatus: const IdleState()));
  }

  initial(String id) {
    add(DealDetailEvent.initial(id));
  }

  reject(String id, String mess) {
    add(DealDetailEvent.rejectDeal(id, mess));
  }

  approved(String id) {
    add(DealDetailEvent.approvedDeal(id));
  }

  assignAppraiser(String realEstateId, String valuationUnitId) {
    add(DealDetailEvent.assignAppraiser(realEstateId, valuationUnitId));
  }

  joinDeal(String dealId, String allocation, String payment) {
    add(DealDetailEvent.joinDeal(dealId, allocation, payment));
  }

  voteLeader(String dealId, String userId) {
    add(DealDetailEvent.voteLeaderDeal(dealId, userId));
  }

  updateEventDeal(String dealId, String eventId) {
    add(DealDetailEvent.updateEventDeal(dealId, eventId));
  }

  closeDeal(String dealId) {
    add(DealDetailEvent.closeDeal(dealId));
  }

  updatePayment(String dealId, String allocationId, String paymentStatusId) {
    add(DealDetailEvent.updatePayment(dealId, allocationId, paymentStatusId));
  }

  reOpenDeal(String dealId, int extendTimeInSecond, String reason) {
    add(DealDetailEvent.reOpenDeal(dealId, extendTimeInSecond, reason));
  }
}
