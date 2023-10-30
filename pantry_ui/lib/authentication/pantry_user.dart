class PantryUser {
  late String? displayName;
  late String email;
  late String? userImageUrl;
  late String accessToken;
  late int userId;
  late int expiry;

  PantryUser(
      {required this.displayName,
      required this.email,
      required this.userImageUrl,
      required this.accessToken,
      required this.userId,
      required this.expiry});

  List<String> toStringList() {
    return [displayName ?? "", email, userImageUrl ?? "", accessToken, userId.toString(), expiry.toString()];
  }

  PantryUser.fromStringList(List<String> list) {
    displayName = list[0];
    email = list[1];
    userImageUrl = list[2];
    accessToken = list[3];
    userId = int.parse(list[4]);
    expiry = int.parse(list[5]);
  }
}
