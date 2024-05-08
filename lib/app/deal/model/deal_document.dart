import 'package:equatable/equatable.dart';
import 'package:youreal/common/constants/general.dart';

class DealDocument extends Equatable {
  final List<String> imagePathOrUrls;
  final List<String> filePathOrUrls;

  const DealDocument({
    this.imagePathOrUrls = const [],
    this.filePathOrUrls = const [],
  });

  bool get isEmpty {
    return imagePathOrUrls.isEmpty && filePathOrUrls.isEmpty;
  }

  factory DealDocument.fromAPI(String? imagesAndFiles) {
    final images = <String>[];
    final files = <String>[];
    if (imagesAndFiles != null) {
      final splitString = imagesAndFiles.split(",");
      for (final path in splitString) {
        final temp = path.split(".");
        if (temp.isNotEmpty) {
          final fileExt = temp.last;
          if (kSupportFileTypes.contains(fileExt)) {
            files.add(path);
          } else if (kSupportImageTypes.contains(fileExt)) {
            images.add(path);
          }
        }
      }
    }
    return DealDocument(imagePathOrUrls: images, filePathOrUrls: files);
  }

  @override
  List<Object?> get props => [imagePathOrUrls, filePathOrUrls];

  DealDocument copyWith({
    List<String>? imagePathOrUrls,
    List<String>? filePathOrUrls,
  }) {
    return DealDocument(
      imagePathOrUrls: imagePathOrUrls ?? this.imagePathOrUrls,
      filePathOrUrls: filePathOrUrls ?? this.filePathOrUrls,
    );
  }
}
