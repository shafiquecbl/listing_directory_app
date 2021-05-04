import '../configs/app_constants.dart';

class User {
  int id;
  String username;
  String email;
  String displayName;
  String firstName;
  String lastName;
  String avatar;
  String cookie;
  User({
    this.id,
    this.displayName,
    this.email,
    this.firstName,
    this.lastName,
    this.username,
    this.avatar,
    this.cookie,
  });

  void copyWith(User appUser) {
    id = appUser.id ?? id;
    displayName = appUser.displayName ?? displayName;
    email = appUser.email ?? email;
    firstName = appUser.firstName ?? firstName;
    lastName = appUser.lastName ?? lastName;
    username = appUser.username ?? username;
    avatar = appUser.avatar ?? avatar;
    cookie = appUser.cookie ?? cookie;
  }

  User.fromJson(json) {
    id = json['id'];
    username = json['username'] ?? '';
    email = json['email'] ?? '';
    displayName = json['displayname'] ?? '';
    firstName = json['firstname'] ?? '';
    lastName = json['lastname'] ?? '';
    avatar = json['avatar'] ?? kDefaultImage;
    cookie = json['cookie'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'displayname': displayName,
      'firstname': firstName,
      'lastname': lastName,
      'avatar': avatar,
      'cookie': cookie,
    };
  }

  @override
  String toString() {
    return '{\nid: $id, \nusername: $username, \nemail: $email, \ndisplayName: $displayName, \nfirstName: $firstName, \nlastName: $lastName}';
  }
}
