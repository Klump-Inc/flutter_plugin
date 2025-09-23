import 'package:flutter_test/flutter_test.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'helpers/pump_app.dart';

void main() {
  testWidgets('KCBottomSheet shows AccountEmail when email/phone are null',
      (tester) async {
    const checkoutData = KlumpCheckoutData(
      amount: 1000,
      merchantReference: 'ref',
      metaData: {'customer': 'User'},
      items: [
        KlumpCheckoutItem(
          imageUrl: 'https://example.com/img.png',
          itemUrl: 'https://example.com',
          name: 'Item',
          unitPrice: 1000,
          quantity: 1,
        ),
      ],
      merchantPublicKey: 'test_key',
    );

    await tester.pumpKCScreen(const KCBottomSheet(data: checkoutData));
    await tester.pump();

    expect(find.byType(AccountEmail), findsOneWidget);
    expect(find.byType(SelectBankFlow), findsOneWidget);
  });
}
