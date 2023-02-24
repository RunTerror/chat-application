class Model {
  late final String id;
  late final String fullName;
  late final String email;
  late String profilePic;
  Model({
    required this.id,
    required this.email,
    required this.fullName,
    required this.profilePic,
  });

  Model.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    email = map["email"];
    fullName = map["fullName"];
    profilePic = map["profilePic"];
  }
}
