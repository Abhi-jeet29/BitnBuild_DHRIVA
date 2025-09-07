import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String userName;
  final double rating;
  final String comment;
  final String userAvatarUrl;
  final DateTime date;

  const Review({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.userAvatarUrl,
    required this.date,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] ?? '',
      userName: map['userName'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      comment: map['comment'] ?? '',
      userAvatarUrl: map['userAvatarUrl'] ?? '',
      date: map['date'] != null
          ? (map['date'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'Review(id: $id, userName: $userName, rating: $rating, comment: $comment, userAvatarUrl: $userAvatarUrl, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Review &&
        other.id == id &&
        other.userName == userName &&
        other.rating == rating &&
        other.comment == comment &&
        other.userAvatarUrl == userAvatarUrl &&
        other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userName.hashCode ^
        rating.hashCode ^
        comment.hashCode ^
        userAvatarUrl.hashCode ^
        date.hashCode;
  }
}
