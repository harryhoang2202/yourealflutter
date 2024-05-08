import 'package:dio/dio.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/common/constants/extensions.dart';
import 'package:youreal/common/constants/general.dart';
import 'package:youreal/services/services_api.dart';

class HomeService {
  static final _accessToken = APIServices().accessToken;
  static final _url = APIServices().url;
  static final _pageSize = APIServices().pageSize;
  static Future<List<Deal>?> getListDealSuggest(
      {required int page, required sessionId}) async {
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $_accessToken',
      };
      Response response = await dio.get(
          "${_url}deal/recommended?page=$page&pageSize=$_pageSize&sessionId=$sessionId");
      if (response.statusCode == 200) {
        List<Deal> listDeal = [];
        var data = response.data;
        data.forEach((item) async {
          listDeal.add(Deal.fromJson(item));
        });
        listDeal.sort((a, b) => b.approvedTime!.compareTo(a.approvedTime!));
        return listDeal;
      } else {
        return null;
      }
    } on DioError catch (e, trace) {
      printLog("[ERROR][getListDealSuggest] ${e.errorMessage} $trace");
      return null;
    }
  }

  static Future<List<Deal>?> getListDealInvesting(
      {required int page,
      required int sessionId,
      int? pSize,
      List<int> statusIds = const []}) async {
    List<Deal> listDeal = [];
    final pagesize = pSize ?? _pageSize;
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $_accessToken',
      };
      Response response = await dio.post(
          "${_url}deal/joined?page=$page&pageSize=$pagesize&sessionId=$sessionId",
          data: {"statusIds": statusIds});
      if (response.statusCode == 200) {
        var data = response.data;
        data.forEach((item) async {
          listDeal.add(Deal.fromJson(item));
        });
        listDeal.sort((a, b) => b.approvedTime!.compareTo(a.approvedTime!));
        return listDeal;
      } else {
        return null;
      }
    } on DioError catch (e, trace) {
      printLog("[ERROR][getListDealInvesting] ${e.errorMessage} $trace");

      return null;
    }
  }

  static Future<List<Deal>?> getListDealNew(
      {required int page,
      required int sessionId,
      int? pSize,
      List<int> statusIds = const [4, 5]}) async {
    List<Deal> listDeal = [];
    final pagesize = pSize ?? _pageSize;
    try {
      Dio dio = Dio();
      dio.options.headers = {
        'Authorization': 'Bearer $_accessToken',
      };
      Response response = await dio.get(
        "${_url}deal/approved?page=$page&pageSize=$pagesize&&dealStatusIds=4&dealStatusIds=5",
      );
      if (response.statusCode == 200) {
        var data = response.data;
        data.forEach((item) async {
          listDeal.add(Deal.fromJson(item));
        });
        listDeal.sort((a, b) => b.approvedTime!.compareTo(a.approvedTime!));
        return listDeal;
      } else {
        return null;
      }
    } on DioError catch (e, trace) {
      printLog("[ERROR][getListDealInvesting] ${e.errorMessage} $trace");

      return null;
    }
  }
}
