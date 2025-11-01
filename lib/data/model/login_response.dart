/// 로그인 응답 데이터 모델(LoginResponse)
/// - 로그인 API 응답을 담는 데이터 클래스입니다.
/// - access_token, refresh_token, 사용자 정보(UserData)를 포함합니다.
/// - fromJson()으로 서버 응답을 파싱합니다.

import 'package:ai_parking/data/model/user_data.dart';

class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final UserData user;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      user: UserData.fromJson(json['user']),
    );
  }
}
