import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// UserProvider, kullanıcı adı ve konum bilgisini yönetmek için ChangeNotifier kullanan bir provider.
/// Kullanıcı bilgilerini SharedPreferences ile yerel olarak saklar ve günceller.
class UserProvider extends ChangeNotifier {
  // Kullanıcı adı bilgisini tutan değişken.
  String? _kullaniciAdi;
  // Kullanıcı konum bilgisini tutan değişken.
  String? _konum;

  // Kullanıcı adı getter'ı.
  String? get kullaniciAdi => _kullaniciAdi;
  // Konum getter'ı.
  String? get konum => _konum;

  /// SharedPreferences'tan kullanıcı bilgilerini yükler.
  Future<void> loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _kullaniciAdi = prefs.getString('kullaniciAdi');
    _konum = prefs.getString('konum');
    notifyListeners(); // Değişiklikleri dinleyen widget'lara bildirim gönderir.
  }

  /// Kullanıcı adı ve konum bilgisini kaydeder ve günceller.
  Future<void> saveUserInfo(String ad, String konum) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('kullaniciAdi', ad);
    await prefs.setString('konum', konum);
    _kullaniciAdi = ad;
    _konum = konum;
    notifyListeners();
  }

  /// Kullanıcı adını günceller ve kaydeder.
  Future<void> updateKullaniciAdi(String yeniAd) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('kullaniciAdi', yeniAd);
    _kullaniciAdi = yeniAd;
    notifyListeners();
  }

  /// Kullanıcı konumunu günceller ve kaydeder.
  Future<void> updateKonum(String yeniKonum) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('konum', yeniKonum);
    _konum = yeniKonum;
    notifyListeners();
  }
}
