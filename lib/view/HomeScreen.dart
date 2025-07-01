import 'package:flutter/material.dart';
import 'package:flutter_wc_app/providers/UserProvider.dart';
import 'package:flutter_wc_app/view/AddRecordScreen.dart';
import 'package:flutter_wc_app/view/ListRecordScreen.dart';
import 'package:provider/provider.dart';

/// HomeScreen, uygulamanın ana ekranıdır.
/// Kullanıcıya hoş geldin mesajı gösterir ve yeni kayıt ekleme veya kayıtları listeleme seçenekleri sunar.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Kullanıcı bilgilerine erişmek için UserProvider kullanılır.
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: Colors.blue[700],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wc, color: Colors.white, size: 28),
            const SizedBox(width: 10),
            const Text(
              'Tuvalet Takip',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFF90CAF9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 8,
            margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.wc, size: 64, color: Colors.blue[700]),
                  const SizedBox(height: 16),
                  Text(
                    userProvider.kullaniciAdi != null
                        ? 'Hoş geldin, ${userProvider.kullaniciAdi}!'
                        : 'Hoş geldin!',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: Colors.blue[700],
                    ),
                    icon: const Icon(Icons.add, size: 24),
                    label: const Text(
                      'Yeni Tuvalet Kaydı Ekle',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AddRecordScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: BorderSide(color: Colors.blue[700]!),
                    ),
                    icon: Icon(Icons.list, color: Colors.blue[700]),
                    label: Text(
                      'Kayıtları Listele',
                      style: TextStyle(fontSize: 16, color: Colors.blue[700]),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ListRecordsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
