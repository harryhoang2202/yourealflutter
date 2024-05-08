import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'news.freezed.dart';

part 'news.g.dart';

@freezed
class News with _$News {
  const News._();

  @JsonSerializable(explicitToJson: true)
  const factory News({
    required String id,
    required String sourceNewsId,
    required Thumbnail thumbnail,
    required Vi vi,
    required List<String> tags,
    required int publishedTime,
    required String slugUrl,
  }) = _News;

  String getCreatedDate() {
    final date = DateTime.fromMillisecondsSinceEpoch(publishedTime * 1000);
    final df = DateFormat("EEEE, dd/MM/yyyy");
    return df.format(date);
  }

  String getLaunchableUrl() {
    return "https://youtrade.vn/news/detail/$slugUrl";
  }

  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);
}

@freezed
class Thumbnail with _$Thumbnail {
  @JsonSerializable(explicitToJson: true)
  const factory Thumbnail({
    required String displayName,
    required String filename,
  }) = _Thumbnail;

  factory Thumbnail.fromJson(Map<String, dynamic> json) =>
      _$ThumbnailFromJson(json);
}

@freezed
class Vi with _$Vi {
  @JsonSerializable(explicitToJson: true)
  const factory Vi({
    required String title,
    required String? description,
    List<AttachedDocument>? attachedDocument,
    String? content,
  }) = _Vi;

  factory Vi.fromJson(Map<String, dynamic> json) => _$ViFromJson(json);
}

@freezed
class AttachedDocument with _$AttachedDocument {
  @JsonSerializable(explicitToJson: true)
  const factory AttachedDocument({
    required String displayName,
    required String filename,
  }) = _AttachedDocument;

  factory AttachedDocument.fromJson(Map<String, dynamic> json) =>
      _$AttachedDocumentFromJson(json);
}
