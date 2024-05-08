import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/app/deal/model/deal_document.dart';
import 'package:youreal/common/constants/enums.dart';

part 'deal_document_bloc.freezed.dart';
part 'deal_document_event.dart';
part 'deal_document_state.dart';

class DealDocumentBloc extends Bloc<DealDocumentEvent, DealDocumentState> {
  DealDocumentBloc(Deal deal) : super(DealDocumentState.initial(deal)) {
    _mapEventToState();
  }

  void _mapEventToState() {
    on<DealDocumentOwnerDocTypeChanged>((event, emit) {
      emit(state.copyWith(ownerDocType: event.type));
    });
    on<DealDocumentRealEstateDocTypeChanged>((event, emit) {
      emit(state.copyWith(realDocType: event.type));
    });
  }
}
