import 'package:dio/dio.dart';

extension ResponseEx on Response {
  bool isSuccess() {
    if (statusCode == null) return false;
    return 200 <= statusCode! && statusCode! <= 299;
  }
}
