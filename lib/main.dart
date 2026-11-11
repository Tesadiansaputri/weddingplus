import 'package:flutter/material.dart';
import 'ui/bottom_navigation.dart';
import 'ui/home/chat_page.dart';
import 'ui/home/home_page.dart';
import 'ui/rencana_page.dart';
import 'ui/user_page.dart';
import 'ui/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'wedding+',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Montserrat'),
      home: const WelcomePage(),
      routes: {
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.rencana: (context) => const RencanaPage(),
        AppRoutes.chat: (context) => const ChatPage(),
        AppRoutes.user: (context) => const UserPage(),
      },
    );
  }
}