import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_wc_app/app.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart'; // <<--- Firebase yapılandırma dosyası

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("⭕️ Firebase bağlantısı başarılı!");
  } catch (e) {
    print("❌ Firebase bağlantı hatası: $e");
  }
  runApp(const TuvaletTakipApp());
}
