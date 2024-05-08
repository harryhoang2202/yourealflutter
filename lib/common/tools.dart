import 'dart:io';
import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:youreal/app/chats/widget/chat_detail_info/error_dialog.dart';
import 'package:youreal/app/chats/widget/confirm_dialog.dart';
import 'package:youreal/common/config/text_config.dart';
import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/utils/vietnamese_text_delegate.dart';
import 'package:youreal/generated/i10n.dart';
import 'package:youreal/services/domain/auth/models/user.dart';
import 'package:youreal/services/services_api.dart';

import 'package:youreal/utils/photo_viewer.dart';

import '../view_models/app_model.dart';
import 'config/color_config.dart';
import 'constants/general.dart';

class Utils {
  static Future<List<PlatformFile>> pickFiles() async {
    List<PlatformFile> pickedFiles = [];
    try {
      pickedFiles = (await FilePicker.platform.pickFiles(
            type: FileType.any,
            allowMultiple: true,
          ))
              ?.files ??
          [];
    } on PlatformException catch (e) {
      printLog("[Utils] _pickFiles Error: $e");
    } catch (e) {
      printLog("[Utils] _pickFiles Error: $e");
    }
    return pickedFiles;
  }

  static DateTime dateFromJson(
    String data, {
    String pattern = "dd/MM/yyyy hh:mm:ss aa",
  }) {
    final dateFormat = DateFormat(
      pattern,
      "en_US",
    );
    final date = DateTime.parse(data);
    return date;
  }

  static final thousandFormatter = NumberFormat.decimalPattern();

  static hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static launchUrl(BuildContext context, String url) async {
    final launchResult = await launch(url);
    if (!launchResult) {
      Utils.showErrorDialog(context, message: "Đã có lỗi xảy ra khi mở link!");
    }
  }

  static int get newSessionId {
    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  static Future<void> showInfoSnackBar(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    bool isError = false,
    FlushbarPosition position = FlushbarPosition.TOP,
    EdgeInsets margin = EdgeInsets.zero,
    bool blockBackgroundInteraction = false,
  }) async {
    if (margin == EdgeInsets.zero && position == FlushbarPosition.BOTTOM) {
      margin = EdgeInsets.only(bottom: 32.h);
    }
    await Flushbar(
      message: message,
      duration: duration,
      messageColor: yrColorLight,
      borderRadius: BorderRadius.circular(10),
      title: title,
      margin: margin,
      backgroundColor: isError ? yrColorError : yrColorSuccess,
      flushbarPosition: position,
      blockBackgroundInteraction: blockBackgroundInteraction,
    ).show(context);
  }

  static Future<void> openFile(
    BuildContext context, {
    required String pathOrUrl,
    required VoidCallback showLoading,
    required VoidCallback hideLoading,
    double? size,
  }) async {
    String openPath = pathOrUrl;
    String? errorMessage;
    try {
      String readableUrl;
      if (pathOrUrl.isHttpUrl) {
        showLoading();
        if (!pathOrUrl.contains("amazonaws") ||
            pathOrUrl.contains("X-Amz-Signature")) {
          //doesnt need auth
          readableUrl = pathOrUrl;
        } else if (pathOrUrl.contains("amazonaws")) {
          //Need auth
          readableUrl =
              (await APIServices().getPreviewLinks(paths: [pathOrUrl])).first;
        } else {
          //doesnt need auth
          readableUrl = pathOrUrl;
        }
        // readableUrl =
        //     (await APIServices().getPreviewLinks(paths: [pathOrUrl])).first;
        final fileSize = size ?? await Utils.getFileSize(readableUrl);
        bool wantToView = true;
        final isCached =
            await DefaultCacheManager().getFileFromCache(readableUrl) == null
                ? false
                : true;
        if (!isCached && (fileSize ?? 0) > 10 * 1024) {
          wantToView = await Utils.showConfirmDialog(context,
              title: "File này có dung lượng lớn hơn 10MB, bạn có muốn xem?");
        }
        if (!wantToView) return;
        final file = await DefaultCacheManager().getSingleFile(readableUrl);
        hideLoading();

        openPath = file.path;
      }

      final openResult = await OpenFilex.open(openPath);
      switch (openResult.type) {
        case ResultType.error:
          errorMessage = openResult.message;
          break;
        case ResultType.fileNotFound:
          errorMessage = "Không tìm thấy file";
          break;
        case ResultType.noAppToOpen:
          errorMessage = "Không tìm thấy ứng dụng phù hợp để mở file";
          break;
        case ResultType.permissionDenied:
          errorMessage = "Quyền truy cập bị từ chối";
          break;
        default:
      }
    } catch (e) {
      errorMessage = "Đường dẫn file không hợp lệ";
      hideLoading();
    }
    if (errorMessage != null) {
      await Utils.showErrorDialog(context, message: errorMessage);
    }
  }

  static void setOrientation(Orientation orientation) {
    if (orientation == Orientation.landscape) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  static FaIcon icFromFile(String name, {double? size}) {
    if (name.isFileWithType(["pdf"])) {
      return FaIcon(
        FontAwesomeIcons.filePdf,
        color: Colors.red,
        size: size,
      );
    }
    //Excel
    else if (name.isFileWithType([
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
    ])) {
      return FaIcon(
        FontAwesomeIcons.fileExcel,
        color: Colors.green,
        size: size,
      );
    }
    //Powerpoint
    else if (name.isFileWithType([
      "potm",
      "potx",
      "ppam",
      "pps",
      "ppsx",
      "ppsm",
      "ppt",
      "pptm",
      "pptx",
    ])) {
      return FaIcon(
        FontAwesomeIcons.filePowerpoint,
        color: Colors.orange,
        size: size,
      );
    }
    //Word
    else if (name.isFileWithType([
      "doc",
      "docm",
      "docx",
      "dotx",
      "dotm",
    ])) {
      return FaIcon(
        FontAwesomeIcons.fileWord,
        color: Colors.blue,
        size: size,
      );
    } else if (name.isFileWithType([
      "rtf",
      "rtf2",
      "txt",
    ])) {
      return FaIcon(
        FontAwesomeIcons.fileAlt,
        size: size,
      );
    } else if (name.isFileWithType([
      "jpg",
      "gif",
      "png",
      "jpeg",
      "heic",
    ])) {
      return FaIcon(
        FontAwesomeIcons.image,
        size: size,
      );
    }

    return FaIcon(
      FontAwesomeIcons.file,
      color: Colors.red,
      size: size,
    );
  }

  static Future<double?> getFileSize(String url) async {
    try {
      final response = await Dio().head(url);
      final size =
          double.parse((response.headers["content-length"] as List).first);
      return size / 1024;
    } on DioError catch (e) {
      printLog("getFileSize ${e.errorMessage} with $url");
      return null;
    } catch (e) {
      printLog("getFileSize $e");
      return null;
    }
  }

  static Future<bool> showConfirmDialog(BuildContext context,
      {required String title}) async {
    return await showAnimatedDialog<bool?>(
          barrierDismissible: true,
          context: context,
          builder: (context) => ConfirmDialog(
            title: title,
          ),
          animationType: DialogTransitionType.slideFromTop,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        ) ??
        false;
  }

  static Future showErrorDialog(BuildContext context,
      {required String message}) async {
    return await showAnimatedDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => ErrorDialog(
        error: message,
      ),
      animationType: DialogTransitionType.slideFromTop,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  static EventTransformer<E> debounce<E>(Duration duration) {
    return (events, mapper) {
      return events.debounce(duration).switchMap(mapper);
    };
  }

  static String getDuration(DateTime date, {bool addMore = true}) {
    late final int now;
    if (addMore) {
      now = DateTime.now().add(const Duration(hours: 7)).millisecondsSinceEpoch;
    } else {
      now = DateTime.now().millisecondsSinceEpoch;
    }
    int duration = date.millisecondsSinceEpoch - now;
    return toDuration(duration.abs());
  }

  static String milToBil(double money) {
    if (money > 10) {
      return (money ~/ 10 + (money.toInt() % 10) / 10.0).toStringAsFixed(1);
    }

    return (money / 10).toStringAsFixed(1);
  }

  static final List<int> times = [
    const Duration(days: 365).inMilliseconds,
    const Duration(days: 30).inMilliseconds,
    const Duration(days: 1).inMilliseconds,
    const Duration(hours: 1).inMilliseconds,
    const Duration(minutes: 1).inMilliseconds,
  ];
  static final List<String> timesString = [
    "năm",
    "tháng",
    "ngày",
    "giờ",
    "phút",
  ];

  static String toDuration(int duration) {
    StringBuffer res = StringBuffer();
    for (int i = 0; i < times.length; i++) {
      int current = times[i];
      int temp = duration ~/ current;
      if (temp > 0) {
        res
          ..write(temp)
          ..write(" ")
          ..write(timesString[i])
          ..write(" trước");
        break;
      }
    }
    if ("" == (res.toString())) {
      return "0 giây trước";
    } else {
      return res.toString();
    }
  }

  static Function getLanguagesList = ([context]) {
    return [
      {
        "name": context != null ? S.of(context)!.english : "English",
        "icon": "",
        "code": "en",
        "text": "English",
        "storeViewCode": ""
      },
      {
        "name": context != null ? S.of(context)!.vietnamese : "Vietnam",
        "icon": "",
        "code": "vi",
        "text": "Vietnam",
        "storeViewCode": ""
      },
    ];
  };
}

Widget getImage(
  String link, {
  BoxFit? fit,
  bool short = true,
  double? height,
  double? width,
  BorderRadius borderRadius = BorderRadius.zero,
  bool useCached = true,
  bool isAsset = false,
  GestureTapCallback? onTap,
}) {
  if (link.isHttpUrl) {
    final placeHolder = Shimmer.fromColors(
      baseColor: yrColorHint,
      highlightColor: yrColorLight,
      period: const Duration(milliseconds: 1200),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: SizedBox.fromSize(
          size: Size(width ?? 1.sw, height ?? 300.h),
          child: const Material(
            color: yrColorLight,
          ),
        ),
      ),
    );
    final errorWidget = ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        width: width,
        height: height,
        color: yrColorHint,
        child: const Center(
          child: Icon(
            Icons.broken_image,
            color: yrColorPrimary,
          ),
        ),
      ),
    );

    late Future<List<String>> previewLinksFuture;
    String path;
    if (link.lastIndexOf('http') > 0) {
      path = link.split(APIServices().url).last;
      path = APIServices().url + path;
    } else {
      path = link;
    }

    if (!path.contains("amazonaws") || path.contains("X-Amz-Signature")) {
      //doesnt need auth
      previewLinksFuture = Future.value([path]);
    } else if (path.contains("amazonaws")) {
      //Need auth
      previewLinksFuture = APIServices().getPreviewLinks(paths: [path]);
    } else {
      //doesnt need auth
      previewLinksFuture = Future.value([path]);
    }
    return FutureBuilder<List<String>>(
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return placeHolder;
        }
        if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data?.isEmpty == true) {
          return errorWidget;
        }
        String previewUrl = snapshot.data!.first;

        if (!useCached) {
          previewUrl =
              "$previewUrl?refresh=${DateTime.now().millisecondsSinceEpoch}";
        }

        return GestureDetector(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: width ?? 1.sw, maxHeight: height ?? 1.sh),
            child: Stack(
              fit: StackFit.expand,
              children: [
                placeHolder,
                // ClipRRect(
                //   child: FadeInImage.memoryNetwork(
                //     fit: fit,
                //     height: height,
                //     width: width,
                //     imageErrorBuilder: (_, __, ___) => errorWidget,
                //     placeholder: kTransparentImage,
                //     image: previewUrl,
                //   ),
                //   borderRadius: borderRadius,
                // ),
                CachedNetworkImage(
                  fit: fit,
                  imageUrl: previewUrl,
                  height: height,
                  width: width,
                  imageBuilder: (context, image) => ClipRRect(
                    borderRadius: borderRadius,
                    child: Image(
                      fit: fit,
                      image: image,
                      width: width,
                      height: height,
                    ),
                  ),
                  placeholder: (__, _) => placeHolder,
                  errorWidget: (_, __, ___) => errorWidget,
                ),
              ],
            ),
          ),
        );
      },
      future: previewLinksFuture,
    );
  } else if (isAsset) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Image.asset(
          short ? "assets/images/$link" : link,
          fit: fit,
          height: height,
          width: width,
        ),
      ),
    );
  } else {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Image.file(
          File(link),
          fit: fit,
          height: height,
          width: width,
        ),
      ),
    );
  }
}

String getIcon(link) {
  return "assets/icons/$link";
}

String thousandSeparateFormat(int num) {
  return NumberFormat.decimalPattern("vi").format(num).replaceAll(".", ",");
}

getDate(String date) {
  try {
    DateTime dateTime = DateTime.parse(date);
    String converted = DateFormat('dd/MM/yyyy', "vi").format(dateTime);
    return converted;
  } catch (e) {
    return "";
  }
}

getTime(String date) {
  try {
    DateTime dateTime = DateTime.parse(date);
    String converted = DateFormat("hh:mm", "vi").format(dateTime);
    return converted;
  } catch (e) {
    return "";
  }
}

class Tools {
  Future _multiImgFromGallery(
    BuildContext context, {
    Color themeColor = Colors.blue,
    required Function(List<String>) success,
    int maxAssets = 9,
  }) async {
    try {
      var status = await AssetPicker.permissionCheck();
      if (status != PermissionState.denied) {
        List<String> listImagePath = [];
        final images = await AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
              textDelegate: VietnameseTextDelegate(),
              maxAssets: maxAssets,
              themeColor: themeColor,
              requestType: RequestType.image),
        );
        if (images != null) {
          for (AssetEntity element in images) {
            final file = await element.file;

            listImagePath.add(file!.path);
          }
        }
        success(listImagePath);
      } else {
        await PhotoManager.requestPermissionExtend();
      }
    } catch (e) {
      await Utils.showInfoSnackBar(
        context,
        message:
            "YouReal không có quyền truy cập vào kho ảnh!!! Kiểm tra lại cài đặt của bạn.",
        isError: true,
        position: FlushbarPosition.TOP,
      );
      printLog(e);
    }
  }

  Future<void> showPickerMultiImage({
    required BuildContext context,
    required Function(List<String>) successGallery,
    required Function(List<String>) successCamera,
    int maxAssets = 9,
  }) async {
    await showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Chọn từ thư viện'),
                    onTap: () async {
                      await _multiImgFromGallery(
                        context,
                        success: successGallery,
                        themeColor: yrColorPrimary,
                        maxAssets: maxAssets,
                      );
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Chụp ảnh mới'),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => TakePictureScreen(
                    //       camera: cameras.first,
                    //       onBack: (List<String> listImg) {
                    //         successCamera(listImg);
                    //         Navigator.pop(context);
                    //       },
                    //     ),
                    //   ),
                    // );
                  },
                ),
              ],
            ),
          );
        });
  }

  static Widget buildSelectedImage(
      {required String imagePath,
      required String key,
      double? width,
      double? height}) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Stack(
        key: Key(key),
        alignment: AlignmentDirectional.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                height: height ?? 65,
                width: width ?? 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: imagePath.isHttpUrl
                    ? CachedNetworkImage(imageUrl: imagePath)
                    : Image.file(File(imagePath)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String tinhThoiGian(DateTime timeStart, DateTime timeNow, timeEnd) {
    int a = timeEnd +
        timeStart.hour * 3600 +
        timeStart.minute * 60 +
        timeStart.second;

    int b = timeNow.hour * 3600 + timeNow.minute * 60 + timeNow.second;
    int c = a - b;
    if (c < 0) {
      c = -c;
    }

    var temp1 = c ~/ 3600;
    var temp2 = (c % 3600) ~/ 60;
    var temp3 = (c % 3600) % 60;

    return "${temp1 < 10 ? '0' : ''}$temp1:${temp2 < 10 ? '0' : ''}$temp2:${temp3 < 10 ? '0' : ''}$temp3";
  }

  String convertMoneyToUnitMoney(String value) {
    int money = double.parse(value).round();
    if (money >= 1000000000) {
      return "${money / 1000000000} tỷ VNĐ";
    } else if (money >= 1000000) {
      return "${money / 1000000} triệu VNĐ";
    }
    return "${money.toString()} VNĐ";
  }

  String convertUnitMoneyToMoney(double value) {
    return (value * 1000000000).toString();
  }

  String? convertMoneyToSymbolMoney(String value, {String? symbol = "."}) {
    try {
      final NumberFormat oCcy;
      if (symbol == ",") {
        oCcy = NumberFormat("#,###", "en_US");
      } else {
        oCcy = NumberFormat("#,###", "vi_VN");
      }

      double a = double.parse(value);

      return oCcy.format(a).toString();
    } catch (e) {
      printLog("ConvertMoneyToSymbolMoney Error: $e");
    }
    return null;
  }

  Future<void> makePhoneCall(String phone) async {
    String url = 'tel:$phone';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<String> resizeImage(String imagePath) async {
    var before = await getFileSize(imagePath, 1);
    var a = double.parse(before.split(' ')[0]);
    if (a > 5 && before.split(' ')[1] == "MB") {
      var compressedFile = await FlutterNativeImage.compressImage(
        imagePath,
        quality: 50,
      );
      var after = await getFileSize(compressedFile.path, 1);
      return compressedFile.path;
    } else {
      return imagePath;
    }
  }

  getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  Widget toolTip(
      {double? height, required title, titleStyle, backgroundColor}) {
    double h = height ?? 30.h;
    return SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: h / 4 * 3,
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            decoration: BoxDecoration(
                color: backgroundColor ?? yrColorLight,
                borderRadius: BorderRadius.circular(4.h)),
            child: Text(
              title,
              style: titleStyle ?? kText14Weight400_Primary,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: h / 3),
            child: Icon(
              Icons.arrow_drop_down,
              color: backgroundColor ?? yrColorLight,
              size: h,
            ),
          )
        ],
      ),
    );
  }
}

String durationToString(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}

Future<File> fileFromImageUrl(String url) async {
  final response = await Dio().get<List<int>>(
    url,
    options: Options(
        responseType: ResponseType.bytes), // set responseType to `bytes`
  );

  final documentDirectory = await getTemporaryDirectory();

  final file = File(join(documentDirectory.path, 'tempImage.png'));

  file.writeAsBytesSync(response.data!);

  return file;
}

Future<List<String>> uploadFiles(List<String> paths,
    {bool isImage = false}) async {
  try {
    APIServices services = APIServices();
    List<String> notUpdated =
        paths.where((element) => !element.isHttpUrl).toList();

    List<String> updated = paths.where((element) => element.isHttpUrl).toList();
    late final List<String> result;
    if (isImage) {
      result = await Future.wait<String>([
        for (int i = 0; i < notUpdated.length; i++)
          services.upFile(path: notUpdated[i], type: FileUploadType.Images)
      ]);
    } else {
      result = await Future.wait<String>([
        for (int i = 0; i < notUpdated.length; i++)
          services.upFile(path: notUpdated[i], type: FileUploadType.Documents)
      ]);
    }

    return [...result, ...updated];
  } catch (e, trace) {
    printLog("[ERROR][tools][uploadFiles] $e $trace");
    return [];
  }
}

Future openPhotoViewer(
  BuildContext context, {
  required int index,
  required List<String> imagePaths,
  void Function(List<String>)? onImageDeleted,
  bool viewOnly = false,
  bool useCached = true,
}) async {
  assert(viewOnly ? onImageDeleted == null : true);

  Utils.hideKeyboard(context);
  await Navigator.of(context, rootNavigator: true).push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => PhotoViewer(
        initialIndex: index,
        scrollDirection: Axis.horizontal,
        imagePaths: imagePaths,
        onImageDeleted: onImageDeleted,
        useCached: useCached,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ),
  );
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  // ignore: avoid_print
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

bool checkRole(BuildContext context, RolesType roleRequest) {
  List<Roles>? role = [];
  role = Provider.of<AppModel>(context, listen: false).user.roles;

  if (role != null) {
    for (var element in role) {
      if (element.id == roleRequest.index) {
        return true;
      }
    }
    return false;
  } else {
    if (roleRequest == RolesType.User) {
      return true;
    } else {
      return false;
    }
  }
}
