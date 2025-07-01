import 'package:flutter/material.dart';
import 'package:flutter_wc_app/models/ToiletRecordModel.dart';
import 'package:flutter_wc_app/view/AddRecordScreen.dart';
import 'package:flutter_wc_app/providers/ToiletProvider.dart';
import 'package:provider/provider.dart';

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
                const SizedBox(height: 16),
                // Fotoğraf önizlemesi
                if (record.fotoUrl != null && record.fotoUrl.isNotEmpty)
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        record.fotoUrl,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => const Icon(
                              Icons.broken_image,
                              size: 60,
                              color: Colors.grey,
                            ),
                      ),
                    ),
                  )
                else
                  const Center(
                    child: Text(
                      'Fotoğraf yok',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                // Güncelleme ekranına yönlendir
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => AddRecordScreen(
                          // Eğer AddRecordScreen güncelleme destekliyorsa, ilgili kaydı parametre olarak gönderin
                          // ör: record: record
                        ),
                  ),
                );
              },
              icon: const Icon(Icons.edit, color: Colors.orange),
              label: const Text('Düzenle'),
            ),
            TextButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                // Silme işlemi için onay al
                final confirm = await showDialog<bool>(
                  context: context,
                  builder:
                      (_) => AlertDialog(
                        title: const Text('Silme Onayı'),
                        content: const Text('Bu kayıt silinsin mi?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('İptal'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              'Sil',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                );
                if (confirm == true) {
                  // Silme işlemi
                  final provider = Provider.of<ToiletProvider>(
                    context,
                    listen: false,
                  );
                  await provider.deleteRecord(record.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kayıt silindi')),
                  );
                }
              },
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text('Sil'),
            ),
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
              label: const Text('Tamam'),
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
