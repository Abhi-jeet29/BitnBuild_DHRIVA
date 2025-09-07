import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../models/shorts_video.dart';
import '../providers/shorts_provider.dart';

class ShortsFeedScreen extends ConsumerStatefulWidget {
  const ShortsFeedScreen({super.key});

  @override
  ConsumerState<ShortsFeedScreen> createState() => _ShortsFeedScreenState();
}

class _ShortsFeedScreenState extends ConsumerState<ShortsFeedScreen> {
  late PageController _pageController;
  int _currentIndex = 0;
  final Map<int, VideoPlayerController> _videoControllers = {};
  final Map<int, ChewieController> _chewieControllers = {};
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeVideos();
    });
  }

  void _initializeVideos() {
    if (_isInitialized) return;
    
    final videos = ref.read(shortsVideosProvider);
    // Only initialize the first 3 videos for better performance
    for (int i = 0; i < videos.length && i < 3; i++) {
      _initializeVideoController(i, videos[i]);
    }
    _isInitialized = true;
  }

  void _initializeVideoController(int index, ShortsVideo video) {
    final videoController = VideoPlayerController.networkUrl(
      Uri.parse(video.videoUrl),
    );
    
    videoController.initialize().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
    
    final chewieController = ChewieController(
      videoPlayerController: videoController,
      autoPlay: false,
      looping: true,
      showControls: false,
      showOptions: false,
      allowFullScreen: false,
      allowMuting: true,
      allowPlaybackSpeedChanging: false,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.red,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.lightGreen,
      ),
    );

    _videoControllers[index] = videoController;
    _chewieControllers[index] = chewieController;
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    for (var controller in _chewieControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    // Pause all videos
    for (var controller in _videoControllers.values) {
      controller.pause();
    }
    
    // Initialize video if not already initialized
    if (!_videoControllers.containsKey(index)) {
      final videos = ref.read(shortsVideosProvider);
      if (index < videos.length) {
        _initializeVideoController(index, videos[index]);
      }
    }
    
    // Play current video
    if (_videoControllers.containsKey(index)) {
      _videoControllers[index]!.play();
    }
  }

  void _onVideoTap() {
    final currentController = _videoControllers[_currentIndex];
    if (currentController != null) {
      if (currentController.value.isPlaying) {
        currentController.pause();
      } else {
        currentController.play();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final videos = ref.watch(shortsVideosProvider);
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        onPageChanged: _onPageChanged,
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return _buildVideoItem(videos[index], index);
        },
      ),
    );
  }

  Widget _buildVideoItem(ShortsVideo video, int index) {
    final isCurrentVideo = index == _currentIndex;
    final hasVideoController = _videoControllers.containsKey(index);
    final isVideoInitialized = hasVideoController && _videoControllers[index]!.value.isInitialized;
    
    return Stack(
      fit: StackFit.expand,
      children: [
        // Video Player
        GestureDetector(
          onTap: _onVideoTap,
          child: Container(
            color: Colors.black,
            child: isCurrentVideo && isVideoInitialized
                ? Chewie(controller: _chewieControllers[index]!)
                : Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(video.thumbnailUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.play_circle_filled,
                            color: Colors.white,
                            size: 80,
                          ),
                          if (hasVideoController && !isVideoInitialized)
                            const Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
        
        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.3),
                Colors.transparent,
                Colors.black.withValues(alpha: 0.7),
              ],
              stops: const [0.0, 0.3, 1.0],
            ),
          ),
        ),
        
        // Action buttons on the right
        Positioned(
          right: 16,
          bottom: 100,
          child: Column(
            children: [
              _buildActionButton(
                icon: video.isLiked ? Icons.favorite : Icons.favorite_border,
                color: video.isLiked ? Colors.red : Colors.white,
                count: video.likes,
                onTap: () => _onLikeTap(video),
              ),
              const SizedBox(height: 24),
              _buildActionButton(
                icon: Icons.comment_outlined,
                color: Colors.white,
                count: video.comments,
                onTap: () => _onCommentTap(video),
              ),
              const SizedBox(height: 24),
              _buildActionButton(
                icon: Icons.share,
                color: Colors.white,
                count: video.shares,
                onTap: () => _onShareTap(video),
              ),
              const SizedBox(height: 24),
              _buildActionButton(
                icon: Icons.bookmark_border,
                color: Colors.white,
                count: 0,
                onTap: () => _onBookmarkTap(video),
              ),
            ],
          ),
        ),
        
        // Course info at the bottom
        Positioned(
          left: 16,
          right: 80,
          bottom: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Educator info
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(video.educatorAvatar),
                    onBackgroundImageError: (exception, stackTrace) {
                      // Handle image loading error
                    },
                    child: Text(
                      video.educatorName.isNotEmpty 
                          ? video.educatorName[0].toUpperCase() 
                          : 'E',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video.educatorName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Educator',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Course title
              Text(
                video.courseTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              
              // Video title
              Text(
                video.title,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        
        // Play/Pause indicator
        if (!isCurrentVideo)
          const Center(
            child: Icon(
              Icons.play_circle_filled,
              color: Colors.white,
              size: 60,
            ),
          ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required int count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatCount(count),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  void _onLikeTap(ShortsVideo video) {
    // TODO: Implement like functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${video.isLiked ? 'Unliked' : 'Liked'} "${video.title}"'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onCommentTap(ShortsVideo video) {
    // TODO: Implement comment functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Comments for "${video.title}"'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onShareTap(ShortsVideo video) {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing "${video.title}"'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onBookmarkTap(ShortsVideo video) {
    // TODO: Implement bookmark functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bookmarked "${video.title}"'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
