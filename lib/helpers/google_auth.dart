import 'package:google_sign_in/google_sign_in.dart';

// Pembungkus login Google supaya kode di halaman Login tetap pendek.
class GoogleAuth {
  // ISI dengan "Web client ID" dari Google Cloud Console
  // (OAuth client bertipe Web application).
  // Contoh: '1234567890-abcdefg.apps.googleusercontent.com'
  static const String serverClientId =
      'ISI_WEB_CLIENT_ID.apps.googleusercontent.com';

  static bool _initialized = false;

  // Membuka pilihan akun Google.
  // Mengembalikan akun kalau berhasil, dan melempar error kalau
  // dibatalkan atau gagal (ditangkap di halaman Login).
  static Future<GoogleSignInAccount> signIn() async {
    if (!_initialized) {
      await GoogleSignIn.instance.initialize(serverClientId: serverClientId);
      _initialized = true;
    }
    return GoogleSignIn.instance.authenticate();
  }

  static Future<void> signOut() async {
    if (!_initialized) return;
    await GoogleSignIn.instance.signOut();
  }
}