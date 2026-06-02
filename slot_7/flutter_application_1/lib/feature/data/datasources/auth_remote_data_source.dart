import 'package:dio/dio.dart';
import 'package:flutter_application_1/core/constants/api_constants.dart';
import 'package:flutter_application_1/core/errors/app_exception.dart';
import 'package:flutter_application_1/feature/data/dtos/login/login_request_dto.dart';
import 'package:flutter_application_1/feature/data/dtos/login/login_response_dto.dart';

class AuthRemoteDataSource {
  final Dio _dio;
  AuthRemoteDataSource(this._dio);
  Future<LoginResponseDto> login(LoginRequestDto request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.loginEndpoint,
        data: request.toJson(),
      );
      final data = response.data;
      if (data == null) {
        throw const AppException('Du lieu phan hoi tu server khong hop le');
      }
      return LoginResponseDto.fromJson(data);
    } on DioException catch (e) {
      throw AppException('Loi khi ket noi den server: ${_getErrorMessage(e)}');
    }
  }

  String _getErrorMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message != null) {
        return message.toString();
      }
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Ket noi den server het thoi gian cho phep. Vui long thu lai sau.';
    }
    if (error.type == DioExceptionType.connectionError) {
      return 'Khong the ket noi den server. Vui long kiem tra ket noi mang va thu lai.';
    }
    return 'Loi khong xac dinh.';
  }
}
