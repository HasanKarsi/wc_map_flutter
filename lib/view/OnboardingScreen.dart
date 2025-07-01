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
      appBar: AppBar(
        title: const Text('Kullanıcı Bilgileri'),
        backgroundColor: Colors.blue[700],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        elevation: 4,
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
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person, size: 56, color: Colors.blue[700]),
                  const SizedBox(height: 16),
                  const Text(
                    "Hoş geldiniz!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _adController,
                    decoration: InputDecoration(
                      labelText: 'Adınız',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Konum',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.place),
                    ),
                    items:
                        konumlar
                            .map(
                              (k) => DropdownMenuItem(value: k, child: Text(k)),
                            )
                            .toList(),
                    onChanged: (val) => setState(() => _selectedKonum = val),
                    value: _selectedKonum,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.save),
                      label: const Text('Kaydet ve Devam Et'),
                      onPressed: () async {
                        // Alanlar doluysa bilgileri kaydet ve ana ekrana geç.
                        if (_adController.text.isNotEmpty &&
                            _selectedKonum != null) {
                          await userProvider.saveUserInfo(
                            _adController.text,
                            _selectedKonum!,
                          );
                          if (!mounted) return;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HomeScreen(),
                            ),
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
                    ),
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
