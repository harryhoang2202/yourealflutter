import 'package:intl/message_lookup_by_library.dart';

final messages = MessageLookup();

typedef MessageIfAbsent = String Function(
    String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  @override
  String get localeName => 'vi';

  // static m0(day) => "${day} days ago";

  @override
  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "language": MessageLookupByLibrary.simpleMessage("Ngôn ngữ"),
        "languageSuccess": MessageLookupByLibrary.simpleMessage(
            "Cập nhật ngôn ngữ thành công"),
        "vietnamese": MessageLookupByLibrary.simpleMessage("Tiếng Việt"),
        "english": MessageLookupByLibrary.simpleMessage("Tiếng Anh"),
        "darkTheme": MessageLookupByLibrary.simpleMessage("Chế độ ban đêm"),
      };
}
