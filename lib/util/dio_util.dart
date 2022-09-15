import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:dio_http_formatter/dio_http_formatter.dart';

import 'app_config.dart';

class RestClient {
  static Dio getInstance() {
    final DioCacheInterceptor cacheInterceptor = DioCacheInterceptor(
      options: CacheOptions(
        store: HiveCacheStore(AppConfig.getString("applicationPath")),
        policy: CachePolicy.request,
        hitCacheOnErrorExcept: [],
        maxStale: const Duration(days: 2),
        priority: CachePriority.high,
      ),
    );
    final Dio dio = Dio(BaseOptions());
    dio.interceptors.add(cacheInterceptor);
    dio.interceptors.add(HttpFormatter());
    return dio;
  }
}
