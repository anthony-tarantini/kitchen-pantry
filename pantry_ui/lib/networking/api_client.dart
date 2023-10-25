import 'package:dio/dio.dart';

class UserResponse {
  int userId;

  UserResponse({required this.userId}){}
}

Future<UserResponse> authenticate(String accessToken) {
  final dio = Dio();
  dio.interceptors.add(LogInterceptor());
  return dio.get<UserResponse>('http://localhost:8080/users/authenticate',
      options: Options(headers: {
        "Authorization": "Bearer $accessToken"
      })).then((value) => Future.value(value.data));
}
