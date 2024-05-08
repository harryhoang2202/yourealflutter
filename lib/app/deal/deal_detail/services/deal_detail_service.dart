import 'package:dio/dio.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/services/services_api.dart';

class DealDetailService {
  static Future<Deal?> getDealById({required dealId}) async {
    final accessToken = APIServices().accessToken;
    final url = APIServices().url;
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
    } on DioError catch (e) {
      printLog(e.error);
      return null;
    }
  }

  static Future<bool> rejectDeal({
    required dealId,
    required String message,
  }) async {
    final accessToken = APIServices().accessToken;
    final url = APIServices().url;
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio
          .put("${url}deal/$dealId/reject", data: {"message": message});
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioError catch (e) {
      printLog(e.error);
      return false;
    }
  }

  static Future<bool> approvedDeal({required dealId}) async {
    final accessToken = APIServices().accessToken;
    final url = APIServices().url;
    try {
      Dio dio = Dio();

      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio.put("${url}deal/$dealId/approve");
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioError catch (e) {
      printLog(e.error);
      return false;
    }
  }

  static Future<bool> assignAppraiser({
    required realEstateId,
    required valuationUnitId,
  }) async {
    final accessToken = APIServices().accessToken;
    final url = APIServices().url;
    try {
      Dio dio = Dio();

      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio.post("${url}valuation/request", data: {
        "realEstateId": realEstateId,
        "valuationUnitId": valuationUnitId
      });
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioError catch (e) {
      printLog(e.error);
      return false;
    }
  }

  static Future<bool> joinDeal({
    required String dealId,
    required String allocation,
    required String paymentMethodId,
  }) async {
    final accessToken = APIServices().accessToken;
    final url = APIServices().url;
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio.post("${url}deal/join", data: {
        "dealId": dealId,
        "allocation": allocation,
        "paymentMethodId": paymentMethodId
      });
      if (response.statusCode == 200) return true;

      return false;
    } on DioError catch (e) {
      printLog("joinDeal ${e.errorMessage}");

      return false;
    }
  }

  static Future<bool> voteLeader({
    required String dealId,
    required String userId,
  }) async {
    final accessToken = APIServices().accessToken;
    final url = APIServices().url;
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio.post(
        "${url}voting/deals/$dealId/users/$userId",
      );
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioError catch (e) {
      printLog("voteLeader ${e.errorMessage}");
      return false;
    }
  }

  static Future<bool> sendDealEvent(
      {required dealId, required eventTypeId}) async {
    final accessToken = APIServices().accessToken;
    final url = APIServices().url;
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio.post("${url}dealevent",
          data: {"dealId": dealId, "eventTypeId": eventTypeId});
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioError catch (e) {
      printLog("update status deal ${e.errorMessage}");
      return false;
    }
  }

  static Future<bool> closeDeal({required dealId}) async {
    final accessToken = APIServices().accessToken;
    final url = APIServices().url;
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio.put("${url}deal/$dealId/status/6");

      if (response.statusCode == 200) return true;
      return false;
    } on DioError catch (e) {
      printLog("closeDeal ${e.errorMessage}");
      return false;
    }
  }

  static Future<bool> paymentStatus(
      {required dealId,
      required allowcationId,
      required paymentStatusId}) async {
    final accessToken = APIServices().accessToken;
    final url = APIServices().url;
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio.put(
          "${url}deal/$dealId/allowcations/$allowcationId/status/$paymentStatusId");

      if (response.statusCode == 200) return true;
      return false;
    } on DioError catch (e) {
      printLog("paymentStatus ${e.errorMessage}");
      return false;
    }
  }

  static Future<bool> reOpenDeal(
      {required dealId, required extendTimeInSecond, required reason}) async {
    final accessToken = APIServices().accessToken;
    final url = APIServices().url;
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
      Response response = await dio.put(
        "${url}deal/$dealId/extend",
        data: {
          "extendTimeInSecond": extendTimeInSecond,
          "reason": reason,
          "newStatusId": "4"
        },
      );

      if (response.statusCode == 200) return true;
      return false;
    } on DioError catch (e) {
      printLog("paymentStatus ${e.errorMessage}");
      return false;
    }
  }
}
