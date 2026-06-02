import 'package:flutter_application_1/feature/data/dtos/user/user_dto.dart';

class LoginResponseDto {
  final UserDto user;
  final String accessToken;
  final String refreshToken;

  const LoginResponseDto({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(
      user: UserDto.fromJson(json),
      accessToken: json['access_token'] as String? ?? '',
      refreshToken: json['refresh_token'] as String? ?? '',
    );
  }
}
