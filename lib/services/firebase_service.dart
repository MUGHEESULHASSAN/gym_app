import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart'; // import the generated file

class FirebaseService {
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
