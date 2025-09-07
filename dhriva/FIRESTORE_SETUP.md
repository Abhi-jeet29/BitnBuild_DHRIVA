# Firestore Setup Guide for My Learning Dashboard

This guide will help you set up the necessary Firestore data structure for the My Learning Dashboard to work properly.

## Database Structure

### 1. User Progress Document
**Path:** `users/{userId}/progress/stats`

```json
{
  "enrolledCourses": {
    "1": {
      "completedLessons": ["lesson_1", "lesson_2", "lesson_3", "lesson_4", "lesson_5"],
      "totalLessons": 10
    },
    "2": {
      "completedLessons": ["lesson_1", "lesson_2"],
      "totalLessons": 8
    },
    "3": {
      "completedLessons": ["lesson_1", "lesson_2", "lesson_3", "lesson_4", "lesson_5", "lesson_6", "lesson_7", "lesson_8"],
      "totalLessons": 8
    }
  },
  "lastLearningDate": "2024-01-15T10:30:00Z",
  "streak": 5,
  "longestStreak": 15,
  "totalWatchMinutes": 1247,
  "totalLessonsCompleted": 15
}
```

### 2. Courses Collection
**Path:** `courses/{courseId}`

```json
{
  "title": "Complete Flutter Development Bootcamp",
  "educatorName": "Dr. Sarah Johnson",
  "price": 2999,
  "rating": 4.8,
  "thumbnailUrl": "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400&h=200&fit=crop",
  "heroImageUrl": "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=1200&h=600&fit=crop",
  "description": "Master Flutter development from beginner to advanced level...",
  "modules": [
    "Lesson 1: Introduction to Flutter",
    "Lesson 2: Setting up Development Environment",
    "Lesson 3: Understanding Widgets",
    "Lesson 4: State Management with Provider",
    "Lesson 5: Navigation and Routing",
    "Lesson 6: Working with APIs",
    "Lesson 7: Local Storage and Database",
    "Lesson 8: Testing and Debugging",
    "Lesson 9: App Deployment",
    "Lesson 10: Advanced Topics"
  ],
  "reviews": [],
  "startDate": "2024-01-22T00:00:00Z",
  "durationHours": 40,
  "durationMinutes": 0,
  "level": "Beginner to Advanced"
}
```

## Quick Setup

### Option 1: Manual Setup
1. Open your Firebase Console
2. Go to Firestore Database
3. Create the collections and documents as shown above
4. Use the sample data provided

### Option 2: Programmatic Setup
You can use the `FirestoreSampleData` utility class:

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'utils/firestore_sample_data.dart';

// Get current user ID
final userId = FirebaseAuth.instance.currentUser?.uid;

if (userId != null) {
  // Create all sample data
  await FirestoreSampleData.createAllSampleData(userId);
}
```

## Field Descriptions

### User Progress Fields
- **enrolledCourses**: Map of course IDs to progress data
- **lastLearningDate**: Timestamp of last completed lesson (for streak calculation)
- **streak**: Current consecutive day streak
- **longestStreak**: Longest streak ever achieved
- **totalWatchMinutes**: Cumulative minutes of video watched
- **totalLessonsCompleted**: Total lessons completed across all courses

### Course Fields
- **title**: Course name
- **educatorName**: Instructor name
- **price**: Course price in cents
- **rating**: Average rating (0-5)
- **thumbnailUrl**: Course thumbnail image URL
- **heroImageUrl**: Course hero image URL
- **description**: Course description
- **modules**: List of lesson titles
- **reviews**: List of review objects
- **startDate**: Course start date
- **durationHours**: Course duration in hours
- **durationMinutes**: Additional minutes
- **level**: Difficulty level

## Testing the Dashboard

1. Ensure you have a user logged in
2. Create the user progress document with sample data
3. Create at least 3 courses in the courses collection
4. Navigate to the My Learning tab in the app
5. The dashboard should display your progress data

## Troubleshooting

- **Empty State**: If you see the empty state, check that the user progress document exists
- **Loading Forever**: Check your Firestore security rules allow read access
- **No Courses**: Ensure courses exist in the courses collection
- **Missing Images**: Verify the image URLs are accessible

## Security Rules

Make sure your Firestore security rules allow reading the data:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow users to read their own progress
    match /users/{userId}/progress/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Allow reading courses
    match /courses/{document} {
      allow read: if request.auth != null;
    }
  }
}
```
