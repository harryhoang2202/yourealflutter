import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youreal/common/config/color_config.dart';

const fontFamily = "Roboto";
const titleFontFamily = "Cutie Biscuit";
//region Title Text

final kTextTitle = TextStyle(
    fontSize: 96.sp,
    fontWeight: FontWeight.normal,
    color: yrColorLight,
    fontFamily: titleFontFamily);

//endregion

final kTextConfig_Light = TextStyle(
    fontSize: ScreenUtil().setSp(14),
    fontWeight: FontWeight.w500,
    color: yrColorLight,
    fontFamily: fontFamily);

///Font size 48

///Font size 32
final kText32_Light = kTextConfig_Light.copyWith(
  fontSize: ScreenUtil().setSp(32),
);
final kText32_Primary = kText32_Light.copyWith(color: yrColorPrimary);
final kText32Weight500_Primary = kText32_Light.copyWith(
  color: yrColorPrimary,
  fontWeight: FontWeight.w500,
);

///Font size 28
final kText28_Light = kTextConfig_Light.copyWith(
  fontSize: ScreenUtil().setSp(28),
);
final kText28_Primary = kText28_Light.copyWith(color: yrColorPrimary);
final kText28Weight500_Light = kTextConfig_Light.copyWith(
  fontSize: ScreenUtil().setSp(28),
  fontWeight: FontWeight.w500,
);

final kText25_Light = kTextConfig_Light.copyWith(
  fontSize: ScreenUtil().setSp(24),
);
final kText25_Dark = kText25_Light.copyWith(color: yrColorDark);

///Font size 24

final kText24_Light = kTextConfig_Light.copyWith(
  fontSize: ScreenUtil().setSp(24),
);
final kText24_Dark = kText24_Light.copyWith(color: yrColorDark);
final kText24_Accent = kText24_Light.copyWith(color: yrColorAccent);
final kText24_Primary = kText24_Light.copyWith(color: yrColorPrimary);
final kText24_Error = kText24_Light.copyWith(color: yrColorError);

///Font size 20
final kText20_Light = kTextConfig_Light.copyWith(
  fontSize: ScreenUtil().setSp(20),
);
final kText20Weight500_Light = kTextConfig_Light.copyWith(
  fontSize: ScreenUtil().setSp(20),
  fontWeight: FontWeight.w500,
);
final kText20Weight500_Dark = kTextConfig_Light.copyWith(
  fontSize: ScreenUtil().setSp(20),
  fontWeight: FontWeight.w500,
  color: yrColorDark,
);
final kText20Weight500_Primary = kTextConfig_Light.copyWith(
  fontSize: ScreenUtil().setSp(20),
  fontWeight: FontWeight.w500,
  color: yrColorPrimary,
);
final kText20_Dark = kText20_Light.copyWith(color: yrColorDark);
final kText20_Error = kText20_Light.copyWith(color: yrColorError);
final kText20_Primary = kText20_Light.copyWith(color: yrColorPrimary);
final kText20_Accent = kText20_Light.copyWith(color: yrColorAccent);

///Font size 18

final kText18_Light = kTextConfig_Light.copyWith(
  fontSize: ScreenUtil().setSp(18),
);
final kText18Bold_Light = kTextConfig_Light.copyWith(
    fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.bold);
final kText18_Dark = kText18_Light.copyWith(color: yrColorDark);
final kText18_Primary = kText18_Light.copyWith(color: yrColorPrimary);
final kText18_Error = kText18_Light.copyWith(color: yrColorError);
final kText18_Accent = kText18_Light.copyWith(color: yrColorAccent);
final kText18Bold_Accent =
    kText18_Light.copyWith(color: yrColorAccent, fontWeight: FontWeight.bold);
final kText18Weight400_Hint =
    kText18_Light.copyWith(color: yrColorHint, fontWeight: FontWeight.w400);
final kText18Weight400_Primary =
    kText18_Light.copyWith(color: yrColorPrimary, fontWeight: FontWeight.w400);

final kText18Weight400_Light =
    kText18_Light.copyWith(color: yrColorLight, fontWeight: FontWeight.w400);
final kText18Weight400_Dark =
    kText18_Light.copyWith(color: yrColorDark, fontWeight: FontWeight.w400);
final kText18Weight500_Light =
    kText18_Light.copyWith(color: yrColorLight, fontWeight: FontWeight.w500);
final kText18Weight500_Dark =
    kText18_Light.copyWith(color: yrColorDark, fontWeight: FontWeight.w500);
final kText18Weight500_Primary =
    kText18_Light.copyWith(color: yrColorPrimary, fontWeight: FontWeight.w500);
final kText18Weight400_Error =
    kText18_Light.copyWith(color: yrColorError, fontWeight: FontWeight.w400);

///Font size 16
final kText16_Light = kTextConfig_Light.copyWith(
  fontSize: ScreenUtil().setSp(16),
);
final kText16Weight700_Light = kTextConfig_Light.copyWith(
  fontSize: ScreenUtil().setSp(16),
  fontWeight: FontWeight.w700,
);

final kText16_Dark = kText16_Light.copyWith(color: yrColorDark);

final kText16_Primary = kText16_Light.copyWith(color: yrColorPrimary);
final kText16Weight400_Primary =
    kText16_Light.copyWith(color: yrColorPrimary, fontWeight: FontWeight.w400);
final kText16Weight400_Error =
    kText16_Light.copyWith(color: yrColorError, fontWeight: FontWeight.w400);
final kText16_Hint = kText16_Light.copyWith(color: yrColorHint);
final kText16_Accent = kText16_Light.copyWith(color: yrColorAccent);
final kText16Weight400_Accent =
    kText16_Light.copyWith(color: yrColorAccent, fontWeight: FontWeight.w400);
final kText16Weight400_Hint =
    kText16_Light.copyWith(color: yrColorHint, fontWeight: FontWeight.w400);
final kText16_Secondary2 = kText16_Light.copyWith(color: yrColorSecondary);
final kText16Weight400_Secondary2 = kText16_Light.copyWith(
    color: yrColorSecondary, fontWeight: FontWeight.w400);
final kText16Weight400_Dark =
    kText16_Dark.copyWith(fontWeight: FontWeight.w400);
final kText16Weight400_Light =
    kText16Weight400_Dark.copyWith(color: yrColorLight);

final kText16_Error = kText16Weight400_Dark.copyWith(color: yrColorError);

///Font size 14
final kText14_Light = kTextConfig_Light.copyWith(
  fontSize: ScreenUtil().setSp(14),
);
final kText14Weight400_Light = kTextConfig_Light.copyWith(
    fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w400);
final kText14_Dark = kText14_Light.copyWith(color: yrColorDark);
final kText14_Secondary2 = kText14_Light.copyWith(color: yrColorSecondary);
final kText14_Error = kText14_Light.copyWith(color: yrColorError);
final kText14_Primary = kText14_Light.copyWith(color: yrColorPrimary);
final kText14Bold_Primary =
    kText14_Light.copyWith(color: yrColorPrimary, fontWeight: FontWeight.bold);
final kText14Bold_Light =
    kText14_Light.copyWith(color: yrColorLight, fontWeight: FontWeight.bold);
final kText14_Accent = kText14_Light.copyWith(color: yrColorAccent);
final kText14Weight400_Secondary2 = kText14_Light.copyWith(
    color: yrColorSecondary, fontWeight: FontWeight.w400);
final kText14Weight400_Accent =
    kText14_Light.copyWith(color: yrColorAccent, fontWeight: FontWeight.w400);
final kText14Weight700_Accent =
    kText14_Light.copyWith(color: yrColorAccent, fontWeight: FontWeight.w700);
final kText14Weight400_Dark =
    kText14_Dark.copyWith(fontWeight: FontWeight.w400);
final kText14Weight400_Hint =
    kText14_Light.copyWith(color: yrColorHint, fontWeight: FontWeight.w400);
final kText14Weight400_Primary =
    kText14_Light.copyWith(color: yrColorPrimary, fontWeight: FontWeight.w400);
final kText14Weight400_Success = kText14Weight400_Primary.copyWith(
  color: yrColorSuccess,
);
final kText14Weight400_Warning = kText14Weight400_Primary.copyWith(
  color: yrColorWarning,
);
final kText14Weight400_Error = kText14Weight400_Primary.copyWith(
  color: yrColorError,
);

///Font size 12
final kText12Weight400_Light = kTextConfig_Light.copyWith(
    fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w400);
final kText12Weight400_Accent = kTextConfig_Light.copyWith(
    color: yrColorAccent,
    fontSize: ScreenUtil().setSp(12),
    fontWeight: FontWeight.w400);
final kText12Weight400_Dark = kTextConfig_Light.copyWith(
    color: yrColorDark,
    fontSize: ScreenUtil().setSp(12),
    fontWeight: FontWeight.w400);

final kText12_Light =
    kTextConfig_Light.copyWith(fontSize: ScreenUtil().setSp(12));

final kText12_Primary = kText12_Light.copyWith(color: yrColorPrimary);

final kText12Weight400_Hint = kTextConfig_Light.copyWith(
    fontSize: ScreenUtil().setSp(12),
    fontWeight: FontWeight.w400,
    color: yrColorHint);
final kText12Weight400_Primary = kTextConfig_Light.copyWith(
    fontSize: ScreenUtil().setSp(12),
    fontWeight: FontWeight.w400,
    color: yrColorPrimary);

final kText12Weight700_Primary = kText12Weight400_Primary.copyWith(
  fontWeight: FontWeight.w700,
);
final kText12Weight700_Light =
    kText12Weight700_Primary.copyWith(color: yrColorLight);
final kText12Weight400_Error =
    kText12Weight400_Light.copyWith(color: yrColorError);

///Font size 10

///Font size 8

final kText8Weight400_Light = kText18_Light.copyWith(
  color: yrColorLight,
  fontWeight: FontWeight.w400,
  fontSize: 8.sp,
);
