import { getFirestore, collection, addDoc, doc, setDoc } from "firebase/firestore";
import { initializeApp } from "firebase/app";

const firebaseConfig = {
  apiKey: "AIzaSyCLAMAT_j9g00vPF9s9kwiNG0tI9Qh0IVs",
  authDomain: "dhriva-ea92a.firebaseapp.com",
  projectId: "dhriva-ea92a",
  storageBucket: "dhriva-ea92a.firebasestorage.app",
  messagingSenderId: "950438143945",
  appId: "1:950438143945:web:7cb4fd4fa121312294aa18"
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

// !!! DEFINE YOUR TEST USER ID HERE !!!
const TEST_USER_ID = "dMoiAmbhUTNbwDPGeh4tiOMQPZ93"; // You can make this any simple string you want.

async function seed() {
  try {
    console.log("Starting to seed data...");

    // 1. ADD COURSES
    const courses = [
      {
        title: "Digital Marketing Strategy",
        educatorName: "James Wilson",
        price: 499,
        rating: 4.4,
        thumbnailUrl: "https://picsum.photos/400/300?random=1",
        description: "Master the fundamentals of digital marketing...",
        totalLessons: 10
      },
      {
        title: "Introduction to Flutter Development",
        educatorName: "Your Name",
        price: 299,
        rating: 4.8,
        thumbnailUrl: "https://picsum.photos/400/300?random=2",
        description: "Learn how to build beautiful, fast apps...",
        totalLessons: 8
      }
    ];

    const courseIds = [];
    for (const course of courses) {
      const docRef = await addDoc(collection(db, "courses"), course);
      courseIds.push(docRef.id);
      console.log("Course added with ID: ", docRef.id);
    }

    // 2. ADD USER PROGRESS DATA
    // This creates or overwrites a document at the path: users/test_user_123/progress/stats
    const userProgressRef = doc(db, "users", TEST_USER_ID, "progress", "stats");
    
    await setDoc(userProgressRef, {
      streak: 3,
      longestStreak: 10,
      totalLessonsCompleted: 15,
      totalWatchMinutes: 284,
      lastLearningDate: new Date(), // Sets to right now
      enrolledCourses: {
        // This uses the first course ID from the array above
        [courseIds[0]]: {
          completedLessons: ["lesson_1", "lesson_2"],
          totalLessons: 10
        }
      }
    });

    console.log("✅ Dummy data added successfully!");
    console.log("📝 Test User ID for app login: ", TEST_USER_ID);

  } catch (e) {
    console.error("❌ Error adding document: ", e);
  }
}

seed();