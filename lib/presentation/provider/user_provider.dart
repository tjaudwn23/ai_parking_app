import 'dart:convert';

import 'package:ai_parking/data/data_source/auth_api.dart';
import 'package:ai_parking/data/model/login_response.dart';
import 'package:ai_parking/data/model/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProvider extends ChangeNotifier {
  UserData? _user;
  final AuthApi _authApi = AuthApi();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  UserData? get user => _user;
  bool get isLoggedIn => _user != null;

  Future<void> tryAutoLogin() async {
    final userJson = await _storage.read(key: 'user_data');
    if (userJson != null) {
      _user = UserData.fromJson(jsonDecode(userJson));
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    final LoginResponse loginResponse = await _authApi.login(email, password);
    _user = loginResponse.user;

    await _storage.write(key: 'access_token', value: loginResponse.accessToken);
    await _storage.write(
      key: 'refresh_token',
      value: loginResponse.refreshToken,
    );
    await _storage.write(
      key: 'user_data',
      value: jsonEncode(loginResponse.user.toJson()),
    );

    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;
    await _storage.deleteAll();
    notifyListeners();
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }
}
