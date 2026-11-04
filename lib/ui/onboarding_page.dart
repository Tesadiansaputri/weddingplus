import 'dart:ui';
import 'package:flutter/material.dart';
import 'login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _page = 0;

  // Satu gambar = satu halaman onboarding (hasil ekspor Figma).
  final List<String> _images = const [
    'assets/images/SOB 1.png',
    'assets/images/SOB 2.png',
    'assets/images/SOB 3.png',
  ];

  int get _lastPage => _images.length - 1;

  void _next() {
    if (_page < _lastPage) {
      setState(() {
        _page++;
      });
    } else {
      // Halaman terakhir (SOB 3) -> buka Login.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  void _back() {
    if (_page > 0) {
      setState(() {
        _page--;
      });
    }
  }

  // Tombol kaca: normal = putih transparan,
  // saat di-hover (atau ditekan) = warna E7B6B0 dengan tulisan C58A85.
  Widget _pillButton(String text, VoidCallback onPressed) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        // Efek kaca: buram pada gambar di belakang tombol.
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: OutlinedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.pressed)) {
                return const Color(0x99E7B6B0); // E7B6B0 transparan 60%
              }
              return const Color(0x66FFFFFF);
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.pressed)) {
                return const Color(0xFFC58A85);
              }
              return const Color(0xFF5B4A47);
            }),
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            side: WidgetStateProperty.all(
              const BorderSide(color: Color(0x99FFFFFF)),
            ),
            shape: WidgetStateProperty.all(const StadiumBorder()),
            minimumSize: WidgetStateProperty.all(const Size(88, 36)),
            textStyle: WidgetStateProperty.all(
              const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          child: Text(text),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF4EF),
      body: Stack(
        children: [
          // Gambar memenuhi seluruh layar.
          Positioned.fill(
            child: Image.asset(
              _images[_page],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFFF7DDD8),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Gambar ${_images[_page]} belum ada',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFF8A5A55)),
                  ),
                );
              },
            ),
          ),
          // Tombol di atas gambar.
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _page > 0 ? _pillButton('Kembali', _back) : const SizedBox(),
                  // Halaman ke-3 (SOB 3) bertuliskan "Mulai".
                  _pillButton(_page == 2 ? 'Mulai' : 'Lanjut', _next),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}