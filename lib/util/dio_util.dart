import 'package:dio/dio.dart';

class RestClient {
  static Dio get instance {
    return Dio(BaseOptions())
      ..interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
  }
}
