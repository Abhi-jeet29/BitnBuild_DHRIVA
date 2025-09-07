import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/chat_screen.dart';

class StudyBuddyFAB extends ConsumerStatefulWidget {
  const StudyBuddyFAB({super.key});

  @override
  ConsumerState<StudyBuddyFAB> createState() => _StudyBuddyFABState();
}

class _StudyBuddyFABState extends ConsumerState<StudyBuddyFAB>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isMatching = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _startMatching() async {
    if (_isMatching) return;

    setState(() {
      _isMatching = true;
    });

    // Start pulsing animation
    _animationController.repeat(reverse: true);

    try {
      // Show matchmaking dialog
      _showMatchmakingDialog();
      
      // Simulate matchmaking process
      await Future.delayed(const Duration(seconds: 2));
      
      // Close dialog
      if (mounted) {
        Navigator.of(context).pop();
        
        // Navigate to chat screen with demo data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatId: 'demo_chat_${DateTime.now().millisecondsSinceEpoch}',
              peerUserName: 'Study Buddy',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to find a study buddy: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isMatching = false;
        });
        _animationController.stop();
        _animationController.reset();
      }
    }
  }

  void _showMatchmakingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
            ),
            const SizedBox(height: 16),
            const Text(
              'Finding your perfect study buddy...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 80, // Above bottom navigation
      right: 16,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _isMatching ? _scaleAnimation.value : 1.0,
            child: FloatingActionButton.extended(
              onPressed: _isMatching ? null : _startMatching,
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              elevation: 8,
              icon: _isMatching
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.people),
              label: Text(
                _isMatching ? 'Matching...' : 'Study Buddy',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Provider for study buddy state
final studyBuddyStateProvider = StateProvider<bool>((ref) => false);
