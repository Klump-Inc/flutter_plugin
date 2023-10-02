import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
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
    shippingData: {
      "address": "Ediam road Akppa",
      "landmark": "extras",
      "city_id": "73c743dd-9b62-411c-9d2f-2255e72a89ec"
    },
  );

  final repaymentDetailsJson = {
    "accountNumber": "1234567890",
    "transactionType": "NEW",
    "instantBuyAmount": 40000,
    "loanAmount": 33333.33,
    "downpaymentAmount": 6666.67,
    "monthlyRepayment": 7174.9,
    "totalRepayment": 35874.5,
    "managementFee": 333.33,
    "interest": 2.5,
    "vat": 25,
    "insurance": 150,
    "tenor": 5,
    "installment": 6,
    "minimumBalanceRequired": 7675,
    "repaymentDay": 7,
    "repaymentSchedules": [
      {
        "principal": 6341.57,
        "interest": 833.33,
        "monthlyRepayment": 7174.9,
        "principalBalance": 26991.77,
        "repayment_date": "Jun 7, 2023"
      },
      {
        "principal": 6500.11,
        "interest": 674.79,
        "monthlyRepayment": 7174.9,
        "principalBalance": 20491.66,
        "repayment_date": "Jul 7, 2023"
      },
      {
        "principal": 6662.61,
        "interest": 512.29,
        "monthlyRepayment": 7174.9,
        "principalBalance": 13829.05,
        "repayment_date": "Aug 7, 2023"
      },
      {
        "principal": 6829.17,
        "interest": 345.73,
        "monthlyRepayment": 7174.9,
        "principalBalance": 6999.88,
        "repayment_date": "Sep 7, 2023"
      },
      {
        "principal": 6999.9,
        "interest": 175,
        "monthlyRepayment": 7174.9,
        "principalBalance": 0,
        "repayment_date": "Oct 7, 2023"
      }
    ],
    "repaymentMetadata": null
  };
  group('Chekout widget test:', () {
    testWidgets('Bank popup menu content renders correctly', (tester) async {
      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          KCPartnerPopupMenuItemContent(
            logo: KCAssets.stanbicLogo,
            title: 'Bank name',
          ),
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

  testWidgets('KCBottomSheet renders correctly', (tester) async {
    await tester.pumpKCWidget(KCBottomSheet(data: checkoutData, isLive: false));
    await tester.pumpAndSettle();
    expect(find.byType(SizedBox), findsWidgets);
    expect(find.byType(YSpace), findsWidgets);
    expect(find.byType(Expanded), findsWidgets);
    expect(find.byType(PageView), findsOneWidget);
  });

  group('Standbic Views:', () {
    testWidgets('SelectBankFlow renders correctly', (tester) async {
      when(kcChangeNotifier.isBusy).thenAnswer((_) => false);
      when(kcChangeNotifier.selectedBankFlow).thenAnswer(
        (_) => Partner(
          name: 'Partner',
          logo: KCAssets.stanbicLogo,
          slug: 'stanbic',
          isActive: true,
          id: 'id',
          requiresPrequalification: false,
          config: null,
        ),
      );
      when(
        kcChangeNotifier.setBankFlow(
          Partner(
            name: 'Partner',
            logo: KCAssets.stanbicLogo,
            slug: 'stanbic',
            isActive: true,
            id: 'id',
            requiresPrequalification: false,
            config: null,
          ),
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
      expect(find.byType(SvgPicture), findsWidgets);
      expect(find.byType(KCPrimaryButton), findsOneWidget);
    });
    testWidgets('PartnerLogin renders correctly', (tester) async {
      when(kcChangeNotifier.isBusy).thenAnswer((_) => false);
      await tester.pumpKCWidget(
        ChangeNotifierProvider<KCChangeNotifier>.value(
          value: kcChangeNotifier,
          builder: (context, kcChangeNotifier) {
            return const PartnerLogin();
          },
        ),
      );
      expect(find.byType(YSpace), findsWidgets);
      expect(find.byType(SvgPicture), findsWidgets);
      expect(find.byType(KCInputField), findsNWidgets(2));
      expect(find.byType(Spacer), findsOneWidget);
      expect(find.byType(KCPrimaryButton), findsOneWidget);
    });
    testWidgets('PartnerLoginOTP renders correctly', (tester) async {
      when(kcChangeNotifier.phoneNumber).thenAnswer((_) => '08011111111');
      when(kcChangeNotifier.isBusy).thenAnswer((_) => false);
      await tester.pumpKCWidget(
        ChangeNotifierProvider<KCChangeNotifier>.value(
          value: kcChangeNotifier,
          builder: (context, kcChangeNotifier) {
            return const PartnerLoginOTP();
          },
        ),
      );
      expect(find.byType(YSpace), findsWidgets);
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(SvgPicture), findsWidgets);
      expect(find.byType(KCInputField), findsNWidgets(1));
      expect(find.byType(Spacer), findsOneWidget);
      expect(find.byType(KCPrimaryButton), findsOneWidget);
      expect(find.text('Enter the code'), findsOneWidget);
    });
    // testWidgets('PartnerTerms renders correctly', (tester) async {
    //   when(kcChangeNotifier.stanbicTC).thenAnswer(
    //     (_) => const TermsAndCondition(
    //         title: '', doc: '', version: '1', channel: 'web', text: ''),
    //   );
    //   when(kcChangeNotifier.isBusy).thenAnswer((_) => false);
    //   await tester.pumpKCWidget(
    //     ChangeNotifierProvider<KCChangeNotifier>.value(
    //       value: kcChangeNotifier,
    //       builder: (context, kcChangeNotifier) {
    //         return const PartnerTerms();
    //       },
    //     ),
    //   );
    //   await tester.pump(Duration.zero);
    //   expect(find.byType(YSpace), findsWidgets);
    //   expect(find.byType(Image), findsOneWidget);
    //   expect(find.byType(SvgPicture), findsWidgets);
    //   expect(find.text('Read and agree to the terms of service to continue'),
    //       findsOneWidget);
    //   expect(find.byType(KCPrimaryButton), findsOneWidget);
    // });
    testWidgets('PartnerConfirmation renders correctly', (tester) async {
      when(kcChangeNotifier.klumpUser?.maxLoanLimit).thenAnswer((_) => 500000);
      await tester.pumpKCWidget(
        ChangeNotifierProvider<KCChangeNotifier>.value(
          value: kcChangeNotifier,
          builder: (context, kcChangeNotifier) {
            return const PartnerConfirmation();
          },
        ),
      );
      await tester.pump(Duration.zero);
      expect(find.byType(YSpace), findsWidgets);
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(SvgPicture), findsWidgets);
      expect(find.text('You are qualified for a spending limit of'),
          findsOneWidget);
      expect(find.text('NGN 500,000.00'), findsOneWidget);
      expect(find.byType(KCPrimaryButton), findsOneWidget);
    });

    testWidgets('PartnerPaymentSplit renders correctly', (tester) async {
      when(kcChangeNotifier.isBusy).thenAnswer((_) => false);
      await tester.pumpKCWidget(
        ChangeNotifierProvider<KCChangeNotifier>.value(
          value: kcChangeNotifier,
          builder: (context, kcChangeNotifier) {
            return const PartnerPaymentSplit();
          },
        ),
      );
      expect(find.byType(SvgPicture), findsWidgets);
      expect(find.text('Your installment split'), findsOneWidget);
      expect(find.text('How would you like to split your payment?'),
          findsOneWidget);
      expect(find.text('What day of the month would you like to pay?'),
          findsOneWidget);
      expect(find.byType(YSpace), findsWidgets);
      expect(find.byType(Image), findsNothing);
      expect(find.byType(PopupMenuButton<int>), findsNWidgets(2));
      await tester.tap(find.byType(PopupMenuButton<int>).first);
      await tester.pump();
      expect(find.byType(KCInstallmentPopupMenuItemContent), findsNWidgets(3));
      await tester.tap(find.byType(LayoutBuilder));
      await tester.pump();
      await tester.tap(find.byType(PopupMenuButton<int>).last);
      await tester.pump();
      expect(find.byType(KCInstallmentPopupMenuItemContent), findsNWidgets(31));
      expect(find.byType(SvgPicture), findsWidgets);
      expect(find.byType(Spacer), findsOneWidget);
      expect(find.byType(KCPrimaryButton), findsOneWidget);
    });
    testWidgets('PartnerPaymentPreview renders correctly', (tester) async {
      when(kcChangeNotifier.repaymentDetails).thenAnswer(
          (_) => RepaymentDetailsModel.fromJson(repaymentDetailsJson));
      when(kcChangeNotifier.isBusy).thenAnswer((_) => false);
      await tester.pumpKCWidget(
        ChangeNotifierProvider<KCChangeNotifier>.value(
          value: kcChangeNotifier,
          builder: (context, kcChangeNotifier) {
            return const PartnerPaymentPreview();
          },
        ),
      );
      final text = kcChangeNotifier.repaymentDetails?.installment.toString() ==
              '2'
          ? 'Get your order  immediately at half the payment upfront. The balance will be scheduled for one month post your first instalment.'
          : kcChangeNotifier.repaymentDetails?.installment.toString() == '3'
              ? 'Get your order  immediately at one third of the payment upfront. The balance will be split into two (2) equal instalments over 2 months.'
              : kcChangeNotifier.repaymentDetails?.installment.toString() == '4'
                  ? 'Get your order  immediately at one fourth of the payment upfront. The balance will be split into three (3) equal instalments over 3 months.'
                  : kcChangeNotifier.repaymentDetails?.installment.toString() ==
                          '5'
                      ? 'Get your order  immediately at one fifth of the payment upfront. The balance will be split into four (4) equal instalments over 4 months.'
                      : kcChangeNotifier.repaymentDetails?.installment
                                  .toString() ==
                              '6'
                          ? 'Get your order  immediately at one sixth of the payment upfront. The balance will be split into four (5) equal instalments over 5 months.'
                          : '';
      expect(find.byType(YSpace), findsWidgets);
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
      expect(find.byType(KPPaymentItemTile), findsWidgets);
      expect(find.byType(Expanded), findsWidgets);
      expect(find.text(text), findsOneWidget);
      expect(find.byType(KCPrimaryButton), findsOneWidget);
    });

    testWidgets('PartnerDecision renders correctly', (tester) async {
      await tester.pumpKCWidget(
        ChangeNotifierProvider<KCChangeNotifier>.value(
          value: kcChangeNotifier,
          builder: (context, kcChangeNotifier) {
            return const PartnerDecision();
          },
        ),
      );
      await tester.pump(Duration.zero);
      expect(find.byType(YSpace), findsWidgets);
      expect(find.byType(CircularPercentIndicator), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
      expect(find.byType(Expanded), findsWidgets);
      expect(find.byType(KCPrimaryButton), findsNothing);
    });

    testWidgets('PartnerDisbursementStatus renders correctly', (tester) async {
      when(kcChangeNotifier.disbursementStatusResponse).thenAnswer(
        (_) => const DisbursementStatusResponse(
          isCompleted: true,
          isSuccessful: true,
          message: 'Loan has been disbursed successfully',
          next_repayment_date: null,
        ),
      );
      await tester.pumpKCWidget(
        ChangeNotifierProvider<KCChangeNotifier>.value(
          value: kcChangeNotifier,
          builder: (context, kcChangeNotifier) {
            return const PartnerDisbursementStatus();
          },
        ),
      );
      expect(find.byType(YSpace), findsWidgets);
      expect(find.byType(SvgPicture), findsOneWidget);
      expect(find.byType(Expanded), findsWidgets);
      expect(find.text('Successful'), findsOneWidget);
      expect(find.text('Loan has been disbursed successfully'), findsOneWidget);
      expect(find.byType(KCPrimaryButton), findsOneWidget);
    });
  });
}
