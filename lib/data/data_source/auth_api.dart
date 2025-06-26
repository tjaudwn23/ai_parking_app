import 'dart:convert';
import 'package:ai_parking/data/model/login_response.dart';
import 'package:ai_parking/data/model/user_register.dart';
import 'package:ai_parking/data/model/change_password_request.dart';
import 'package:http/http.dart' as http;
import '../model/notification_settings.dart';
import 'package:ai_parking/data/model/user_data.dart';

class AuthApi {
  static const String baseUrl = 'http://localhost:8000';
  final http.Client _client;

  AuthApi({http.Client? client}) : _client = client ?? http.Client();

  Future<LoginResponse> login(String username, String password) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': username,
        'password': password,
      }),
    );

    // 로그인 API 응답 본문을 출력하여 디버깅
    print('로그인 API 응답: \x1B[35m\x1B[1m\x1B[4m\x1B[7m${response.body}\x1B[0m');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return LoginResponse.fromJson(data);
    } else {
      throw Exception('Failed to login: $response');
    }
  }

  Future<String> signUp(UserRegister user) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/api/auth/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['message'] ?? '회원가입에 성공했습니다.';
    } else {
      throw Exception('Failed to sign up: $response');
    }
  }

  Future<String> changePassword(ChangePasswordRequest req) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/api/auth/change-password'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(req.toJson()),
    );

    print(req.toJson());
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
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(settings.toJson()),
    );
    return response.statusCode == 200;
  }

  static Future<NotificationSettings?> fetchNotificationSettings(
    String token,
  ) async {
    final url = Uri.parse('$baseUrl/api/auth/notification-settings');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
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
    final response = await _client.delete(
      Uri.parse('$baseUrl/api/auth/withdrawal'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return response.statusCode == 200;
  }

  Future<UserData> patchUserProfile(
    UserData userData,
    String accessToken,
  ) async {
    final response = await _client.patch(
      Uri.parse('$baseUrl/api/auth/user-profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(userData.toJson()),
    );
    if (response.statusCode == 200) {
      return UserData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('프로필 수정 실패: $response');
    }
  }

  /// refresh_token으로 access_token 재발급
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/api/auth/refresh-token'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'refresh_token': refreshToken}),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to refresh token: ${response.body}');
    }
  }
}
