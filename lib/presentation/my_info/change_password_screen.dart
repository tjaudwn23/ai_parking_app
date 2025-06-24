import 'package:ai_parking/presentation/common/custom_text_field.dart';
import 'package:ai_parking/presentation/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ai_parking/data/data_source/auth_api.dart';
import 'package:ai_parking/data/model/change_password_request.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _newPasswordConfirmController = TextEditingController();

  bool _isNewPasswordVisible = false;
  bool _isNewPasswordConfirmVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _newPasswordConfirmController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (_isLoading) return;
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user == null) {
      _showDialog('오류', '로그인 정보가 없습니다.', false);
      return;
    }
    final email = user.email; // UserData에 email 필드가 있다면 user.email로 교체
    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final newPasswordConfirm = _newPasswordConfirmController.text;

    if (newPassword != newPasswordConfirm) {
      _showDialog('오류', '새 비밀번호가 일치하지 않습니다.', false);
      return;
    }
    if (!_isPasswordValid(newPassword)) {
      _showDialog('오류', '새 비밀번호는 8자 이상, 대문자와 소문자를 모두 포함해야 합니다.', false);
      return;
    }

    setState(() {
      _isLoading = true;
    });
    try {
      final api = AuthApi();
      final req = ChangePasswordRequest(
        email: email,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      final message = await api.changePassword(req);
      if (mounted) {
        _showDialog('성공', message, true);
      }
    } catch (e) {
      if (mounted) {
        _showDialog('오류', e.toString().replaceAll('Exception: ', ''), false);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showDialog(String title, String message, bool isSuccess) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text(
            title,
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
          content: Text(message, style: GoogleFonts.inter()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (isSuccess) Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  bool _isPasswordValid(String password) {
    final passwordRegExp = RegExp(r'^(?=.*[a-z])(?=.*[A-Z]).{8,}');
    return passwordRegExp.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF454545)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '비밀번호 변경',
          style: GoogleFonts.inter(
            color: const Color(0xFF454545),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            CustomTextField(
              hintText: '현재 비밀번호 입력',
              controller: _currentPasswordController,
              obscureText: true,
            ),
            const SizedBox(height: 12),
            _buildPasswordTextField(
              hintText: '새 비밀번호 입력',
              controller: _newPasswordController,
              isVisible: _isNewPasswordVisible,
              onToggleVisibility: () {
                setState(() {
                  _isNewPasswordVisible = !_isNewPasswordVisible;
                });
              },
            ),
            const SizedBox(height: 12),
            _buildPasswordTextField(
              hintText: '새 비밀번호 확인',
              controller: _newPasswordConfirmController,
              isVisible: _isNewPasswordConfirmVisible,
              onToggleVisibility: () {
                setState(() {
                  _isNewPasswordConfirmVisible = !_isNewPasswordConfirmVisible;
                });
              },
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: _isLoading ? null : _changePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066CC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : Text(
                      '비밀번호 변경',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordTextField({
    required String hintText,
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          color: const Color(0xFF999999),
          fontSize: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFF0066CC)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: const Color(0xFF999999),
          ),
          onPressed: onToggleVisibility,
        ),
      ),
    );
  }
}
