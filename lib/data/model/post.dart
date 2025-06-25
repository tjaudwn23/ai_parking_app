// 게시글(Post) 모델 클래스입니다.
// 서버에서 받아온 게시글 정보를 담습니다.
class Post {
  final String id; // 게시글 고유 ID
  final String title; // 제목
  final String content; // 내용
  final List<String> imageUrls; // 이미지 URL 리스트
  final String apartmentId; // 아파트 ID
  final String buildingId; // 동(건물) ID
  final String userId; // 작성자 ID
  final DateTime createdAt; // 생성 날짜
  final int commentCount; // 댓글 수
  final String userName; // 작성자 닉네임

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrls,
    required this.apartmentId,
    required this.buildingId,
    required this.userId,
    required this.createdAt,
    required this.commentCount,
    required this.userName,
  });

  // JSON 데이터를 Post 객체로 변환하는 팩토리 생성자입니다.
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'].toString(), // int든 String이든 안전하게 변환
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrls:
          (json['image_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      apartmentId: json['apartment_id'] as String,
      buildingId: json['building_id'] as String,
      userId: json['user_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      // comment_count가 int 또는 String으로 올 수 있으므로 안전하게 변환
      commentCount: json['comment_count'] is int
          ? json['comment_count'] as int
          : int.tryParse(json['comment_count'].toString()) ?? 0,
      userName: json['user_name'] as String,
    );
  }
}
