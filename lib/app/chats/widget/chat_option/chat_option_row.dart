import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:tvt_gallery/tvt_gallery.dart';
import 'package:youreal/app/chats/blocs/chat_input_bloc/chat_input_bloc.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/tools.dart';

class ChatOptionRow extends StatefulWidget {
  const ChatOptionRow({Key? key}) : super(key: key);

  @override
  State<ChatOptionRow> createState() => _ChatOptionRowState();
}

class _ChatOptionRowState extends State<ChatOptionRow> {
  @override
  void didChangeDependencies() {
    _inputBloc = context.read<ChatInputBloc>();

    super.didChangeDependencies();
  }

  late ChatInputBloc _inputBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatInputBloc, ChatInputState>(
      builder: (context, state) {
        late final List<Widget> icons;
        if (state.isTextFieldExpanded) {
          icons = [
            RotatedBox(
              quarterTurns: 2,
              child: ChatOptionIcon(
                onTap: () {
                  _inputBloc
                      .add(ChatInputOptionChanged(InputOption.Idle, context));
                  _inputBloc
                      .add(const ChatInputTextFieldExpandedChanged(false));
                },
                iconName: "ic_left_arrow",
              ),
            ),
          ];
        } else {
          icons = [
            ChatOptionIcon(
              onTap: () {
                Utils.hideKeyboard(context);

                _inputBloc
                    .add(ChatInputOptionChanged(InputOption.Camera, context));
              },
              enable: state.inputOption == InputOption.Camera ||
                  state.inputOption == InputOption.Idle,
              iconName: "ic_camera",
            ),
            GalleryViewField(
              controller: _inputBloc.galleryPickerController,
              child: ChatOptionIcon(
                onTap: () {
                  _inputBloc.add(
                      ChatInputOptionChanged(InputOption.Picture, context));
                },
                enable: state.inputOption == InputOption.Picture ||
                    state.inputOption == InputOption.Idle,
                iconName: "ic_picture",
              ),
            ),
          ];
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 24.w,
              child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) => icons[index],
                  separatorBuilder: (_, __) => SizedBox(
                        width: 16.w,
                      ),
                  itemCount: icons.length),
            )
          ],
        );
      },
    );
  }
}

class ChatOptionIcon extends StatelessWidget {
  const ChatOptionIcon({
    Key? key,
    required this.iconName,
    this.onTap,
    this.size,
    this.splashRadius,
    this.enable = true,
    this.onTapUp,
    this.onTapDown,
    this.onTapCancel,
  }) : super(key: key);
  final String iconName;
  final GestureTapCallback? onTap;
  final Size? size;
  final double? splashRadius;
  final bool enable;
  final GestureTapUpCallback? onTapUp;
  final GestureTapDownCallback? onTapDown;
  final GestureTapCancelCallback? onTapCancel;
  @override
  Widget build(BuildContext context) {
    final child = SizedBox.fromSize(
      size: size ?? Size(24.w, 24.w),
      child: SvgPicture.asset(
        "assets/icons/$iconName.svg",
        color: enable ? yrColorLight : yrColorSecondary,
      ),
    );

    late final Widget result;
    if (onTapUp != null) {
      result = GestureDetector(
        onTapUp: onTapUp,
        onTapDown: onTapDown,
        onTapCancel: onTapCancel,
        child: child,
      );
    } else {
      result = InkResponse(
        onTap: onTap ?? () {},
        radius: splashRadius ?? 18.w,
        child: child,
      );
    }
    return result;
  }
}
