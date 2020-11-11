import 'package:dio/dio.dart';
import 'package:flutter_aliplayer_example/config.dart';

typedef HttpSuccessCallback<T> = void Function(dynamic data);

typedef HttpFailureCallback = void Function(dynamic data);

typedef T JsonParse<T>(String data);

class NetWorkUtils {
  static final NetWorkUtils _instance = NetWorkUtils._privateConstructor();

  static NetWorkUtils get instance {
    return _instance;
  }

  Dio _dio;

  NetWorkUtils._privateConstructor() {
    if (_dio == null) {
      _dio = Dio();
      _dio.options.baseUrl = HttpConstant.HTTP_HOST;
    }
  }

  void getHttp(String url) async {
    Response response = await _dio.get(url);
    Map<String, dynamic> data = response.data;
    if (data.isNotEmpty && data['result'] == 'true') {
      print("success");
    } else {
      print('error');
    }
  }
}
