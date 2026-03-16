import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:klump_checkout/src/src.dart';
import 'helpers/pump_app.dart';

void main() {
  late TextEditingController searchController;
  late FocusNode focusNode;
  late List<Map<String, dynamic>> banks;
  Map<String, dynamic>? selectedBank;
  late void Function(Map<String, dynamic>) onSelect;

  setUp(() {
    searchController = TextEditingController();
    focusNode = FocusNode();
    selectedBank = null;
    onSelect = (b) => selectedBank = b;
    banks = [
      {'name': 'Access Bank', 'code': '044'},
      {'name': 'GTBank', 'code': '058'},
      {'name': 'First Bank', 'code': '011'},
    ];
  });

  tearDown(() {
    searchController.dispose();
    focusNode.dispose();
  });

  List<dynamic> filterBanks(List<dynamic> list, String query) {
    if (query.isEmpty) return list;
    final lowerQuery = query.toLowerCase();
    return list
        .where((b) => (b['name'] as String).toLowerCase().contains(lowerQuery))
        .toList();
  }

  Future<void> pumpDropdown(WidgetTester tester) async {
    await tester.pumpKCWidget(
      KCBankSearchDropdown(
        banks: banks,
        selectedBank: selectedBank,
        searchController: searchController,
        focusNode: focusNode,
        onFilter: filterBanks,
        onSelect: onSelect,
      ),
    );
  }

  testWidgets('KCBankSearchDropdown shows search field with hint',
      (tester) async {
    await pumpDropdown(tester);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Search by name'), findsOneWidget);
  });

  testWidgets('KCBankSearchDropdown shows bank list when no selection',
      (tester) async {
    await pumpDropdown(tester);
    expect(find.text('Access Bank'), findsOneWidget);
    expect(find.text('GTBank'), findsOneWidget);
    expect(find.text('First Bank'), findsOneWidget);
  });

  testWidgets('KCBankSearchDropdown calls onSelect when tapping a bank',
      (tester) async {
    await pumpDropdown(tester);
    await tester.tap(find.text('Access Bank'));
    await tester.pump();
    expect(selectedBank?['name'], 'Access Bank');
    expect(selectedBank?['code'], '044');
  });

  testWidgets('KCBankSearchDropdown shows No banks found when filter empty',
      (tester) async {
    await pumpDropdown(tester);
    await tester.tap(find.byType(TextField));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'nonexistent');
    await tester.pump();
    expect(find.text('No banks found'), findsOneWidget);
  });

  testWidgets('KCBankSearchDropdown filters by search query', (tester) async {
    await pumpDropdown(tester);
    await tester.tap(find.byType(TextField));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'First');
    await tester.pump();
    expect(find.text('First Bank'), findsOneWidget);
    expect(find.text('Access Bank'), findsNothing);
    expect(find.text('GTBank'), findsNothing);
  });

  testWidgets('KCBankSearchDropdown hides dropdown when has selection and not focused',
      (tester) async {
    selectedBank = banks.first;
    await pumpDropdown(tester);
    await tester.pump();
    expect(find.text('Access Bank'), findsNothing);
    expect(find.text('GTBank'), findsNothing);
  });
}
