import 'package:ai_parking/data/data_source/building_api.dart';
import 'package:ai_parking/data/model/building.dart';
import 'package:provider/provider.dart';
import 'package:ai_parking/presentation/provider/user_provider.dart';
import 'package:ai_parking/presentation/community/create_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ai_parking/data/data_source/board_api.dart';
import 'package:ai_parking/data/model/post.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  // 동(건물) 리스트와 선택된 동, 로딩/에러 상태를 관리합니다.
  List<Building> _dongList = [];
  Building? _selectedDong;
  bool _isLoading = true;
  String? _errorMessage;
  List<Post> _posts = [];
  bool _isPostLoading = false;
  String? _postErrorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDongList();
  }

  // 서버에서 동 리스트를 받아오는 함수입니다.
  Future<void> _fetchDongList() async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user == null || user.apartmentId.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = '로그인 정보가 없거나 아파트 정보가 없습니다.';
      });
      return;
    }
    try {
      final dongList = await BuildingApi().fetchAllBuildings(user.apartmentId);
      setState(() {
        _dongList = dongList;
        if (_dongList.isNotEmpty) {
          _selectedDong ??= _dongList.first;
        }
        _isLoading = false;
        _errorMessage = null;
      });
      // 동 리스트를 받아온 후 게시글을 불러옵니다.
      if (_dongList.isNotEmpty) {
        await _fetchPosts();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = '동 목록을 불러오지 못했습니다. 네트워크를 확인하거나 다시 시도해 주세요.';
      });
    }
  }

  // 동 리스트를 받아온 후 게시글을 불러옵니다.
  Future<void> _fetchPosts() async {
    if (_selectedDong == null) return;
    setState(() {
      _isPostLoading = true;
      _postErrorMessage = null;
    });
    try {
      final posts = await BoardApi().fetchPostsByBuilding(
        _selectedDong!.buildingId,
      );
      setState(() {
        _posts = posts;
        _isPostLoading = false;
      });
    } catch (e) {
      setState(() {
        _isPostLoading = false;
        _postErrorMessage = '게시글을 불러오지 못했습니다. 다시 시도해 주세요.';
      });
    }
  }

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
                child: _isLoading
                    ? const SizedBox(
                        height: 40,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : _errorMessage != null
                    ? Row(
                        children: [
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                                _errorMessage = null;
                              });
                              _fetchDongList();
                            },
                          ),
                        ],
                      )
                    : DropdownButtonHideUnderline(
                        child: DropdownButton<Building>(
                          value: _selectedDong,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: _dongList.map((Building b) {
                            return DropdownMenuItem<Building>(
                              value: b,
                              child: Text(
                                b.name,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: const Color(0xFF454545),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: _onDongChanged,
                        ),
                      ),
              ),
            ),
          ),
          Expanded(
            child: _isPostLoading
                ? const Center(child: CircularProgressIndicator())
                : _postErrorMessage != null
                ? Center(
                    child: Text(
                      _postErrorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : _posts.isEmpty
                ? const Center(child: Text('게시글이 없습니다.'))
                : ListView.builder(
                    itemCount:
                        _posts.length + 1, // +1 for the "Load More" button
                    itemBuilder: (context, index) {
                      if (index == _posts.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: TextButton(
                              onPressed: () {
                                // TODO: Load more posts (페이징 구현 시)
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
                      return _buildPostCard(post, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(Post post, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${index + 1}', // 1부터 시작하는 인덱스
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
                  post.title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: const Color(0xFF454545),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${post.userName} · '
                  '${post.createdAt.year.toString().padLeft(4, '0')}-${post.createdAt.month.toString().padLeft(2, '0')}-${post.createdAt.day.toString().padLeft(2, '0')}'
                  ' · 💬 ${post.commentCount}',
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

  // 동이 변경될 때 게시글을 다시 불러옵니다.
  // 드롭다운 onChanged에서 호출
  void _onDongChanged(Building? newValue) {
    setState(() {
      _selectedDong = newValue;
    });
    _fetchPosts();
  }
}
