import 'package:ai_parking/presentation/community/create_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  String _selectedDong = '101동';
  final List<String> _dongList = ['101동', '102동', '103동'];

  // 더미 데이터
  final List<Map<String, dynamic>> _posts = [
    {
      'id': 65,
      'title': '지하주차장 B에 자리 있어요!',
      'author': '홍길동',
      'date': '06-19',
      'comments': 3,
    },
    {
      'id': 64,
      'title': '오늘 세차 예정 있으신가요?',
      'author': '김영희',
      'date': '06-18',
      'comments': 1,
    },
    {
      'id': 63,
      'title': '놀이터 앞 주차 금지 부탁드립니다',
      'author': '이철수',
      'date': '06-17',
      'comments': 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '커뮤니티 게시판',
          style: GoogleFonts.inter(
            color: const Color(0xFF454545),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF454545)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreatePostScreen(),
                ),
              );
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 12.0,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(color: const Color(0xFFCCCCCC)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedDong,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: _dongList.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF454545),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedDong = newValue!;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _posts.length + 1, // +1 for the "Load More" button
              itemBuilder: (context, index) {
                if (index == _posts.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          // TODO: Load more posts
                        },
                        child: Text(
                          '더 보기',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF454545),
                          ),
                        ),
                      ),
                    ),
                  );
                }
                final post = _posts[index];
                return _buildPostCard(post);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post['id'].toString(),
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF454545),
            ),
          ),
          const SizedBox(width: 22),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post['title'],
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: const Color(0xFF454545),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${post['author']} · ${post['date']} · 💬 ${post['comments']}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
