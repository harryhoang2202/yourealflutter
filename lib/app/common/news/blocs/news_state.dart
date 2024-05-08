part of 'news_cubit.dart';

@freezed
class NewsState with _$NewsState {
  const NewsState._();

  const factory NewsState({
    required List<News> hotNews,
    required List<News> otherNews,
    required bool isLoading,
  }) = _NewsState;

  factory NewsState.initial() =>
      const NewsState(hotNews: [], otherNews: [], isLoading: false);
}
