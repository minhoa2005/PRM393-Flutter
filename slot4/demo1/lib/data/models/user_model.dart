import 'package:demo1/domain/entities/user.dart';

class UserModel extends User {
  UserModel({required String super.username, required String super.fullName});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(username: json['username'], fullName: json['fullName']);
  }

  Map<String, dynamic> toJson() {
    return {'username': username, 'fullName': fullName};
  }
}
