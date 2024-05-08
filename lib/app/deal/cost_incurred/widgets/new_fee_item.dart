import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/app/deal/create_deal/widget/create_deal_number_text_field.dart';
import 'package:youreal/app/deal/model/deal_fee.dart';
import 'package:youreal/app/form_appraisal/widget/text_input1.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

class NewFeeItem extends StatefulWidget {
  final Function(DealFee, String id) onChanged;
  final Function(String) remove;
  final String id;

  const NewFeeItem({
    Key? key,
    required this.remove,
    required this.onChanged,
    required this.id,
  }) : super(key: key);

  @override
  _NewFeeItemState createState() => _NewFeeItemState();
}

class _NewFeeItemState extends State<NewFeeItem> {
  DealFee fee = DealFee(
      value: 0,
      feeType: FeeType.Others,
      feeTypeName: FeeType.Others.name,
      id: -1);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(bottom: 2.h, left: 12.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Tên khoản phí", style: kText14Weight400_Light),
              GestureDetector(
                onTap: () {
                  widget.remove(widget.id);
                },
                child: Text(
                  "Xóa",
                  style: kText14Weight400_Light,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 40.h,
          width: 1.sw,
          padding: EdgeInsets.only(left: 10.w),
          decoration: BoxDecoration(
              color: yrColorLight, borderRadius: BorderRadius.circular(8.h)),
          child: DropdownButton<FeeType>(
            value: fee.feeType,
            underline: Container(),
            hint: Text(
              "Chọn loại phí...",
              style: kText14Weight400_Hint,
            ),
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down, color: yrColorHint),
            onChanged: (val) {
              if (val == null) {
                return;
              }
              setState(() {
                fee = fee.copyWith(feeType: val);
              });
              widget.onChanged(fee, widget.id);
            },
            style: kText14Weight400_Dark,
            items: FeeType.values.map((e) {
              return DropdownMenuItem(
                  value: e, child: Text(e.name, style: kText14Weight400_Dark));
            }).toList(),
          ),
        ),
        if (fee.feeType == FeeType.Others)
          Column(
            children: [
              SizedBox(height: 8.h),
              TextInput1(
                labelText: "Ghi chú",
                labelStyle: kText14Weight400_Light,
                onChanged: (value) {
                  fee = fee.copyWith(note: value);
                  widget.onChanged(fee, widget.id);
                },
              ),
            ],
          ),
        CreateDealNumberTextField(
          prefixText: "Chi phí",
          onChanged: (value) {
            if (value.isNotEmpty) {
              fee =
                  fee.copyWith(value: double.parse(value.replaceAll(".", "")));
              widget.onChanged(fee, widget.id);
            }
          },
          affixText: 'VNĐ',
          suffixIconWidth: 60.w,
        ),
        SizedBox(height: 8.h),
      ],
    );
  }
}
