import 'package:dio/dio.dart';

import 'user_response.dart';

Future<UserResponse> authenticate(String accessToken) => Dio()
    .get('http://localhost:8080/users/authenticate',
        options: Options(headers: {"Authorization": "Bearer $accessToken"}))
    .then((value) => Future(() => UserResponse.fromJson(value.data)));

Future<String> uploadImageUrl(String accessToken, String url) => Dio()
    .post('http://localhost:8080/v1/images',
        queryParameters: {'url': url}, options: Options(headers: {"Authorization": "Bearer $accessToken"}))
    .then((value) => value.data['imageUrl']);
