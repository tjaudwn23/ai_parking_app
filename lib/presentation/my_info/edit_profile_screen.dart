import 'package:ai_parking/presentation/common/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nicknameController = TextEditingController(
    text: '홍길동',
  );
  final TextEditingController _addressController = TextEditingController(
    text: '서울시 강남구 ○○로 ○○',
  );
  final TextEditingController _addressDetailController = TextEditingController(
    text: '101동 203호',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '010-1234-5678',
  );
  final TextEditingController _verificationCodeController =
      TextEditingController();

  @override
  void dispose() {
    _nicknameController.dispose();
    _addressController.dispose();
    _addressDetailController.dispose();
    _phoneController.dispose();
    _verificationCodeController.dispose();
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
          '프로필 수정',
          style: GoogleFonts.inter(
            color: const Color(0xFF454545),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xFFF5F5F5),
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Color(0xFFCCCCCC),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '(변경)',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF0066CC),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildTextField(label: '닉네임', controller: _nicknameController),
              const SizedBox(height: 16),
              _buildTextField(
                label: '집 주소',
                controller: _addressController,
                // TODO: 주소 검색 기능 추가
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: '동/호수',
                controller: _addressDetailController,
              ),
              const SizedBox(height: 16),
              const Text(
                '• 휴대폰 번호',
                style: TextStyle(fontSize: 14, color: Color(0xFF454545)),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      hintText: '010-1234-5678',
                      controller: _phoneController,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: 인증번호 발송 로직
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF808080),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                    ),
                    child: Text(
                      '인증번호 발송',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: '인증번호 입력',
                controller: _verificationCodeController,
              ),
              const SizedBox(height: 24),
              const Text(
                '* 변경된 정보는 "저장" 터치 시 적용됩니다.',
                style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• $label',
          style: const TextStyle(fontSize: 14, color: Color(0xFF454545)),
        ),
        const SizedBox(height: 8),
        CustomTextField(hintText: '', controller: controller),
      ],
    );
  }
}
