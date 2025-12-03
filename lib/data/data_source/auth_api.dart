/// 인증 관련 API 클래스(AuthApi)
/// - 사용자 인증 및 계정 관리 관련 API 호출을 담당하는 데이터 소스 클래스입니다.
/// - login(): 이메일과 비밀번호로 로그인하고 토큰과 사용자 정보를 받아옵니다.
/// - signUp(): 회원가입 요청을 처리합니다.
/// - changePassword(): 비밀번호 변경을 처리합니다.
/// - refreshToken(): refresh token으로 새로운 access token을 발급받습니다.
/// - withdrawal(): 회원 탈퇴를 처리합니다.
/// - patchUserProfile(): 사용자 프로필 정보를 수정합니다.
/// - 알림 설정 조회/수정 메서드도 포함되어 있습니다.
library;

import 'dart:convert';
import 'package:ai_parking/data/model/login_response.dart';
import 'package:ai_parking/data/model/user_register.dart';
import 'package:ai_parking/data/model/change_password_request.dart';
import 'package:http/http.dart' as http;
import '../model/notification_settings.dart';
import 'package:ai_parking/data/model/user_data.dart';

import 'board_api.dart';

class AuthApi {
  //static const String baseUrl = 'http://localhost:8000';
  static const String baseUrl = BASE_URL;
  final http.Client _client;

  AuthApi({http.Client? client}) : _client = client ?? http.Client();

  Future<LoginResponse> login(String username, String password) async {
    final url = '$baseUrl/api/auth/login';
    final requestBody = jsonEncode(<String, String>{
      'email': username,
      'password': password,
    });

    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    // 요청 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🔵 [API 요청] POST $url');
    print('📤 요청 헤더: $headers');
    print('📤 요청 바디: $requestBody');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    final response = await _client.post(
      Uri.parse(url),
      headers: headers,
      body: requestBody,
    );

    // 응답 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🟢 [API 응답] POST $url');
    print('📥 응답 상태 코드: ${response.statusCode}');
    print('📥 응답 헤더: ${response.headers}');
    print('📥 응답 바디: ${response.body}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return LoginResponse.fromJson(data);
    } else {
      throw Exception('Failed to login: $response');
    }
  }

  Future<String> signUp(UserRegister user) async {
    final url = '$baseUrl/api/auth/signup';
    final requestBody = jsonEncode(user.toJson());

    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    // 요청 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🔵 [API 요청] POST $url');
    print('📤 요청 헤더: $headers');
    print('📤 요청 바디: $requestBody');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    final response = await _client.post(
      Uri.parse(url),
      headers: headers,
      body: requestBody,
    );

    // 응답 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🟢 [API 응답] POST $url');
    print('📥 응답 상태 코드: ${response.statusCode}');
    print('📥 응답 헤더: ${response.headers}');
    print('📥 응답 바디: ${response.body}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['message'] ?? '회원가입에 성공했습니다.';
    } else {
      throw Exception('Failed to sign up: $response');
    }
  }

  Future<String> changePassword(ChangePasswordRequest req) async {
    final url = '$baseUrl/api/auth/change-password';
    final requestBody = jsonEncode(req.toJson());

    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    // 요청 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🔵 [API 요청] POST $url');
    print('📤 요청 헤더: $headers');
    print('📤 요청 바디: $requestBody');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    final response = await _client.post(
      Uri.parse(url),
      headers: headers,
      body: requestBody,
    );

    // 응답 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🟢 [API 응답] POST $url');
    print('📥 응답 상태 코드: ${response.statusCode}');
    print('📥 응답 헤더: ${response.headers}');
    print('📥 응답 바디: ${response.body}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    final Map<String, dynamic> data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data['message'] ?? '비밀번호가 성공적으로 변경되었습니다.';
    } else {
      throw Exception(data['message'] ?? '비밀번호 변경에 실패했습니다.');
    }
  }

  static Future<bool> updateNotificationSettings(
    NotificationSettings settings,
    String token,
  ) async {
    final url = Uri.parse('$baseUrl/api/auth/notification-settings');
    final requestBody = jsonEncode(settings.toJson());
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    // 요청 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🔵 [API 요청] PATCH ${url.toString()}');
    print(
      '📤 요청 헤더: ${headers.map((k, v) => MapEntry(k, k == 'Authorization' ? 'Bearer ***' : v))}',
    );
    print('📤 요청 바디: $requestBody');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    final response = await http.patch(url, headers: headers, body: requestBody);

    // 응답 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🟢 [API 응답] PATCH ${url.toString()}');
    print('📥 응답 상태 코드: ${response.statusCode}');
    print('📥 응답 헤더: ${response.headers}');
    print('📥 응답 바디: ${response.body}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    return response.statusCode == 200;
  }

  static Future<NotificationSettings?> fetchNotificationSettings(
    String token,
  ) async {
    final url = Uri.parse('$baseUrl/api/auth/notification-settings');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    // 요청 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🔵 [API 요청] GET ${url.toString()}');
    print(
      '📤 요청 헤더: ${headers.map((k, v) => MapEntry(k, k == 'Authorization' ? 'Bearer ***' : v))}',
    );
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    final response = await http.get(url, headers: headers);

    // 응답 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🟢 [API 응답] GET ${url.toString()}');
    print('📥 응답 상태 코드: ${response.statusCode}');
    print('📥 응답 헤더: ${response.headers}');
    print('📥 응답 바디: ${response.body}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return NotificationSettings.fromJson(data);
    } else {
      // 에러 처리: 필요시 로그 등
      return null;
    }
  }

  /// 회원탈퇴 API 호출
  /// [token]: access token (Bearer)
  /// 성공 시 true, 실패 시 false 반환
  Future<bool> withdrawal(String token) async {
    final url = '$baseUrl/api/auth/withdrawal';
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    // 요청 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🔵 [API 요청] DELETE $url');
    print(
      '📤 요청 헤더: ${headers.map((k, v) => MapEntry(k, k == 'Authorization' ? 'Bearer ***' : v))}',
    );
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    final response = await _client.delete(Uri.parse(url), headers: headers);

    // 응답 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🟢 [API 응답] DELETE $url');
    print('📥 응답 상태 코드: ${response.statusCode}');
    print('📥 응답 헤더: ${response.headers}');
    print('📥 응답 바디: ${response.body}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    return response.statusCode == 200;
  }

  Future<UserData> patchUserProfile(
    UserData userData,
    String accessToken,
  ) async {
    final url = '$baseUrl/api/auth/user-profile';
    final requestBody = jsonEncode(userData.toJson());
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    // 요청 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🔵 [API 요청] PATCH $url');
    print(
      '📤 요청 헤더: ${headers.map((k, v) => MapEntry(k, k == 'Authorization' ? 'Bearer ***' : v))}',
    );
    print('📤 요청 바디: $requestBody');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    final response = await _client.patch(
      Uri.parse(url),
      headers: headers,
      body: requestBody,
    );

    // 응답 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🟢 [API 응답] PATCH $url');
    print('📥 응답 상태 코드: ${response.statusCode}');
    print('📥 응답 헤더: ${response.headers}');
    print('📥 응답 바디: ${response.body}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    if (response.statusCode == 200) {
      return UserData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('프로필 수정 실패: $response');
    }
  }

  /// refresh_token으로 access_token 재발급
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final url = '$baseUrl/api/auth/refresh-token';
    final requestBody = jsonEncode(<String, String>{
      'refresh_token': refreshToken,
    });

    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    // 요청 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🔵 [API 요청] POST $url');
    print('📤 요청 헤더: $headers');
    print('📤 요청 바디: $requestBody');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    final response = await _client.post(
      Uri.parse(url),
      headers: headers,
      body: requestBody,
    );

    // 응답 로그
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🟢 [API 응답] POST $url');
    print('📥 응답 상태 코드: ${response.statusCode}');
    print('📥 응답 헤더: ${response.headers}');
    print('📥 응답 바디: ${response.body}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to refresh token: ${response.body}');
    }
  }
}
