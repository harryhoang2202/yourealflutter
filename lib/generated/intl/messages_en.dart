import 'package:intl/message_lookup_by_library.dart';

final messages = MessageLookup();

typedef MessageIfAbsent = String Function(
    String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  @override
  String get localeName => 'en';

  // static m0(day) => "${day} days ago";

  @override
  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "language": MessageLookupByLibrary.simpleMessage("Language"),
        "languageSuccess": MessageLookupByLibrary.simpleMessage(
            "The Language is updated successfully"),
        "vietnamese": MessageLookupByLibrary.simpleMessage("Vietnam"),
        "english": MessageLookupByLibrary.simpleMessage("English"),
        "darkTheme": MessageLookupByLibrary.simpleMessage("Dark Theme"),
      };
}
