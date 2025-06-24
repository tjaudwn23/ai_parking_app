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
