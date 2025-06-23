import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PushNotificationSettingsScreen extends StatefulWidget {
  const PushNotificationSettingsScreen({super.key});

  @override
  State<PushNotificationSettingsScreen> createState() =>
      _PushNotificationSettingsScreenState();
}

class _PushNotificationSettingsScreenState
    extends State<PushNotificationSettingsScreen> {
  bool _parkingInfoUpdateEnabled = true;
  bool _newPostEnabled = false;
  bool _commentLikeEnabled = true;
  bool _appNewsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF333333)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '푸시 알림 설정',
          style: GoogleFonts.notoSans(
            color: const Color(0xFF333333),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFF5F5F5), height: 1.0),
        ),
      ),
      body: ListView(
        children: [
          _buildCategoryHeader('주차장 알림'),
          _buildSwitchListTile(
            title: '주차장 정보 업데이트 알림',
            value: _parkingInfoUpdateEnabled,
            onChanged: (value) {
              setState(() {
                _parkingInfoUpdateEnabled = value;
              });
            },
          ),
          _buildDivider(),
          _buildCategoryHeader('커뮤니티 알림'),
          _buildSwitchListTile(
            title: '내 동 새 게시글 알림',
            value: _newPostEnabled,
            onChanged: (value) {
              setState(() {
                _newPostEnabled = value;
              });
            },
          ),
          _buildSwitchListTile(
            title: '댓글·좋아요 알림',
            value: _commentLikeEnabled,
            onChanged: (value) {
              setState(() {
                _commentLikeEnabled = value;
              });
            },
          ),
          _buildDivider(),
          _buildCategoryHeader('기타 알림'),
          _buildSwitchListTile(
            title: '앱 소식 알림',
            value: _appNewsEnabled,
            onChanged: (value) {
              setState(() {
                _appNewsEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 17.0),
      child: Text(
        '■ $title',
        style: GoogleFonts.notoSans(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF333333),
        ),
      ),
    );
  }

  Widget _buildSwitchListTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 30.0, right: 15.0),
      title: Text(
        '• $title',
        style: GoogleFonts.notoSans(
          fontSize: 14,
          color: const Color(0xFF333333),
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.white,
        activeTrackColor: const Color(0xFF0066CC),
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: const Color(0xFFCCCCCC),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      color: Color(0xFFF5F5F5),
      indent: 20,
      endIndent: 20,
    );
  }
}
