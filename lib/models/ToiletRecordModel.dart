class ToiletRecord {
  String? id;
  String kullanici;
  String konum;
  String oturmaSaati;
  int oturmaSuresi;
  String gitmeSebebi;
  String diskMiktariTuvalet;
  String diskMiktariBez;
  String kivam;
  String fotoUrl; // Fotoğraf alanı devre dışı

  ToiletRecord({
    this.id,
    required this.kullanici,
    required this.konum,
    required this.oturmaSaati,
    required this.oturmaSuresi,
    required this.gitmeSebebi,
    required this.diskMiktariTuvalet,
    required this.diskMiktariBez,
    required this.kivam,
    required this.fotoUrl, // Fotoğraf alanı devre dışı
  });

  Map<String, dynamic> toMap() {
    return {
      'kullanici': kullanici,
      'konum': konum,
      'oturmaSaati': oturmaSaati,
      'oturmaSuresi': oturmaSuresi,
      'gitmeSebebi': gitmeSebebi,
      'diskMiktariTuvalet': diskMiktariTuvalet,
      'diskMiktariBez': diskMiktariBez,
      'kivam': kivam,
      'fotoUrl': fotoUrl, // Fotoğraf alanı devre dışı
    };
  }

  factory ToiletRecord.fromMap(Map<String, dynamic> map, String docId) {
    return ToiletRecord(
      id: docId,
      kullanici: map['kullanici'] ?? '',
      konum: map['konum'] ?? '',
      oturmaSaati: map['oturmaSaati'] ?? '',
      oturmaSuresi: map['oturmaSuresi'] ?? 0,
      gitmeSebebi: map['gitmeSebebi'] ?? '',
      diskMiktariTuvalet: map['diskMiktariTuvalet'] ?? '',
      diskMiktariBez: map['diskMiktariBez'] ?? '',
      kivam: map['kivam'] ?? '',
      fotoUrl: map['fotoUrl'] ?? '', // Fotoğraf alanı devre dışı
    );
  }
}
