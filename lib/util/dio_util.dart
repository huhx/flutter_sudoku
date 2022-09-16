import 'package:dio/dio.dart';
import 'package:dio_http_formatter/dio_http_formatter.dart';

class RestClient {
  static Dio getInstance() {
    return Dio(BaseOptions())..interceptors.add(HttpFormatter());
  }
}
