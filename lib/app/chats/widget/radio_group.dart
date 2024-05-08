import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/chats/blocs/chat_detail_bloc/chat_detail_bloc.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

import 'custom_radio.dart';

class RadioGroup<T> extends StatefulWidget {
  const RadioGroup({
    Key? key,
    required this.items,
    required this.onCheckChanged,
    this.checkedFillColor = Colors.blue,
    this.unCheckedBorderColor = Colors.grey,
    this.haveCheckIcon = true,
    this.icon,
    this.shape = BoxShape.rectangle,
    this.titleMaxLines = 2,
    this.margin = const EdgeInsets.all(4),
    this.padding = const EdgeInsets.all(2),
    this.size = 24,
    this.borderRadius,
    this.style,
    this.centerSpace = 8,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.separator,
  }) : super(key: key);
  final List<RadioState<T>> items;
  final Color checkedFillColor;
  final Color unCheckedBorderColor;
  final Widget? icon;
  final bool haveCheckIcon;
  final BoxShape shape;
  final int titleMaxLines;
  final void Function(T selectedItems) onCheckChanged;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double size;
  final BorderRadius? borderRadius;
  final TextStyle? style;
  final double centerSpace;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final Widget? separator;

  @override
  _RadioGroupState<T> createState() => _RadioGroupState<T>();
}

class RadioState<T> {
  final String title;
  final T value;

  RadioState({required this.title, required this.value});
}

class _RadioGroupState<T> extends State<RadioGroup<T>> {
  List<RadioState> items = [];

  T? groupValue;

  @override
  void initState() {
    super.initState();
    items = widget.items;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, i) => _buildCheckBox(items[i]),
      separatorBuilder: (_, __) => widget.separator ?? const SizedBox.shrink(),
      itemCount: items.length,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
    );
  }

  Widget _buildCheckBox(RadioState radio) {
    return Row(
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: widget.unCheckedBorderColor,
          ),
          child: CustomRadio<T>(
            margin: widget.margin,
            padding: widget.padding,
            unCheckedBorderColor: widget.unCheckedBorderColor,
            checkedFillColor: widget.checkedFillColor,
            size: widget.size,
            shape: widget.shape,
            value: radio.value,
            groupValue: groupValue,
            icon: widget.haveCheckIcon ? widget.icon : const SizedBox.shrink(),
            borderRadius:
                widget.shape == BoxShape.rectangle ? widget.borderRadius : null,
            onChanged: (T value) => setState(
              () {
                groupValue = value;
                widget.onCheckChanged(value);
              },
            ),
          ),
        ),
        SizedBox(
          width: widget.centerSpace,
        ),
        Text(
          radio.title,
          maxLines: widget.titleMaxLines,
          overflow: TextOverflow.ellipsis,
          style: widget.style,
        ),
        if (T.toString() == "ChatVoteLeaderItem")
          Flexible(
            child: SizedBox(
              height: 16.w,
              child: DealLeaderVoters(),
            ),
          ),
      ],
    );
  }
}

class DealLeaderVoters extends StatelessWidget {
  DealLeaderVoters({Key? key}) : super(key: key);

  final images = [
    ChatDetailBloc.testImage,
    ChatDetailBloc.testImage,
    ChatDetailBloc.testImage,
    ChatDetailBloc.testImage,
    ChatDetailBloc.testImage,
    ChatDetailBloc.testImage,
  ];

  @override
  Widget build(BuildContext context) {
    int startingRight = images.length > 2 ? 13 : 0;
    //extract the first 2 images
    late final List<String> extractedImage;
    if (images.length > 2) {
      extractedImage = images.sublist(0, 2);
    } else {
      extractedImage = images;
    }
    return Stack(
      fit: StackFit.loose,
      alignment: Alignment.centerRight,
      children: [
        if (images.length > 2)
          Positioned(
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: yrColorSecondary,
                borderRadius: BorderRadius.circular(8.r),
              ),
              alignment: Alignment.centerRight,
              padding: EdgeInsets.fromLTRB(8.w, 2.5.h, 4.w, 2.5.h),
              child: Text(
                "+${images.length - 2}",
                style: kText8Weight400_Light,
              ),
            ),
          ),
        ...extractedImage
            .asMap()
            .map((i, e) => MapEntry(
                  i,
                  Positioned(
                    right:
                        i == 0 ? startingRight.w : (i * 10 + startingRight).w,
                    child: CachedNetworkImage(
                      imageUrl: e,
                      imageBuilder: (context, image) {
                        return CircleAvatar(
                          radius: 15.w,
                          backgroundColor: yrColorSecondary,
                          child: SizedBox.fromSize(
                            size: Size(14.w, 14.w),
                            child: CircleAvatar(
                              radius: 14.w,
                              backgroundImage: image,
                            ),
                          ),
                        );
                      },
                      width: 15.w,
                      height: 15.w,
                    ),
                  ),
                ))
            .values
            .toList()
      ],
    );
  }
}
