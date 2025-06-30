import 'package:flutter/material.dart';
import 'package:flutter_wc_app/providers/UserProvider.dart';
import 'package:flutter_wc_app/view/HomeScreen.dart';
import 'package:provider/provider.dart';

/// OnboardingScreen, uygulamayı ilk kez kullanan kullanıcıdan ad ve konum bilgisini alır.
/// Kullanıcı bilgileri girildikten sonra kaydedilir ve ana ekrana yönlendirilir.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Kullanıcı adı için controller.
  final TextEditingController _adController = TextEditingController();
  // Seçilen konum.
  String? _selectedKonum;

  // Konum seçenekleri.
  final List<String> konumlar = ['Ev', 'Kreş', 'Diğer'];

  @override
  Widget build(BuildContext context) {
    // UserProvider ile kullanıcı bilgilerine erişim.
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Kullanıcı Bilgileri')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Ad giriş alanı.
            TextField(
              controller: _adController,
              decoration: const InputDecoration(labelText: 'Adınız'),
            ),
            const SizedBox(height: 16),
            // Konum seçici dropdown.
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Konum'),
              items:
                  konumlar
                      .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                      .toList(),
              onChanged: (val) => setState(() => _selectedKonum = val),
              value: _selectedKonum,
            ),
            const SizedBox(height: 24),
            // Kaydet ve devam et butonu.
            ElevatedButton(
              onPressed: () async {
                // Alanlar doluysa bilgileri kaydet ve ana ekrana geç.
                if (_adController.text.isNotEmpty && _selectedKonum != null) {
                  await userProvider.saveUserInfo(
                    _adController.text,
                    _selectedKonum!,
                  );
                  if (!mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                } else {
                  // Eksik bilgi varsa uyarı göster.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Lütfen tüm alanları doldurun"),
                    ),
                  );
                }
              },
              child: const Text('Kaydet ve Devam Et'),
            ),
          ],
        ),
      ),
    );
  }
}
