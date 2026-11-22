import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:edit_doc_flutter/main.dart';

void main() {
  testWidgets('O aplicativo inicia corretamente', (WidgetTester tester) async {
    await tester.pumpWidget(const MeuApp());

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}