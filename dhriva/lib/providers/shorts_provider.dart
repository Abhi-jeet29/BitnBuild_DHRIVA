import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/shorts_video.dart';

// Provider for shorts videos
final shortsVideosProvider = Provider<List<ShortsVideo>>((ref) {
  return _getMockShortsVideos();
});

// Provider for current video index
final currentVideoIndexProvider = StateProvider<int>((ref) => 0);

// Provider for video interactions (likes, comments, shares)
final videoInteractionsProvider = StateNotifierProvider<VideoInteractionsNotifier, Map<String, VideoInteraction>>((ref) {
  return VideoInteractionsNotifier();
});

class VideoInteraction {
  final bool isLiked;
  final int likes;
  final int comments;
  final int shares;
  final bool isBookmarked;

  const VideoInteraction({
    this.isLiked = false,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.isBookmarked = false,
  });

  VideoInteraction copyWith({
    bool? isLiked,
    int? likes,
    int? comments,
    int? shares,
    bool? isBookmarked,
  }) {
    return VideoInteraction(
      isLiked: isLiked ?? this.isLiked,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}

class VideoInteractionsNotifier extends StateNotifier<Map<String, VideoInteraction>> {
  VideoInteractionsNotifier() : super({});

  void toggleLike(String videoId) {
    final current = state[videoId] ?? const VideoInteraction();
    state = {
      ...state,
      videoId: current.copyWith(
        isLiked: !current.isLiked,
        likes: current.isLiked ? current.likes - 1 : current.likes + 1,
      ),
    };
  }

  void addComment(String videoId) {
    final current = state[videoId] ?? const VideoInteraction();
    state = {
      ...state,
      videoId: current.copyWith(comments: current.comments + 1),
    };
  }

  void addShare(String videoId) {
    final current = state[videoId] ?? const VideoInteraction();
    state = {
      ...state,
      videoId: current.copyWith(shares: current.shares + 1),
    };
  }

  void toggleBookmark(String videoId) {
    final current = state[videoId] ?? const VideoInteraction();
    state = {
      ...state,
      videoId: current.copyWith(isBookmarked: !current.isBookmarked),
    };
  }
}

// Mock data for shorts videos
List<ShortsVideo> _getMockShortsVideos() {
  return [
    ShortsVideo(
      id: '1',
      title: 'Learn Flutter in 60 seconds! 🚀',
      educatorName: 'Dr. Sarah Johnson',
      educatorAvatar: 'https://picsum.photos/seed/sarah/80/80',
      videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
      thumbnailUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400&h=600&fit=crop',
      courseId: '1',
      courseTitle: 'Complete Flutter Development Bootcamp',
      likes: 12500,
      comments: 234,
      shares: 89,
      duration: const Duration(minutes: 1),
      description: 'Quick overview of Flutter development basics',
    ),
    ShortsVideo(
      id: '2',
      title: 'React Native vs Flutter - Which is Better?',
      educatorName: 'Mike Chen',
      educatorAvatar: 'https://picsum.photos/seed/mike/80/80',
      videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4',
      thumbnailUrl: 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=400&h=600&fit=crop',
      courseId: '2',
      courseTitle: 'Advanced React Native Development',
      likes: 8900,
      comments: 156,
      shares: 67,
      duration: const Duration(minutes: 1, seconds: 30),
      description: 'Comparing the two most popular mobile development frameworks',
    ),
    ShortsVideo(
      id: '3',
      title: 'Machine Learning Explained Simply',
      educatorName: 'Prof. Emily Rodriguez',
      educatorAvatar: 'https://picsum.photos/seed/emily/80/80',
      videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_5mb.mp4',
      thumbnailUrl: 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=400&h=600&fit=crop',
      courseId: '3',
      courseTitle: 'Machine Learning Fundamentals',
      likes: 15600,
      comments: 312,
      shares: 124,
      duration: const Duration(minutes: 2),
      description: 'Understanding AI and machine learning concepts',
    ),
    ShortsVideo(
      id: '4',
      title: 'UI/UX Design Tips for Beginners',
      educatorName: 'Alex Thompson',
      educatorAvatar: 'https://picsum.photos/seed/alex/80/80',
      videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
      thumbnailUrl: 'https://images.unsplash.com/photo-1558655146-d09347e92766?w=400&h=600&fit=crop',
      courseId: '4',
      courseTitle: 'UI/UX Design Masterclass',
      likes: 7200,
      comments: 98,
      shares: 45,
      duration: const Duration(minutes: 1, seconds: 15),
      description: 'Essential design principles every developer should know',
    ),
    ShortsVideo(
      id: '5',
      title: 'Python Data Science Quick Start',
      educatorName: 'Dr. Lisa Wang',
      educatorAvatar: 'https://picsum.photos/seed/lisa/80/80',
      videoUrl: 'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4',
      thumbnailUrl: 'https://images.unsplash.com/photo-1526379095098-d400fd0bf935?w=400&h=600&fit=crop',
      courseId: '5',
      courseTitle: 'Python for Data Science',
      likes: 9800,
      comments: 187,
      shares: 73,
      duration: const Duration(minutes: 1, seconds: 45),
      description: 'Getting started with data analysis in Python',
    ),
  ];
}
