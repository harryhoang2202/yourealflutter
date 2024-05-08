part of '../index.dart';

class FilterService {
  Future<Tuple2<List<OtpCheckModel>, List<OtpCheckModel>>>
      getListLeader() async {
    APIServices().accessToken;
    Dio dio = Dio();
    List<String> listLeader = [
      "Leader A",
      "Leader B",
      "Leader C",
      "Leader D",
      "Leader E",
      "Leader F",
    ];
    var listLeader1 = <OtpCheckModel>[];
    var listLeader2 = <OtpCheckModel>[];
    for (int i = 0; i < listLeader.length; i++) {
      if (i % 2 == 0) {
        listLeader1.add(OtpCheckModel(id: i.toString(), name: listLeader[i]));
      } else {
        listLeader2.add(OtpCheckModel(id: i.toString(), name: listLeader[i]));
      }
    }
    return Tuple2(listLeader1, listLeader2);
  }

  Future<Tuple2<List<OtpCheckModel>, List<OtpCheckModel>>>
      getListSoilType() async {
    Dio dio = Dio();
    var listSoilType = [
      {"id": 1, "name": "Nhà ở/ đất ở riêng lẻ"},
      {"id": 2, "name": "Đất nông nghiệp"},
      {"id": 3, "name": "Dự án nhà ở"},
      {"id": 4, "name": "Đất sản xuất kinh doanh"},
      {"id": 5, "name": "Căn hộ chung cư"},
      {"id": 6, "name": "Khác"}
    ];
    var list1 = <OtpCheckModel>[];
    var list2 = <OtpCheckModel>[];
    for (int i = 0; i < listSoilType.length; i++) {
      if (i % 2 == 0) {
        list1.add(OtpCheckModel(
          id: listSoilType[i]["id"].toString(),
          name: listSoilType[i]["name"].toString(),
        ));
      } else {
        list2.add(OtpCheckModel(
          id: listSoilType[i]["id"].toString(),
          name: listSoilType[i]["name"].toString(),
        ));
      }
    }

    return Tuple2(list1, list2);
  }

  /// api get filter
  Future<Map<String, dynamic>?> getFilter() async {
    Dio dio = Dio();
    try {
      dio.options.headers = {
        'Authorization': 'Bearer ${APIServices().accessToken}'
      };
      Response response = await dio.get("${APIServices().url}filter");
      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } on DioError catch (e) {
      printLog("[$runtimeType] getFilter ${e.errorMessage}");

      return null;
    }
  }

  Future<bool> sendCriteria({
    required Province position,
    required List<OtpCheckModel> soilType,
    required double investmentMin,
    required double investmentMax,
  }) async {
    try {
      List<String> types = soilType.map((e) => e.name).toList();

      Map<String, dynamic> data = {
        "data": [
          {
            "criteriaId": 1,
            "value": jsonEncode({"id": position.id, "name": position.name})
          },
          {"criteriaId": 2, "value": types.join(',')},
          {"criteriaId": 3, "value": "$investmentMin,$investmentMax"}
        ]
      };
      Dio dio = Dio();

      dio.options.headers = {
        'Authorization': 'Bearer ${APIServices().accessToken}',
        "Content-Type": "application/json",
      };

      Response response =
          await dio.post("${APIServices().url}filter", data: data);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on DioError catch (e) {
      printLog("[$runtimeType] sendCriteria ${e.errorMessage}");
      return false;
    }
  }
}
