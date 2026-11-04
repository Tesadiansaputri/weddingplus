import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_wedding_planning_system/main.dart';
import 'package:smart_wedding_planning_system/ui/onboarding_page.dart';
import 'package:smart_wedding_planning_system/ui/welcome_page.dart';

void main() {
  testWidgets('MyApp starts on the welcome screen and advances to onboarding',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(WelcomePage), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pump();
    expect(find.byType(OnboardingPage), findsOneWidget);
  });
}
