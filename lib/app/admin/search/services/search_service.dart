import 'package:dio/dio.dart';
import 'package:youreal/app/deal/model/deal.dart';
import 'package:youreal/services/services_api.dart';

class SearchService {
  Future<List<Deal>?> search(String query) async {
    Dio dio = Dio();
    List<Deal> listDeal = [];
    dio.options.headers = {
      'Authorization': 'Bearer ${APIServices().accessToken}',
    };
    Response response =
        await dio.post("${APIServices().url}search", data: {"query": query});

    if (response.statusCode == 200 && response.data != null) {
      for (var item in response.data) {
        listDeal.add(Deal.fromJson(item));
      }
    }
    return listDeal;
  }
}
