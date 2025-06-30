import 'package:flutter/material.dart';
import 'package:flutter_wc_app/models/ToiletRecordModel.dart';

/// Kayıt detaylarını gösteren şık dialog.
void showRecordDetailDialog(BuildContext context, ToiletRecord record) {
  showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.blue),
              const SizedBox(width: 8),
              const Text('Kayıt Detayları'),
            ],
          ),
          content: Container(
            constraints: const BoxConstraints(maxWidth: 350),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailRow(Icons.person, 'Kullanıcı', record.kullanici),
                _detailRow(Icons.place, 'Konum', record.konum),
                _detailRow(
                  Icons.access_time,
                  'Oturma Saati',
                  record.oturmaSaati,
                ),
                _detailRow(
                  Icons.timer,
                  'Oturma Süresi',
                  '${record.oturmaSuresi} dk',
                ),
                _detailRow(
                  Icons.event_note,
                  'Gitme Sebebi',
                  record.gitmeSebebi,
                ),
                _detailRow(
                  Icons.wc,
                  'Tuvalette Dışkı',
                  record.diskMiktariTuvalet,
                ),
                _detailRow(
                  Icons.baby_changing_station,
                  'Bezde Dışkı',
                  record.diskMiktariBez,
                ),
                _detailRow(Icons.texture, 'Kıvam', record.kivam),
                // Fotoğraf alanı devre dışı
              ],
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
              label: const Text('Kapat'),
            ),
          ],
        ),
  );
}

/// Detay satırı için yardımcı widget.
Widget _detailRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      children: [
        Icon(icon, size: 20, color: Colors.blueGrey),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.black87),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

/// Kayıt listesinde kullanılacak, tıklanınca detay gösteren widget.
class RecordListItem extends StatelessWidget {
  final ToiletRecord record;

  const RecordListItem({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.event_note, color: Colors.white),
        ),
        title: Text('${record.kullanici} - ${record.konum}'),
        subtitle: Text(
          'Saat: ${record.oturmaSaati}\nSüre: ${record.oturmaSuresi} dk',
        ),
        onTap: () => showRecordDetailDialog(context, record),
      ),
    );
  }
}
