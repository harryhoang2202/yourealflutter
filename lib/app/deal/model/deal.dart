import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/common/model/address.dart';

import 'package:youreal/services/domain/auth/models/user.dart';

import 'deal_fee.dart';

class Deal {
  late int id;
  String? referralKey;
  String? userId;
  User? user;
  int? realEstateId;
  late String createdTime;
  String? deadline;
  RealEstate? realEstate;
  String? valuationUnit;
  String? price;
  late DealStatus dealStatusId;
  String? dealStatusName;
  List<Allocation>? allocations;
  String? minAllocation;
  String? maxAllocation;
  late String dealCode;
  List<EventDeal>? events;
  String? approvedTime;
  String? adminNote;
  List? dealLeaders;
  late List<DealFee> dealFees;

  Deal({
    required this.id,
    this.referralKey,
    this.userId,
    this.user,
    this.realEstateId,
    required this.createdTime,
    this.deadline,
    this.realEstate,
    this.valuationUnit,
    this.price,
    required this.dealStatusId,
    this.dealStatusName,
    this.allocations,
    this.minAllocation,
    this.maxAllocation,
    this.events,
    required this.dealCode,
    this.approvedTime,
    this.adminNote,
    this.dealLeaders,
  });

  @override
  String toString() {
    return 'Deal{id: $id, referralKey: $referralKey, userId: $userId, user: $user, realEstateId: $realEstateId, createdTime: $createdTime, deadline: $deadline, realEstate: $realEstate, valuationUnit: $valuationUnit, price: $price, dealStatusId: $dealStatusId, dealStatusName: $dealStatusName, allocations: $allocations, minAllocation: $minAllocation, maxAllocation: $maxAllocation, events: $events}';
  }

  Deal.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      referralKey = json['referralKey'].toString();
      userId = json['userId'].toString();
      user = json['user'] != null ? User.fromJson(json['user']) : null;
      realEstateId = json['realEstateId'];
      createdTime = json['createdTime'].toString();
      deadline = json['deadline'].toString();
      realEstate = json['realEstate'] != null
          ? RealEstate.fromJson(json['realEstate'])
          : null;
      valuationUnit = json['valuationUnit'].toString();
      price = json['price'].toString();
      dealStatusId = DealStatus.values[json['dealStatusId']];
      dealStatusName = json['dealStatusName'].toString();

      if (json['allocations'] != null) {
        allocations = [];
        json['allocations'].forEach((v) {
          allocations!.add(Allocation.fromJson(v));
        });
        allocations!.sort((a, b) => b.allocation!.compareTo(a.allocation!));
      }

      minAllocation = json['minAllocation'].toString();
      maxAllocation = json['maxAllocation'].toString();
      dealCode = json['dealCode'].toString();

      List<EventDeal> list = [];
      if (json["events"] != null) {
        json["events"].forEach((_event) {
          list.add(EventDeal.fromJson(_event));
        });
        events = list;
        if (events!.isNotEmpty) {
          events!.sort((a, b) => b.createdDate!.compareTo(a.createdDate!));
        }
        events!.sort((a, b) => b.eventOrder!.compareTo(a.eventOrder!));

        // events!.sort((a, b) {
        //   final dateA = DateTime.parse(a.createdDate!);
        //   final dateB = DateTime.parse(b.createdDate!);
        //   return dateA.isBefore(dateB) ? 1 : 0;
        // });
      }
      approvedTime = json['approvedTime'].toString();
      adminNote = json['adminNote'].toString();
      List<Leader> dealLeader = [];
      if (json["dealLeaders"] != null) {
        json["dealLeaders"].forEach((_leader) {
          dealLeader.add(Leader.fromJson(_leader));
        });
        dealLeaders = dealLeader;
      }

      dealFees = [];
      if (json["dealFee"] != null) {
        final dealFee = json["dealFee"] as List;
        for (final fee in dealFee) {
          dealFees.add(DealFee.fromJson(fee));
        }
      }
    } on Exception catch (e, trace) {
      printLog("$e $trace");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['referralKey'] = referralKey;
    data['userId'] = userId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['realEstateId'] = realEstateId;
    data['createdTime'] = createdTime;
    data['deadline'] = deadline;
    if (realEstate != null) {
      data['realEstate'] = realEstate!.toJson();
    }
    data['valuationUnit'] = valuationUnit;
    data['price'] = price;
    data['dealStatusId'] = dealStatusId.index;
    data['dealStatusName'] = dealStatusName;
    data['allocations'] = allocations;
    data['dealCode'] = dealCode;
    data['minAllocation'] = minAllocation;
    data['maxAllocation'] = maxAllocation;
    data['approvedTime'] = approvedTime;
    data['adminNote'] = adminNote;
    data['dealLeaders'] = dealLeaders;

    return data;
  }
}

class RealEstate {
  int? id;
  int? realEstateTypeId;
  String? realEstateTypeName;
  Info? acreage1;
  Info? acreage2;
  Info? acreage3;
  Info? acreage4;
  Info? fullAddress;
  Info? province;
  Info? district;
  Info? ward;
  Info? note;
  Info? region;
  Address? address;
  Info? position;
  Info? soHK;
  Info? cmnd;
  Info? cccd;
  Info? passport;
  Info? bhyt;
  Info? hsThamDinh;
  Info? size;
  Info? numberOfFloors;
  Info? realEstateImages;
  Info? depositTime;
  Info? price;
  Info? soDo;
  // Info? soHong;
  //  Info? giayChungNhan;
  Info? hopDongMuaBan;
  Info? hopDongGopVon;
  Info? quyetDinhPheDuyet;
  Info? chungTuKhac;
  Info? banTKTC;
  Info? GPXD;
  Info? appraisalFile;
  Info? giaThamDinh;

  List<Info?> get ownerDocuments => [soHK, cmnd, cccd, passport, bhyt];
  List<Info?> get realEstateDocuments => [
        soDo,
        // soHong,
        hopDongMuaBan,
        hopDongGopVon,
        quyetDinhPheDuyet,
        banTKTC,
        GPXD,
        chungTuKhac
      ];
  RealEstate.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      realEstateTypeId = json['realEstateTypeId'];
      realEstateTypeName = json['realEstateTypeName'].toString();
      if (json['info'] != null) {
        json['info'].forEach((v) {
          switch (v["rowId"]) {
            case 1:
              acreage1 = Info.fromJson(v);
              break;
            case 2:
              acreage2 = Info.fromJson(v);
              break;
            case 3:
              acreage3 = Info.fromJson(v);
              break;
            case 4:
              acreage4 = Info.fromJson(v);
              break;
            case 5:
              fullAddress = Info.fromJson(v);
              break;
            case 6:
              note = Info.fromJson(v);
              break;
            case 7:
              region = Info.fromJson(v);
              break;
            case 8:
              ward = Info.fromJson(v);
              break;
            case 9:
              district = Info.fromJson(v);
              break;
            case 10:
              province = Info.fromJson(v);
              break;
            case 11:
              position = Info.fromJson(v);
              break;
            case 12:
              soHK = Info.fromJson(v);
              break;
            case 13:
              cmnd = Info.fromJson(v);
              break;
            case 14:
              cccd = Info.fromJson(v);
              break;
            case 15:
              passport = Info.fromJson(v);
              break;
            case 16:
              bhyt = Info.fromJson(v);
              break;
            case 17:
              hsThamDinh = Info.fromJson(v);
              break;
            case 18:
              size = Info.fromJson(v);
              break;
            case 19:
              numberOfFloors = Info.fromJson(v);
              break;
            case 20:
              realEstateImages = Info.fromJson(v);
              break;
            case 21:
              depositTime = Info.fromJson(v);
              break;
            case 22:
              price = Info.fromJson(v);
              break;
            case 23:
              soDo = Info.fromJson(v);
              break;
            // case 24:
            //   soHong = Info.fromJson(v);
            //   break;

            case 25:
              banTKTC = Info.fromJson(v);
              break;
            case 26:
              GPXD = Info.fromJson(v);
              break;
            case 27:
              appraisalFile = Info.fromJson(v);
              break;
            case 1027:
              hopDongMuaBan = Info.fromJson(v);
              break;
            case 1028:
              hopDongGopVon = Info.fromJson(v);
              break;
            case 1029:
              quyetDinhPheDuyet = Info.fromJson(v);

              break;
            case 1031:
              chungTuKhac = Info.fromJson(v);
              break;
            case 1032:
              giaThamDinh = Info.fromJson(v);
              break;
            default:
              break;
          }
        });
      }
      address = Address(province?.content, district?.content, ward?.content,
          fullAddress?.content);
    } catch (e, trace) {
      printLog("Deal id ${json["id"]} $e $trace");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['realEstateTypeId'] = realEstateTypeId;
    data['realEstateTypeName'] = realEstateTypeName;
    data['info'] = [
      acreage1!.toJson(),
      acreage2!.toJson(),
      acreage3!.toJson(),
      acreage4!.toJson(),
      fullAddress!.toJson(),
      note!.toJson(),
      region!.toJson(),
      ward!.toJson(),
      district!.toJson(),
      province!.toJson(),
      position!.toJson(),
      soHK!.toJson(),
      cmnd!.toJson(),
      cccd!.toJson(),
      passport!.toJson(),
      bhyt!.toJson(),
      hsThamDinh!.toJson(),
      appraisalFile!.toJson(),
    ];
    return data;
  }
}

class Info {
  int? id;
  String? content;
  int? rowId;
  String? rowName;

  Info({this.id, this.content, this.rowId, this.rowName});

  Info.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      content = json['content'];
      rowId = json['rowId'];
      rowName = json['rowName'];
    } catch (e, trace) {
      printLog("$e $trace");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['rowId'] = rowId;
    data['rowName'] = rowName;
    return data;
  }
}

class EventDeal {
  late int id;
  late EventType eventTypeId;
  int? dealId;
  String? eventName;
  int? eventOrder;
  String? createdDate;

  EventDeal(
      {required this.id,
      required this.eventTypeId,
      this.dealId,
      this.eventName,
      this.eventOrder,
      this.createdDate});

  EventDeal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eventTypeId = EventType.values[json['eventTypeId']];
    dealId = json['dealId'];
    eventName = json['eventName'];
    eventOrder = json['eventOrder'];
    createdDate = json['createdTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['eventTypeId'] = eventTypeId.index;
    data['dealId'] = dealId;
    data['eventName'] = eventName;
    data['eventOrder'] = eventOrder;
    data['createdTime'] = createdDate;
    return data;
  }
}

class Allocation {
  int? id;
  String? userId;
  String? firstName;
  String? lastName;
  double? allocation;
  int? paymentStatusId;
  String? paymentStatus;
  int? paymentMethodId;
  String? paymentMethodName;
  Allocation(
      {this.id,
      this.userId,
      this.firstName,
      this.lastName,
      this.allocation = 0,
      this.paymentStatusId = 0,
      this.paymentStatus,
      this.paymentMethodId,
      this.paymentMethodName});

  Allocation.fromJson(Map<String, dynamic> json, {bool isAdmin = false}) {
    id = !isAdmin ? json['id'] : null;
    userId = isAdmin ? json['id'] : json['userId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    allocation = json['allocation'] ?? 0;
    paymentStatusId = json['paymentStatusId'] ?? 0;
    paymentStatus = json['paymentStatus'];
    paymentMethodId = json['paymentMethodId'];
    paymentMethodName = json['paymentMethodName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['allocation'] = allocation;
    data['paymentStatusId'] = paymentStatusId;
    data['paymentStatus'] = paymentStatus;
    data['paymentMethodId'] = paymentMethodId;
    data['paymentMethodName'] = paymentMethodName;
    return data;
  }
}

class Leader {
  late String id;
  String? firstName;
  String? lastName;

  Leader({required this.id, this.firstName, this.lastName});

  Leader.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    return data;
  }
}
