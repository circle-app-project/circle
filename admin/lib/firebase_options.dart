import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

/// Firebase configuration for the HLA admin **web** app.
///
/// ⚠️ The `apiKey` and `appId` below are PLACEHOLDERS. A Web app must be
/// registered on the `circle-60af7` Firebase project to obtain them. The
/// quickest way is to run, from this `admin/` directory:
///
///     flutterfire configure --project=circle-60af7 --platforms=web
///
/// which regenerates this file with the real web credentials. Alternatively,
/// register a Web app in the Firebase console (Project settings → Your apps →
/// Add app → Web) and paste its `apiKey` and `appId` here.
///
/// The non-secret identifiers (projectId, messagingSenderId, storageBucket)
/// are shared with the mobile app and already filled in.

 const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBdJoJ6xP2VH2fuAS4oUtQ1qQ2xDoIn5o8',
    appId: '1:497391679746:web:7a3f50c4e6f710119d2a1b',
    messagingSenderId: '497391679746',
    projectId: 'circle-60af7',
    authDomain: 'circle-60af7.firebaseapp.com',
    storageBucket: 'circle-60af7.firebasestorage.app',
    measurementId: 'G-3KQHB7RSVC',
  );

class DefaultFirebaseOptions {
}