import 'package:ai_parking/presentation/common/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ai_parking/presentation/provider/user_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nicknameController;
  late TextEditingController _addressController;
  late TextEditingController _addressDetailController;
  late TextEditingController _phoneController;
  final TextEditingController _verificationCodeController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    _nicknameController = TextEditingController(text: user?.nickname ?? '');
    _addressController = TextEditingController(text: user?.address ?? '');
    _addressDetailController = TextEditingController(
      text: user?.addressDetail ?? '',
    );
    _phoneController = TextEditingController(text: user?.phoneNumber ?? '');
  }

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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20.0,
              ),
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
                  _buildTextField(
                    label: '닉네임',
                    controller: _nicknameController,
                  ),
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
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await Provider.of<UserProvider>(
                          context,
                          listen: false,
                        ).editProfile(
                          nickname: _nicknameController.text,
                          address: _addressController.text,
                          addressDetail: _addressDetailController.text,
                          phoneNumber: _phoneController.text,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('프로필이 성공적으로 수정되었습니다.')),
                        );
                        Navigator.of(context).pop();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('프로필 수정 실패: $e')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0066CC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '저장',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
