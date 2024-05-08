import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'jwt_interceptor.dart';

const serverConfig = {
  "type": "app",
  // "url": "dev-api.youreal.vn",
  // "urlToken": "dev-auth.youreal.vn",
  "url": "http://171.244.37.66:8000/",
  "urlToken": "http://171.244.37.66:8080/",
  "mapUrl": "https://maps.googleapis.com/maps/api"
};

@singleton
class ApiRemote {
  VoidCallback? _onExpireToken;
  Future<dynamic> Function()? _refreshToken;
  Future<String> Function()? _token;
  init({
    required VoidCallback onExpireToken,
    Future<dynamic> Function()? refreshToken,
    Future<String> Function()? token,
  }) {
    _onExpireToken = onExpireToken;
    _refreshToken = refreshToken;
    _token = token;
  }

  Dio get _dio => _initDio();
  late final Dio _dioToken = _intiDioToken();
  Dio _initDio() {
    final Dio dio = Dio();

    const config = serverConfig;

    dio
      ..options.baseUrl = config["url"] as String
      // ..options.followRedirects = false
      ..options.contentType = Headers.formUrlEncodedContentType
      ..options.headers = {
        'Content-Type': Headers.formUrlEncodedContentType,
        // "Accept": "application/json",
      }
      ..interceptors.add(PrettyDioLogger(
        request: true,
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        error: true,
      ))
      ..interceptors.add(
          JWTInterceptor(_onExpireToken, _refreshToken, _dioToken, _token));
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      // You can verify the certificate here
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      return client;
    };

    return dio;
  }

  Dio _intiDioToken() {
    final Dio dio = Dio();

    const config = serverConfig;

    dio
      ..options.baseUrl = config["url"] as String
      // ..options.connectTimeout = config.connectionTimeout
      // ..options.receiveTimeout = config.receiveTimeout
      // ..options.followRedirects = false
      ..options.headers = {
        // 'Content-Type': 'application/json; charset=utf-8',
        'Content-Type': Headers.formUrlEncodedContentType,
        // "Accept": "application/json",
      }
      ..interceptors.add(PrettyDioLogger(
        request: true,
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: false,
        error: true,
      ))
      ..interceptors.add(QueuedInterceptorsWrapper());
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      // You can verify the certificate here
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    return dio;
  }

  Future<Response<T>> get<T>(
    String endpoint, {
    String? url,
    Function(Map<String, dynamic> data)? parse,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgres,
  }) async {
    try {
      var dio = _dio;
      if (url != null) dio.options.baseUrl = url;
      final response = await dio.get<T>(
        endpoint,
        queryParameters: query,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgres,
      );

      // return BaseResponse.fromJson(
      //   response.data,
      //   parse: (data) => parse?.call(data),
      //   response: response,
      // );
      return response;
    } on DioError catch (e) {
      return e.response as Response<T>? ??
          Response<T>(
            requestOptions: e.requestOptions,
            statusCode: 500,
          );
    }
  }

  Future<Response<T>> post<T>(
    String endpoint, {
    String? url,
    Function(Map<String, dynamic> data)? parse,
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var dio = _dio;
      if (url != null) dio.options.baseUrl = url;
      final response = await dio.post<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
        options: options,
      );

      return response;
    } on DioError catch (e) {
      return e.response as Response<T>? ??
          Response<T>(
            requestOptions: e.requestOptions,
            statusCode: 500,
          );
    }
  }

  Future<Response<T>> put<T>(
    String endpoint, {
    String? url,
    Function(Map<String, dynamic> data)? parse,
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var dio = _dio;
      if (url != null) dio.options.baseUrl = url;
      final response = await dio.put<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
        options: options,
      );

      return response;
    } on DioError catch (e) {
      return e.response as Response<T>? ??
          Response<T>(
            requestOptions: e.requestOptions,
            statusCode: 500,
          );
    }
  }

  Future<Response<T>> patch<T>(
    String endpoint, {
    String? url,
    Function(Map<String, dynamic> data)? parse,
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var dio = _dio;
      if (url != null) dio.options.baseUrl = url;
      final response = await dio.patch<T>(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
        options: options,
      );

      return response;
    } on DioError catch (e) {
      return e.response as Response<T>? ??
          Response<T>(
            requestOptions: e.requestOptions,
            statusCode: 500,
          );
    }
  }
}
