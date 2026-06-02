class LoginRequestDto {
  final String username;
  final String password;
  final int expiresInMins;

  const LoginRequestDto({
    required this.username,
    required this.password,
    this.expiresInMins = 60,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'expiresInMins': expiresInMins,
    };
  }
}
