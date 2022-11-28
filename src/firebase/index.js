// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getStorage } from "firebase/storage";

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyAt5U9Bmd8Rz4UT3bpWqs7WhbXypfpYOjc",
  authDomain: "musichain-9d5bb.firebaseapp.com",
  projectId: "musichain-9d5bb",
  storageBucket: "musichain-9d5bb.appspot.com",
  messagingSenderId: "501825881763",
  appId: "1:501825881763:web:01eea5cb536b7346702116"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const storage = getStorage(app);

export {
    storage
}