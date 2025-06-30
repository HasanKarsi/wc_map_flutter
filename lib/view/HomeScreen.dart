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
        title: const Text('Tuvalet Takip'),
        actions: [
          // Kayıtları listeleme ekranına geçiş butonu.
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ListRecordsScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Kullanıcı adı varsa hoş geldin mesajı gösterilir.
            if (userProvider.kullaniciAdi != null)
              Text(
                'Hoş geldin, ${userProvider.kullaniciAdi}!',
                style: const TextStyle(fontSize: 18),
              ),
            const SizedBox(height: 20),
            // Yeni tuvalet kaydı ekleme ekranına geçiş butonu.
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddRecordScreen()),
                );
              },
              child: const Text('Yeni Tuvalet Kaydı Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}
