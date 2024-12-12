import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";

const firebaseConfig = {
  apiKey: "AIzaSyCEBgmyAVQE37AB1fABJLm1CJn5mih1i-Y",
  authDomain: "capstone--c242-ps301.firebaseapp.com",
  projectId: "capstone--c242-ps301",
  storageBucket: "capstone--c242-ps301.firebasestorage.app",
  messagingSenderId: "599704937134",
  appId: "1:599704937134:web:760e9d11cb02d5532f833f",
  measurementId: "G-WVEMQE53EE"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);