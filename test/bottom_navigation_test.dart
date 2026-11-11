import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_wedding_planning_system/ui/atur_tanggal_page.dart';
import 'package:smart_wedding_planning_system/ui/asisten/asisten_page.dart';
import 'package:smart_wedding_planning_system/ui/bottom_navigation.dart';
import 'package:smart_wedding_planning_system/ui/home/chat_page.dart';
import 'package:smart_wedding_planning_system/ui/home/home_page.dart';
import 'package:smart_wedding_planning_system/ui/pencarian/pencarian_page.dart';
import 'package:smart_wedding_planning_system/ui/rencana_page.dart';
import 'package:smart_wedding_planning_system/ui/tabungan_pages.dart';
import 'package:smart_wedding_planning_system/ui/user_page.dart';
import 'package:smart_wedding_planning_system/ui/rencana/berkas_booking.dart';

Widget _appWithHome(Widget home) {
  return MaterialApp(
    home: home,
    routes: {
      AppRoutes.home: (context) => const HomePage(),
      AppRoutes.rencana: (context) => const RencanaPage(),
      AppRoutes.chat: (context) => const ChatPage(),
      AppRoutes.user: (context) => const UserPage(),
    },
  );
}

Future<void> _tapTab(WidgetTester tester, String label) async {
  final tab = find.text(label).last;
  await tester.ensureVisible(tab);
  await tester.tap(tab);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Bottom navigation switches tabs from Asisten', (tester) async {
    await tester.pumpWidget(_appWithHome(const AsistenPage()));

    await _tapTab(tester, 'Chat');
    expect(find.byType(ChatPage), findsOneWidget);

    await _tapTab(tester, 'User');
    expect(find.byType(UserPage), findsOneWidget);

    await _tapTab(tester, 'Beranda');
    expect(find.byType(HomePage), findsOneWidget);

    await _tapTab(tester, 'Rencana');
    expect(find.byType(RencanaPage), findsOneWidget);

    await _tapTab(tester, 'Rencana');
    expect(find.byType(RencanaPage), findsOneWidget);
  });

  testWidgets('Chat and User tabs work from Berkas', (tester) async {
    await tester.pumpWidget(_appWithHome(const BerkasBookingPage()));

    await _tapTab(tester, 'Chat');
    expect(find.byType(ChatPage), findsOneWidget);

    await _tapTab(tester, 'User');
    expect(find.byType(UserPage), findsOneWidget);
  });

  testWidgets('Chat and User tabs work from planning subpages', (
    tester,
  ) async {
    const subpages = <Widget>[
      AturTanggalPage(),
      PencarianPage(),
      TabunganPage(),
    ];

    for (final page in subpages) {
      await tester.pumpWidget(_appWithHome(page));
      await _tapTab(tester, 'Chat');
      expect(find.byType(ChatPage), findsOneWidget);

      await tester.pumpWidget(_appWithHome(page));
      await _tapTab(tester, 'User');
      expect(find.byType(UserPage), findsOneWidget);
    }
  });
}
