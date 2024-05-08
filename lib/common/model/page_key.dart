class PageKey {
  final int sessionId;
  final int page;

  const PageKey({
    required this.sessionId,
    required this.page,
  });
  PageKey increasePage() {
    return copyWith(page: page + 1);
  }

  PageKey copyWith({
    int? sessionId,
    int? page,
  }) {
    return PageKey(
      sessionId: sessionId ?? this.sessionId,
      page: page ?? this.page,
    );
  }
}
