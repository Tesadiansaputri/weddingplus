// Menyimpan status login sementara selama aplikasi berjalan.
class Session {
  static bool isLoggedIn = false;

  static String? get userName => null;

  // TODO: minggu 2 -> simpan token dari API login di sini
  static String? token;
}