// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:take_it_easy/app.dart';
import 'package:take_it_easy/resources/strings/app_strings.dart';
import 'package:take_it_easy/utils/string_utils.dart';
import 'package:take_it_easy/webservice/http_manager/http_manager.dart';

void main() async {
  print("object");
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
  final res = await TEst().sendRequest(HttpMethod.POST, endPoint: Endpoints.sigin, baseUrl: BaseUrl.local);
  print(res);
}

class TEst extends HttpManager {}
