class User {
  UserClass user;
  String token;

  User({
    required this.user,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      // If the response data is null, return a default User instance
      return User(user: UserClass(id: '', displayName: '', email: ''), token: '');
    }

    return User(
      user: UserClass.fromJson(json["user"] ?? {}),
      token: json["token"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "token": token,
      };
}

class UserClass {
  String id;
  String displayName;
  String email;

  UserClass({
    required this.id,
    required this.displayName,
    required this.email,
  });

  factory UserClass.fromJson(Map<String, dynamic> json) {
    return UserClass(
      id: json['_id'] ?? '', // Add a null check and provide a default value
      displayName: json["displayName"] ?? '',
      email: json["email"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "displayName": displayName,
        "email": email,
      };
}
