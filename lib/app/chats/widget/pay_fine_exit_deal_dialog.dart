import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

class PayFineExitDealDialog extends StatelessWidget {
  const PayFineExitDealDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      titlePadding: EdgeInsets.only(top: 8.h, right: 16.w),
      contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'ĐÓNG PHẠT',
              style: kText18Weight500_Primary,
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.clear,
              color: yrColorHint,
              size: 22.w,
            ),
          ),
        ],
      ),
      children: [
        SizedBox(height: 16.h),
        Text(
          'Bạn đang rút khỏi Deal đang được đầu tư. Vì vậy bạn cần phải đóng phí phạt khi thực hiện yêu cầu này.',
          style: kText14Weight400_Primary,
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.only(left: 12.w),
          child: Text(
            'Số tiền phạt: ',
            style: kText14Weight400_Primary,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.w),
            border: Border.all(color: yrColorSecondary),
            color: yrColorLight,
          ),
          alignment: Alignment.center,
          child: Row(
            children: [
              SizedBox(width: 12.w),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Text(
                  '15,000,000',
                  style: kText14Weight400_Hint,
                ),
              ),
              const Spacer(),
              Text(
                'VNĐ',
                style: kText14Weight400_Hint,
              ),
              SizedBox(width: 12.w)
            ],
          ),
        ),
        SizedBox(height: 16.h),
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            backgroundColor: yrColorPrimary,
            minimumSize: Size(double.infinity, 54.h),
          ),
          child: Text(
            'Thanh toán',
            style: kText18Weight400_Light,
          ),
        ),
        SizedBox(height: 8.h),
      ],
    );
  }
}
