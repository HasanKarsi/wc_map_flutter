import 'package:flutter/material.dart';
import 'package:flutter_wc_app/models/ToiletRecordModel.dart';
import 'package:flutter_wc_app/services/FirestoreServices.dart';
import 'package:flutter_wc_app/services/StorageServices.dart';

/// ToiletProvider, tuvalet kayıtlarını yönetmek için ChangeNotifier kullanan bir provider.
/// Kayıtları FirestoreService üzerinden alır, ekler, günceller ve siler.
class ToiletProvider extends ChangeNotifier {
  // Tüm tuvalet kayıtlarını tutan liste.
  List<ToiletRecord> _records = [];
  // Kayıtların dışarıdan okunabilmesi için getter.
  List<ToiletRecord> get records => _records;

  // Firestore işlemleri için servis.
  final FirestoreService _firestoreService = FirestoreService();

  bool isLoading = false;

  /// Firestore'dan tüm kayıtları çeker ve dinleyicilere bildirir.
  Future<void> fetchRecords() async {
    isLoading = true;
    notifyListeners();
    _records = await _firestoreService.getAllRecords();
    // Kayıtlar güncellendiğinde dinleyicilere haber ver.
    isLoading = false;
    notifyListeners();
  }

  /// Yeni bir tuvalet kaydı ekler ve kayıt listesini günceller.
  Future<void> addRecord(ToiletRecord record) async {
    await _firestoreService.addRecord(record);
    await fetchRecords(); // Kayıt eklendikten sonra tüm kayıtları yeniden getir.
  }

  /// Var olan bir kaydı günceller ve kayıt listesini yeniler.
  Future<void> updateRecord(ToiletRecord record) async {
    await _firestoreService.updateRecord(record);
    await fetchRecords();
  }

  /// Belirtilen id'ye sahip kaydı siler ve kayıt listesini günceller.
  Future<void> deleteRecord(String id) async {
    // Önce kaydı bul ve fotoğraf url'sini al
    final record = _records.firstWhere(
      (rec) => rec.id == id,
      //orElse: () => null,
    );
    if (record != null && record.fotoUrl != null && record.fotoUrl.isNotEmpty) {
      await StorageService().deletePhoto(record.fotoUrl);
    }
    await _firestoreService.deleteRecord(id);
    await fetchRecords();
  }
}
