part of 'deal_document_bloc.dart';

@freezed
class DealDocumentEvent with _$DealDocumentEvent {
  const factory DealDocumentEvent.ownerDocTypeChanged(DealDocumentType type) =
      DealDocumentOwnerDocTypeChanged;

  const factory DealDocumentEvent.realEstateDocTypeChanged(
      DealDocumentType type) = DealDocumentRealEstateDocTypeChanged;
}
