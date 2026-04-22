import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'helpers/pump_app.dart';

void main() {
  late TextEditingController searchController;
  late FocusNode focusNode;
  late List<Partner> partners;
  Partner? selectedPartner;
  late void Function(Partner) onSelect;
  Partner? inactiveTapPartner;

  setUp(() {
    searchController = TextEditingController();
    focusNode = FocusNode();
    selectedPartner = null;
    inactiveTapPartner = null;
    onSelect = (p) => selectedPartner = p;
    partners = [
      const Partner(
        id: '1',
        name: 'Credit Direct',
        slug: 'credit-direct',
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
      const Partner(
        id: '2',
        name: 'Fidelity Bank',
        slug: 'fidelity',
        isActive: false,
        requiresPrequalification: true,
        config: {},
        isActiveForMobile: false,
        metadata: PartnerMetadataModel(
          partnerType: null,
          customerType: 'its customers',
          dropdownMessage: null,
          allowDynamicDownpayment: null,
        ),
      ),
      const Partner(
        id: '3',
        name: 'Stanbic IBTC',
        slug: 'stanbic',
        isActive: true,
        requiresPrequalification: true,
        config: {},
        isActiveForMobile: true,
        metadata: PartnerMetadataModel(
          partnerType: null,
          customerType: 'its customers',
          dropdownMessage: null,
          allowDynamicDownpayment: null,
        ),
      ),
    ];
  });

  tearDown(() {
    searchController.dispose();
    focusNode.dispose();
  });

  List<Partner> filterPartners(
    List<Partner> list,
    String query,
    String partnerName,
  ) {
    if (query.isEmpty) return list;
    final lowerQuery = query.toLowerCase();
    return list
        .where((p) =>
            p.name.toLowerCase().contains(lowerQuery) ||
            partnerName.toLowerCase() == lowerQuery)
        .toList();
  }

  Future<void> pumpDropdown(WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpKCWidget(
        KCLenderSearchDropdown(
          activeLoanPartners: partners,
          selectedBankFlow: selectedPartner,
          searchController: searchController,
          focusNode: focusNode,
          onFilter: filterPartners,
          onSelect: onSelect,
          onInactivePartnerTap: (p) => inactiveTapPartner = p,
        ),
      );
    });
  }

  testWidgets('KCLenderSearchDropdown shows search field with hint',
      (tester) async {
    await pumpDropdown(tester);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Search by name'), findsOneWidget);
  });

  testWidgets('KCLenderSearchDropdown shows dropdown when no selection',
      (tester) async {
    await pumpDropdown(tester);
    expect(find.text('Credit Direct'), findsOneWidget);
    expect(find.text('Stanbic IBTC'), findsOneWidget);
    expect(find.text('Fidelity Bank'), findsOneWidget);
    expect(find.byType(KCPartnerPopupMenuItemContent), findsWidgets);
  });

  testWidgets('KCLenderSearchDropdown sorts active partners before inactive',
      (tester) async {
    await pumpDropdown(tester);
    final menuItems = find.byType(KCPartnerPopupMenuItemContent);
    expect(menuItems, findsNWidgets(3));
    expect(find.text('Credit Direct'), findsOneWidget);
    expect(find.text('Stanbic IBTC'), findsOneWidget);
    expect(find.text('Fidelity Bank'), findsOneWidget);
    expect(find.text('Others banks coming soon'), findsOneWidget);
    final firstListTile =
        tester.widgetList<KCPartnerPopupMenuItemContent>(menuItems).first;
    expect(firstListTile.title, 'Credit Direct');
    expect(firstListTile.isActive, isTrue);
    final lastListTile =
        tester.widgetList<KCPartnerPopupMenuItemContent>(menuItems).last;
    expect(lastListTile.title, 'Fidelity Bank');
    expect(lastListTile.isActive, isTrue);
  });

  testWidgets(
      'KCLenderSearchDropdown calls onSelect when tapping active partner',
      (tester) async {
    await pumpDropdown(tester);
    await tester.tap(find.text('Credit Direct'));
    await tester.pump();
    expect(selectedPartner?.name, 'Credit Direct');
  });

  testWidgets('KCLenderSearchDropdown does not call onSelect for coming soon',
      (tester) async {
    await pumpDropdown(tester);
    await tester.tap(find.text('Fidelity Bank'));
    await tester.pump();
    expect(selectedPartner, isNull);
    expect(inactiveTapPartner?.name, 'Fidelity Bank');
  });

  testWidgets('KCLenderSearchDropdown shows No lenders found when filter empty',
      (tester) async {
    await pumpDropdown(tester);
    await tester.tap(find.byType(TextField));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'nonexistent');
    await tester.pump();
    expect(find.text('No lenders found'), findsOneWidget);
  });

  testWidgets('KCLenderSearchDropdown filters by search query', (tester) async {
    await pumpDropdown(tester);
    await tester.tap(find.byType(TextField));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'Credit');
    await tester.pump();
    expect(find.text('Credit Direct'), findsOneWidget);
    expect(find.text('Fidelity Bank'), findsNothing);
    expect(find.text('Stanbic IBTC'), findsNothing);
  });

  testWidgets(
      'KCLenderSearchDropdown hides dropdown when has selection and not focused',
      (tester) async {
    selectedPartner = partners.first;
    await pumpDropdown(tester);
    await tester.pump();
    expect(find.text('Stanbic IBTC'), findsNothing);
    expect(find.text('Fidelity Bank'), findsNothing);
  });

  testWidgets('KCLenderSearchDropdown disables field when no partners',
      (tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpKCWidget(
        KCLenderSearchDropdown(
          activeLoanPartners: const [],
          selectedBankFlow: null,
          searchController: searchController,
          focusNode: focusNode,
          onFilter: filterPartners,
          onSelect: onSelect,
        ),
      );
    });
    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.enabled, isFalse);
  });
}
