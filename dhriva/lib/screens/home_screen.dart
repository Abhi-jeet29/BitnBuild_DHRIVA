import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course.dart';
import '../widgets/course_card.dart';

// TODO: Replace with repository future provider
final coursesProvider = Provider<List<Course>>((ref) {
  return _getMockCourses();
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(coursesProvider);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search courses...',
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey[500],
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
            style: const TextStyle(fontSize: 14),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return CourseCard(
            course: course,
            onWishlistToggle: () {
              // TODO: Implement wishlist toggle functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added "${course.title}" to wishlist'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[600],
        currentIndex: 0, // Home is selected
        onTap: (index) {
          // TODO: Implement navigation logic
          switch (index) {
            case 0:
              // Home - already here
              break;
            case 1:
              // Wishlist
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Wishlist feature coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
              break;
            case 2:
              // My Learning
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('My Learning feature coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
              break;
            case 3:
              // Profile
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile feature coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_outline),
            label: 'My Learning',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Mock data for testing
List<Course> _getMockCourses() {
  return [
    const Course(
      id: '1',
      title: 'Complete Flutter Development Bootcamp',
      educatorName: 'Dr. Sarah Johnson',
      price: 2999,
      rating: 4.8,
      thumbnailUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400&h=200&fit=crop',
    ),
    const Course(
      id: '2',
      title: 'Advanced React Native Development',
      educatorName: 'Mike Chen',
      price: 2499,
      rating: 4.6,
      thumbnailUrl: 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=400&h=200&fit=crop',
    ),
    const Course(
      id: '3',
      title: 'Machine Learning Fundamentals',
      educatorName: 'Prof. Emily Rodriguez',
      price: 3999,
      rating: 4.9,
      thumbnailUrl: 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=400&h=200&fit=crop',
    ),
    const Course(
      id: '4',
      title: 'UI/UX Design Masterclass',
      educatorName: 'Alex Thompson',
      price: 1999,
      rating: 4.7,
      thumbnailUrl: 'https://images.unsplash.com/photo-1558655146-d09347e92766?w=400&h=200&fit=crop',
    ),
    const Course(
      id: '5',
      title: 'Python for Data Science',
      educatorName: 'Dr. Lisa Wang',
      price: 1799,
      rating: 4.5,
      thumbnailUrl: 'https://images.unsplash.com/photo-1526379095098-d400fd0bf935?w=400&h=200&fit=crop',
    ),
    const Course(
      id: '6',
      title: 'Digital Marketing Strategy',
      educatorName: 'James Wilson',
      price: 1299,
      rating: 4.4,
      thumbnailUrl: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=400&h=200&fit=crop',
    ),
  ];
}
