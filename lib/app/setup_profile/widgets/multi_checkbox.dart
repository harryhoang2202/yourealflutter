import 'package:flutter/material.dart';
import 'package:youreal/app/auth/login/widgets/custom_checkbox.dart';

class MultiCheckbox<T> extends StatefulWidget {
  const MultiCheckbox({
    Key? key,
    required this.items,
    required this.onCheckChanged,
    this.scrollDirection = Axis.vertical,
    required this.crossAxisCount,
    this.checkedFillColor = Colors.blue,
    this.unCheckedBorderColor = Colors.grey,
    this.haveCheckIcon = true,
    this.icon,
    this.shape = BoxShape.rectangle,
    this.titleMaxLines = 2,
    this.mainAxisExtent = 50,
    this.mainAxisSpacing = 10,
    this.crossAxisSpacing = 5,
    this.margin = const EdgeInsets.all(4),
    this.padding = const EdgeInsets.all(4),
    this.size = 24,
    this.borderRadius,
    this.style,
    this.shrinkWrap = false,
    this.scrollPhysics,
  }) : super(key: key);
  final List<CheckBoxState<T>> items;
  final Color checkedFillColor;
  final Color unCheckedBorderColor;
  final Widget? icon;
  final bool haveCheckIcon;
  final BoxShape shape;
  final int titleMaxLines;
  final void Function(List<T> selectedItems) onCheckChanged;
  final int crossAxisCount;
  final double mainAxisExtent;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final Axis scrollDirection;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double size;
  final BorderRadius? borderRadius;
  final TextStyle? style;
  final bool shrinkWrap;
  final ScrollPhysics? scrollPhysics;
  @override
  _MultiCheckboxState<T> createState() => _MultiCheckboxState<T>();
}

class CheckBoxState<T> {
  final String title;
  bool isChecked;
  final T value;

  CheckBoxState(
      {required this.title, this.isChecked = false, required this.value});
}

class _MultiCheckboxState<T> extends State<MultiCheckbox<T>> {
  List<CheckBoxState<T>> items = [];

  @override
  void initState() {
    super.initState();
    items = widget.items;
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      physics: widget.scrollPhysics,
      padding: EdgeInsets.zero,
      shrinkWrap: widget.shrinkWrap,
      scrollDirection: widget.scrollDirection,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        mainAxisSpacing: widget.mainAxisSpacing,
        mainAxisExtent: widget.mainAxisExtent,
        crossAxisSpacing: widget.crossAxisSpacing,
      ),
      children: items.map(_buildCheckBox).toList(),
    );
  }

  Widget _buildCheckBox(CheckBoxState checkBox) {
    return InkWell(
      onTap: () {
        setState(
          () {
            checkBox.isChecked = !checkBox.isChecked;
            final selectedItems = items
                .where((element) => element.isChecked == true)
                .map((e) => e.value)
                .toList();
            widget.onCheckChanged(selectedItems);
          },
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              unselectedWidgetColor: widget.unCheckedBorderColor,
            ),
            child: CustomCheckbox(
              margin: widget.margin,
              padding: widget.padding,
              unCheckedBorderColor: widget.unCheckedBorderColor,
              checkedFillColor: widget.checkedFillColor,
              size: widget.size,
              shape: widget.shape,
              isChecked: checkBox.isChecked,
              icon:
                  widget.haveCheckIcon ? widget.icon : const SizedBox.shrink(),
              borderRadius: widget.borderRadius,
            ),
          ),
          Expanded(
            child: Text(
              checkBox.title,
              maxLines: widget.titleMaxLines,
              overflow: TextOverflow.ellipsis,
              style: widget.style,
            ),
          ),
        ],
      ),
    );
  }
}
