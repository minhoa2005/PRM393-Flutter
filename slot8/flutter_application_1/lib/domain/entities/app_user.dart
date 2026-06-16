class AppUser {
  const AppUser({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
  });

  final int id;
  final String username;
  final String email;
  final String fullName;
}
