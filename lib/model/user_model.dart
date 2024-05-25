class UserModel {
  String? uid;
  String? email;

  UserModel({this.uid, this.email});

  factory UserModel.fromMap(Map<String, dynamic>? data) {
    return UserModel(
      uid: data?['uid'],
      email: data?['email'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
    };
  }
}
