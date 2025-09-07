class ShortsVideo {
  final String id;
  final String title;
  final String educatorName;
  final String educatorAvatar;
  final String videoUrl;
  final String thumbnailUrl;
  final String courseId;
  final String courseTitle;
  final int likes;
  final int comments;
  final int shares;
  final Duration duration;
  final bool isLiked;
  final String description;

  const ShortsVideo({
    required this.id,
    required this.title,
    required this.educatorName,
    required this.educatorAvatar,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.courseId,
    required this.courseTitle,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.duration,
    this.isLiked = false,
    required this.description,
  });

  ShortsVideo copyWith({
    String? id,
    String? title,
    String? educatorName,
    String? educatorAvatar,
    String? videoUrl,
    String? thumbnailUrl,
    String? courseId,
    String? courseTitle,
    int? likes,
    int? comments,
    int? shares,
    Duration? duration,
    bool? isLiked,
    String? description,
  }) {
    return ShortsVideo(
      id: id ?? this.id,
      title: title ?? this.title,
      educatorName: educatorName ?? this.educatorName,
      educatorAvatar: educatorAvatar ?? this.educatorAvatar,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      courseId: courseId ?? this.courseId,
      courseTitle: courseTitle ?? this.courseTitle,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      duration: duration ?? this.duration,
      isLiked: isLiked ?? this.isLiked,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'ShortsVideo(id: $id, title: $title, educatorName: $educatorName, likes: $likes, comments: $comments, shares: $shares)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShortsVideo &&
        other.id == id &&
        other.title == title &&
        other.educatorName == educatorName &&
        other.videoUrl == videoUrl &&
        other.courseId == courseId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        educatorName.hashCode ^
        videoUrl.hashCode ^
        courseId.hashCode;
  }
}
