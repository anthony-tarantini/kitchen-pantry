import 'dart:io';

import 'package:dio/dio.dart';

import '../authentication/authentication_response.dart';

class ApiClient {
  late Dio client;

  ApiClient._privateConstructor(String baseUrl) {
    baseUrl = baseUrl;
    client = Dio(BaseOptions(baseUrl: baseUrl));
  }

  Map<String, String> getHeaders(String accessToken) {
    return {"Authorization": "Bearer $accessToken"};
  }

  Future<AuthenticationResponse> authenticate(String accessToken) => client
      .get('/users/authenticate', options: Options(headers: getHeaders(accessToken)))
      .then((value) => Future(() => AuthenticationResponse.fromJson(value.data)));

  Future<String> uploadImageUrl(String accessToken, String url) => client
      .post('/v1/images', queryParameters: {'url': url}, options: Options(headers: getHeaders(accessToken)))
      .then((value) => value.data['imageUrl']);

  Future<String> uploadImage(String accessToken, File file) => client
      .post('v1/images', options: Options(headers: getHeaders(accessToken)))
      .then((value) => value.data['imageUrl']);

  static final ApiClient _instance = ApiClient._privateConstructor("http://localhost:8080");

  factory ApiClient() {
    return _instance;
  }
}
