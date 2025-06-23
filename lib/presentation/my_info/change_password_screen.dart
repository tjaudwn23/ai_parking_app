import 'package:ai_parking/presentation/common/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _newPasswordConfirmController.dispose();
    super.dispose();
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
              onPressed: () {
                // TODO: 비밀번호 변경 로직 구현
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066CC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                '비밀번호 변경',
                style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
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
