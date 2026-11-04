import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../helpers/google_auth.dart';
import '../helpers/session.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Warna ditebak dari screenshot Figma.
  // Ganti dengan kode hex asli dari Figma kalau berbeda.
  static const Color _rose = Color(0xFFC58A85);
  static const Color _pink = Color(0xFFE7B6B0);
  static const Color _textDark = Color(0xFF3D3533);
  static const Color _hint = Color(0xFF9A8F8D);

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _login() {
    final id = _idController.text.trim();
    final password = _passwordController.text;

    if (id.isEmpty || password.isEmpty) {
      _showMessage('Email/nama dan password wajib diisi');
      return;
    }
    if (password.length < 8) {
      _showMessage('Password minimal 8 karakter');
      return;
    }

    // TODO: minggu 2 -> panggil API login di sini

    Session.isLoggedIn = true;
    _showMessage('Login berhasil');

    // Buka Home dan hapus halaman sebelumnya,
    // jadi tombol back tidak kembali ke Login.
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );
  }

  // Login dengan akun Google (hanya jalan di HP Android).
  Future<void> _loginWithGoogle() async {
    try {
      final account = await GoogleAuth.signIn();
      final idToken = account.authentication.idToken;

      // TODO: minggu 2 -> kirim idToken ke backend untuk diverifikasi,
      // lalu simpan token dari backend di Session.
      debugPrint('Google login: ${account.email}, idToken: ${idToken != null}');

      Session.isLoggedIn = true;
      if (!mounted) return;
      _showMessage('Masuk sebagai ${account.email}');

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    } catch (e) {
      debugPrint('Google login error: $e');
      if (!mounted) return;
      _showMessage('Login Google gagal atau dibatalkan');
    }
  }

  void _goToRegister() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: _textDark,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  InputDecoration _fieldDecoration(
    String hint,
    IconData icon, {
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _hint, fontSize: 12),
      prefixIcon: Icon(icon, color: _textDark, size: 22),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0x99FFFFFF),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _pink),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _rose, width: 1.5),
      ),
    );
  }

  // Tab "Masuk" / "Daftar" dengan garis bawah.
  Widget _tab(String text, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? _rose : const Color(0x33C58A85),
                width: selected ? 2 : 1,
              ),
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? _rose : const Color(0xFFD9B3AF),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _googleButton() {
    return GestureDetector(
      onTap: _loginWithGoogle,
      child: Container(
        width: 48,
        height: 48,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0x99FFFFFF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _pink),
        ),
        child: SvgPicture.asset(
          'assets/images/google.svg',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  // Panel kaca di bagian bawah layar.
  Widget _buildPanel() {
    final screen = MediaQuery.of(context);
    final bottomSpace = screen.viewInsets.bottom + screen.padding.bottom;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 480),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          // Efek kaca: buram pada bunga di belakang panel.
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(maxHeight: screen.size.height * 0.9),
            padding: EdgeInsets.fromLTRB(24, 16, 24, 16 + bottomSpace),
            decoration: const BoxDecoration(
              color: Color(0x66FFFFFF),
              border: Border(top: BorderSide(color: Color(0x99FFFFFF))),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Tab Masuk / Daftar
                  Row(
                    children: [
                      _tab('Masuk', true, () {}),
                      _tab('Daftar', false, _goToRegister),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Email atau Nama Lengkap
                  _label('Email atau Nama Lengkap'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _idController,
                    style: const TextStyle(color: _textDark, fontSize: 13),
                    decoration: _fieldDecoration(
                      'Masukan email atau nama lengkap',
                      Icons.mail_outline,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Password
                  _label('Password'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscure,
                    style: const TextStyle(color: _textDark, fontSize: 13),
                    decoration: _fieldDecoration(
                      'Masukan password',
                      Icons.lock_outline,
                      suffix: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: _hint,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscure = !_obscure;
                          });
                        },
                      ),
                    ),
                  ),

                  // Lupa Password?
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: halaman lupa password
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        minimumSize: const Size(0, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Lupa Password?',
                        style: TextStyle(color: _rose, fontSize: 11),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Tombol Masuk
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _rose,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(46),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // atau masuk dengan
                  const Text(
                    'atau masuk dengan',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _hint, fontSize: 10),
                  ),
                  const SizedBox(height: 8),
                  Center(child: _googleButton()),
                  const SizedBox(height: 8),

                  // Belum punya akun?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          'Belum punya akun?',
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: _hint, fontSize: 11),
                        ),
                      ),
                      TextButton(
                        onPressed: _goToRegister,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          minimumSize: const Size(0, 32),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Daftar sekarang',
                          style: TextStyle(color: _rose, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF4EF),
      // Latar tidak ikut bergeser saat keyboard muncul.
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Latar: bunga, logo, dan kalimat (hasil ekspor Figma).
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/images/Login.svg',
              fit: BoxFit.cover,
            ),
          ),
          // Panel kaca di bagian bawah.
          Align(alignment: Alignment.bottomCenter, child: _buildPanel()),
        ],
      ),
    );
  }
}