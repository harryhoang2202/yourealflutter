import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youreal/app/chats/blocs/heart_cubit/heart_cubit.dart';

import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/common/tools.dart';
import 'package:youreal/view_models/app_model.dart';

import 'chat_item.dart';

class HeartWidget extends StatefulWidget {
  const HeartWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<HeartWidget> createState() => _HeartWidgetState();
}

class _HeartWidgetState extends State<HeartWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _heartController = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
    reverseDuration: const Duration(milliseconds: 500),
  );
  late final Animation<double> _heartAnimation = CurvedAnimation(
    parent: _heartController,
    curve: Curves.easeInOutQuad,
  );

  double height = 0;
  _startAnimation() async {
    setState(() {
      height = kHeartMessageMaxHeight;
    });
    _heartController.forward();
  }

  _stopAnimation() async {
    await _heartController.reverse();
    setState(() {
      height = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HeartCubit, HeartState>(
      listener: (context, state) {
        if (state is HeartForwardingAnimation) {
          _startAnimation();
        } else if (state is HeartReversingAnimation) {
          state.scaleCallback(_heartController.value);
          _stopAnimation();
        }
      },
      builder: (context, state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: height,
          padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ScaleTransition(
                scale: _heartAnimation,
                alignment: Alignment.bottomRight,
                child: SvgPicture.asset(
                  getIcon("ic_heart.svg"),
                  width: kHeartMessageMaxHeight.w,
                  height: kHeartMessageMaxHeight.w,
                  color: yrColorError,
                ),
              ),
              SizedBox(
                width: 8.w,
              ),
              ChatAvatar(
                imageUrl: context.read<AppModel>().user.picture ?? "",
                status: true,
              ),
            ],
          ),
        );
      },
    );
  }
}
