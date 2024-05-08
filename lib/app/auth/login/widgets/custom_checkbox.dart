import 'package:flutter/material.dart';

const defaultIcon = Icon(
  Icons.check,
  color: Colors.white,
  size: 16,
);

class CustomCheckbox extends StatefulWidget {
  final bool isChecked;
  final double size;
  final Color checkedFillColor;
  final Color unCheckedBorderColor;
  final Widget? icon;
  final BorderRadius? borderRadius;
  final BoxShape shape;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Function(bool)? onChange;

  const CustomCheckbox({
    Key? key,
    required this.isChecked,
    this.size = 24,
    this.checkedFillColor = Colors.blue,
    this.icon = defaultIcon,
    this.unCheckedBorderColor = Colors.grey,
    this.borderRadius,
    this.onChange,
    this.shape = BoxShape.rectangle,
    this.margin = const EdgeInsets.all(4),
    this.padding = const EdgeInsets.all(0),
  }) : super(key: key);

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isSelected = widget.isChecked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onChange != null
          ? () {
              setState(() {
                _isSelected = !_isSelected;
              });
              widget.onChange!(_isSelected);
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linearToEaseOut,
        margin: widget.margin,
        padding: widget.padding,
        decoration: BoxDecoration(
          color:
              widget.isChecked ? widget.checkedFillColor : Colors.transparent,
          shape: widget.shape,
          borderRadius: widget.shape == BoxShape.circle
              ? null
              : widget.borderRadius ?? BorderRadius.circular(4),
          border: Border.all(
            color: widget.unCheckedBorderColor,
            width: 2.0,
          ),
        ),
        width: widget.size,
        height: widget.size,
        constraints: BoxConstraints(
          minHeight: widget.size,
          maxWidth: widget.size,
          minWidth: widget.size,
          maxHeight: widget.size,
        ),
        child: widget.isChecked ? Center(child: widget.icon) : null,
      ),
    );
  }
}
