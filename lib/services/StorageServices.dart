import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// StorageService, Firebase Storage üzerinde fotoğraf yükleme ve silme işlemlerini yönetir.
class StorageService {
  // Firebase Storage örneği.
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Verilen dosyayı 'toilet_photos' klasörüne yükler ve indirme linkini döner.
  Future<String> uploadPhoto(File file, String fileName) async {
    Reference ref = _storage.ref().child('toilet_photos/$fileName');
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  /// Verilen dosya URL'sine sahip fotoğrafı siler.
  Future<void> deletePhoto(String fileUrl) async {
    try {
      Reference ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } catch (e) {
      // Fotoğraf yoksa hata verme
    }
  }
}
