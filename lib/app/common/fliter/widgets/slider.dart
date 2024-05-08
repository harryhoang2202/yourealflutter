part of '../index.dart';

class CustomSlider1 extends StatefulWidget {
  final double valueMin;
  final double valueMax;
  final double valueLower;
  final double valueUpper;
  final double? step;
  final Function(double, double)? valueChange;

  const CustomSlider1({
    Key? key,
    required this.valueMin,
    required this.valueMax,
    required this.valueLower,
    required this.valueUpper,
    this.step,
    this.valueChange,
  }) : super(key: key);

  @override
  _CustomSlider1State createState() => _CustomSlider1State();
}

class _CustomSlider1State extends State<CustomSlider1> {
  @override
  Widget build(BuildContext context) {
    return FlutterSlider(
      handlerHeight: 24.w,
      handlerWidth: 24.w,
      values: [widget.valueLower, widget.valueUpper],
      rangeSlider: true,
      trackBar: FlutterSliderTrackBar(
        activeTrackBar: BoxDecoration(
            color: yrColorAccent, borderRadius: BorderRadius.circular(16.r)),
        activeTrackBarHeight: 10.h,
        inactiveTrackBarHeight: 10.h,
        inactiveTrackBar: BoxDecoration(
            color: yrColorLight, borderRadius: BorderRadius.circular(16.r)),
      ),
      onDragCompleted: (a, lowerValue, upperValue) {
        widget.valueChange!(lowerValue, upperValue);
      },
      step: FlutterSliderStep(step: widget.step ?? 1000000),
      tooltip: FlutterSliderTooltip(
        custom: (value) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (value == 0)
                    SizedBox(
                      width: 30.w,
                    ),
                  Container(
                    height: 30.h,
                    padding:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 5.w),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: yrColorLight,
                        borderRadius: BorderRadius.circular(4.w)),
                    child: Text(
                      "${Tools().convertMoneyToSymbolMoney(value.toString())} VNĐ",
                      style: kText12_Primary.copyWith(fontSize: 10.h),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(
                  left: value == 0 ? 20.w : 0,
                ),
                child: ClipPath(
                  clipper: TriangleClipper(),
                  child: Container(
                    color: yrColorLight,
                    height: 8.h,
                    width: 16.w,
                  ),
                ),
              )
            ],
          );
        },
        alwaysShowTooltip: true,
        direction: FlutterSliderTooltipDirection.left,
        positionOffset: FlutterSliderTooltipPositionOffset(
          top: -60.h,
          left: -18.h,
        ),
      ),
      rightHandler: FlutterSliderHandler(
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: yrColorAccent,
          ),
          width: 24.w,
          height: 24.w,
        ),
      ),
      handler: FlutterSliderHandler(
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: yrColorAccent,
          ),
        ),
      ),
      max: widget.valueMax,
      min: widget.valueMin,
    );
  }
}

class CustomSlider2 extends StatelessWidget {
  final double valueMax;
  final double value;
  final bool viewOnly;

  const CustomSlider2(
      {Key? key,
      required this.valueMax,
      required this.value,
      this.viewOnly = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
          children: [
            FlutterSlider(
              values: [value],
              rangeSlider: false,
              trackBar: FlutterSliderTrackBar(
                activeTrackBarHeight: 15.h,
                inactiveTrackBarHeight: 15.h,
                activeTrackBar: BoxDecoration(
                    color: yrColorAccent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.h),
                      bottomLeft: Radius.circular(16.h),
                    )),
                inactiveTrackBar: BoxDecoration(
                    color: yrColorLight,
                    borderRadius: BorderRadius.circular(16.h)),
              ),
              tooltip: FlutterSliderTooltip(
                textStyle: kText14_Primary,
                custom: (value) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          if (value == 0)
                            SizedBox(
                              width: 30.w,
                            ),
                          Container(
                            height: 30.h,
                            padding: EdgeInsets.symmetric(
                                vertical: 8.h, horizontal: 5.w),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: yrColorLight,
                                borderRadius: BorderRadius.circular(4.w)),
                            child: Text(
                              "${Tools().convertMoneyToSymbolMoney(value.toString())} VNĐ",
                              style: kText12_Primary.copyWith(fontSize: 10.h),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: value == 0 ? 20.w : 0,
                        ),
                        child: ClipPath(
                          clipper: TriangleClipper(),
                          child: Container(
                            color: yrColorLight,
                            height: 8.h,
                            width: 16.w,
                          ),
                        ),
                      )
                    ],
                  );
                },
                direction: FlutterSliderTooltipDirection.left,
                positionOffset:
                    FlutterSliderTooltipPositionOffset(top: -60.h, left: -18.w),
                alwaysShowTooltip: true,
              ),
              handlerHeight: 24.h,
              handlerWidth: 24.h,
              handler: FlutterSliderHandler(
                disabled: true,
                child: Container(
                  height: 24.h,
                  width: 24.h,
                  decoration: BoxDecoration(
                      color: yrColorAccent,
                      borderRadius: BorderRadius.circular(16.h)),
                ),
              ),
              max: valueMax,
              min: 0,
            ),
            if (viewOnly)
              Container(
                height: 80.h,
                width: screenWidth,
                color: Colors.transparent,
              ),
          ],
        ),
        Column(
          children: [
            SizedBox(
              height: 50.h,
            ),
            Container(
              height: 20.h,
              padding: EdgeInsets.only(left: 15.w, right: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "0 VNĐ",
                    style: kText14Weight400_Light,
                  ),
                  Text(
                    "${Tools().convertMoneyToSymbolMoney(valueMax.toString())} VNĐ",
                    style: kText14Weight400_Light,
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
