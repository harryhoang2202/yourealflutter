import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youreal/app/notification/models/yr_notification.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/tools.dart';

class NotificationItem extends StatefulWidget {
  const NotificationItem({
    Key? key,
    required this.item,
    required this.onSeen,
    required this.onTap,
  }) : super(key: key);

  final YrNotification item;
  final Future<bool> Function(String id) onSeen;
  final Future Function() onTap;
  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  late bool isSeen;
  bool dismissed = false;
  @override
  void initState() {
    super.initState();
    isSeen = widget.item.isSeen;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          widget.onSeen(widget.item.id);
          Future.delayed(const Duration(milliseconds: 300)).then((value) {
            if (mounted) {
              setState(() {
                isSeen = true;
              });
            }
          });
        } else if (direction == DismissDirection.endToStart) {}
        return Future.value(false);
      },
      background: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.w),
          color: yrColorSuccess,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: 56.w,
          child: Text(
            "Đánh dấu đã xem",
            style: kText14Weight400_Light,
          ),
        ),
      ),
      // secondaryBackground: Container(
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(8.w),
      //     color: yrColorAccent,
      //   ),
      //   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      //   child: SizedBox(
      //     width: 56.w,
      //     child: Text(
      //       "Xóa thông báo",
      //       style: kText14Weight400_Light,
      //       textDirection: TextDirection.rtl,
      //     ),
      //   ),
      //   alignment: Alignment.centerRight,
      // ),
      child: Material(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.w),
        ),
        color: isSeen ? Colors.grey[400] : yrColorLight,
        child: InkWell(
          onTap: () async {
            final seen = await widget.onTap();
            if (seen) {
              setState(() {
                isSeen = true;
              });
            }
          },
          child: Container(
            padding: EdgeInsets.all(8.w),
            constraints: BoxConstraints(
              minHeight: 80.h,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 48.w,
                  child: SvgPicture.asset(
                    getIcon(getNotificationIcon()),
                    height: 32.w,
                    color: yrColorPrimary,
                    width: 32.w,
                  ),
                ),
                8.horSp,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.item.message,
                        style: kText18Weight400_Primary,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Text(
                        Utils.getDuration(
                            widget.item.createdTime ?? DateTime.now()),
                        style: kText14Weight400_Primary,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getNotificationIcon() {
    switch (widget.item.notificationType) {
      case NotificationType.newNotification:
        return "ic_notification.svg";
      case NotificationType.investorClosed:
        return "ic_people1.svg";
      case NotificationType.representativeChosen:
        return "ic_role.svg";
      case NotificationType.newMessage:
        return "ic_chat.svg";
      case NotificationType.newDeal:
        return "ic_bulb.svg";
      case NotificationType.dealAppraised:
        return "ic_file_check.svg";
      case NotificationType.newAppraisalRequest:
        return "ic_new_request.svg";
      case NotificationType.contractSigned:
        return "ic_new_request.svg";
      default:
        return "ic_notification.svg";
    }
  }
}
