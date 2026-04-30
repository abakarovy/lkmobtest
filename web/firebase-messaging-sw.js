importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyCikFSsp_s8RWL_sZSbUm_bA1wlcp60gLU",
  authDomain: "flytech-24f17.firebaseapp.com",
  projectId: "flytech-24f17",
  storageBucket: "flytech-24f17.appspot.com",
  messagingSenderId: "173322126082",
  appId: "1:173322126082:web:109899280bf4a517c5381b"
//
//  apiKey: 'AIzaSyCikFSsp_s8RWL_sZSbUm_bA1wlcp60gLU',
//  authDomain: 'flutterfire-e2e-tests.firebaseapp.com',
//  projectId: 'flutterfire-e2e-tests',
//  storageBucket: 'flutterfire-e2e-tests.appspot.com',
//  messagingSenderId: '406099696497',
//  appId: '1:406099696497:web:87e25e51afe982cd3574d0',

//  databaseURL:
//      'https://flutterfire-e2e-tests-default-rtdb.europe-west1.firebasedatabase.app',
//  measurementId: 'G-JN95N1JV2E',
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});