import 'package:equatable/equatable.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/common/model/message.dart';

import '../../deal/model/deal.dart';

class GroupChat extends Equatable {
  late int id;
  late String name;
  Message? latestMessage;
  late int numberMessageWait;
  late int numberMember;
  late List<Allocation> allocations;

  GroupChat.formDeal(Deal? deal, {Message? latestMessage}) {
    try {
      if (deal != null) {
        id = deal.id;
        name = "Nhóm BĐS Deal #${deal.id}";
        this.latestMessage = latestMessage;
        numberMember = deal.allocations!.length;
        numberMessageWait = 10;
        allocations = deal.allocations!;
      }
    } catch (e) {
      printLog("[$runtimeType] $e");
    }
  }

  @override
  String toString() {
    return 'GroupChat{id: $id, name: $name, message: $latestMessage, numberMessageWait: $numberMessageWait, numberMember: $numberMember}';
  }

  @override
  List<Object?> get props => [
        id,
        name,
        latestMessage,
        numberMessageWait,
        numberMember,
        allocations,
      ];

  GroupChat copyWith({
    int? id,
    String? name,
    Message? latestMessage,
    int? numberMessageWait,
    int? numberMember,
    List<Allocation>? allocations,
  }) {
    return GroupChat(
      id: id ?? this.id,
      name: name ?? this.name,
      latestMessage: latestMessage ?? this.latestMessage,
      numberMessageWait: numberMessageWait ?? this.numberMessageWait,
      numberMember: numberMember ?? this.numberMember,
      allocations: allocations ?? this.allocations,
    );
  }

  GroupChat({
    required this.id,
    required this.name,
    this.latestMessage,
    required this.numberMessageWait,
    required this.numberMember,
    required this.allocations,
  });
}
