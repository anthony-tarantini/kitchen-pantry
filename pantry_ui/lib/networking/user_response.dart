class UserResponse {
  late String username;
  late String email;
  late String userImageUrl;
  late int id;

  UserResponse.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    userImageUrl = json['userImageUrl'];
    id = json['id'];
  }
}
