import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_wc_app/models/ToiletRecordModel.dart';
import 'package:flutter_wc_app/providers/ToiletProvider.dart';
import 'package:flutter_wc_app/providers/UserProvider.dart';
import 'package:flutter_wc_app/view/HomeScreen.dart';
// import 'package:flutter_wc_app/services/StorageServices.dart'; // Fotoğraf işlemleri devre dışı
//import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

/// AddRecordScreen, yeni bir tuvalet kaydı eklemek için kullanılan ekran.
/// Kullanıcıdan gerekli bilgileri ve fotoğrafı alır, doğrulama yapar ve kaydı ekler.
class AddRecordScreen extends StatefulWidget {
  const AddRecordScreen({super.key});

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  // Oturma saati için tarih/zaman değişkeni.
  DateTime _oturmaSaati = DateTime.now();
  // Oturma süresi için controller.
  final TextEditingController _sureController = TextEditingController(
    text: '15',
  );

  // Formda seçilecek alanlar için değişkenler.
  String? _gitmeSebebi;
  String? _diskMiktariTuvalet;
  String? _diskMiktariBez;
  String? _kivam;

  // Seçilen fotoğraf dosyası.
  // File? _pickedImage;
  // final ImagePicker _picker = ImagePicker();

  // Sabit seçenek listeleri.
  final List<String> sebepList = [
    'Haber Verdi',
    'Bez Değişimi',
    'Rutin (Yemek Sonrası)',
    'Rutin (Banyo)',
    'Rutin (Diğer)',
  ];
  final List<String> miktarList = ['Yok', 'Az', 'Orta', 'Çok'];
  final List<String> kivamList = [
    'Sert (Kabız)',
    'Yumuşak (Normal)',
    'Sulu (İshal)',
  ];

  @override
  Widget build(BuildContext context) {
    // Provider'lar ile kullanıcı ve tuvalet kayıtlarına erişim.
    var userProvider = Provider.of<UserProvider>(context);
    var toiletProvider = Provider.of<ToiletProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Tuvalet Kaydı')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Kullanıcı adı ve değiştirme butonu.
            Row(
              children: [
                Expanded(
                  child: Text('Kullanıcı: ${userProvider.kullaniciAdi}'),
                ),
                TextButton(
                  onPressed: () async {
                    var yeniAd = await _showEditDialog(
                      context,
                      'Kullanıcı Adı',
                      userProvider.kullaniciAdi ?? '',
                    );
                    if (yeniAd != null && yeniAd.isNotEmpty) {
                      await userProvider.updateKullaniciAdi(yeniAd);
                    }
                  },
                  child: const Text('Değiştir'),
                ),
              ],
            ),
            // Konum ve değiştirme butonu.
            Row(
              children: [
                Expanded(child: Text('Konum: ${userProvider.konum}')),
                TextButton(
                  onPressed: () async {
                    var yeniKonum = await _showKonumDialog(
                      context,
                      userProvider.konum ?? '',
                    );
                    if (yeniKonum != null) {
                      await userProvider.updateKonum(yeniKonum);
                    }
                  },
                  child: const Text('Değiştir'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Oturma saati seçici.
            ListTile(
              title: Text('Oturulan Saat: ${_formatDateTime(_oturmaSaati)}'),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _oturmaSaati,
                    firstDate: DateTime.now().subtract(
                      const Duration(days: 180),
                    ),
                    lastDate: DateTime.now(),
                  );
                  if (selectedDate != null) {
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_oturmaSaati),
                    );
                    if (selectedTime != null) {
                      setState(() {
                        _oturmaSaati = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                      });
                    }
                  }
                },
              ),
            ),
            // Oturma süresi giriş alanı.
            TextField(
              controller: _sureController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tuvalette Oturulan Süre (dk)',
              ),
            ),
            const SizedBox(height: 16),
            // Gitme sebebi seçici.
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Tuvalete Gitme Sebebi',
              ),
              items:
                  sebepList
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
              onChanged: (val) => setState(() => _gitmeSebebi = val),
              value: _gitmeSebebi,
            ),
            // Tuvalette dışkı miktarı seçici.
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Tuvalette Dışkı Miktarı',
              ),
              items:
                  miktarList
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
              onChanged: (val) => setState(() => _diskMiktariTuvalet = val),
              value: _diskMiktariTuvalet,
            ),
            // Bezde dışkı miktarı seçici.
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Bezde Dışkı Miktarı',
              ),
              items:
                  miktarList
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
              onChanged: (val) => setState(() => _diskMiktariBez = val),
              value: _diskMiktariBez,
            ),
            // Dışkı kıvamı seçici.
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Dışkı Kıvamı'),
              items:
                  kivamList
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
              onChanged: (val) => setState(() => _kivam = val),
              value: _kivam,
            ),
            const SizedBox(height: 16),
            // Fotoğraf ekleme butonu ve önizlemesi DEVRE DIŞI!
            /*
            ElevatedButton.icon(
              onPressed: () async {
                final picked = await _picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (picked != null) {
                  setState(() {
                    _pickedImage = File(picked.path);
                  });
                }
              },
              icon: const Icon(Icons.photo),
              label: const Text('Fotoğraf Ekle'),
            ),
            if (_pickedImage != null) Image.file(_pickedImage!, height: 100),
            */
            const SizedBox(height: 24),
            // Kaydet butonu, doğrulama ve kayıt işlemi.
            ElevatedButton(
              onPressed: () async {
                if (_gitmeSebebi == null ||
                    _diskMiktariTuvalet == null ||
                    _diskMiktariBez == null ||
                    _kivam == null
                // || _pickedImage == null
                ) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        // "Tüm alanları doldurun ve fotoğraf ekleyin.",
                        "Tüm alanları doldurun.",
                      ),
                    ),
                  );
                  return;
                }

                // Fotoğrafı yükle ve kayıt oluştur.
                String fileName = _formatDateTime(_oturmaSaati);
                // String fotoUrl = await StorageService().uploadPhoto(
                //   _pickedImage!,
                //   "$fileName.jpg",
                // );
                String fotoUrl = ''; // Fotoğraf işlemleri devre dışı

                ToiletRecord record = ToiletRecord(
                  kullanici: userProvider.kullaniciAdi ?? '',
                  konum: userProvider.konum ?? '',
                  oturmaSaati: _formatDateTime(_oturmaSaati),
                  oturmaSuresi: int.tryParse(_sureController.text) ?? 15,
                  gitmeSebebi: _gitmeSebebi!,
                  diskMiktariTuvalet: _diskMiktariTuvalet!,
                  diskMiktariBez: _diskMiktariBez!,
                  kivam: _kivam!,
                  // fotoUrl: fotoUrl, // Fotoğraf işlemleri devre dışı
                );

                await toiletProvider.addRecord(record);

                if (!mounted) return;
                showDialog(
                  context: context,
                  builder:
                      (_) => AlertDialog(
                        title: const Text('Kayıt Başarılı'),
                        content: const Text('Kayıt başarıyla kaydedildi.'),
                        actions: [
                          TextButton(
                            onPressed:
                                () => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                  ),
                                  (route) => false,
                                ),
                            child: const Text('Tamam'),
                          ),
                        ],
                      ),
                );
              },
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }

  /// Tarih ve saati formatlayan yardımcı fonksiyon.
  String _formatDateTime(DateTime dt) {
    return "${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

  /// Kullanıcı adı düzenleme dialog'u.
  Future<String?> _showEditDialog(
    BuildContext context,
    String title,
    String current,
  ) {
    TextEditingController controller = TextEditingController(text: current);
    return showDialog<String>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('$title Değiştir'),
            content: TextField(controller: controller),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('İptal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, controller.text),
                child: const Text('Kaydet'),
              ),
            ],
          ),
    );
  }

  /// Konum seçme dialog'u.
  Future<String?> _showKonumDialog(BuildContext context, String current) {
    String? selected = current;
    return showDialog<String>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Konum Seç'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  ['Ev', 'Kreş', 'Diğer'].map((konum) {
                    return RadioListTile<String>(
                      title: Text(konum),
                      value: konum,
                      groupValue: selected,
                      onChanged: (val) {
                        setState(() {
                          selected = val!;
                        });
                        Navigator.pop(context, val);
                      },
                    );
                  }).toList(),
            ),
          ),
    );
  }
}
