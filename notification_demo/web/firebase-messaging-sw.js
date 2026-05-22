// Give the service worker access to Firebase Messaging.
// Note: Using compat libraries is required since Service Workers run in a distinct environment.
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js");

// Initialize the Firebase app in the service worker by passing in the web configurations.
firebase.initializeApp({
  apiKey: "AIzaSyCqzzEyHE8SfGHbo98jhT7awFlA77fxexM",
  authDomain: "notification-demo-c82e6.firebaseapp.com",
  projectId: "notification-demo-c82e6",
  storageBucket: "notification-demo-c82e6.firebasestorage.app",
  messagingSenderId: "64115782291",
  appId: "1:64115782291:web:d8244112b1b716a61d9366",
  measurementId: "G-X5ZQN24V4P"
});

// Retrieve an instance of Firebase Messaging so that it can handle background messages.
const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  
  const notificationTitle = payload.notification.title || "New Notification";
  const notificationOptions = {
    body: payload.notification.body || "",
    icon: '/icons/Icon-192.png'
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
