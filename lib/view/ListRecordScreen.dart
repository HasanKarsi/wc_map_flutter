import 'package:flutter/material.dart';
import 'package:flutter_wc_app/models/ToiletRecordModel.dart';
import 'package:flutter_wc_app/providers/ToiletProvider.dart';
import 'package:flutter_wc_app/view/AddRecordScreen.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    // Varsayılan tarih aralığı son 180 gün.
    var now = DateTime.now();
    _startDate = now.subtract(const Duration(days: 180));
    _endDate = now;
    // Kayıtları yükle.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ToiletProvider>(context, listen: false).fetchRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Provider'dan kayıtları al ve filtre uygula.
    var provider = Provider.of<ToiletProvider>(context);
    var records = provider.records.where(_applyFilters).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Kayıtlar')),
      body: Column(
        children: [
          // Filtreleme paneli.
          _buildFilters(),
          // Kayıtların listesi.
          Expanded(
            child:
                records.isEmpty
                    ? const Center(
                      child: Text(
                        'Kayıt bulunmamaktadır.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      itemCount: records.length,
                      itemBuilder: (context, index) {
                        var rec = records[index];
                        return RecordListItem(record: rec);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  /// Filtreleme panelini oluşturan widget.
  Widget _buildFilters() {
    return ExpansionTile(
      title: const Text('Filtrele'),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildDropdown(
                'Konum',
                konumlar,
                _konumFilter,
                (val) => setState(() => _konumFilter = val),
              ),
              _buildDropdown(
                'Sebep',
                sebepler,
                _sebepFilter,
                (val) => setState(() => _sebepFilter = val),
              ),
              _buildDropdown(
                'Tuvalet Dışkı',
                miktarlar,
                _diskTuvaletFilter,
                (val) => setState(() => _diskTuvaletFilter = val),
              ),
              _buildDropdown(
                'Bez Dışkı',
                miktarlar,
                _diskBezFilter,
                (val) => setState(() => _diskBezFilter = val),
              ),
              _buildDropdown(
                'Kıvam',
                kivamlar,
                _kivamFilter,
                (val) => setState(() => _kivamFilter = val),
              ),
              // Tarih aralığı seçimi.
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        var picked = await showDatePicker(
                          context: context,
                          initialDate: _startDate!,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) setState(() => _startDate = picked);
                      },
                      child: Text(
                        'Başlangıç: ${_startDate!.day}.${_startDate!.month}.${_startDate!.year}',
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        var picked = await showDatePicker(
                          context: context,
                          initialDate: _endDate!,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) setState(() => _endDate = picked);
                      },
                      child: Text(
                        'Bitiş: ${_endDate!.day}.${_endDate!.month}.${_endDate!.year}',
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
      decoration: InputDecoration(labelText: label),
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      value: value,
    );
  }

  /// Kayıtları filtreleyen fonksiyon.
  bool _applyFilters(ToiletRecord rec) {
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
    if (_startDate != null && oturmaTarihi.isBefore(_startDate!)) return false;
    if (_endDate != null && oturmaTarihi.isAfter(_endDate!)) return false;

    return true;
  }

  /// Kayıt tarihini stringden DateTime'a çevirir.
  DateTime? _parseDate(String str) {
    try {
      var parts = str.split(' ');
      var date = parts[0].split('.');
      var time = parts[1].split(':');
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
    // Fotoğraf işlemleri devre dışı bırakıldı!
    /*
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
    */
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
}
