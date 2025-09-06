import 'package:flutter/material.dart';
import '../models/course.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;

  const CourseDetailScreen({
    super.key,
    required this.course,
  });

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 768;
    
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Hero Image with SliverAppBar
              SliverAppBar(
                expandedHeight: isWeb ? 400.0 : 250.0,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        widget.course.heroImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image,
                              size: 100,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                      // Gradient overlay for better text readability
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.4),
                            ],
                          ),
                        ),
                      ),
                      // Course title overlay for web
                      if (isWeb)
                        Positioned(
                          bottom: 20,
                          left: 20,
                          right: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.course.title,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'by ${widget.course.educatorName}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border, color: Colors.white),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Added to wishlist'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.share, color: Colors.white),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Share feature coming soon'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
              
              // Course Information Section
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(isWeb ? 40.0 : 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Course Title (only show on mobile since web shows it in hero)
                        if (!isWeb) ...[
                          Text(
                            widget.course.title,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          
                          // Educator Name
                          Text(
                            'by ${widget.course.educatorName}',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        
                        // Rating and Price Row
                        Row(
                          children: [
                            // Rating
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.course.rating.toString(),
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '(${widget.course.reviews.length} reviews)',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            // Price
                            Text(
                              '₹${widget.course.price.toStringAsFixed(0)}',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        // Metadata with Icons
                        _buildMetadataRow(),
                        const SizedBox(height: 20),
                        
                        // Tab Bar
                        TabBar(
                          controller: _tabController,
                          labelColor: Theme.of(context).colorScheme.primary,
                          unselectedLabelColor: Theme.of(context).colorScheme.secondary,
                          indicatorColor: Theme.of(context).colorScheme.primary,
                          tabs: const [
                            Tab(text: 'Overview'),
                            Tab(text: 'Curriculum'),
                            Tab(text: 'Reviews'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Tab Content
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(),
                    _buildCurriculumTab(),
                    _buildReviewsTab(),
                  ],
                ),
              ),
            ],
          ),
          
          // Sticky Enroll Now Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Enrolled in "${widget.course.title}"'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Enroll Now',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMetadataItem(
            icon: Icons.person,
            label: 'Educator',
            value: widget.course.educatorName,
          ),
        ),
        Expanded(
          child: _buildMetadataItem(
            icon: Icons.calendar_today,
            label: 'Starts',
            value: _formatDate(widget.course.startDate),
          ),
        ),
        Expanded(
          child: _buildMetadataItem(
            icon: Icons.schedule,
            label: 'Duration',
            value: _formatDuration(widget.course.duration),
          ),
        ),
        Expanded(
          child: _buildMetadataItem(
            icon: Icons.school,
            label: 'Level',
            value: widget.course.level,
          ),
        ),
      ],
    );
  }

  Widget _buildMetadataItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About this Course',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.course.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          
          // Course Features
          Text(
            'What You\'ll Learn',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...widget.course.modules.take(5).map((module) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    module,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          )),
          if (widget.course.modules.length > 5)
            Text(
              '... and ${widget.course.modules.length - 5} more lessons',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCurriculumTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20.0),
      itemCount: widget.course.modules.length,
      itemBuilder: (context, index) {
        final module = widget.course.modules[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              module,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Icon(
              Icons.play_circle_outline,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Playing: $module'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildReviewsTab() {
    if (widget.course.reviews.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.reviews,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No reviews yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20.0),
      itemCount: widget.course.reviews.length,
      itemBuilder: (context, index) {
        final review = widget.course.reviews[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(review.userAvatarUrl),
                      onBackgroundImageError: (exception, stackTrace) {
                        // Handle image loading error
                      },
                      child: Text(
                        review.userName.isNotEmpty ? review.userName[0].toUpperCase() : 'U',
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
                            review.userName,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              ...List.generate(5, (starIndex) {
                                return Icon(
                                  starIndex < review.rating.floor()
                                      ? Icons.star
                                      : starIndex < review.rating
                                          ? Icons.star_half
                                          : Icons.star_border,
                                  color: Colors.amber,
                                  size: 16,
                                );
                              }),
                              const SizedBox(width: 8),
                              Text(
                                _formatDate(review.date),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  review.comment,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours >= 24) {
      final days = (duration.inHours / 24).floor();
      return '$days day${days > 1 ? 's' : ''}';
    } else if (duration.inHours >= 1) {
      return '${duration.inHours}h';
    } else {
      return '${duration.inMinutes}m';
    }
  }
}
