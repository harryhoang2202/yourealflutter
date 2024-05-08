import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youreal/common/config/color_config.dart';
import 'package:youreal/common/config/text_config.dart';

class ModifyDealDialog extends StatelessWidget {
  const ModifyDealDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      titlePadding: EdgeInsets.fromLTRB(6.w, 6.h, 6.w, 24.h),
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Text(
              'ĐIỀU CHỈNH % DEAL',
              style: kText14Weight400_Dark,
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.clear,
              color: yrColorPrimary,
              size: 22.w,
            ),
          ),
        ],
      ),
      children: [
        Text(
          'Bạn muốn tăng / giảm % DEAL. Vui lòng gửi yêu cầu tới Leader để được thực hiện',
          style: kText14_Primary,
        ),
        Padding(
          padding: EdgeInsets.only(top: 24.h, bottom: 8.h),
          child: Text(
            'Số % điều chỉnh:',
            style: kText14Weight400_Dark,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: yrColorPrimary),
              ),
              height: 37.h,
              width: 106.w,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '10',
                      style: kText14Weight400_Dark,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    '%',
                    style: kText14Weight400_Dark,
                  ),
                  SizedBox(
                    width: 5.w,
                  )
                ],
              ),
            ),
            Flexible(
              child: SvgPicture.asset('assets/icons/ic_arrow_right.svg'),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: yrColorPrimary),
              ),
              height: 37.h,
              width: 106.w,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(2),
                      ],
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                      style: kText14Weight400_Dark,
                    ),
                  ),
                  Text(
                    '%',
                    style: kText14Weight400_Dark,
                  ),
                  SizedBox(
                    width: 5.w,
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 19.h,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: yrColorPrimary),
          ),
          height: 37.h,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '15,000,000',
                  style: kText14Weight400_Dark,
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                'VNĐ',
                style: kText14Weight400_Dark,
              ),
              SizedBox(
                width: 5.w,
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            40.w,
            38.h,
            40.w,
            24.h,
          ),
          child: OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              backgroundColor: yrColorPrimary,
              minimumSize: Size(double.infinity, 50.h),
            ),
            child: Text(
              'GỬI ĐỀ NGHỊ VÀ THANH TOÁN',
              style: kText14Weight400_Dark,
            ),
          ),
        ),
      ],
    );
  }
}
