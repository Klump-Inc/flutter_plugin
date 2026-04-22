import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:klump_checkout/klump_checkout.dart';

import 'helpers/pump_app.dart';

void main() {
  testWidgets('OpayBrowserDisclaimer shows verification message',
      (tester) async {
    await tester.pumpKCWidget(const OpayBrowserDisclaimer());

    expect(find.text(OpayBrowserDisclaimer.message), findsOneWidget);
    expect(find.byType(KCBodyText1), findsOneWidget);
  });

  testWidgets('OpayBrowserDisclaimer uses bordered info container',
      (tester) async {
    await tester.pumpKCWidget(const OpayBrowserDisclaimer());

    final container = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(OpayBrowserDisclaimer),
            matching: find.byType(Container),
          )
          .first,
    );
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.border, isNotNull);
    expect(decoration.borderRadius, BorderRadius.circular(3.52));
  });
}
