import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'helpers/helpers.dart';
import 'klump_checkout_test.mocks.dart';

@GenerateMocks([KCChangeNotifier])
void main() {
  late MockKCChangeNotifier kcChangeNotifier;
  setUp(() {
    kcChangeNotifier = MockKCChangeNotifier();
  });

  var checkoutData = const KlumpCheckoutData(
    amount: 45000,
    shippingFee: 5000,
    merchantReference: "what-ever-you-want-this-to-be",
    metaData: {
      'customer': "Elon Musk",
      'email': "musk@spacex.com",
    },
    items: [
      KlumpCheckoutItem(
        imageUrl:
            'https://s3.amazonaws.com/uifaces/faces/twitter/ladylexy/128.jpg',
        itemUrl: 'https://www.paypal.com/in/webapps/mpp/home',
        name: 'Awesome item',
        unitPrice: 20000,
        quantity: 2,
      )
    ],
    merchantPublicKey:
        'klp_pk_test_e4aaa1a8e96644ad9af23fa453ddd6ffa39a8233a88c4b93860f119c8cd9a332',
  );

  group('Chekout widget test:', () {
    testWidgets('Bank popup menu content renders correctly', (tester) async {
      await tester.pumpKCWidget(
        KCBankPopupMenuItemContent(
          logo: KCAssets.stanbicLogo,
          title: 'Bank name',
        ),
      );
      expect(find.byType(Container), findsWidgets);
      expect(find.text('Bank name'), findsOneWidget);
    });

    testWidgets('KCPrimaryButton renders correctly', (tester) async {
      await tester.pumpKCWidget(
        const KCPrimaryButton(
          title: 'Continue',
          loading: true,
        ),
      );
      expect(find.byType(InkWell), findsOneWidget);
      expect(find.byType(Center), findsWidgets);
      expect(find.byType(KCButtonLoaderWidget), findsOneWidget);
    });
    testWidgets('KCSecondaryButton renders correctly', (tester) async {
      await tester.pumpKCWidget(
        const KCSecondaryButton(
          title: 'Continue',
        ),
      );
      expect(find.byType(InkWell), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('KCButtonLoaderWidget renders correctly', (tester) async {
      await tester.pumpKCWidget(
        const KCButtonLoaderWidget(),
      );
      expect(find.byType(SizedBox), findsOneWidget);
      if (Platform.isIOS) {
        expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
      } else {
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      }
    });

    testWidgets('Input field renders properly', (tester) async {
      await tester.pumpKCWidget(
        const KCInputField(
          controller: null,
          validationMessage: 'Required',
          hint: 'hint',
          password: true,
        ),
      );
      final inputfieldFinder = find.byType(TextField);
      final labelTextFinder = find.text('hint');
      expect(inputfieldFinder, findsOneWidget);
      expect(labelTextFinder, findsOneWidget);
      expect(find.byType(GestureDetector), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('KCInstallmentPopupMenuItemContent renders correctly',
        (tester) async {
      await tester.pumpKCWidget(
        KCInstallmentPopupMenuItemContent(
          logo: KCAssets.stanbicLogo,
          title: 'Bank name',
        ),
      );
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Align), findsOneWidget);
      expect(find.text('Bank name'), findsOneWidget);
    });
    testWidgets('XSpace renders correctly', (tester) async {
      await tester.pumpKCWidget(
        const XSpace(100),
      );
      expect(find.byType(SizedBox), findsOneWidget);
    });
    testWidgets('YSpace renders correctly', (tester) async {
      await tester.pumpKCWidget(
        const YSpace(100),
      );
      expect(find.byType(SizedBox), findsOneWidget);
    });
    testWidgets('KCTextBase renders correctly', (tester) async {
      await tester.pumpKCWidget(
        const KCTextBase('text'),
      );
      expect(find.text('text'), findsOneWidget);
    });
  });

  group('Standbic Views: ', () {
    testWidgets('SelectBankFlow renders correctly', (tester) async {
      when(kcChangeNotifier.isBusy).thenAnswer((_) => false);
      when(kcChangeNotifier.selectedBankFlow).thenAnswer(
        (_) => KCBank(name: 'Stanbic', logo: KCAssets.stanbicLogo),
      );
      when(
        kcChangeNotifier.setBankFlow(
          KCBank(name: 'Stanbic', logo: KCAssets.stanbicLogo),
        ),
      ).thenAnswer((_) async {});
      await tester.pumpKCWidget(
        ChangeNotifierProvider<KCChangeNotifier>.value(
          value: kcChangeNotifier,
          builder: (context, kcChangeNotifier) {
            return SelectBankFlow(isLive: false, data: checkoutData);
          },
        ),
      );
      await tester.pump(Duration.zero);
      expect(find.byType(YSpace), findsWidgets);
    });
  });
}
