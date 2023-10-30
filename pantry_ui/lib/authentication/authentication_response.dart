class AuthenticationResponse {
  late String username;
  late String email;
  late String userImageUrl;
  late int id;
  late int expiry;

  AuthenticationResponse.fromJson(Map<String, dynamic> json) {
    username = json['user']['username'];
    email = json['user']['email'];
    userImageUrl = json['user']['userImageUrl'];
    id = json['user']['id'];
    expiry = json['expiry'];
  }
}
