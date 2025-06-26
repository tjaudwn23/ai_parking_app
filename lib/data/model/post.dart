// 게시글(Post) 모델 클래스입니다.
// 서버에서 받아온 게시글 정보를 담습니다.
class Comment {
  final int? id;
  final DateTime? createdAt;
  final int? postId;
  final String? userId;
  final String? name;
  final String? body;

  Comment({
    this.id,
    this.createdAt,
    this.postId,
    this.userId,
    this.name,
    this.body,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      postId: json['post_id'],
      userId: json['user_id'],
      name: json['nickname'] ?? json['name'],
      body: json['content'] ?? json['body'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'created_at': createdAt?.toIso8601String(),
    'post_id': postId,
    'user_id': userId,
    'name': name,
    'body': body,
  };
}

class Post {
  final int? id;
  final String? title;
  final String? content;
  final List<String>? imageUrls;
  final String? apartmentId;
  final String? buildingId;
  final String? userId;
  final DateTime? createdAt;
  final int? commentCount;
  final String? userName;
  final List<Comment>? comments;

  Post({
    this.id,
    this.title,
    this.content,
    this.imageUrls,
    this.apartmentId,
    this.buildingId,
    this.userId,
    this.createdAt,
    this.commentCount,
    this.userName,
    this.comments,
  });

  // JSON 데이터를 Post 객체로 변환하는 팩토리 생성자입니다.
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      imageUrls: (json['image_urls'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      apartmentId: json['apartment_id'],
      buildingId: json['building_id'],
      userId: json['user_id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      commentCount: json['comment_count'] is int
          ? json['comment_count'] as int
          : int.tryParse(json['comment_count']?.toString() ?? '') ?? 0,
      userName: json['user_name'],
      comments: (json['comments'] as List<dynamic>?)
          ?.map((c) => Comment.fromJson(c))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'image_urls': imageUrls,
    'apartment_id': apartmentId,
    'building_id': buildingId,
    'user_id': userId,
    'created_at': createdAt?.toIso8601String(),
    'comment_count': commentCount,
    'user_name': userName,
    'comments': comments?.map((c) => c.toJson()).toList(),
  };
}
