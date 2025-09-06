import 'review.dart';

class Course {
  final String id;
  final String title;
  final String educatorName;
  final double price;
  final double rating;
  final String thumbnailUrl;
  final String heroImageUrl;
  final String description;
  final List<String> modules;
  final List<Review> reviews;
  final DateTime startDate;
  final Duration duration;
  final String level;

  const Course({
    required this.id,
    required this.title,
    required this.educatorName,
    required this.price,
    required this.rating,
    required this.thumbnailUrl,
    required this.heroImageUrl,
    required this.description,
    required this.modules,
    required this.reviews,
    required this.startDate,
    required this.duration,
    required this.level,
  });

  @override
  String toString() {
    return 'Course(id: $id, title: $title, educatorName: $educatorName, price: $price, rating: $rating, thumbnailUrl: $thumbnailUrl, heroImageUrl: $heroImageUrl, description: $description, modules: $modules, reviews: $reviews, startDate: $startDate, duration: $duration, level: $level)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Course &&
        other.id == id &&
        other.title == title &&
        other.educatorName == educatorName &&
        other.price == price &&
        other.rating == rating &&
        other.thumbnailUrl == thumbnailUrl &&
        other.heroImageUrl == heroImageUrl &&
        other.description == description &&
        other.modules == modules &&
        other.reviews == reviews &&
        other.startDate == startDate &&
        other.duration == duration &&
        other.level == level;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        educatorName.hashCode ^
        price.hashCode ^
        rating.hashCode ^
        thumbnailUrl.hashCode ^
        heroImageUrl.hashCode ^
        description.hashCode ^
        modules.hashCode ^
        reviews.hashCode ^
        startDate.hashCode ^
        duration.hashCode ^
        level.hashCode;
  }
}

