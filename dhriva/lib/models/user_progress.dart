import 'package:cloud_firestore/cloud_firestore.dart';
import 'course.dart';

class UserProgress {
  final String userId;
  final Map<String, CourseProgress> enrolledCourses;
  final DateTime? lastLearningDate;
  final int streak;
  final int longestStreak;
  final int totalWatchMinutes;
  final int totalLessonsCompleted;

  const UserProgress({
    required this.userId,
    required this.enrolledCourses,
    this.lastLearningDate,
    required this.streak,
    required this.longestStreak,
    required this.totalWatchMinutes,
    required this.totalLessonsCompleted,
  });

  factory UserProgress.fromMap(Map<String, dynamic> map, String userId) {
    final enrolledCoursesMap = map['enrolledCourses'] as Map<String, dynamic>? ?? {};
    final enrolledCourses = enrolledCoursesMap.map(
      (key, value) => MapEntry(
        key,
        CourseProgress.fromMap(value as Map<String, dynamic>),
      ),
    );

    return UserProgress(
      userId: userId,
      enrolledCourses: enrolledCourses,
      lastLearningDate: map['lastLearningDate'] != null
          ? (map['lastLearningDate'] as Timestamp).toDate()
          : null,
      streak: map['streak'] ?? 0,
      longestStreak: map['longestStreak'] ?? 0,
      totalWatchMinutes: map['totalWatchMinutes'] ?? 0,
      totalLessonsCompleted: map['totalLessonsCompleted'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'enrolledCourses': enrolledCourses.map(
        (key, value) => MapEntry(key, value.toMap()),
      ),
      'lastLearningDate': lastLearningDate != null
          ? Timestamp.fromDate(lastLearningDate!)
          : null,
      'streak': streak,
      'longestStreak': longestStreak,
      'totalWatchMinutes': totalWatchMinutes,
      'totalLessonsCompleted': totalLessonsCompleted,
    };
  }

  // Calculate total progress percentage across all courses
  double get totalProgressPercentage {
    if (enrolledCourses.isEmpty) return 0.0;
    
    double totalProgress = 0.0;
    for (final courseProgress in enrolledCourses.values) {
      totalProgress += courseProgress.progressPercentage;
    }
    
    return totalProgress / enrolledCourses.length;
  }

  // Get total enrolled courses count
  int get totalEnrolledCourses => enrolledCourses.length;

  @override
  String toString() {
    return 'UserProgress(userId: $userId, streak: $streak, totalWatchMinutes: $totalWatchMinutes, totalLessonsCompleted: $totalLessonsCompleted)';
  }
}

class CourseProgress {
  final List<String> completedLessons;
  final int totalLessons;

  const CourseProgress({
    required this.completedLessons,
    required this.totalLessons,
  });

  factory CourseProgress.fromMap(Map<String, dynamic> map) {
    return CourseProgress(
      completedLessons: List<String>.from(map['completedLessons'] ?? []),
      totalLessons: map['totalLessons'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'completedLessons': completedLessons,
      'totalLessons': totalLessons,
    };
  }

  // Calculate progress percentage for this course
  double get progressPercentage {
    if (totalLessons == 0) return 0.0;
    return completedLessons.length / totalLessons;
  }

  // Get completed lessons count
  int get completedCount => completedLessons.length;

  // Check if course is completed
  bool get isCompleted => completedLessons.length >= totalLessons;

  @override
  String toString() {
    return 'CourseProgress(completed: ${completedLessons.length}/$totalLessons)';
  }
}

// Combined data model for dashboard display
class DashboardData {
  final UserProgress userProgress;
  final Map<String, Course> courses;

  const DashboardData({
    required this.userProgress,
    required this.courses,
  });

  // Get courses with progress data
  List<CourseWithProgress> get coursesWithProgress {
    return userProgress.enrolledCourses.entries.map((entry) {
      final courseId = entry.key;
      final progress = entry.value;
      final course = courses[courseId];
      
      return CourseWithProgress(
        course: course!,
        progress: progress,
      );
    }).toList();
  }
}

class CourseWithProgress {
  final Course course;
  final CourseProgress progress;

  const CourseWithProgress({
    required this.course,
    required this.progress,
  });
}

