class SurahResponse {
  int nomor;
  String nama;
  String namaLatin;
  int jumlahAyat;
  String tempatTurun;
  String arti;
  String deskripsi;
  String audio;

  SurahResponse({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.audio,
  });

  factory SurahResponse.fromJson(Map<String, dynamic> json) => SurahResponse(
    nomor: json["nomor"],
    nama: json["nama"],
    namaLatin: json["nama_latin"],
    jumlahAyat: json["jumlah_ayat"],
    tempatTurun: json["tempat_turun"],
    arti: json["arti"],
    deskripsi: json["deskripsi"],
    audio: json["audio"],
  );

  Map<String, dynamic> toJson() => {
    "nomor": nomor,
    "nama": nama,
    "nama_latin": namaLatin,
    "jumlah_ayat": jumlahAyat,
    "tempat_turun": tempatTurun,
    "arti": arti,
    "deskripsi": deskripsi,
    "audio": audio,
  };
}

class DetailSurahResponse {
  bool status;
  int nomor;
  String nama;
  String namaLatin;
  int jumlahAyat;
  String tempatTurun;
  String arti;
  String deskripsi;
  String audio;
  List<Ayat> ayat;
  SuratSenya suratSelanjutnya;
  SuratSenya suratSebelumnya;

  DetailSurahResponse({
    required this.status,
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.audio,
    required this.ayat,
    required this.suratSelanjutnya,
    required this.suratSebelumnya,
  });

  factory DetailSurahResponse.fromJson(Map<String, dynamic> json) =>
      DetailSurahResponse(
        status: json["status"],
        nomor: json["nomor"],
        nama: json["nama"],
        namaLatin: json["nama_latin"],
        jumlahAyat: json["jumlah_ayat"],
        tempatTurun: json["tempat_turun"],
        arti: json["arti"],
        deskripsi: json["deskripsi"],
        audio: json["audio"],
        ayat: List<Ayat>.from(json["ayat"].map((x) => Ayat.fromJson(x))),
        suratSelanjutnya: SuratSenya.fromJson(json["surat_selanjutnya"]),
        suratSebelumnya: SuratSenya.fromJson(json["surat_sebelumnya"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "nomor": nomor,
    "nama": nama,
    "nama_latin": namaLatin,
    "jumlah_ayat": jumlahAyat,
    "tempat_turun": tempatTurun,
    "arti": arti,
    "deskripsi": deskripsi,
    "audio": audio,
    "ayat": List<dynamic>.from(ayat.map((x) => x.toJson())),
    "surat_selanjutnya": suratSelanjutnya.toJson(),
    "surat_sebelumnya": suratSebelumnya.toJson(),
  };
}

class Ayat {
  int id;
  int surah;
  int nomor;
  String ar;
  String tr;
  String idn;

  Ayat({
    required this.id,
    required this.surah,
    required this.nomor,
    required this.ar,
    required this.tr,
    required this.idn,
  });

  factory Ayat.fromJson(Map<String, dynamic> json) => Ayat(
    id: json["id"],
    surah: json["surah"],
    nomor: json["nomor"],
    ar: json["ar"],
    tr: json["tr"],
    idn: json["idn"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "surah": surah,
    "nomor": nomor,
    "ar": ar,
    "tr": tr,
    "idn": idn,
  };
}

class SuratSenya {
  int id;
  int nomor;
  String nama;
  String namaLatin;
  int jumlahAyat;
  String tempatTurun;
  String arti;
  String deskripsi;
  String audio;

  SuratSenya({
    required this.id,
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.audio,
  });

  factory SuratSenya.fromJson(Map<String, dynamic> json) => SuratSenya(
    id: json["id"],
    nomor: json["nomor"],
    nama: json["nama"],
    namaLatin: json["nama_latin"],
    jumlahAyat: json["jumlah_ayat"],
    tempatTurun: json["tempat_turun"],
    arti: json["arti"],
    deskripsi: json["deskripsi"],
    audio: json["audio"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nomor": nomor,
    "nama": nama,
    "nama_latin": namaLatin,
    "jumlah_ayat": jumlahAyat,
    "tempat_turun": tempatTurun,
    "arti": arti,
    "deskripsi": deskripsi,
    "audio": audio,
  };
}
