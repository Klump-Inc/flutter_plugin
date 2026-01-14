import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

import 'helpers/pump_app.dart';
import 'klump_checkout_test.mocks.dart';

void main() {
  late MockKCLendersNotifier kcLendersNotifier;
  setUp(() {
    kcLendersNotifier = MockKCLendersNotifier();
  });

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

  testWidgets('SelectBankFlow disables popup when no partners', (tester) async {
    when(kcLendersNotifier.loanPartners).thenAnswer((_) => []);
    when(kcLendersNotifier.selectedBankFlow).thenAnswer((_) => null);
    when(kcLendersNotifier.isBusy).thenAnswer((_) => false);

    await mockNetworkImagesFor(() async {
      await tester.pumpKCWidget(
        ChangeNotifierProvider<KCLendersNotifier>.value(
          value: kcLendersNotifier,
          builder: (context, _) => const SelectBankFlow(data: checkoutData),
        ),
      );
    });

    await tester.pump();
    final popupFinder = find.byType(PopupMenuButton<Partner>);
    expect(popupFinder, findsOneWidget);
    // Tapping should not open menu since it's disabled
    await tester.tap(popupFinder);
    await tester.pump();
    expect(find.byType(KCPartnerPopupMenuItemContent), findsNothing);
  });

  testWidgets('SelectBankFlow selecting a partner calls setBankFlow',
      (tester) async {
    final partners = [
      const Partner(
        id: '1',
        name: 'Polaris Bank',
        slug: 'polaris',
        logo: 'https://example.com/polaris.png',
        isActive: true,
        requiresPrequalification: false,
        config: {},
        isActiveForMobile: true,
      ),
    ];
    when(kcLendersNotifier.loanPartners).thenAnswer((_) => partners);
    when(kcLendersNotifier.selectedBankFlow).thenAnswer((_) => null);
    when(kcLendersNotifier.isBusy).thenAnswer((_) => false);
    when(kcLendersNotifier.setBankFlow(any)).thenAnswer((_) async {
      return null;
    });

    await mockNetworkImagesFor(() async {
      await tester.pumpKCWidget(
        ChangeNotifierProvider<KCLendersNotifier>.value(
          value: kcLendersNotifier,
          builder: (context, _) => const SelectBankFlow(data: checkoutData),
        ),
      );
    });

    await tester.pump();
    await tester.tap(find.byType(PopupMenuButton<Partner>).first);
    await tester.pump();
    expect(find.byType(KCPartnerPopupMenuItemContent), findsWidgets);
    // The first item should be tappable and call setBankFlow
    await tester.tap(find.byType(KCPartnerPopupMenuItemContent).first);
    await tester.pump();
    verify(kcLendersNotifier.setBankFlow(partners.first)).called(1);
  });
}
