import 'dart:convert';

import 'package:ai_parking/data/data_source/auth_api.dart';
import 'package:ai_parking/data/model/login_response.dart';
import 'package:ai_parking/data/model/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserProvider extends ChangeNotifier {
  UserData? _user;
  final AuthApi _authApi = AuthApi();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  UserProvider() {
    print('UserProvider 생성됨!');
    tryAutoLogin();
  }

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
    print('로그인 응답 user: [32m[1m[4m[7m${loginResponse.user}[0m');
    print('UserData json: [34m[1m[4m[7m${loginResponse.user.toJson()}[0m');

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

  Future<void> editProfile({
    required String nickname,
    required String address,
    required String addressDetail,
    required String phoneNumber,
  }) async {
    final accessToken = await getAccessToken();
    if (accessToken == null || _user == null) throw Exception('로그인 필요');

    final oldUser = _user;

    final updatedUser = UserData(
      email: _user!.email,
      address: address,
      latitude: _user!.latitude,
      nickname: nickname,
      longitude: _user!.longitude,
      phoneNumber: phoneNumber,
      addressDetail: addressDetail,
      emailVerified: _user!.emailVerified,
      phoneVerified: _user!.phoneVerified,
    );

    try {
      final newUser = await _authApi.patchUserProfile(updatedUser, accessToken);
      _user = newUser;
      await _storage.write(
        key: 'user_data',
        value: jsonEncode(newUser.toJson()),
      );
      notifyListeners();
    } catch (e) {
      _user = oldUser;
      notifyListeners();
      rethrow;
    }
  }
}
