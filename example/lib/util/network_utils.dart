import 'package:dio/dio.dart';
import 'package:flutter_aliplayer_example/config.dart';

class NetWorkUtils {
  static final NetWorkUtils _instance = NetWorkUtils._privateConstructor();

  static NetWorkUtils get instance {
    return _instance;
  }

  static Dio _dio;

  NetWorkUtils._privateConstructor() {
    if (_dio == null) {
      _dio = Dio();
      _dio.options.connectTimeout = 5000;
      _dio.options.receiveTimeout = 5000;
      _dio.options.baseUrl = HttpConstant.HTTP_HOST;  
    }
  }

  void getHttp(String url,
      {Map<String, String> params,
      Function successCallback,
      Function errorCallback}) async {
    Response response = await _dio.get(url, queryParameters: params);
    Map<String, dynamic> data = response.data;
    if (data.isNotEmpty && data['result'] == 'true') {
      successCallback(data['data']);
    } else {
      errorCallback(data);
    }
  }

}
