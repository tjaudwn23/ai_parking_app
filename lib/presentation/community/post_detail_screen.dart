import 'package:flutter/material.dart';
import 'package:ai_parking/data/model/post.dart';
import 'package:ai_parking/data/data_source/board_api.dart';
import 'package:provider/provider.dart';
import 'package:ai_parking/presentation/provider/user_provider.dart';
import 'package:ai_parking/presentation/community/create_post_screen.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;
  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  Post? _post;
  List<Comment> comments = [];
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final detail = await BoardApi().fetchPostDetail(
        widget.post.id?.toString() ?? '',
      );
      setState(() {
        _post = detail;
        comments = List<Comment>.from(detail.comments ?? []);
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
        _errorMessage = '상세 정보를 불러오지 못했습니다.';
      });
    }
  }

  void showImageViewer(
    BuildContext context,
    List<String> imageUrls,
    int initialIndex,
  ) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            PageView.builder(
              controller: PageController(initialPage: initialIndex),
              itemCount: imageUrls.length,
              itemBuilder: (context, idx) => InteractiveViewer(
                child: Center(
                  child: Image.network(
                    imageUrls[idx],
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) => const Icon(
                      Icons.broken_image,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 30,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addComment() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _post == null) return;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user?.id;
    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('로그인 정보가 없습니다.')));
      return;
    }
    try {
      await BoardApi().createComment(
        postId: _post!.id!,
        userId: userId,
        body: text,
      );
      _controller.clear();
      await _fetchDetail(); // 댓글 목록 새로고침
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('댓글 등록 실패: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final sectionTitleStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.grey[700],
    );
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('게시글 상세')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('게시글 상세')),
        body: Center(
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }
    final post = _post!;
    final userName = (post.userName != null && post.userName!.trim().isNotEmpty)
        ? post.userName!
        : '알 수 없음';
    final commentCount = post.commentCount ?? 0;
    final commentList = post.comments ?? [];
    final title = post.title ?? '(제목 없음)';
    final content = post.content ?? '';
    final createdAt = post.createdAt;
    String dateStr = '';
    if (createdAt != null) {
      dateStr = _formatDate(createdAt);
    } else {
      dateStr = '날짜 없음';
    }
    final imageUrls = post.imageUrls ?? [];
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final myUserId = userProvider.user?.id;
    return Scaffold(
      appBar: AppBar(
        title: const Text('게시글 상세'),
        actions: [
          if (myUserId != null && post.userId == myUserId) ...[
            IconButton(
              icon: const Icon(Icons.edit, color: Color(0xFF454545)),
              tooltip: '수정',
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreatePostScreen(post: post),
                  ),
                );
                if (result == true) {
                  await _fetchDetail();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Color(0xFFB00020)),
              tooltip: '삭제',
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('게시글 삭제'),
                    content: const Text('정말로 이 게시글을 삭제하시겠습니까?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('취소'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text(
                          '삭제',
                          style: TextStyle(color: Color(0xFFB00020)),
                        ),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  try {
                    await BoardApi().deletePost(post.id!);
                    if (mounted) {
                      Navigator.of(context).pop(true);
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('게시글 삭제 실패: $e')));
                  }
                }
              },
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 본문 영역
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$userName · $dateStr',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Text(content),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Divider(thickness: 1, color: Colors.grey),
            // 사진 영역
            if (imageUrls.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('사진', style: sectionTitleStyle),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: imageUrls.length,
                        itemBuilder: (context, idx) => GestureDetector(
                          onTap: () {
                            showImageViewer(context, imageUrls, idx);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageUrls[idx],
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                              errorBuilder: (c, e, s) =>
                                  const Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(thickness: 1, color: Colors.grey[200]),
            ],
            // 댓글 영역
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('댓글 (${commentList.length})', style: sectionTitleStyle),
                  const SizedBox(height: 12),
                  if (commentList.isEmpty)
                    const Text(
                      '아직 댓글이 없습니다.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ...commentList.map(
                    (c) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        c.name ?? '알 수 없음',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(c.body ?? ''),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            c.createdAt != null
                                ? _formatDate(c.createdAt!)
                                : '날짜 없음',
                            style: const TextStyle(fontSize: 12),
                          ),
                          if (myUserId != null && c.userId == myUserId)
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Color(0xFFB00020),
                                size: 20,
                              ),
                              tooltip: '댓글 삭제',
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('댓글 삭제'),
                                    content: const Text('정말로 이 댓글을 삭제하시겠습니까?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('취소'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text(
                                          '삭제',
                                          style: TextStyle(
                                            color: Color(0xFFB00020),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  try {
                                    await BoardApi().deleteComment(c.id!);
                                    await _fetchDetail();
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('댓글 삭제 실패: $e')),
                                    );
                                  }
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80), // 입력창 가려지지 않게 여유 공간
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(height: 1, color: Colors.grey[200]),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: '댓글을 입력하세요',
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      onSubmitted: (_) => _addComment(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addComment,
                    child: const Text('등록'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}
