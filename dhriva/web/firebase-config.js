// web/firebase-config.js
// Import the functions you need from the SDKs you need
import { initializeApp } from "https://www.gstatic.com/firebasejs/12.2.1/firebase-app.js";
// TODO: Add SDKs for Firebase products that you want to use
import { getAuth } from "https://www.gstatic.com/firebasejs/12.2.1/firebase-auth.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/12.2.1/firebase-firestore.js";

// Your web app's Firebase configuration
const firebaseConfig = {
    apiKey: "AIzadyCLAMAT_19g@qvFF9S5kwNkG0tJQ0h8IVe",
    authDomain: "dhriva-ea92a.firebaseapp.com",
    projectId: "dhriva-ea92a",
    storageBucket: "dhriva-ea92a.firebasestorage.app",
    messagingSenderId: "958438149945",
    appId: "1998438143945.web:996307b8d2d9bb4094aa18"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);

// Initialize Firebase services and export them
export const auth = getAuth(app);
export const db = getFirestore(app);