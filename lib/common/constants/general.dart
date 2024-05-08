import 'package:flutter/material.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/tools.dart';

/// Logging config
const kLOG_TAG = "[APP]";
const kLOG_ENABLE = true;
const ApiPageSize = 20;
const kDEAL_ID_ENABLE = true;

/// enable network proxy
const debugNetworkProxy = false;

/// some constants Local Key
const kLocalKey = {};
const kAdvanceConfig = {
  "DefaultLanguage": "vi",

  /// set kIsResizeImage to true if you have finish running Re-generate image plugin
  "kIsResizeImage": false,
  "OnBoardOnlyShowFirstTime": true,
  "DefaultCurrency": {
    "symbol": "đ",
    "decimalDigits": 0,
    "symbolBeforeTheNumber": false,
    "currency": "VND"
  },
  "Currencies": [
    {
      "symbol": "đ",
      "decimalDigits": 0,
      "symbolBeforeTheNumber": false,
      "currency": "VND"
    },
  ],

  ///if  [APP] supports multi languages. set false if [APP] only have one language
  "isMultiLanguages": false
};

const String kSavedAccount = 'SavedAccount';
const String kUserSaved = "UserSaved";
const String kStorageName = 'YOUREAL';
const String kSettingFilter = "isSettingFilter";

const double kBillion = 1000000000;
const double kDefaultInvestmentLimit = kBillion * 10;
const double kDefaultMinDepositPrice = 0;
const double kDefaultMaxDepositPrice = 1000000000;
const double kInvestmentRangeStep = 100000000;
const String kChatHeartSpecialCode = r"!@@###$$$$%%%%%";
const double kHeartMessageMaxHeight = 96;
const kCacheBox = "CACHE_BOX";
const kSupportFileTypes = [
  "pdf",
  'xla',
  'xlam',
  'xlc',
  'xlf',
  'xlm',
  'xls',
  'xlsb',
  'xlsm',
  'xlsx',
  'xlt',
  'xltm',
  'xltx',
  "potm",
  "potx",
  "ppam",
  "pps",
  "ppsx",
  "ppsm",
  "ppt",
  "pptm",
  "pptx",
  "doc",
  "docm",
  "docx",
  "dotx",
  "dotm",
  "rtf",
  "rtf2",
  "txt",
];
const kSupportImageTypes = [
  "jpg",
  "gif",
  "png",
  "jpeg",
  "heic",
];

void printLog(dynamic data) {
  if (kLOG_ENABLE) {
    printWrapped("[${DateTime.now().toUtc()}]$kLOG_TAG${data.toString()}");
  }
}

Widget kDEAL_ID(id) {
  return kDEAL_ID_ENABLE
      ? SizedBox(height: 20, child: Text("#$id", style: kText14Weight400_Dark))
      : Container();
}
