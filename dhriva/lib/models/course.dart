class Course {
  final String id;
  final String title;
  final String educatorName;
  final double price;
  final double rating;
  final String thumbnailUrl;

  const Course({
    required this.id,
    required this.title,
    required this.educatorName,
    required this.price,
    required this.rating,
    required this.thumbnailUrl,
  });

  @override
  String toString() {
    return 'Course(id: $id, title: $title, educatorName: $educatorName, price: $price, rating: $rating, thumbnailUrl: $thumbnailUrl)';
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
        other.thumbnailUrl == thumbnailUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        educatorName.hashCode ^
        price.hashCode ^
        rating.hashCode ^
        thumbnailUrl.hashCode;
  }
}

