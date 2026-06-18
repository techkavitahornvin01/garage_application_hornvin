import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hornvin/screens/garage_wallet_page.dart';

void main() {
  testWidgets('Garage wallet page renders wallet content', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GarageWalletPage(),
        ),
      ),
    );

    expect(find.text('Garage Wallet'), findsWidgets);
    expect(find.text('QR Coupon Scanner'), findsOneWidget);
    expect(find.text('Scan History'), findsOneWidget);
    expect(find.text('Pending'), findsOneWidget);
    expect(find.text('Available'), findsOneWidget);
  });
}
