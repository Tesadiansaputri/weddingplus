import 'package:flutter/material.dart';
import 'onboarding_page.dart';
import 'wedding_logo.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    // Tampilkan logo 2 detik, lalu pindah ke Onboarding.
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF4EF),
      body: Center(
        child: Image.asset(
          'assets/images/image 2.png',
          width: 200,
          // Kalau file logo belum ada, tampilkan logo sementara
          // supaya aplikasi tidak error.
          errorBuilder: (context, error, stackTrace) {
            return const WeddingLogo(size: 80);
          },
        ),
      ),
    );
  }
}