import 'package:ai_parking/presentation/my_info/change_password_screen.dart';
import 'package:ai_parking/presentation/my_info/edit_profile_screen.dart';
import 'package:ai_parking/presentation/my_info/push_notification_settings_screen.dart';
import 'package:ai_parking/presentation/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyInfoScreen extends StatelessWidget {
  const MyInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          '내 정보',
          style: GoogleFonts.inter(
            color: const Color(0xFF000000),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(),
                ),
              );
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _ProfileSection(),
              const SizedBox(height: 20),
              const _AccountInfoSection(),
              const SizedBox(height: 20),
              const _SettingsSection(),
              const SizedBox(height: 20),
              const _LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;
        if (user == null) {
          return const Center(child: Text('사용자 정보가 없습니다.'));
        }

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFFF5F5F5),
                // TODO: Add user profile image
                child: Icon(Icons.person, size: 40, color: Color(0xFFCCCCCC)),
              ),
              const SizedBox(height: 8),
              Text(
                user.nickname,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF454545),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.nickname, // 임시로 닉네임 표시
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF999999),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AccountInfoSection extends StatelessWidget {
  const _AccountInfoSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;
        if (user == null) {
          return const SizedBox.shrink(); // 사용자 정보 없으면 표시 안함
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _InfoRow(title: '아이디', value: user.email), // 임시로 닉네임 표시
              const SizedBox(height: 12),
              _InfoRow(title: '집 주소', value: user.address),
              const SizedBox(height: 12),
              _InfoRow(title: '동/호수', value: user.addressDetail),
              const SizedBox(height: 12),
              _InfoRow(title: '휴대폰', value: user.phoneNumber),
            ],
          ),
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const _InfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF999999),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF454545),
          ),
        ),
      ],
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingsItem(context, '비밀번호 변경', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangePasswordScreen(),
              ),
            );
          }),
          _buildDivider(),
          _buildSettingsItem(context, '푸시 알림 설정', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PushNotificationSettingsScreen(),
              ),
            );
          }),
          _buildDivider(),
          _buildSettingsItem(context, '회원 탈퇴', () {
            _showWithdrawalDialog(context);
          }),
        ],
      ),
    );
  }

  void _showWithdrawalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: Text(
            '회원 탈퇴',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF333333),
            ),
          ),
          content: Text(
            '정말로 탈퇴하시겠습니까?\n모든 정보가 삭제되며 복구할 수 없습니다.',
            style: GoogleFonts.inter(color: const Color(0xFF454545)),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                '취소',
                style: GoogleFonts.inter(color: const Color(0xFF999999)),
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: 회원 탈퇴 API 호출 로직 구현
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text(
                '탈퇴',
                style: GoogleFonts.inter(
                  color: const Color(0xFFDB3645),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    String title,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: const Color(0xFF454545),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFCCCCCC)),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Divider(height: 1, color: Color(0xFFF5F5F5)),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Provider.of<UserProvider>(context, listen: false).logout();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFDB3645),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        elevation: 0,
      ),
      child: Text(
        '로그아웃',
        style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
