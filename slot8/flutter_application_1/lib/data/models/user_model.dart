import 'package:flutter_application_1/domain/entities/app_user.dart';

class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.fullName,
    required this.createdAt,
    required this.updatedAt,
    required this.password,
  });

  final int? id;
  final String name;
  final String email;
  final String fullName;
  final String createdAt;
  final String updatedAt;
  final String password;

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      name: map['username'] as String,
      email: map['email'] as String,
      fullName: map['full_name'] as String,
      createdAt: map['created_at'] as String,
      updatedAt: map['updated_at'] as String,
      password: map['password'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'username': name,
      'email': email,
      'full_name': fullName,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'password': password,
    };
  }

  AppUser toEntity() {
    return AppUser(
      id: id ?? 0,
      username: name,
      email: email,
      fullName: fullName,
    );
  }
}
