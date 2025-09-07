import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_progress.dart';
import '../models/course.dart';

// Provider for current user ID
final currentUserIdProvider = Provider<String?>((ref) {
  return FirebaseAuth.instance.currentUser?.uid;
});

// Provider for user progress data
final userProgressProvider = StreamProvider<UserProgress?>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  
  if (userId == null) {
    return Stream.value(null);
  }

  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('progress')
      .doc('stats')
      .snapshots()
      .map((snapshot) {
    if (!snapshot.exists) {
      return null;
    }
    
    return UserProgress.fromMap(snapshot.data()!, userId);
  });
});

// Provider for courses data
final coursesProvider = StreamProvider<List<Course>>((ref) {
  return FirebaseFirestore.instance
      .collection('courses')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) {
      return Course.fromMap(doc.data(), doc.id);
    }).toList();
  });
});

// Combined provider for dashboard data
final dashboardDataProvider = StreamProvider<DashboardData?>((ref) {
  final userProgressAsync = ref.watch(userProgressProvider);
  final coursesAsync = ref.watch(coursesProvider);

  return userProgressAsync.when(
    data: (userProgress) {
      if (userProgress == null) return Stream.value(null);
      
      return coursesAsync.when(
        data: (courses) {
          // Convert courses list to map for easy lookup
          final coursesMap = {
            for (final course in courses) course.id: course
          };
          
          return Stream.value(DashboardData(
            userProgress: userProgress,
            courses: coursesMap,
          ));
        },
        loading: () => Stream.value(null),
        error: (_, __) => Stream.value(null),
      );
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
});

// Provider for streak calculation
final streakProvider = Provider<int>((ref) {
  final userProgress = ref.watch(userProgressProvider).value;
  if (userProgress == null) return 0;
  
  // For demo purposes, return the stored streak
  // In production, this would calculate based on lastLearningDate
  return userProgress.streak;
});

// Provider for weekly activity data (simplified for demo)
final weeklyActivityProvider = Provider<List<bool>>((ref) {
  final userProgress = ref.watch(userProgressProvider).value;
  if (userProgress == null) return List.filled(7, false);
  
  // For demo, simulate some activity in the last 7 days
  // In production, this would be calculated from actual learning data
  final now = DateTime.now();
  final weekDays = List.generate(7, (index) {
    final day = now.subtract(Duration(days: 6 - index));
    // Simulate activity on some days (for demo)
    return day.weekday <= 5; // Monday to Friday
  });
  
  return weekDays;
});

// Provider for total statistics
final totalStatsProvider = Provider<Map<String, int>>((ref) {
  final dashboardData = ref.watch(dashboardDataProvider).value;
  if (dashboardData == null) {
    return {
      'totalWatchMinutes': 0,
      'totalLessonsCompleted': 0,
      'totalCourses': 0,
      'totalQuestions': 0, // Placeholder
    };
  }
  
  final userProgress = dashboardData.userProgress;
  return {
    'totalWatchMinutes': userProgress.totalWatchMinutes,
    'totalLessonsCompleted': userProgress.totalLessonsCompleted,
    'totalCourses': userProgress.totalEnrolledCourses,
    'totalQuestions': 0, // Placeholder for future implementation
  };
});
