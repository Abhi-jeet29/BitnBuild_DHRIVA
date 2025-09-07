import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/message.dart';

class ChatService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  static String? get currentUserId => _auth.currentUser?.uid;

  // Get messages stream for a chat
  static Stream<List<Message>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Message.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Send a message
  static Future<void> sendMessage({
    required String chatId,
    required String text,
  }) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    final messageData = {
      'senderId': currentUserId!,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'chatId': chatId,
    };

    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(messageData);
  }

  // Create a new chat
  static Future<String> createChat({
    required String peerUserId,
    required String peerUserName,
  }) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    // Create chat document
    final chatData = {
      'participants': [currentUserId!, peerUserId],
      'participantNames': {
        currentUserId!: 'You', // This will be replaced with actual user name
        peerUserId: peerUserName,
      },
      'createdAt': FieldValue.serverTimestamp(),
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
    };

    final chatDoc = await _firestore.collection('chats').add(chatData);
    return chatDoc.id;
  }

  // Get or create chat with a peer
  static Future<String> getOrCreateChat({
    required String peerUserId,
    required String peerUserName,
  }) async {
    if (currentUserId == null) {
      throw Exception('User not authenticated');
    }

    // First, try to find existing chat
    final existingChats = await _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUserId!)
        .get();

    for (var chatDoc in existingChats.docs) {
      final data = chatDoc.data();
      final participants = List<String>.from(data['participants'] ?? []);
      
      if (participants.contains(peerUserId)) {
        return chatDoc.id;
      }
    }

    // If no existing chat found, create a new one
    return await createChat(
      peerUserId: peerUserId,
      peerUserName: peerUserName,
    );
  }

  // Update last message in chat
  static Future<void> updateLastMessage({
    required String chatId,
    required String message,
  }) async {
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': message,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  // Get user's chats
  static Stream<List<Map<String, dynamic>>> getUserChats() {
    if (currentUserId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUserId!)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'chatId': doc.id,
          ...data,
        };
      }).toList();
    });
  }
}
