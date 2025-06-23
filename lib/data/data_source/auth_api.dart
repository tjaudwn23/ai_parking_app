import 'dart:convert';
import 'package:ai_parking/data/model/login_response.dart';
import 'package:ai_parking/data/model/user_register.dart';
import 'package:http/http.dart' as http;

class AuthApi {
  final http.Client _client;
  final String _baseUrl = 'http://localhost:8000';

  AuthApi({http.Client? client}) : _client = client ?? http.Client();

  Future<LoginResponse> login(String username, String password) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return LoginResponse.fromJson(data);
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<String> signUp(UserRegister user) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/api/auth/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['message'] ?? '회원가입에 성공했습니다.';
    } else {
      throw Exception('Failed to sign up: ${response.body}');
    }
  }
}
