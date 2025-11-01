/// 알림 설정 데이터 모델(NotificationSettings)
/// - 사용자의 푸시 알림 설정을 담는 데이터 클래스입니다.
/// - 주차장 업데이트, 새 게시글, 댓글/좋아요, 앱 소식 등의 알림 설정을 boolean으로 관리합니다.
/// - toJson()과 fromJson()을 통해 서버와 데이터를 주고받습니다.

class NotificationSettings {
  final bool parkingUpdate;
  final bool newPostInArea;
  final bool commentLike;
  final bool appNews;

  NotificationSettings({
    required this.parkingUpdate,
    required this.newPostInArea,
    required this.commentLike,
    required this.appNews,
  });

  Map<String, dynamic> toJson() => {
    'parking_update': parkingUpdate,
    'new_post_in_area': newPostInArea,
    'comment_like': commentLike,
    'app_news': appNews,
  };

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      parkingUpdate: json['parking_update'],
      newPostInArea: json['new_post_in_area'],
      commentLike: json['comment_like'],
      appNews: json['app_news'],
    );
  }
}
