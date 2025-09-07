import 'package:firebase_auth/firebase_auth.dart';
import 'chat_service.dart';

class MatchmakingService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  static String? get currentUserId => _auth.currentUser?.uid;

  // Find a study buddy based on similar interests/courses
  static Future<Map<String, String>?> findStudyBuddy() async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Get current user's enrolled courses
      final userCourses = await _getUserCourses(currentUserId!);
      
      // Find users with similar courses
      final potentialBuddies = await _findUsersWithSimilarCourses(userCourses);
      
      if (potentialBuddies.isEmpty) {
        // If no similar users found, create a mock buddy for demo
        return await _createMockBuddy();
      }
      
      // Select a random buddy from potential matches
      final selectedBuddy = potentialBuddies[DateTime.now().millisecondsSinceEpoch % potentialBuddies.length];
      
      return {
        'userId': selectedBuddy['userId'],
        'userName': selectedBuddy['userName'],
        'commonCourses': selectedBuddy['commonCourses'].toString(),
      };
    } catch (e) {
      // Fallback to mock buddy if there's an error
      return await _createMockBuddy();
    }
  }

  // Get user's enrolled courses (mock data for demo)
  static Future<List<String>> _getUserCourses(String userId) async {
    // In a real app, this would fetch from user's enrolled courses
    // For demo, return some mock courses
    return [
      'Complete Flutter Development Bootcamp',
      'Machine Learning Fundamentals',
      'UI/UX Design Masterclass',
    ];
  }

  // Find users with similar courses
  static Future<List<Map<String, dynamic>>> _findUsersWithSimilarCourses(List<String> userCourses) async {
    // In a real app, this would query users with similar course enrollments
    // For demo, return empty list to trigger mock buddy creation
    return [];
  }

  // Create a mock study buddy for demo purposes
  static Future<Map<String, String>> _createMockBuddy() async {
    final mockBuddies = [
      {
        'userId': 'mock_buddy_1',
        'userName': 'Alex Chen',
        'commonCourses': '2',
      },
      {
        'userId': 'mock_buddy_2', 
        'userName': 'Sarah Johnson',
        'commonCourses': '3',
      },
      {
        'userId': 'mock_buddy_3',
        'userName': 'Mike Wilson',
        'commonCourses': '1',
      },
      {
        'userId': 'mock_buddy_4',
        'userName': 'Emily Rodriguez',
        'commonCourses': '2',
      },
    ];

    // Select a random buddy
    final randomIndex = DateTime.now().millisecondsSinceEpoch % mockBuddies.length;
    return Map<String, String>.from(mockBuddies[randomIndex]);
  }

  // Start matchmaking process
  static Future<String> startMatchmaking() async {
    final buddy = await findStudyBuddy();
    
    if (buddy == null) {
      throw Exception('No study buddy found');
    }

    // Create or get existing chat with the buddy
    final chatId = await ChatService.getOrCreateChat(
      peerUserId: buddy['userId']!,
      peerUserName: buddy['userName']!,
    );

    return chatId;
  }

  // Get matchmaking status
  static Stream<String> getMatchmakingStatus() async* {
    yield 'Searching for study buddies...';
    await Future.delayed(const Duration(seconds: 1));
    
    yield 'Found potential matches!';
    await Future.delayed(const Duration(seconds: 1));
    
    yield 'Connecting you with a study buddy...';
    await Future.delayed(const Duration(seconds: 1));
    
    yield 'Match found!';
  }
}
