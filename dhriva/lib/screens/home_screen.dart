import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course.dart';
import '../models/review.dart';
import '../widgets/course_card.dart';
import '../widgets/shorts_horizontal_section.dart';
import '../widgets/study_buddy_fab.dart';
import 'shorts_feed_screen.dart';

// TODO: Replace with repository future provider
final coursesProvider = Provider<List<Course>>((ref) {
  return _getMockCourses();
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(coursesProvider);
    final isWeb = MediaQuery.of(context).size.width > 768;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      floatingActionButton: const StudyBuddyFAB(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: isWeb 
          ? Row(
              children: [
                const Text(
                  'Dhriva',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(width: 40),
                Expanded(
                  child: Container(
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
                ),
                const SizedBox(width: 20),
                TextButton(
                  onPressed: () {},
                  child: const Text('Browse'),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {},
                  child: const Text('Sign In'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Sign Up'),
                ),
              ],
            )
          : Container(
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
        centerTitle: !isWeb,
      ),
      body: isWeb 
        ? _buildWebLayout(courses)
        : _buildMobileLayout(courses),
      bottomNavigationBar: isWeb ? null : BottomNavigationBar(
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
              // Shorts
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShortsFeedScreen(),
                ),
              );
              break;
            case 2:
              // Wishlist
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Wishlist feature coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
              break;
            case 3:
              // My Learning
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('My Learning feature coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
              break;
            case 4:
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
            icon: Icon(Icons.video_library),
            label: 'Shorts',
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

  Widget _buildWebLayout(List<Course> courses) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(60),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF2563EB),
                  const Color(0xFF1D4ED8),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Learn Without Limits',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Start, switch, or advance your career with more than 5,000 courses, Professional Certificates, and degrees from world-class universities and companies.',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF2563EB),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Join for Free'),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Try for Free'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Shorts Section
          const ShortsHorizontalSection(),
          
          // Featured Courses Section
          Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Featured Courses',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 24),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return CourseCard(
                      course: course,
                      onWishlistToggle: () {
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(List<Course> courses) {
    return CustomScrollView(
      slivers: [
        // Hero Section for Mobile
        SliverToBoxAdapter(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF2563EB),
                  const Color(0xFF1D4ED8),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Learn Without Limits',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Start, switch, or advance your career with more than 5,000 courses, Professional Certificates, and degrees from world-class universities and companies.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF2563EB),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Join for Free'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Try for Free'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        // Shorts Section
        const SliverToBoxAdapter(
          child: ShortsHorizontalSection(),
        ),
        
        // Featured Courses Section
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == 0) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text(
                      'Featured Courses',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  );
                }
                
                final course = courses[index - 1];
                return CourseCard(
                  course: course,
                  onWishlistToggle: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added "${course.title}" to wishlist'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                );
              },
              childCount: courses.length + 1,
            ),
          ),
        ),
      ],
    );
  }
}

// Mock data for testing
List<Course> _getMockCourses() {
  return [
    Course(
      id: '1',
      title: 'Complete Flutter Development Bootcamp',
      educatorName: 'Dr. Sarah Johnson',
      price: 2999,
      rating: 4.8,
      thumbnailUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400&h=200&fit=crop',
      heroImageUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=1200&h=600&fit=crop',
      description: 'Master Flutter development from beginner to advanced level. Learn to build beautiful, responsive mobile applications for both iOS and Android platforms. This comprehensive course covers everything from basic widgets to complex state management, API integration, and app deployment.',
      modules: [
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
      reviews: [
        Review(
          id: '1',
          userName: 'Alex Chen',
          rating: 5.0,
          comment: 'Excellent course! The instructor explains everything clearly and the projects are very practical.',
          userAvatarUrl: 'https://picsum.photos/seed/alex/40/40',
          date: DateTime.now().subtract(const Duration(days: 5)),
        ),
        Review(
          id: '2',
          userName: 'Maria Garcia',
          rating: 4.5,
          comment: 'Great content and well-structured. Helped me land my first Flutter developer job!',
          userAvatarUrl: 'https://picsum.photos/seed/maria/40/40',
          date: DateTime.now().subtract(const Duration(days: 10)),
        ),
      ],
      startDate: DateTime.now().add(const Duration(days: 7)),
      duration: const Duration(hours: 40),
      level: 'Beginner to Advanced',
    ),
    Course(
      id: '2',
      title: 'Advanced React Native Development',
      educatorName: 'Mike Chen',
      price: 2499,
      rating: 4.6,
      thumbnailUrl: 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=400&h=200&fit=crop',
      heroImageUrl: 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=1200&h=600&fit=crop',
      description: 'Take your React Native skills to the next level with advanced concepts, performance optimization, and native module integration.',
      modules: [
        'Lesson 1: Advanced JavaScript Concepts',
        'Lesson 2: React Native Architecture',
        'Lesson 3: Performance Optimization',
        'Lesson 4: Native Module Integration',
        'Lesson 5: Advanced Navigation',
        'Lesson 6: State Management Patterns',
        'Lesson 7: Testing Strategies',
        'Lesson 8: App Store Deployment'
      ],
      reviews: [
        Review(
          id: '3',
          userName: 'John Smith',
          rating: 4.8,
          comment: 'Very comprehensive course with real-world examples.',
          userAvatarUrl: 'https://picsum.photos/seed/john/40/40',
          date: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ],
      startDate: DateTime.now().add(const Duration(days: 14)),
      duration: const Duration(hours: 30),
      level: 'Intermediate to Advanced',
    ),
    Course(
      id: '3',
      title: 'Machine Learning Fundamentals',
      educatorName: 'Prof. Emily Rodriguez',
      price: 3999,
      rating: 4.9,
      thumbnailUrl: 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=400&h=200&fit=crop',
      heroImageUrl: 'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=1200&h=600&fit=crop',
      description: 'Learn the fundamentals of machine learning with Python. From basic algorithms to neural networks and deep learning.',
      modules: [
        'Lesson 1: Introduction to ML',
        'Lesson 2: Data Preprocessing',
        'Lesson 3: Supervised Learning',
        'Lesson 4: Unsupervised Learning',
        'Lesson 5: Neural Networks',
        'Lesson 6: Deep Learning',
        'Lesson 7: Model Evaluation',
        'Lesson 8: Real-world Projects'
      ],
      reviews: [
        Review(
          id: '4',
          userName: 'David Kim',
          rating: 5.0,
          comment: 'Outstanding course! Professor Rodriguez makes complex topics easy to understand.',
          userAvatarUrl: 'https://picsum.photos/seed/david/40/40',
          date: DateTime.now().subtract(const Duration(days: 7)),
        ),
      ],
      startDate: DateTime.now().add(const Duration(days: 21)),
      duration: const Duration(hours: 50),
      level: 'Intermediate',
    ),
    Course(
      id: '4',
      title: 'UI/UX Design Masterclass',
      educatorName: 'Alex Thompson',
      price: 1999,
      rating: 4.7,
      thumbnailUrl: 'https://images.unsplash.com/photo-1558655146-d09347e92766?w=400&h=200&fit=crop',
      heroImageUrl: 'https://images.unsplash.com/photo-1558655146-d09347e92766?w=1200&h=600&fit=crop',
      description: 'Master the art of user interface and user experience design. Learn design principles, tools, and methodologies.',
      modules: [
        'Lesson 1: Design Principles',
        'Lesson 2: User Research',
        'Lesson 3: Wireframing',
        'Lesson 4: Prototyping',
        'Lesson 5: Visual Design',
        'Lesson 6: Usability Testing',
        'Lesson 7: Design Systems',
        'Lesson 8: Portfolio Building'
      ],
      reviews: [
        Review(
          id: '5',
          userName: 'Sarah Wilson',
          rating: 4.6,
          comment: 'Great course for beginners. The instructor provides excellent feedback on projects.',
          userAvatarUrl: 'https://picsum.photos/seed/sarah/40/40',
          date: DateTime.now().subtract(const Duration(days: 12)),
        ),
      ],
      startDate: DateTime.now().add(const Duration(days: 10)),
      duration: const Duration(hours: 25),
      level: 'Beginner to Intermediate',
    ),
    Course(
      id: '5',
      title: 'Python for Data Science',
      educatorName: 'Dr. Lisa Wang',
      price: 1799,
      rating: 4.5,
      thumbnailUrl: 'https://images.unsplash.com/photo-1526379095098-d400fd0bf935?w=400&h=200&fit=crop',
      heroImageUrl: 'https://images.unsplash.com/photo-1526379095098-d400fd0bf935?w=1200&h=600&fit=crop',
      description: 'Learn Python programming specifically for data science applications. From data analysis to machine learning.',
      modules: [
        'Lesson 1: Python Basics',
        'Lesson 2: NumPy and Pandas',
        'Lesson 3: Data Visualization',
        'Lesson 4: Statistical Analysis',
        'Lesson 5: Machine Learning with Scikit-learn',
        'Lesson 6: Data Cleaning',
        'Lesson 7: Real-world Projects',
        'Lesson 8: Advanced Topics'
      ],
      reviews: [
        Review(
          id: '6',
          userName: 'Michael Brown',
          rating: 4.4,
          comment: 'Solid course with practical examples. Good for data science beginners.',
          userAvatarUrl: 'https://picsum.photos/seed/michael/40/40',
          date: DateTime.now().subtract(const Duration(days: 8)),
        ),
      ],
      startDate: DateTime.now().add(const Duration(days: 5)),
      duration: const Duration(hours: 35),
      level: 'Beginner',
    ),
    Course(
      id: '6',
      title: 'Digital Marketing Strategy',
      educatorName: 'James Wilson',
      price: 1299,
      rating: 4.4,
      thumbnailUrl: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=400&h=200&fit=crop',
      heroImageUrl: 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=1200&h=600&fit=crop',
      description: 'Master digital marketing strategies and tools. Learn SEO, social media marketing, and analytics.',
      modules: [
        'Lesson 1: Digital Marketing Overview',
        'Lesson 2: SEO Fundamentals',
        'Lesson 3: Social Media Marketing',
        'Lesson 4: Content Marketing',
        'Lesson 5: Email Marketing',
        'Lesson 6: Analytics and Metrics',
        'Lesson 7: Paid Advertising',
        'Lesson 8: Marketing Automation'
      ],
      reviews: [
        Review(
          id: '7',
          userName: 'Emma Davis',
          rating: 4.3,
          comment: 'Good overview of digital marketing concepts. Practical assignments.',
          userAvatarUrl: 'https://picsum.photos/seed/emma/40/40',
          date: DateTime.now().subtract(const Duration(days: 15)),
        ),
      ],
      startDate: DateTime.now().add(const Duration(days: 3)),
      duration: const Duration(hours: 20),
      level: 'Beginner',
    ),
  ];
}
