import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/tools.dart';

class FileItem extends StatefulWidget {
  const FileItem({
    Key? key,
    required this.url,
    required this.username,
  }) : super(key: key);

  final String url;
  final String username;

  @override
  State<FileItem> createState() => _FileItemState();
}

class _FileItemState extends State<FileItem> {
  bool isDownloading = false;

  _toggleLoading(bool value) => setState(() {
        isDownloading = value;
      });

  late Future<double?> fileSizeFuture;
  @override
  void initState() {
    super.initState();
    fileSizeFuture = Utils.getFileSize(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (isDownloading) {
          return;
        }
        double? size = await fileSizeFuture;
        await Utils.openFile(
          context,
          pathOrUrl: widget.url,
          showLoading: () {
            _toggleLoading(true);
          },
          hideLoading: () {
            _toggleLoading(false);
          },
          size: size,
        );
      },
      child: Row(
        children: [
          Utils.icFromFile(widget.url, size: 35.w),
          SizedBox(width: 8.w),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.url.split("/").last,
                style: kText14Weight400_Dark,
              ),
              FutureBuilder(
                future: fileSizeFuture,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      if (snapshot.hasData && snapshot.data != null) {
                        double fileSize = snapshot.data!;
                        String unit = "KB";
                        if (fileSize > 1024) {
                          unit = "MB";
                          fileSize /= 1024;
                        }
                        return Text(
                          "${fileSize.toStringAsFixed(1)} $unit - ${widget.username}",
                          style: kText14Weight400_Dark,
                        );
                      }
                      return Text(
                        widget.username,
                        style: kText14Weight400_Dark,
                      );
                    default:
                      return Row(
                        children: [
                          SizedBox.fromSize(
                            size: Size(12.w, 12.w),
                            child: const CircularProgressIndicator.adaptive(
                              backgroundColor: yrColorPrimary,
                              strokeWidth: 2,
                            ),
                          ),
                          Text(
                            " - ${widget.username}",
                            style: kText14Weight400_Dark,
                          ),
                        ],
                      );
                  }
                },
              ),
            ],
          ),
          const Spacer(),
          AnimatedOpacity(
            opacity: isDownloading ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: SizedBox.fromSize(
              size: Size(24.w, 24.w),
              child: const CircularProgressIndicator.adaptive(
                backgroundColor: yrColorPrimary,
                strokeWidth: 3,
              ),
            ),
          ),
          8.horSp,
        ],
      ),
    );
  }
}
