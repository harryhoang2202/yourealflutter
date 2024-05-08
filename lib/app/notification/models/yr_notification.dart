import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/tools.dart';

class YrNotification {
  final String id;
  final NotificationType notificationType;
  final NotificationTargetType? targetType;
  final int? targetId;
  final String? userReceivedMessage;
  final String? mess;
  final DateTime? createdTime;

  final bool isSeen;
  const YrNotification({
    required this.id,
    required this.notificationType,
    required this.targetType,
    required this.targetId,
    this.userReceivedMessage,
    required this.mess,
    required this.createdTime,
    this.isSeen = false,
  });
  String get message {
    switch (notificationType) {
      case NotificationType.newNotification:
        return "Bạn có tin nhắn mới";
      case NotificationType.investorClosed:
        return "Deal #$targetId đã chốt danh sách nhà đầu tư";
      case NotificationType.representativeChosen:
        return "${mess == null ? "Đã chọn" : "User $mess là"} người đại diện Deal #$targetId";
      case NotificationType.newMessage:
        return "Bạn có tin nhắn mới từ Deal #$targetId";
      case NotificationType.newDeal:
        return "Bạn có deal đề xuất mới";
      case NotificationType.dealAppraised:
        return "Deal #$targetId đã được thẩm định xong";
      case NotificationType.newAppraisalRequest:
        return "Bạn được yêu cầu thẩm định Deal #$targetId";
      case NotificationType.totallyPaid:
        return "Deal #$targetId đã thanh toán toàn bộ cho người bán";
      case NotificationType.changeOwner:
        return "Đã thực hiện trước bạ sang tên cho Deal #$targetId";
      case NotificationType.contractSigned:
        return "Deal #$targetId đã ký hợp đồng mua tài sản với người bán và tiến hành đặt cọc";
      default:
        return "Bạn có thông báo mới";
    }
  }

  int get jumpToNavBarIndex {
    switch (notificationType) {
      case NotificationType.newDeal:
      case NotificationType.investorClosed:
      case NotificationType.dealAppraised:
      case NotificationType.newAppraisalRequest:
      case NotificationType.representativeChosen:
        return 0;
      case NotificationType.newMessage:
        return 1;
      default:
        return 0;
    }
  }

  factory YrNotification.fromJson(Map<String, dynamic> json) {
    return YrNotification(
      id: json['id'] != null ? json['id'].toString() : "-1",
      notificationType: json['notificationTypeId'] != null
          ? NotificationType
              .values[int.parse(json['notificationTypeId'].toString())]
          : NotificationType.none,
      targetType: json['notificationTargetTypeId'] != null
          ? NotificationTargetType
              .values[int.parse(json['notificationTargetTypeId'].toString())]
          : NotificationTargetType.Deal,
      targetId: json['targetId'] ?? "-1",
      mess: json['additionalInfo'],
      createdTime: json['createdTime'] != null
          ? Utils.dateFromJson(json['createdTime'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['notificationTypeId'] = notificationType.index;
    data['notificationTargetTypeId'] = targetType?.index;
    data['targetId'] = targetId;
    data['additionalInfo'] = mess;
    data['createdTime'] = createdTime?.toString();
    return data;
  }
}
