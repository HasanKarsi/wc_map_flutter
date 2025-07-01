import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_wc_app/models/ToiletRecordModel.dart';
import 'package:flutter_wc_app/providers/ToiletProvider.dart';
import 'package:flutter_wc_app/providers/UserProvider.dart';
import 'package:flutter_wc_app/view/HomeScreen.dart';
import 'package:flutter_wc_app/services/StorageServices.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddRecordScreen extends StatefulWidget {
  const AddRecordScreen({super.key});

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  DateTime _oturmaSaati = DateTime.now();
  final TextEditingController _sureController = TextEditingController(
    text: '15',
  );
  String? _gitmeSebebi;
  String? _diskMiktariTuvalet;
  String? _diskMiktariBez;
  String? _kivam;
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

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
    var userProvider = Provider.of<UserProvider>(context);
    var toiletProvider = Provider.of<ToiletProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Tuvalet Kaydı'),
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
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      size: 48,
                      color: Colors.blue[700],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Yeni Kayıt Ekle",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Kullanıcı adı ve değiştirme butonu.
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Kullanıcı: ${userProvider.kullaniciAdi}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
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
                        Expanded(
                          child: Text(
                            'Konum: ${userProvider.konum}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
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
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Oturulan Saat: ${_formatDateTime(_oturmaSaati)}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.calendar_today,
                          color: Colors.blue,
                        ),
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
                      decoration: InputDecoration(
                        labelText: 'Tuvalette Oturulan Süre (dk)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.timer),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Gitme sebebi seçici.
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Tuvalete Gitme Sebebi',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.event_note),
                      ),
                      items:
                          sebepList
                              .map(
                                (s) =>
                                    DropdownMenuItem(value: s, child: Text(s)),
                              )
                              .toList(),
                      onChanged: (val) => setState(() => _gitmeSebebi = val),
                      value: _gitmeSebebi,
                    ),
                    const SizedBox(height: 12),
                    // Tuvalette dışkı miktarı seçici.
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Tuvalette Dışkı Miktarı',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.wc),
                      ),
                      items:
                          miktarList
                              .map(
                                (s) =>
                                    DropdownMenuItem(value: s, child: Text(s)),
                              )
                              .toList(),
                      onChanged:
                          (val) => setState(() => _diskMiktariTuvalet = val),
                      value: _diskMiktariTuvalet,
                    ),
                    const SizedBox(height: 12),
                    // Bezde dışkı miktarı seçici.
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Bezde Dışkı Miktarı',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.baby_changing_station),
                      ),
                      items:
                          miktarList
                              .map(
                                (s) =>
                                    DropdownMenuItem(value: s, child: Text(s)),
                              )
                              .toList(),
                      onChanged: (val) => setState(() => _diskMiktariBez = val),
                      value: _diskMiktariBez,
                    ),
                    const SizedBox(height: 12),
                    // Dışkı kıvamı seçici.
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Dışkı Kıvamı',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.texture),
                      ),
                      items:
                          kivamList
                              .map(
                                (s) =>
                                    DropdownMenuItem(value: s, child: Text(s)),
                              )
                              .toList(),
                      onChanged: (val) => setState(() => _kivam = val),
                      value: _kivam,
                    ),
                    const SizedBox(height: 16),
                    // Fotoğraf ekleme butonu ve önizlemesi
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      onPressed: () async {
                        final picked = await _picker.pickImage(
                          source: ImageSource.camera,
                        );
                        if (picked != null) {
                          setState(() {
                            _pickedImage = File(picked.path);
                          });
                        }
                      },
                      icon: const Icon(Icons.photo_camera),
                      label: const Text(
                        'Fotoğraf Ekle',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (_pickedImage != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_pickedImage!, height: 120),
                        ),
                      ),
                    const SizedBox(height: 24),
                    // Kaydet butonu
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      onPressed: () async {
                        if (_gitmeSebebi == null ||
                            _diskMiktariTuvalet == null ||
                            _diskMiktariBez == null ||
                            _kivam == null ||
                            _pickedImage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Tüm alanları doldurun ve fotoğraf ekleyin.",
                              ),
                            ),
                          );
                          return;
                        }

                        String fileName = _formatDateTime(_oturmaSaati);
                        String fotoUrl = await StorageService().uploadPhoto(
                          _pickedImage!,
                          "$fileName.jpg",
                        );

                        ToiletRecord record = ToiletRecord(
                          kullanici: userProvider.kullaniciAdi ?? '',
                          konum: userProvider.konum ?? '',
                          oturmaSaati: _formatDateTime(_oturmaSaati),
                          oturmaSuresi:
                              int.tryParse(_sureController.text) ?? 15,
                          gitmeSebebi: _gitmeSebebi!,
                          diskMiktariTuvalet: _diskMiktariTuvalet!,
                          diskMiktariBez: _diskMiktariBez!,
                          kivam: _kivam!,
                          fotoUrl: fotoUrl,
                        );

                        await toiletProvider.addRecord(record);

                        if (!mounted) return;
                        showDialog(
                          context: context,
                          builder:
                              (_) => AlertDialog(
                                title: const Text('Kayıt Başarılı'),
                                content: const Text(
                                  'Kayıt başarıyla kaydedildi.',
                                ),
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
                      child: const Text(
                        'Kaydet',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return "${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
  }

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
