import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signature/signature.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/tools.dart';

class CreateSignatureScreen extends StatefulWidget {
  static const id = "CreateSignatureScreen";
  final Function(dynamic) onSigned;
  const CreateSignatureScreen({Key? key, required this.onSigned})
      : super(key: key);

  @override
  _CreateSignatureScreenState createState() => _CreateSignatureScreenState();
}

class _CreateSignatureScreenState extends State<CreateSignatureScreen> {
  late SignatureController controller;

  @override
  void initState() {
    super.initState();

    controller = SignatureController(
      penStrokeWidth: 5.w,
      penColor: Colors.black,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "Ký tên",
            style: kText24_Primary,
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: yrColorPrimary,
            ),
            onPressed: (() {
              Navigator.pop(context);
            }),
          ),
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Signature(
              controller: controller,
              backgroundColor: Colors.white,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                buildButtons(context),
                // buildSwapOrientation(),
                32.h.verticalSpace
              ],
            )
          ],
        ),
      );

  Widget buildSwapOrientation() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final newOrientation =
            isPortrait ? Orientation.landscape : Orientation.portrait;

        controller.clear();
        Utils.setOrientation(newOrientation);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPortrait
                  ? Icons.screen_lock_portrait
                  : Icons.screen_lock_landscape,
              size: 32.w,
              color: yrColorPrimary,
            ),
            SizedBox(width: 8.w),
            Text(
              'Tap to change signature orientation',
              style: kText18Weight500_Primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtons(BuildContext context) => Container(
        color: yrColorLight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildCheck(context),
            buildClear(),
          ],
        ),
      );

  Widget buildCheck(BuildContext context) => IconButton(
        iconSize: 32.w,
        icon: const Icon(Icons.check, color: yrColorSuccess),
        onPressed: () async {
          if (controller.isNotEmpty) {
            final signature = await exportSignature();
            widget.onSigned(signature);

            controller.clear();
            Navigator.pop(context);
          }
        },
      );

  Widget buildClear() => IconButton(
        iconSize: 32.w,
        icon: const Icon(Icons.clear, color: yrColorError),
        onPressed: () => controller.clear(),
      );

  Future<Uint8List> exportSignature() async {
    final exportController = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
      points: controller.points,
    );

    final signature = await exportController.toPngBytes();
    exportController.dispose();

    return signature!;
  }
}
