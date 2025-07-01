import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_wc_app/app.dart';

import 'firebase_options.dart'; // <<--- Firebase yapılandırma dosyası

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool firebaseReady = false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("⭕️ Firebase bağlantısı başarılı!");
    firebaseReady = true;
  } catch (e) {
    print("❌ Firebase bağlantı hatası: $e");
  }
  runApp(MyRootApp(firebaseReady: firebaseReady));
}

class MyRootApp extends StatelessWidget {
  final bool firebaseReady;
  const MyRootApp({super.key, required this.firebaseReady});

  @override
  Widget build(BuildContext context) {
    if (firebaseReady) {
      return const TuvaletTakipApp();
    } else {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Firebase bağlantısı başarısız!",
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Lütfen uygulamayı tamamen kapatıp tekrar açın.",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
