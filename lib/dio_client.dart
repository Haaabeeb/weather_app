import 'package:dio/dio.dart';
//https://api.openweathermap.org/data/2.5/weather?q=salfit&appid=6b83144fc41cf8a2f4878256819f60c7&units=metric
//Configuration & Setup class
class AppException implements Exception {
  final String message;
  AppException(this.message);
  String toString() => message;
}
Dio createDioClient() {
  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.openweathermap.org/data/2.5',
      connectTimeout: const Duration(seconds: 15)
  ));

  dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {

      options.queryParameters.addAll({'appid': '6b83144fc41cf8a2f4878256819f60c7', 'units': 'metric'});
      handler.next(options);
    },
    onError: (err, handler) {
      final code = err.response?.statusCode;
      final msg = code == 404 ? 'City not found.' :
      code == 401 ? 'Invalid API key.' :
      err.type == DioExceptionType.cancel ? 'Cancelled.' : 'Network error.';

      handler.reject(DioException(requestOptions: err.requestOptions, error: AppException(msg)));
    },
  ));

  return dio;
}