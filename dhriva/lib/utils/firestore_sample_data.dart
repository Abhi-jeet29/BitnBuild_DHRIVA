import 'package:cloud_firestore/cloud_firestore.dart';

/// Sample data setup for Firestore
/// This class provides methods to create sample data for testing the My Learning Dashboard
class FirestoreSampleData {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Creates sample user progress data
  /// Call this method to populate Firestore with test data
  static Future<void> createSampleUserProgress(String userId) async {
    try {
      // Sample user progress data
      final progressData = {
        'enrolledCourses': {
          '1': {
            'completedLessons': ['lesson_1', 'lesson_2', 'lesson_3', 'lesson_4', 'lesson_5'],
            'totalLessons': 10,
          },
          '2': {
            'completedLessons': ['lesson_1', 'lesson_2'],
            'totalLessons': 8,
          },
          '3': {
            'completedLessons': ['lesson_1', 'lesson_2', 'lesson_3', 'lesson_4', 'lesson_5', 'lesson_6', 'lesson_7', 'lesson_8'],
            'totalLessons': 8,
          },
        },
        'lastLearningDate': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1))),
        'streak': 5,
        'longestStreak': 15,
        'totalWatchMinutes': 1247,
        'totalLessonsCompleted': 15,
      };

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('progress')
          .doc('stats')
          .set(progressData);

      print('Sample user progress data created successfully!');
    } catch (e) {
      print('Error creating sample user progress: $e');
    }
  }

  /// Creates sample courses data
  static Future<void> createSampleCourses() async {
    try {
      final courses = [
        {
          'title': 'Complete Flutter Development Bootcamp',
          'educatorName': 'Dr. Sarah Johnson',
          'price': 2999,
          'rating': 4.8,
          'thumbnailUrl': 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400&h=200&fit=crop',
          'heroImageUrl': 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=1200&h=600&fit=crop',
          'description': 'Master Flutter development from beginner to advanced level. Learn to build beautiful, responsive mobile applications for both iOS and Android platforms.',
          'modules': [
            'Lesson 1: Introduction to Flutter',
            'Lesson 2: Setting up Development Environment',
            'Lesson 3: Understanding Widgets',
            'Lesson 4: State Management with Provider',
            'Lesson 5: Navigation and Routing',
            'Lesson 6: Working with APIs',
            'Lesson 7: Local Storage and Database',
            'Lesson 8: Testing and Debugging',
            'Lesson 9: App Deployment',
            'Lesson 10: Advanced Topics'
          ],
          'reviews': [],
          'startDate': Timestamp.fromDate(DateTime.now().add(const Duration(days: 7))),
          'durationHours': 40,
          'durationMinutes': 0,
          'level': 'Beginner to Advanced',
        },
        {
          'title': 'Advanced React Native Development',
          'educatorName': 'Mike Chen',
          'price': 2499,
          'rating': 4.6,
          'thumbnailUrl': 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=400&h=200&fit=crop',
          'heroImageUrl': 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=1200&h=600&fit=crop',
          'description': 'Take your React Native skills to the next level with advanced concepts, performance optimization, and native module integration.',
          'modules': [
            'Lesson 1: Advanced JavaScript Concepts',
            'Lesson 2: React Native Architecture',
            'Lesson 3: Performance Optimization',
            'Lesson 4: Native Module Integration',
            'Lesson 5: Advanced Navigation',
            'Lesson 6: State Management Patterns',
            'Lesson 7: Testing Strategies',
            'Lesson 8: App Store Deployment'
          ],
          'reviews': [],
          'startDate': Timestamp.fromDate(DateTime.now().add(const Duration(days: 14))),
          'durationHours': 30,
          'durationMinutes': 0,
          'level': 'Intermediate to Advanced',
        },
        {
          'title': 'Machine Learning Fundamentals',
          'educatorName': 'Prof. Emily Rodriguez',
          'price': 3999,
          'rating': 4.9,
          'thumbnailUrl': 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=400&h=200&fit=crop',
          'heroImageUrl': 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=1200&h=600&fit=crop',
          'description': 'Learn the fundamentals of machine learning with Python. From basic algorithms to neural networks and deep learning.',
          'modules': [
            'Lesson 1: Introduction to ML',
            'Lesson 2: Data Preprocessing',
            'Lesson 3: Supervised Learning',
            'Lesson 4: Unsupervised Learning',
            'Lesson 5: Neural Networks',
            'Lesson 6: Deep Learning',
            'Lesson 7: Model Evaluation',
            'Lesson 8: Real-world Projects'
          ],
          'reviews': [],
          'startDate': Timestamp.fromDate(DateTime.now().add(const Duration(days: 21))),
          'durationHours': 50,
          'durationMinutes': 0,
          'level': 'Intermediate',
        },
      ];

      for (int i = 0; i < courses.length; i++) {
        await _firestore
            .collection('courses')
            .doc('${i + 1}')
            .set(courses[i]);
      }

      print('Sample courses data created successfully!');
    } catch (e) {
      print('Error creating sample courses: $e');
    }
  }

  /// Creates all sample data
  static Future<void> createAllSampleData(String userId) async {
    await createSampleCourses();
    await createSampleUserProgress(userId);
    print('All sample data created successfully!');
  }

  /// Clears all sample data (for testing)
  static Future<void> clearSampleData(String userId) async {
    try {
      // Clear user progress
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('progress')
          .doc('stats')
          .delete();

      // Clear courses
      final coursesSnapshot = await _firestore.collection('courses').get();
      for (final doc in coursesSnapshot.docs) {
        await doc.reference.delete();
      }

      print('Sample data cleared successfully!');
    } catch (e) {
      print('Error clearing sample data: $e');
    }
  }
}
