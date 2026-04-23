import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

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

  testWidgets('SelectBankFlow disables search when no partners',
      (tester) async {
    when(kcChangeNotifier.loanPartners).thenAnswer((_) => []);
    when(kcChangeNotifier.selectedBankFlow).thenAnswer((_) => null);
    when(kcChangeNotifier.isBusy).thenAnswer((_) => false);
    when(kcChangeNotifier.initiateResponse).thenAnswer((_) => null);
    when(kcChangeNotifier.getLoanPartners()).thenAnswer((_) async {});

    await mockNetworkImagesFor(() async {
      await tester.pumpKCWidget(
        ChangeNotifierProvider<KCChangeNotifier>.value(
          value: kcChangeNotifier,
          builder: (context, _) => const SelectBankFlow(data: checkoutData),
        ),
      );
    });

    await tester.pump();
    await tester
        .pumpAndSettle(); // Allow Future.delayed in initState to complete
    expect(find.byType(KCLenderSearchDropdown), findsOneWidget);
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
        metadata: PartnerMetadataModel(
          partnerType: null,
          customerType: 'everyone',
          dropdownMessage: null,
          allowDynamicDownpayment: null,
        ),
      ),
    ];
    when(kcChangeNotifier.loanPartners).thenAnswer((_) => partners);
    when(kcChangeNotifier.selectedBankFlow).thenAnswer((_) => null);
    when(kcChangeNotifier.isBusy).thenAnswer((_) => false);
    when(kcChangeNotifier.initiateResponse).thenAnswer((_) => null);
    when(kcChangeNotifier.getLoanPartners()).thenAnswer((_) async {});
    when(kcChangeNotifier.setBankFlow(any)).thenAnswer((_) {});

    await mockNetworkImagesFor(() async {
      await tester.pumpKCWidget(
        ChangeNotifierProvider<KCChangeNotifier>.value(
          value: kcChangeNotifier,
          builder: (context, _) => const SelectBankFlow(data: checkoutData),
        ),
      );
    });

    await tester.pump();
    await tester
        .pumpAndSettle(); // Allow Future.delayed in initState to complete
    expect(find.byType(KCLenderSearchDropdown), findsOneWidget);
    expect(find.byType(KCPartnerPopupMenuItemContent), findsWidgets);
    await tester.ensureVisible(find.text('Polaris Bank'));
    await tester.tap(find.text('Polaris Bank'));
    await tester.pump();
    verify(kcChangeNotifier.setBankFlow(partners.first)).called(1);
  });

  testWidgets(
      'SelectBankFlow shows bank dropdown when selected partner has extra form fields',
      (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(800, 900));
    const partnerWithBanks = Partner(
      id: '1',
      name: 'Credit Direct',
      slug: 'credit-direct',
      isActive: true,
      requiresPrequalification: false,
      config: {
        'extra_form_fields': [
          {
            'options': [
              {'name': 'Access Bank'},
              {'name': 'GTBank'},
            ],
          },
        ],
      },
      isActiveForMobile: true,
      metadata: PartnerMetadataModel(
        partnerType: null,
        customerType: 'everyone',
        dropdownMessage: null,
        allowDynamicDownpayment: null,
      ),
    );
    when(kcChangeNotifier.loanPartners).thenAnswer((_) => [partnerWithBanks]);
    when(kcChangeNotifier.selectedBankFlow).thenAnswer((_) => partnerWithBanks);
    when(kcChangeNotifier.selectedBank).thenAnswer((_) => null);
    when(kcChangeNotifier.isBusy).thenAnswer((_) => false);
    when(kcChangeNotifier.initiateResponse).thenAnswer((_) => null);
    when(kcChangeNotifier.getLoanPartners()).thenAnswer((_) async {});

    await mockNetworkImagesFor(() async {
      await tester.pumpKCWidget(
        SizedBox(
          height: 900,
          child: ChangeNotifierProvider<KCChangeNotifier>.value(
            value: kcChangeNotifier,
            builder: (context, _) => const SelectBankFlow(data: checkoutData),
          ),
        ),
      );
    });

    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.byType(KCLenderSearchDropdown), findsOneWidget);
    expect(find.byType(KCBankSearchDropdown), findsOneWidget);
  });

  testWidgets(
      'SelectBankFlow shows universal lenders after tapping inactive partner',
      (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(800, 900));
    const universalLender = Partner(
      id: '1',
      name: 'Credit Direct',
      slug: 'credit-direct',
      logo: 'https://example.com/cdl.png',
      isActive: true,
      requiresPrequalification: false,
      config: {},
      isActiveForMobile: true,
      isAvailable: true,
      metadata: PartnerMetadataModel(
        partnerType: null,
        customerType: 'everyone',
        dropdownMessage: null,
        allowDynamicDownpayment: null,
      ),
    );
    const inactiveLender = Partner(
      id: '2',
      name: 'Fidelity Bank',
      slug: 'fidelity',
      logo: 'https://example.com/fid.png',
      isActive: false,
      requiresPrequalification: true,
      config: {},
      isActiveForMobile: false,
      isAvailable: true,
      metadata: PartnerMetadataModel(
        partnerType: null,
        customerType: 'its customers',
        dropdownMessage: null,
        allowDynamicDownpayment: null,
      ),
    );
    final partners = [universalLender, inactiveLender];
    when(kcChangeNotifier.loanPartners).thenAnswer((_) => partners);
    when(kcChangeNotifier.selectedBankFlow).thenAnswer((_) => null);
    when(kcChangeNotifier.selectedBank).thenAnswer((_) => null);
    when(kcChangeNotifier.isBusy).thenAnswer((_) => false);
    when(kcChangeNotifier.initiateResponse).thenAnswer((_) => null);
    when(kcChangeNotifier.getLoanPartners()).thenAnswer((_) async {});
    when(kcChangeNotifier.setBankFlow(any)).thenAnswer((_) {});

    await mockNetworkImagesFor(() async {
      await tester.pumpKCWidget(
        SizedBox(
          height: 900,
          child: ChangeNotifierProvider<KCChangeNotifier>.value(
            value: kcChangeNotifier,
            builder: (context, _) => const SelectBankFlow(data: checkoutData),
          ),
        ),
      );
    });

    await tester.pump();
    await tester.pumpAndSettle();
    await tester.tap(find.byType(TextField));
    await tester.pump();
    await tester.tap(find.text('Fidelity Bank'));
    await tester.pump();
    expect(find.textContaining("isn't on Klump yet"), findsOneWidget);
    expect(find.text('Credit Direct'), findsWidgets);
    await tester.tap(find.text('Go Back'));
    await tester.pump();
    expect(find.textContaining("isn't on Klump yet"), findsNothing);
    expect(find.text('First 1 below lends to all customers'), findsOneWidget);
  });
}
