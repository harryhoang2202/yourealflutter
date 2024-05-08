part of '../index.dart';

class NewsPopup extends StatelessWidget {
  const NewsPopup({
    Key? key,
    required this.item,
  }) : super(key: key);
  final News item;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomListTile(
          icon: "upload",
          onTap: () => _share(context),
          title: "Chia sẻ",
          padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 8.w),
        ),
        CustomListTile(
          icon: "copy",
          onTap: () => _copy(context),
          title: "Sao chép đường dẫn",
          padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 8.w),
        ),
        CustomListTile(
          icon: "browser",
          onTap: () {
            Utils.launchUrl(context, item.getLaunchableUrl());
            Navigator.pop(context);
          },
          title: "Mở với trình duyệt khác",
          padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 8.w),
        ),
        24.verSp,
        PrimaryButton(
          text: "Đóng",
          onTap: () => Navigator.pop(context),
        ),
        16.verSp,
      ],
    );
  }

  _copy(BuildContext context) {
    FlutterClipboard.copy(item.getLaunchableUrl());
    Navigator.pop(context);
    Utils.showInfoSnackBar(context, message: "Sao chép thành công");
  }

  void _share(BuildContext context) {
    Navigator.pop(context);
    Share.share(item.getLaunchableUrl());
  }
}
