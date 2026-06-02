import 'package:flutter_application_1/feature/data/dtos/login/login_response_dto.dart';
import 'package:flutter_application_1/feature/data/mappers/interfaces/i_mapper.dart';
import 'package:flutter_application_1/feature/domain/entities/user.dart';

class UserMapper implements IMapper<LoginResponseDto, User> {
  @override
  User map(LoginResponseDto source) {
    return User(
      id: source.user.id,
      username: source.user.username,
      email: source.user.email,
      fullName: '${source.user.firstName} ${source.user.lastName}',
      imageUrl: source.user.imageUrl,
      accessToken: source.accessToken,
      refreshToken: source.refreshToken,
    );
  }
}
