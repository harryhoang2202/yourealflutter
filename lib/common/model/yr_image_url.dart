import 'package:equatable/equatable.dart';

class YrImageUrl extends Equatable {
  final String url;
  final String previewUrl;

  const YrImageUrl({
    required this.url,
    required this.previewUrl,
  });

  YrImageUrl copyWith({
    String? url,
    String? previewUrl,
  }) {
    return YrImageUrl(
      url: url ?? this.url,
      previewUrl: previewUrl ?? this.previewUrl,
    );
  }

  @override
  List<Object?> get props => [url];
}
