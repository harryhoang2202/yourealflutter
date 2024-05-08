import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class VietnameseTextDelegate extends AssetPickerTextDelegate {
  @override
  String get accessAllTip =>
      'Youreal chỉ có thể truy cập một số file trong máy. '
      'Đi đến cài đặt hệ thống và cho phép Youreal truy cập tất cả các file trong máy.';

  @override
  String get accessLimitedAssets => 'Tiếp tục với quyền truy cập bị hạn chế';

  @override
  String get accessiblePathName => 'Các file có thể truy cập';

  @override
  String get cancel => 'Huỷ';

  @override
  String get changeAccessibleLimitedAssets =>
      'Cập nhật danh sách file bị hạn chế truy cập';

  @override
  String get confirm => 'Đồng ý';

  @override
  String get edit => "Chỉnh sửa";

  @override
  String get emptyList => "Danh sách rỗng";

  @override
  String get gifIndicator => "GIF";

  @override
  String get goToSystemSettings => "Đi đến cài đặt hệ thống";

  @override
  String get heicNotSupported => "Định dạng HEIC không được hỗ trợ.";

  @override
  String get loadFailed => "Tải ảnh thất bại";

  @override
  String get original => "Nguyên bản";

  @override
  String get preview => "Xem trước";

  @override
  String get select => "Chọn";

  @override
  String get unSupportedAssetType => "Định dạng file không được hỗ trợ";

  @override
  String get unableToAccessAll => "Không thể truy cập file trên máy";

  @override
  String get viewingLimitedAssetsTip =>
      "Chỉ xem file và album có thể truy cập được";
}
