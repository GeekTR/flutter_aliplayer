import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_aliplayer_example/config.dart';

class NetWorkUtils {
  static final NetWorkUtils _instance = NetWorkUtils._privateConstructor();

  static NetWorkUtils get instance {
    return _instance;
  }

  Dio _dio;

  NetWorkUtils._privateConstructor() {
    if (_dio == null) {
      _dio = Dio();
      _dio.options.connectTimeout = 5000;
      _dio.options.receiveTimeout = 5000;
      _dio.options.baseUrl = HttpConstant.HTTP_HOST;
    }
  }

  void getHttp(String url, Function successCallback, errorCallback) async {
    Response response = await _dio.get(url);
    Map<String, dynamic> data = response.data;
    if (data.isNotEmpty && data['result'] == 'true') {
      successCallback(data['data']);
    } else {
      errorCallback(data);
    }
  }
}
