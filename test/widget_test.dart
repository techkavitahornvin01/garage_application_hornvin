import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hornvin/auth/intro_screen.dart';
import 'package:hornvin/controllers/language_controller.dart';
import 'package:hornvin/main.dart';
import 'package:hornvin/screens/splash_screen.dart';
import 'package:hornvin/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App starts on splash screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'language_code': 'en'});
    await StorageService.init();

    final languageController = LanguageController();
    await languageController.loadSavedLanguage();

    await tester.pumpWidget(MyApp(languageController: languageController));

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(SplashScreen), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 2800));
    await tester.pumpAndSettle();

    expect(find.byType(IntroScreen), findsOneWidget);
  });
}
