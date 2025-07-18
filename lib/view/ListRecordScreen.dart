import 'package:flutter/material.dart';
import 'package:flutter_wc_app/models/ToiletRecordModel.dart';
import 'package:flutter_wc_app/providers/ToiletProvider.dart';
import 'package:flutter_wc_app/providers/UserProvider.dart';
import 'package:flutter_wc_app/view/AddRecordScreen.dart';
import 'package:provider/provider.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../widgets/RecordListItem.dart';

/// ListRecordsScreen, tuvalet kayıtlarının listelendiği ve filtrelenebildiği ekrandır.
/// Kullanıcı, kayıtları çeşitli kriterlere göre filtreleyebilir, kayıtları güncelleyebilir, silebilir veya fotoğrafını görüntüleyebilir.
class ListRecordsScreen extends StatefulWidget {
  const ListRecordsScreen({super.key});

  @override
  State<ListRecordsScreen> createState() => _ListRecordsScreenState();
}

class _ListRecordsScreenState extends State<ListRecordsScreen> {
  // Filtreler için değişkenler.
  String? _kullaniciFilter;
  String? _konumFilter = 'Tümü';
  String? _sebepFilter = 'Tümü';
  String? _diskTuvaletFilter = 'Tümü';
  String? _diskBezFilter = 'Tümü';
  String? _kivamFilter = 'Tümü';
  DateTime? _startDate;
  DateTime? _endDate;

  // Filtre seçenekleri için sabit listeler.
  final List<String> konumlar = ['Tümü', 'Ev', 'Kreş', 'Diğer'];
  final List<String> sebepler = [
    'Tümü',
    'Haber Verdi',
    'Bez Değişimi',
    'Rutin (Yemek Sonrası)',
    'Rutin (Banyo)',
    'Rutin (Diğer)',
  ];
  final List<String> miktarlar = ['Tümü', 'Yok', 'Az', 'Orta', 'Çok'];
  final List<String> kivamlar = [
    'Tümü',
    'Sert (Kabız)',
    'Yumuşak (Normal)',
    'Sulu (İshal)',
  ];

  bool _showAll = false; // Şifre ile tüm kayıtları gösterme durumu
  bool _showExportButton = false;

  @override
  void initState() {
    super.initState();
    // Varsayılan tarih aralığı son 180 gün.
    var now = DateTime.now();
    _startDate = now.subtract(const Duration(days: 180));
    _endDate = now;
    // Kullanıcı adını ayarla (örnek: UserProvider'dan alınıyor)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Kullanıcı adını Provider'dan al
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      setState(() {
        _kullaniciFilter = userProvider.kullaniciAdi;
      });
      Provider.of<ToiletProvider>(context, listen: false).fetchRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Provider'dan kayıtları al ve filtre uygula.
    var provider = Provider.of<ToiletProvider>(context);
    var records = provider.records.where(_applyFilters).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.list_alt, color: Colors.white, size: 28),
            const SizedBox(width: 10),
            const Text(
              'Kayıtlar',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue[700],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.lock_open),
            tooltip: 'Tüm Kayıtları Göster',
            onPressed: _showPasswordDialog,
          ),
          if (_showExportButton)
            IconButton(
              icon: const Icon(Icons.download),
              tooltip: 'Excel\'e Aktar',
              onPressed: () async {
                await _exportToExcel(provider.records);
              },
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue[700],
        icon: const Icon(Icons.add),
        label: const Text(
          "Yeni Kayıt",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddRecordScreen()),
          );
        },
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
        child: Column(
          children: [
            // Filtreleme paneli.
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: _buildFilters(),
              ),
            ),
            // Kayıtların listesi.
            Expanded(
              child:
                  provider
                          .isLoading // <-- ToiletProvider'da isLoading değişkeni olmalı
                      ? const Center(child: CircularProgressIndicator())
                      : records.isEmpty
                      ? const Center(
                        child: Text(
                          'Kayıt bulunmamaktadır.',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                      : RefreshIndicator(
                        onRefresh: () async {
                          await Provider.of<ToiletProvider>(
                            context,
                            listen: false,
                          ).fetchRecords();
                          setState(() {}); // Yenileme sonrası arayüzü güncelle
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          itemCount: records.length,
                          itemBuilder: (context, index) {
                            var rec = records[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: RecordListItem(record: rec),
                            );
                          },
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  /// Filtreleme panelini oluşturan widget.
  Widget _buildFilters() {
    return ExpansionTile(
      title: const Text(
        'Filtrele',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      'Konum',
                      konumlar,
                      _konumFilter,
                      (val) => setState(() => _konumFilter = val),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Sebep dropdown'u için Expanded yerine sabit genişlik kullan
                  SizedBox(
                    width: 250, // Genişliği artırarak taşmayı önle
                    child: _buildDropdown(
                      'Sebep',
                      sebepler,
                      _sebepFilter,
                      (val) => setState(() => _sebepFilter = val),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      'Tuvalet Dışkı',
                      miktarlar,
                      _diskTuvaletFilter,
                      (val) => setState(() => _diskTuvaletFilter = val),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildDropdown(
                      'Bez Dışkı',
                      miktarlar,
                      _diskBezFilter,
                      (val) => setState(() => _diskBezFilter = val),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildDropdown(
                'Kıvam',
                kivamlar,
                _kivamFilter,
                (val) => setState(() => _kivamFilter = val),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.date_range),
                      onPressed: () async {
                        var picked = await showDatePicker(
                          context: context,
                          initialDate: _startDate!,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) setState(() => _startDate = picked);
                      },
                      label: Text(
                        'Başlangıç: ${_startDate!.day}.${_startDate!.month}.${_startDate!.year}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.date_range),
                      onPressed: () async {
                        var picked = await showDatePicker(
                          context: context,
                          initialDate: _endDate!,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) setState(() => _endDate = picked);
                      },
                      label: Text(
                        'Bitiş: ${_endDate!.day}.${_endDate!.month}.${_endDate!.year}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Dropdown filtre widget'ı.
  Widget _buildDropdown(
    String label,
    List<String> items,
    String? value,
    void Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      value: value,
    );
  }

  DateTime _onlyDate(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  /// Kayıtları filtreleyen fonksiyon.
  bool _applyFilters(ToiletRecord rec) {
    // Şifre girilmediyse sadece kendi kullanıcı adını göster
    if (!_showAll &&
        _kullaniciFilter != null &&
        rec.kullanici != _kullaniciFilter)
      return false;
    if (_konumFilter != 'Tümü' && rec.konum != _konumFilter) return false;
    if (_sebepFilter != 'Tümü' && rec.gitmeSebebi != _sebepFilter) return false;
    if (_diskTuvaletFilter != 'Tümü' &&
        rec.diskMiktariTuvalet != _diskTuvaletFilter)
      return false;
    if (_diskBezFilter != 'Tümü' && rec.diskMiktariBez != _diskBezFilter)
      return false;
    if (_kivamFilter != 'Tümü' && rec.kivam != _kivamFilter) return false;

    var oturmaTarihi = _parseDate(rec.oturmaSaati);
    if (oturmaTarihi == null) return false;
    if (_startDate != null &&
        _onlyDate(oturmaTarihi).isBefore(_onlyDate(_startDate!)))
      return false;
    if (_endDate != null &&
        _onlyDate(oturmaTarihi).isAfter(_onlyDate(_endDate!)))
      return false;

    return true;
  }

  /// Kayıt tarihini stringden DateTime'a çevirir.
  DateTime? _parseDate(String str) {
    try {
      var parts = str.split(' ');
      if (parts.length < 2) return null;
      var date = parts[0].split('.');
      var time = parts[1].split(':');
      if (date.length < 3 || time.length < 2) return null;
      return DateTime(
        int.parse(date[2]),
        int.parse(date[1]),
        int.parse(date[0]),
        int.parse(time[0]),
        int.parse(time[1]),
      );
    } catch (e) {
      return null;
    }
  }

  /// Kayıt üzerinde yapılan işlemleri (güncelle, sil, fotoğraf) yönetir.
  void _handleAction(String action, ToiletRecord rec) {
    var provider = Provider.of<ToiletProvider>(context, listen: false);

    if (action == 'delete') {
      _confirmDelete(rec, provider);
    } else if (action == 'update') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => AddRecordScreen()),
      );
      // Güncelleme ekranı detaylı şekilde ayrı bir ekranla yapılabilir.
    }
    // Fotoğraf işlemleri AKTIF!
    else if (action == 'photo') {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Fotoğraf'),
              content: Image.network(rec.fotoUrl),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Kapat'),
                ),
              ],
            ),
      );
    }
  }

  /// Silme işlemi için onay dialog'u.
  void _confirmDelete(ToiletRecord rec, ToiletProvider provider) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Silme Onayı'),
            content: const Text('Bu kayıt silinsin mi?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('İptal'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await provider.deleteRecord(rec.id!);
                },
                child: const Text('Sil'),
              ),
            ],
          ),
    );
  }

  /// Şifre dialogunu gösterir ve doğruysa tüm kayıtları açar.
  void _showPasswordDialog() async {
    String password = '';
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Şifre Gerekli'),
            content: TextField(
              autofocus: true,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Şifre'),
              onChanged: (val) => password = val,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('İptal'),
              ),
              TextButton(
                onPressed: () {
                  if (password == '2021') {
                    // Şifrenizi buradan değiştirebilirsiniz
                    setState(() {
                      _showAll = true;
                      _showExportButton = true;
                    });
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Hatalı şifre!')),
                    );
                  }
                },
                child: const Text('Tamam'),
              ),
            ],
          ),
    );
  }

  /// Kayıtları Excel dosyasına aktaran fonksiyon.
  Future<void> _exportToExcel(List<ToiletRecord> records) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Kayıtlar'];
    sheetObject.appendRow([
      TextCellValue('Kullanıcı'),
      TextCellValue('Konum'),
      TextCellValue('Oturma Saati'),
      TextCellValue('Oturma Süresi'),
      TextCellValue('Gitme Sebebi'),
      TextCellValue('Tuvalet Dışkı'),
      TextCellValue('Bez Dışkı'),
      TextCellValue('Kıvam'),
      TextCellValue('Fotoğraf URL'),
    ]);
    for (var rec in records) {
      sheetObject.appendRow([
        TextCellValue(rec.kullanici ?? ''),
        TextCellValue(rec.konum ?? ''),
        TextCellValue(rec.oturmaSaati ?? ''),
        TextCellValue(rec.oturmaSuresi?.toString() ?? ''),
        TextCellValue(rec.gitmeSebebi ?? ''),
        TextCellValue(rec.diskMiktariTuvalet ?? ''),
        TextCellValue(rec.diskMiktariBez ?? ''),
        TextCellValue(rec.kivam ?? ''),
        TextCellValue(rec.fotoUrl ?? ''),
      ]);
    }

    // İndirilenler klasörüne kaydet
    Directory? downloadsDir;
    try {
      downloadsDir =
          await getDownloadsDirectory(); // path_provider 2.0.8+ ile gelir
    } catch (e) {
      downloadsDir = await getExternalStorageDirectory(); // Alternatif olarak
    }
    String filePath = '${downloadsDir!.path}/kayitlar.xlsx';
    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode()!);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Excel dosyası kaydedildi: $filePath')),
    );
  }
}
