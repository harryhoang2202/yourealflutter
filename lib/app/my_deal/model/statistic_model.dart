import 'dart:developer';

import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/general.dart';

class StatisticModel {
  late StatisticDealCreated created;
  late StatisticDealJoined joined;

  StatisticModel({required this.created, required this.joined});

  StatisticModel.fromJson(json) {
    var list = [];
    json['created'].forEach((item) {
      list.add(item);
    });
    created = StatisticDealCreated.fromJson(list);
    var list2 = [];
    json['joined'].forEach((item) {
      list2.add(item);
    });
    joined = StatisticDealJoined.fromJson(list2);
  }
}

class StatisticDealJoined {
  late int numberFinishedInvestorsDeal = 0;
  late int numberCancelledDeal = 0;
  late int numberDoneDeal = 0;

  StatisticDealJoined.fromJson(json) {
    try {
      json.forEach((item) {
        var dealStatusId = item['dealStatusId'];

        switch (DealStatus.values[dealStatusId]) {
          case DealStatus.FinishedInvestors:
            numberFinishedInvestorsDeal = item['count'] ?? 0;
            break;
          case DealStatus.Cancelled:
            numberCancelledDeal = item['count'] ?? 0;
            break;
          case DealStatus.Done:
            numberDoneDeal = item['count'] ?? 0;
            break;
          default:
            break;
        }
      });
    } catch (e) {
      printLog('[ERROR] get StatisticCreateDeal: $e');
    }
  }
}

class StatisticDealCreated {
  late int numberDraftDeal = 0;
  late int numberWaitingVerificationDeal = 0;
  late int numberWaitingApprovalDeal = 0;
  late int numberWaitingMainInvestorDeal = 0;
  late int numberWaitingSubInvestorDeal = 0;
  late int numberFinishedInvestorsDeal = 0;
  late int numberCancelledDeal = 0;
  late int numberDoneDeal = 0;
  late int numberRejectedDeal = 0;

  StatisticDealCreated.fromJson(json) {
    try {
      json.forEach((item) {
        var dealStatusId = item['dealStatusId'];
        switch (DealStatus.values[dealStatusId]) {
          case DealStatus.Draft:
            numberDraftDeal = item['count'] ?? 0;
            break;
          case DealStatus.WaitingVerification:
            numberWaitingVerificationDeal = item['count'] ?? 0;
            break;
          case DealStatus.WaitingApproval:
            numberWaitingApprovalDeal = item['count'] ?? 0;
            break;
          case DealStatus.WaitingMainInvestor:
            numberWaitingMainInvestorDeal = item['count'] ?? 0;
            break;
          case DealStatus.WaitingSubInvestor:
            numberWaitingSubInvestorDeal = item['count'] ?? 0;
            break;
          case DealStatus.FinishedInvestors:
            numberFinishedInvestorsDeal = item['count'] ?? 0;
            break;
          case DealStatus.Cancelled:
            numberCancelledDeal = item['count'] ?? 0;
            break;
          case DealStatus.Done:
            numberDoneDeal = item['count'] ?? 0;
            break;
          case DealStatus.Rejected:
            numberRejectedDeal = item['count'] ?? 0;
            break;
          default:
            break;
        }
      });
    } catch (e) {
      printLog('[ERROR] get StatisticCreateDeal: $e');
    }
  }
}

class StatisticItem {
  late int dealStatusId;
  late int count;

  StatisticItem({required this.dealStatusId, required this.count});

  StatisticItem.fromJson(json) {
    dealStatusId = json['dealStatusId'];
    count = json['count'] ?? 0;
  }
}
