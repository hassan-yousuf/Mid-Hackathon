import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:midhackathon/app/app.dart';
import 'package:midhackathon/core/constants/app_constants.dart';

void main() {
  testWidgets('App displays the splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text(AppConstants.appName), findsOneWidget);
    expect(find.text(AppConstants.appSlogan), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}
