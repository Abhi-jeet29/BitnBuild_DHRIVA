import 'package:flutter/material.dart';
import '../models/course.dart';
import '../screens/course_detail_screen.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback? onWishlistToggle;

  const CourseCard({
    super.key,
    required this.course,
    this.onWishlistToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 768;
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailScreen(course: course),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: isWeb ? 0 : 16, 
          vertical: isWeb ? 0 : 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top section with thumbnail and wishlist button
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: AspectRatio(
                  aspectRatio: isWeb ? 16/9 : 16/10,
                  child: Image.network(
                    course.thumbnailUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Wishlist button
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: onWishlistToggle,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Middle section with title and educator
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'by ${course.educatorName}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom section with rating and price
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Rating section
                Row(
                  children: [
                    ...List.generate(5, (index) {
                      return Icon(
                        Icons.star,
                        color: index < course.rating.floor()
                            ? Colors.amber
                            : Colors.grey[300],
                        size: 16,
                      );
                    }),
                    const SizedBox(width: 4),
                    Text(
                      course.rating.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                
                // Price section
                Text(
                  '₹${course.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }
}
