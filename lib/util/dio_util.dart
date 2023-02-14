import 'package:dio/dio.dart';

class RestClient {
  static Dio get instance {
    return Dio(BaseOptions());
  }
}
