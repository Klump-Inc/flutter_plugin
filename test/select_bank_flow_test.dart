import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'helpers/pump_app.dart';
import 'klump_checkout_test.mocks.dart';

void main() {
  late MockKCChangeNotifier kcChangeNotifier;
  setUp(() {
    kcChangeNotifier = MockKCChangeNotifier();
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
    when(kcChangeNotifier.loanPartners).thenAnswer((_) => []);
    when(kcChangeNotifier.selectedBankFlow).thenAnswer((_) => null);
    when(kcChangeNotifier.isBusy).thenAnswer((_) => false);

    await mockNetworkImagesFor(() async {
      await tester.pumpKCWidget(
        ChangeNotifierProvider<KCChangeNotifier>.value(
          value: kcChangeNotifier,
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
    when(kcChangeNotifier.loanPartners).thenAnswer((_) => partners);
    when(kcChangeNotifier.selectedBankFlow).thenAnswer((_) => null);
    when(kcChangeNotifier.isBusy).thenAnswer((_) => false);
    when(kcChangeNotifier.setBankFlow(any)).thenAnswer((_) async {});

    await mockNetworkImagesFor(() async {
      await tester.pumpKCWidget(
        ChangeNotifierProvider<KCChangeNotifier>.value(
          value: kcChangeNotifier,
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
    verify(kcChangeNotifier.setBankFlow(partners.first)).called(1);
  });
}
