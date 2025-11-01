/// 사용자 상태 관리 Provider(UserProvider)
/// - 앱 전체에서 사용자 정보와 인증 상태를 관리하는 ChangeNotifier입니다.
/// - 로그인, 로그아웃, 자동 로그인, 프로필 수정 등의 기능을 제공합니다.
/// - FlutterSecureStorage를 사용하여 토큰과 사용자 정보를 안전하게 저장합니다.
/// - Provider 패턴을 사용하여 앱 전체에서 사용자 상태를 공유합니다.

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

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
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
      id: _user!.id,
      email: _user!.email,
      address: address,
      latitude: _user!.latitude,
      nickname: nickname,
      longitude: _user!.longitude,
      phoneNumber: phoneNumber,
      addressDetail: addressDetail,
      emailVerified: _user!.emailVerified,
      phoneVerified: _user!.phoneVerified,
      name: _user!.name,
      apartmentId: _user!.apartmentId,
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

  void setApartmentId(String apartmentId) {
    if (_user != null) {
      _user = _user!.copyWith(apartmentId: apartmentId);
      _storage.write(key: 'user_data', value: jsonEncode(_user!.toJson()));
      notifyListeners();
    }
  }
}
