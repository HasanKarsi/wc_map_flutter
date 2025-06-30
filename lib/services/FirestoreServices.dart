import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_wc_app/models/ToiletRecordModel.dart';

/// FirestoreService, Firestore veritabanı ile tuvalet kayıtları üzerinde CRUD işlemleri yapar.
class FirestoreService {
  // Firestore'daki 'toiletRecords' koleksiyonuna referans.
  final CollectionReference _recordsRef = FirebaseFirestore.instance.collection(
    'toiletRecords',
  );

  /// Yeni bir tuvalet kaydı ekler.
  Future<void> addRecord(ToiletRecord record) async {
    await _recordsRef.add(record.toMap());
  }

  /// Var olan bir tuvalet kaydını günceller.
  Future<void> updateRecord(ToiletRecord record) async {
    if (record.id != null) {
      await _recordsRef.doc(record.id).update(record.toMap());
    }
  }

  /// Belirtilen id'ye sahip tuvalet kaydını siler.
  Future<void> deleteRecord(String id) async {
    await _recordsRef.doc(id).delete();
  }

  /// Tüm tuvalet kayıtlarını oturma saatine göre azalan şekilde getirir.
  Future<List<ToiletRecord>> getAllRecords() async {
    QuerySnapshot snapshot =
        await _recordsRef.orderBy('oturmaSaati', descending: true).get();
    return snapshot.docs
        .map(
          (doc) =>
              ToiletRecord.fromMap(doc.data() as Map<String, dynamic>, doc.id),
        )
        .toList();
  }
}
