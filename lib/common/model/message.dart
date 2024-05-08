import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/services/domain/auth/models/user.dart';

class Message {
  late int dealId;
  late User userSend;
  late DateTime sendTime;
  late String content;
  late List<String> images;
  late int id;
  Message({
    required this.dealId,
    required this.userSend,
    required this.sendTime,
    required this.content,
    required this.images,
    required this.id,
  });
  String get hhmmSendTime =>
      '${sendTime.hour.toString().padLeft(2, '0')}:${sendTime.minute.toString().padLeft(2, '0')}';

  Message.fromJson(Map<String, dynamic> json, {int? dealId}) {
    this.dealId = dealId ?? int.parse(json['dealId'].toString());
    userSend = (json['user'] != null
        ? User.fromJson(json['user']).copyWith(userId: json["user"]["id"])
        : null)!;
    sendTime = DateTime.parse(json['createdTime']);
    content = json['content'] ?? '';
    id = json["id"];
    //check if content is image
    if (json['content'] == null) {
      images = [];
    } else {
      final rawContent = json['content'].toString();
      final splattedByComa = rawContent.split(",");
      final imageUrls = <String>[];
      bool isImages = true;
      for (final item in splattedByComa) {
        if (item.isImageUrl) {
          imageUrls.add(item);
        } else {
          isImages = false;
          break;
        }
      }
      if (isImages) {
        images = imageUrls;
        content = '';
      } else {
        images = [];
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dealId'] = dealId;
    data['userSend'] = userSend.toJson();
    data['sendTime'] = sendTime.toString();
    data['content'] = content;
    data['images'] = images;
    return data;
  }

  @override
  String toString() {
    return 'Message{dealId: $dealId, userSend: $userSend, sendTime: $sendTime, content: $content, images: $images, id: $id}';
  }
}
