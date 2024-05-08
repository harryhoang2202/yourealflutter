import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:youreal/app/chats/models/group_chat.dart';
import 'package:youreal/app/common/news/index.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/app/deal/model/deal_fee.dart';
import 'package:youreal/app/menu/list_request_role/model/role_requiring.dart';
import 'package:youreal/app/my_deal/model/statistic_model.dart';

import 'package:youreal/app/notification/models/yr_notification.dart';

import 'package:youreal/common/constants/enums.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/common/model/message.dart';

import 'package:youreal/services/domain/auth/models/user.dart';
import 'package:youreal/services/notification_services.dart';

const serverConfig = {
  "type": "app",
  // "url": "dev-api.youreal.vn",
  // "urlToken": "dev-auth.youreal.vn",
  "url": "http://171.244.37.66:8000/",
  "urlToken": "http://171.244.37.66:8080/",
  "mapUrl": "https://maps.googleapis.com/maps/api"
};

const KEY_GOOGLE = "AIzaSyCY-c62GAhI5EEBJ9WywlAmidHaivHvFiQ";
const KEY_MAPBOX =
    "pk.eyJ1IjoiaHVuZ2h1eTIwMDkiLCJhIjoiY2tyb29leTZjOGZuMDJwbXQ1eWExc3ZjaCJ9.JibKClCMNdAuVJMwkOEetg";
const mapboxGeocodingUrl = "https://api.mapbox.com";

class APIServices {
  static final APIServices _instance = APIServices._internal();
  final _notificationServices = NotificationServices();
  int pageSize = 6;

  APIServices._internal();

  late String url;
  late String urlToken;
  late String accessToken;
  late String mapUrl;

  factory APIServices([String? accessToken]) {
    if (accessToken != null) {
      _instance.accessToken = accessToken;
    }
    return _instance;
  }

  void setAppConfig() {
    url = serverConfig["url"]!;
    urlToken = serverConfig["urlToken"]!;
    mapUrl = serverConfig["mapUrl"]!;
  }

  /// ///////////////////////////
  /// ////API FOR ACCOUNT ///////
  /// ///////////////////////////

  ///api login
  Future<User?> loginWithPhoneNumber(
      {required phoneNumber, required password}) async {
    User? user;
    Dio dio = Dio();

    final prefs = await SharedPreferences.getInstance();
    try {
      Map<String, dynamic> data = {
        "grant_type": "password",
        "scope": "api openid profile",
        "username": phoneNumber.replaceFirst("0", "+84"),
        "password": password
      };
      dio.options.contentType = Headers.formUrlEncodedContentType;
      dio.options.headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        'Authorization': 'Basic WW91UmVhbDpue244TntUVkY1JChkYi5x'
      };
      Response response =
          await dio.post("${urlToken}connect/token", data: data);

      if (response.statusCode == 200) {
        accessToken = response.data["access_token"];
        prefs.setString("tokenUser", accessToken);
        user = await getUserInfo(token: accessToken);
        await sendDeviceToken(token: _notificationServices.deviceToken);
        return user;
      } else {
        return null;
      }
    } on DioError catch (e) {
      printLog("[$runtimeType] loginWithPhoneNumber ${e.errorMessage}");
      return null;
    }
  }

  /// api get user info
  Future<User?> getUserInfo({required String token}) async {
    try {
      User? user;
      Dio dio = Dio();
      dio.options.headers = {'Authorization': 'Bearer $token'};
      Response response = await dio.get("${url}account/info");
      if (response.statusCode == 200) {
        accessToken = token;
        user = User.fromJson(response.data);
        return user;
      }
    } on DioError catch (e) {
      printLog("[$runtimeType] getUserInfo ${e.errorMessage}");
    }
    return null;
  }

  /// send code to phone number to verify phone number
  Future<bool> verifyPhoneNumberResetPassword(
      {required String phoneNumber}) async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio.post("${url}account/reset_password",
          data: {"phoneNumber": phoneNumber.replaceFirst("0", "+84")});

      if (response.statusCode == 200) return true;
      return false;
    } catch (e) {
      return false;
    }
  }

  /// change password
  Future<bool> resetPassword(
      {required String phoneNumber,
      required newPassword,
      required verificationCode}) async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio.post("${url}account/password_reset", data: {
        "phoneNumber": phoneNumber.replaceFirst("0", "+84"),
        "password": newPassword,
        "verificationCode": verificationCode,
      });

      if (response.statusCode == 200) return true;
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateInfoAccount(
      {required String firstName,
      required String lastName,
      required String dob}) async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio.put("${url}account", data: {
        "firstName": firstName,
        "lastName": lastName,
        "dateOfBirth": dob
      });

      if (response.statusCode == 200) return true;
      return false;
    } on DioError catch (e) {
      printLog("[$runtimeType] updateInfoAccount ${e.errorMessage}");

      return false;
    }
  }

  /// Change avatar of user
  Future<bool> changeAvatar({required String imagePath}) async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      final file = MultipartFile.fromFileSync(
        imagePath,
        filename: imagePath.split("/").last.replaceAll(" ", ""),
      );
      FormData data = FormData.fromMap({"file": file});

      Response response = await dio.post("${url}account/picture", data: data);

      if (response.statusCode == 200) return true;
      return false;
    } on DioError catch (e) {
      printLog("[$runtimeType] changeAvatar ${e.errorMessage}");
      return false;
    }
  }

  Future<dynamic> verifyPhone(String phone) async {
    try {
      Dio dio = Dio();
      Response response = await dio.post(
        "${url}account/verification_code",
        data: {
          "phoneNumber": phone.trim(),
        },
      );
      return response.data;
    } on DioError catch (e) {
      printLog("[$runtimeType] verifyPhone ${e.errorMessage}");

      if (e.response?.statusCode == 400) {
        return "Số điện thoại không hợp lệ.";
      } else if (e.response?.statusCode == 409) {
        return "Số điện thoại đã được đăng ký bởi người dùng khác.";
      }
    }
  }

  Future<dynamic> createAccount({
    required String phone,
    required String password,
    required String verificationToken,
    required String verificationCode,
    required String createdDateUtc,
  }) async {
    try {
      Dio dio = Dio();
      Response response = await dio.post(
        "${url}account",
        data: {
          "phoneNumber": phone.trim(),
          "password": password.trim(),
          "verificationCode": verificationCode.trim(),
          "verificationToken": verificationToken.trim(),
          "createdDateUtc": createdDateUtc.trim(),
        },
      );
      if (response.statusCode == 200) {
        return {"data": "success"};
      }
    } on DioError catch (e) {
      printLog("[$runtimeType] createAccount ${e.errorMessage}");

      if (e.response?.statusCode == 400) {
        return "Mã xác thực không đúng";
      } else if (e.response?.statusCode == 410) {
        return "Mã xác thực đã hết hiệu lực.";
      } else {
        return "Lỗi hệ thống";
      }
    }
  }

  /// ///////////////////////////
  /// ////// API FOR FILTER /////
  /// ///////////////////////////

  /// api send criteria
  Future<bool> sendCriteria({
    required position,
    required soilType,
    required investmentLimit,
  }) async {
    try {
      String type = "";

      soilType.forEach((item) {
        if (type == "") {
          type = item;
        } else {
          type = "$type," + item;
        }
      });
      Map<String, dynamic> data = {
        "data": [
          {"criteriaId": 1, "value": position},
          {"criteriaId": 2, "value": soilType},
          {"criteriaId": 3, "value": investmentLimit}
        ]
      };
      Dio dio = Dio();

      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
        "Content-Type": "application/json",
      };

      Response response = await dio.post("${url}filter", data: data);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioError catch (e) {
      printLog("[$runtimeType] sendCriteria ${e.errorMessage}");
      return false;
    }
  }

  /// api get criteria
  Future<List<Map<String, dynamic>>> getCriteria() async {
    List<Map<String, dynamic>> list = [];
    Dio dio = Dio();
    try {
      dio.options.headers = {'Authorization': 'Bearer $accessToken'};
      Response response = await dio.get("${url}filter/criteria");
      if (response.statusCode == 200) {
        response.data.forEach((item) {
          list.add(item);
        });
      }
      return list;
    } on DioError catch (e) {
      printLog("[$runtimeType] getCriteria ${e.errorMessage}");
      return list;
    }
  }

  //region API FOR DEAL
  /// ///////////////////////////
  /// ////// API FOR DEAL ///////
  /// ///////////////////////////

  /// Get deal joining
  Future<List<Deal>?> getListDealInvesting(
      {required int page,
      required int sessionId,
      int? pSize,
      List<int> statusIds = const []}) async {
    List<Deal> listDeal = [];
    final pagesize = pSize ?? pageSize;
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio.post(
          "${url}deal/joined?page=$page&pageSize=$pagesize&sessionId=$sessionId",
          data: {"statusIds": statusIds});
      if (response.statusCode == 200) {
        var data = response.data;
        data.forEach((item) async {
          listDeal.add(Deal.fromJson(item));
        });
        listDeal.sort((a, b) => a.approvedTime!.compareTo(b.approvedTime!));
        return listDeal;
      } else {
        return null;
      }
    } on DioError catch (e, trace) {
      printLog(
          "[ERROR][$runtimeType][getListDealInvesting] ${e.errorMessage} $trace");

      return null;
    }
  }

  Future<List<Deal>?> getListDealWaitingAppraisal({
    required int page,
    required sessionId,
  }) async {
    return getListDealApproving(page: page, sessionId: sessionId);
  }

  Future<List<Deal>?> getDealAssignedToValuate({
    List<int> statusIds = const [1],
  }) async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio
          .post("${url}deal/to_be_valuated", data: {"statusIds": statusIds});

      final result =
          (response.data as List).map((e) => Deal.fromJson(e)).toList();

      return result.reversed.toList();
    } on DioError catch (e) {
      printLog("[ERROR][$runtimeType][getDealAssignedToValuate]  $e");

      return null;
    }
  }

  Future<List<Deal>?> getListDealByStatus({
    required int page,
    required sessionId,
    required List<int> status,
  }) async {
    List<Deal> listDeal = [];

    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio.post(
        "${url}deal/all?page=$page&pageSize=$pageSize&sessionId=$sessionId",
        data: {"statusIds": status},
      );
      if (response.statusCode == 200) {
        var data = response.data;
        data.forEach((item) async {
          listDeal.add(Deal.fromJson(item));
        });
        listDeal.sort((a, b) => b.createdTime.compareTo(a.createdTime));
        return listDeal;
      } else {
        return null;
      }
    } on DioError catch (e, trace) {
      printLog(
          "[ERROR][$runtimeType][getListDealApproving] ${e.errorMessage} $trace");

      return null;
    }
  }

  Future<List<Deal>?> getListDealApproving({
    required int page,
    required sessionId,
  }) async =>
      getListDealByStatus(
        page: page,
        sessionId: sessionId,
        status: [
          DealStatus.WaitingApproval.value,
        ],
      );

  Future<List<Deal>?> getListDealCancelledOrRejected({
    required int page,
    required sessionId,
  }) async =>
      getListDealByStatus(
        page: page,
        sessionId: sessionId,
        status: [
          DealStatus.Cancelled.value,
          DealStatus.Rejected.value,
        ],
      );

  Future<List<Deal>?> getListDealNew({
    required int page,
    required sessionId,
  }) async =>
      getListDealByStatus(
        page: page,
        sessionId: sessionId,
        status: [
          DealStatus.WaitingApproval.value,
        ],
      );

  Future<List<Deal>?> getListDealReviewed({
    required int page,
    required sessionId,
  }) async =>
      getListDealByStatus(
        page: page,
        sessionId: sessionId,
        status: [
          DealStatus.WaitingMainInvestor.value,
          DealStatus.WaitingSubInvestor.value,
          DealStatus.FinishedInvestors.value,
        ],
      );

  Future<void> submitAppraisalForm({
    required String link,
    required int realEstateId,
    required double realEstateValuatedValue,
    required int dealId,
  }) async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };

      Response response = await dio.post("${url}valuation/form", data: {
        "realEstateId": realEstateId,
        "dealId": dealId,
        "link": link,
        "realEstateValuatedValue": realEstateValuatedValue
      });
    } on DioError catch (e, trace) {
      printLog(
          "[ERROR][$runtimeType][submitAppraisalForm] ${e.errorMessage} $trace");
      throw Exception("Request API error");
    }
  }

  /// get deal by id
  Future<Deal?> getDealById({required dealId}) async {
    try {
      Dio dio = Dio();
      Deal? deal;
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio.get("${url}deal/$dealId");
      if (response.statusCode == 200 && response.data != null) {
        deal = Deal.fromJson(response.data);
      }
      return deal;
    } on DioError {
      return null;
    }
  }

  /// get deal draft
  Future<List<Deal>?> getDraftDealOfUser(
      {required int page, required sessionId}) async {
    List<Deal> listDeal = [];
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio.post(
          "${url}deal/created?page=$page&pageSize=$pageSize&sessionId=$sessionId",
          data: {
            "statusIds": [1]
          });
      if (response.statusCode == 200) {
        var data = response.data;
        data.forEach((item) async {
          listDeal.add(Deal.fromJson(item));
        });
        return listDeal;
      } else {
        //throw Exception("Request API error");
      }
    } on DioError catch (e, trace) {
      printLog(
          "[ERROR][$runtimeType][getDraftDealOfUser] ${e.errorMessage} $trace");
    }
    return null;
  }

  /// api get deal of user
  Future<List<Deal>?> getDealAppraisalOfUser(
      {required int page, required sessionId}) async {
    List<Deal> listDeal = [];

    return listDeal;
  }

  /// api get deal of user
  Future<List<Deal>> getDealOfUser(
      {required int page,
      required int pageSize,
      required int sessionId,
      List<int> statusIds = const []}) async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio.post(
          "${url}deal/created?page=$page&pageSize=$pageSize&sessionId=$sessionId",
          data: {"statusIds": statusIds});
      List<Deal> listDeal = [];
      var data = response.data;
      data.forEach((item) {
        listDeal.add(Deal.fromJson(item));
      });

      return listDeal;
    } on DioError catch (e, trace) {
      printLog("[ERROR][$runtimeType][getDealOfUser] ${e.errorMessage} $trace");
      rethrow;
    }
  }

  Future<List<Deal>?> getDealUnvaluated(
      {required lastId, required pageSize}) async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio
          .get("${url}deal/unvaluated?pageSize=$pageSize&lastId=$lastId");
      if (response.statusCode == 200) {
        List<Deal> listDeal = [];
        var data = response.data;
        data.forEach((item) {
          listDeal.add(Deal.fromJson(item));
        });
        listDeal.sort((a, b) => b.createdTime.compareTo(a.createdTime));
        return listDeal;
      } else {
        return null;
      }
    } on DioError catch (e, trace) {
      printLog(
          "[ERROR][$runtimeType][getDealUnvaluated] ${e.errorMessage} $trace");
      return null;
    }
  }

  Future<List<Deal>?> getDealToBeValuated(
      {required lastId, required statusIds}) async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio.post("${url}deal/to_be_valuated", data: {
        "statusIds": [statusIds]
      });
      if (response.statusCode == 200) {
        List<Deal> listDeal = [];
        var data = response.data;
        data.forEach((item) {
          listDeal.add(Deal.fromJson(item));
        });

        return listDeal;
      } else {
        return null;
      }
    } on DioError catch (e, trace) {
      printLog(
          "[ERROR][$runtimeType][getDealToBeValuated] ${e.errorMessage} $trace");
      return null;
    }
  }

  /// api create deal
  Future<int?> createDeal({required Map<String, dynamic> data}) async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
        "Content-Type": "application/json",
      };
      Response response = await dio.post("${url}deal", data: data);

      if (response.statusCode == 200) {
        return int.tryParse(response.data["data"].toString());
      } else {
        return null;
      }
    } on DioError catch (e, trace) {
      printLog("[ERROR][$runtimeType][createDeal] ${e.errorMessage} $trace");
      return null;
    }
  }

  /// update deal
  ///
  Future<int?> updateDeal({required Map<String, dynamic> data}) async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
        "Content-Type": "application/json",
      };

      var response = await dio.put("${url}deal", data: data);
      if (response.statusCode == 200) {
        return int.tryParse(response.data["data"].toString());
      }

      // return int.tryParse(response.data["data"].toString()) ?? null;
    } on DioError catch (e, trace) {
      printLog("[ERROR][$runtimeType][updateDeal] ${e.errorMessage} $trace");
      return null;
    }
    return null;
  }

  /// delete deal
  ///
  Future<bool> deleteDeal({required int dealId}) async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio.delete("${url}deal/$dealId");
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioError {
      return false;
    }
  }

  ///Create appraisal_bloc form
  Future<int?> createAppraisalForm(Map data) async {
    Dio dio = Dio();
    dio.options.headers = {
      'Authorization': 'Bearer $accessToken',
    };

    Response response = await dio.post("${url}valuation", data: data);
    return response.data["data"];
  }

  Future<Allocation?> getYourealAdmin() async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio.get(
        "${url}voting/users/admin",
      );
      if (response.statusCode == 200) {
        var admin = Allocation.fromJson(response.data, isAdmin: true);
        return admin;
      }
    } on DioError catch (e) {
      printLog("[$runtimeType] getYourealAdmin ${e.errorMessage}");
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getVoteResult(dealId) async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio.get(
        "${url}voting/deals/$dealId",
      );
      List<Map<String, dynamic>> list = [];
      if (response.statusCode == 200) {
        response.data.forEach((item) {
          list.add(item);
        });
      }
      return list;
    } on DioError catch (e) {
      printLog("[$runtimeType] getVoteResult ${e.errorMessage}");
    }
    return [];
  }

  Future<Allocation?> getLeader({required dealId}) async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio.get(
        "${url}voting/deals/$dealId",
      );
      if (response.statusCode == 200) {
        var leader = Allocation.fromJson(response.data, isAdmin: true);
        return leader;
      }
    } on DioError catch (e) {
      printLog("[$runtimeType] getLeader ${e.errorMessage}");
    }
    return null;
  }

  Future<List<Account>> getListAppraiser() async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio.get(
        "${url}ValuationUnit",
      );
      if (response.statusCode == 200) {
        List<Account> list = [];
        response.data.forEach((item) {
          list.add(Account.fromJson(item));
        });
        // var appraiser = Account.fromJson(response.data);
        return list;
      }
      return [];
    } on DioError catch (e) {
      printLog("[$runtimeType] getListAppraiser ${e.errorMessage}");
      return [];
    }
  }

//#endregion

  //#region Deal fee
  Future addDealFee({
    required String dealId,
    required FeeType type,
    required double value,
    String? note,
  }) async {
    final dio = Dio();
    dio.options.headers["Authorization"] = 'Bearer $accessToken';
    await dio.post("${url}dealfee", data: {
      "dealId": dealId,
      "feeTypeId": type.id,
      "value": value,
      "note": note
    });
  }

  //#endregion

  //#region API FOR NEWS
  /// ///////////////////////////
  /// ////// API FOR NEWS ///////
  /// ///////////////////////////

  Future<News> getNewsDetail({required String newsId}) async {
    final dio = Dio();
    final response = await dio.get("${url}news/$newsId");
    late News result;
    result = News.fromJson(response.data);

    return result;
  }

  Future<List<News>> getOtherNews({
    required int page,
    int pageSize = 6,
  }) async {
    List<News> result = [];
    final dio = Dio();

    final response = await dio.get("${url}news?page=$page&pageSize=$pageSize");
    final data = response.data as List<dynamic>;
    for (final item in data) {
      result.add(News.fromJson(item));
    }
    return result;
  }

  Future<List<News>> getHotNews({
    int page = 1,
    int pageSize = 3,
  }) async {
    List<News> result = [];
    final dio = Dio();
    final response = await dio.get("${url}news?page=$page&pageSize=$pageSize");
    for (final item in response.data as List<dynamic>) {
      result.add(News.fromJson(item));
    }
    return result;
  }

  //#endregion

  /// ///////////////////////////
  /// ////// API FOR CHAT ///////
  /// ///////////////////////////

  /// get list group chat
  Future<List<GroupChat>?> getListGroupChat(
      {required int page, required sessionId}) async {
    try {
      List<Deal>? itemsKeysList =
          await getListDealInvesting(page: page, sessionId: sessionId);
      List<GroupChat> list = [];
      if (itemsKeysList != null) {
        itemsKeysList.removeWhere((deal) =>
            deal.dealStatusId != DealStatus.FinishedInvestors &&
            deal.dealStatusId != DealStatus.Done);
        await Future.wait(itemsKeysList.map((item) async {
          Deal? deal = await getDealById(dealId: item.id);
          if (deal == null) return;
          final latestMessage = await getHistoryGroupChat(
              dealId: deal.id, lastMessageId: 0, pageSize: 1);
          late GroupChat groupChat;
          if (latestMessage.isNullOrEmpty) {
            groupChat = GroupChat.formDeal(deal);
          } else {
            groupChat =
                GroupChat.formDeal(deal, latestMessage: latestMessage.last);
          }
          list.add(groupChat);
        }).toList());
      }

      return list;
    } on DioError catch (e) {
      printLog("[$runtimeType] getListGroupChat ${e.errorMessage}");
      return [];
    }
  }

  /// get history chat
  Future<List<Message>> getHistoryGroupChat(
      {required dealId, required lastMessageId, int pageSize = 15}) async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio.get(
          "${url}chat/deals/$dealId?pageSize=$pageSize&lastMessageId=$lastMessageId");
      final result = (response.data as List)
          .map((e) => Message.fromJson(e, dealId: dealId))
          .toList();
      return result;
    } on DioError catch (e) {
      printLog("[$runtimeType] getHistoryGroupChat ${e.errorMessage}");
      rethrow;
    }
  }

  Future<dynamic> sendChat({required dealId, required content}) async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio
          .post("${url}chat", data: {"dealId": dealId, "content": content});
    } on DioError catch (e) {
      printLog("Send chat message error: ${e.response?.data}");
    }
  }

  /// ///////////////////////////
  /// // API FOR NOTIFICATION ///
  /// ///////////////////////////

  Future<void> markOneAsSeen(String notificationId) async {
    Dio dio = Dio();
    dio.options.headers = {
      'Authorization': 'Bearer $accessToken',
    };
    Response response =
        await dio.put("${url}notification/$notificationId/seen");
  }

  Future<void> markAllSeen() async {
    Dio dio = Dio();
    dio.options.headers = {
      'Authorization': 'Bearer $accessToken',
    };
    Response response = await dio.put("${url}notification/seen_all");
  }

  /// send notification
  // Future<void> sendNotification() async {
  //   Dio dio = Dio();
  //   dio.options.headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization':
  //         'key=AAAAkNZ_-y8:APA91bF_-kRFCNbgNe7SeIxTzaz6ePRJzYa6R2l-gxivuaHg0x1Tb5Cod61eymeCAJuGLLFNP0RKzZwfFL1AmBK-4JrtDpn6TswllPX3nrIzxmmFi-INljqOESmiB6Dd-n0F9dp9gIK7'
  //   };
  //   await dio.post(
  //     "https://fcm.googleapis.com/fcm/send",
  //     data: {
  //       "to":
  //           "dIjxXbtVRG2AH5AW8MBi90:APA91bFQrBA5ldU04L-smbarYxYd4hE0-jRZM6rmp9pC-UZkcj9IZ4e3CwwdCMX9sQI8TjueKS_oR0QllNEoCyE1T3iqg_weqNC8gM7hmV-yuIME5xi4DQHzu7P-0HPvHJvbJb9w35SF",
  //       "notification": {"title": "This is a test title", "body": "OK HELLO"},
  //       "data": {"title": "This is a test title", "body": "OK HELLO"}
  //     },
  //   );
  // }

  Future<void> sendDeviceToken({required String token}) async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      final os = Platform.isAndroid
          ? "Android"
          : Platform.isIOS
              ? "iOS"
              : throw Exception("OS not supported");
      Response response =
          await dio.post("${url}GCM", data: {"token": token, "os": os});
    } on DioError catch (e) {
      printLog("Send device token error: ${e.response?.data}");
    }
  }

  Future<void> deleteDeviceToken({required token}) async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio.delete("${url}GCM", data: {
        "token": token,
      });
    } on DioError catch (e) {
      printLog("Delete device token error: ${e.response?.data}");
    }
  }

  Future<List<YrNotification>> getNotifications({
    required int lastId,
    int pageSize = 20,
  }) async {
    List<YrNotification> result = [];
    final dio = Dio();
    dio.options.headers = {
      'Authorization': 'Bearer $accessToken',
    };
    final response =
        await dio.get("${url}notification?lastId=$lastId&pageSize=$pageSize");
    final data = response.data as List<dynamic>;
    for (final item in data) {
      result.add(YrNotification.fromJson(item));
    }
    return result;
  }
  //#region api for user role
  /// ///////////////////////////
  /// //// API FOR USER ROLE ////
  /// ///////////////////////////

  Future<void> requireRole(
      {required int roleId,
      required String note,
      required List<String?> portraitLinks,
      required List<String?> idLinks,
      List<String?>? financialLinks,
      List<String?>? fileLinks}) async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };

      Map<String, dynamic> data = {
        "roleId": roleId,
        "requesterNote": note,
        "portrait": portraitLinks.join(","),
        "idCard": idLinks.join(","),
      };
      if (financialLinks != null) {
        data.putIfAbsent("financialCapacity", () => financialLinks.join(","));
      }
      if (fileLinks != null) {
        data.putIfAbsent("files", () => fileLinks.join(","));
      }
      Response response = await dio.post("${url}userroles", data: data);
    } on DioError catch (e, trace) {
      printLog("[ERROR][$runtimeType][requireRole] ${e.errorMessage} $trace");
      if (e.response != null &&
          e.response!.statusCode == 400 &&
          e.response!.data != null) {
        throw (Exception(e.response!.data!["message"]));
      }
    }
  }

  Future<List<RoleRequiring>> getAllRoleRequiringForAdmin(
      {int statusId = 0}) async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response<List> response = await dio
          .get("${url}userroles/admins/new_role_requests?statusId=$statusId");
      if (response.statusCode == 200) {
        List<RoleRequiring> result =
            response.data!.map((item) => RoleRequiring.fromJson(item)).toList();
        result.sort((a, b) => b.id!.compareTo(a.id!));
        return result;
      }
      return [];
    } on DioError catch (e, trace) {
      printLog(
          "[ERROR][$runtimeType][getAllRoleRequiringForAdmin] ${e.errorMessage} $trace");

      return [];
    }
  }

  Future<RoleRequiring?> getRoleRequiring({required int requestId}) async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response<Map<String, dynamic>> response =
          await dio.get("${url}userroles/$requestId");
      if (response.statusCode == 200) {
        if (response.data == null) return null;
        RoleRequiring result = RoleRequiring.fromJson(response.data!);

        return result;
      }
    } on DioError catch (e, trace) {
      printLog(
          "[ERROR][$runtimeType][getRoleRequiring] ${e.errorMessage} $trace");
    }
    return null;
  }

  Future<void> cancelRoleRequire({required int requestId}) async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response =
          await dio.delete("${url}userroles/requests/$requestId");
      if (response.statusCode == 200) {
      } else if (response.statusCode == 400) {
        throw Exception("Request API error");
      }
    } on DioError catch (e, trace) {
      printLog(
          "[ERROR][$runtimeType][cancelRoleRequire] ${e.errorMessage} $trace");
      if (e.response != null &&
          e.response!.statusCode == 400 &&
          e.response!.data != null) {
        printLog("""
        Hủy thất bại
        Lỗi: ${e.response!.data!["message"]}
            """);
      }
    }
  }

  Future<void> approvedRequest(
      {required String id, required int statusId, String? adminNote}) async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio.put(
          "${url}userroles/admins/new_role_requests",
          data: {"id": id, "statusId": statusId, "adminNote": adminNote});
      if (response.statusCode == 200) {
        printLog("Hủy thành công");
      } else if (response.statusCode == 400) {
        throw Exception("Request API error");
      }
    } on DioError catch (e, trace) {
      printLog(
          "[ERROR][$runtimeType][approvedRequest] ${e.errorMessage} $trace");
      if (e.response != null &&
          e.response!.statusCode == 400 &&
          e.response!.data != null) {
        printLog("""
        Lỗi: ${e.response!.data!["message"]}
            """);
      }
    }
  }

  Future<String> upFile(
      {required String path, required FileUploadType type}) async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      FormData data = FormData();
      final file = await MultipartFile.fromFile(
        path,
        filename: path.split("/").last,
      );
      data.files.add(MapEntry("file", file));
      Response<Map<String, dynamic>> response =
          await dio.post("${url}upload/${type.url}", data: data);
      return response.data!["data"].toString();
    } catch (e, trace) {
      printLog("[ERROR][$runtimeType][upFile] $e $trace");
      rethrow;
    }
  }

  //#endregion

  /// ///////////////////////////
  /// //////// OTHER API ////////
  /// ///////////////////////////

  /// search address
  Future<void> searchPlace(keyword) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/textsearch/json?query=${Uri.encodeQueryComponent(keyword)}&key=$KEY_GOOGLE";

    try {
      printLog("search >>: $url");
      Dio dio = Dio();
      var res = await dio.get(url);
    } on DioError catch (e) {
      printLog("[$runtimeType] searchPlace ${e.errorMessage}");
    }
  }

  Future<List<String>?> fetchPredictions(String input) async {
    try {
      Dio dio = Dio();

      String queryParams =
          "input=$input&types=address&language=vi&components=country:vn&key=$KEY_GOOGLE&sessiontoken=${const Uuid().v4}";
      String requestPath = "place/autocomplete";
      String requestUrl = "$mapUrl/$requestPath/json?$queryParams";
      var res = await dio.get(requestUrl);

      if (res.statusCode == 200) {
        return (res.data["predictions"] as List)
            .map((item) => item["description"].toString())
            .toList();
      }
    } on DioError catch (e) {
      printLog("[$runtimeType] fetchPredictions ${e.errorMessage}");

      throw Exception(e);
    }
    return null;
  }

  Future<List<double>?> geoCoding(String address) async {
    try {
      Dio dio = Dio();

      String queryParams = "access_token=$KEY_MAPBOX&country=vn&limit=1";
      String requestPath = "geocoding/v5/mapbox.places";
      String requestUrl =
          "$mapboxGeocodingUrl/$requestPath/${Uri.encodeComponent(address)}.json?$queryParams";

      Response res = await dio.get(requestUrl);
      if (res.statusCode == 200) {
        final data = res.data;

        if (data!["features"].length > 0) {
          final latLng = data!["features"][0]["center"];
          return [latLng[1], latLng[0]];
        }
      }
    } on DioError catch (e) {
      printLog("[$runtimeType] geoCoding ${e.errorMessage}");
    }
    return null;
  }

  Future<List<dynamic>?> getProvinces() async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio.get("${url}useraddress/first_levels");
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (e) {
      printLog("[$runtimeType] getProvinces ${e.errorMessage}");
    }
    return null;
  }

  Future<List<dynamic>?> getDistrict(String province) async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio.post("${url}useraddress/second_levels",
          data: {"firstLevel": province});
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (e) {
      printLog("[$runtimeType] getDistrict ${e.errorMessage}");
    }
    return null;
  }

  Future<List<dynamic>?> getWard(String province, String district) async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio.post("${url}useraddress/third_levels",
          data: {"firstLevel": province, "secondLevel": district});
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (e) {
      printLog("[$runtimeType] getWard ${e.errorMessage}");
    }
    return null;
  }

  Future<void> uploadAddressUser(String subdivisionId, String address) async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      await dio.post("${url}useraddress",
          data: {"subdivisionId": subdivisionId, "address": address});
    } on DioError catch (e) {
      printLog("[$runtimeType] uploadAddressUser ${e.errorMessage}");
    }
  }

  Future<List<String>> getPreviewLinks({required List<String> paths}) async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      final body = {"links": paths};
      final response = await dio.post("${url}upload/preview_links", data: body);
      final result =
          (response.data!["data"] as List).map((e) => e.toString()).toList();
      return result;
    } catch (e, trace) {
      printLog("[ERROR][$runtimeType][upFile] $e $trace");
      rethrow;
    }
  }

  Future<StatisticModel?> getDataStatistics() async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      final response = await dio.get("${url}deal/stats");
      if (response.statusCode == 200) {
        return StatisticModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      printLog('[ERROR] getDataStatistics: $e');
      return null;
    }
  }
}
