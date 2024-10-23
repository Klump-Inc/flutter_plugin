import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import 'api_response.dart';
import 'helpers/helpers.dart';
import 'klump_checkout_test.mocks.dart';

@GenerateMocks([KCChangeNotifier])
void main() {
  late MockKCChangeNotifier kcChangeNotifier;
  setUp(() {
    kcChangeNotifier = MockKCChangeNotifier();
  });
  const phoneNumber = '08012345678';
  final loanPartners = PartnerListModel.fromJson(loanPartnersJson).data;
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

  group('Chekout widget test:', () {
    testWidgets('Partner popup menu content renders correctly', (tester) async {
      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          KCPartnerPopupMenuItemContent(
            logo: KCAssets.stanbicLogo,
            title: 'Partner name',
          ),
        ),
      );
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Image), findsOneWidget);
      expect(find.text('Partner name'), findsOneWidget);
    });
    testWidgets('Bank popup menu content renders correctly', (tester) async {
      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          const KCBankPopupMenuItemContent(
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
    testWidgets('KCBottomSheet renders correctly', (tester) async {
      await tester
          .pumpKCWidget(KCBottomSheet(data: checkoutData, isLive: false));
      await tester.pumpAndSettle();
      expect(find.byType(SizedBox), findsWidgets);
      expect(find.byType(YSpace), findsWidgets);
      expect(find.byType(Expanded), findsWidgets);
      expect(find.byType(PageView), findsOneWidget);
    });
  });

  group('Partner Views:', () {
    testWidgets('AccountEmail renders correctly', (tester) async {
      when(kcChangeNotifier.isBusy).thenAnswer((_) => false);
      when(kcChangeNotifier.isLive).thenAnswer((_) => false);
      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          ChangeNotifierProvider<KCChangeNotifier>.value(
            value: kcChangeNotifier,
            builder: (context, kcChangeNotifier) {
              return AccountEmail(
                data: checkoutData,
                isLive: false,
              );
            },
          ),
        ),
      );
      await tester.pump(Duration.zero);
      expect(find.byType(YSpace), findsWidgets);
      expect(find.byType(SvgPicture), findsWidgets);
      expect(find.text('Please enter your email and phone number to check out'),
          findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(KCInputField), findsNWidgets(2));
      expect(find.text('Continue'), findsOneWidget);
      expect(find.byType(KCPrimaryButton), findsWidgets);
    });

    testWidgets('SelectBankFlow renders correctly', (tester) async {
      when(kcChangeNotifier.isBusy).thenAnswer((_) => false);
      when(kcChangeNotifier.isLive).thenAnswer((_) => false);
      when(kcChangeNotifier.loanPartners).thenAnswer((_) => loanPartners);
      when(kcChangeNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first);
      when(
        kcChangeNotifier.setBankFlow(loanPartners.first),
      ).thenAnswer((_) async {});

      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          ChangeNotifierProvider<KCChangeNotifier>.value(
            value: kcChangeNotifier,
            builder: (context, kcChangeNotifier) {
              return SelectBankFlow(
                data: checkoutData,
                isLive: false,
              );
            },
          ),
        ),
      );
      await tester.pump(Duration.zero);
      expect(find.byType(YSpace), findsWidgets);
      expect(find.byType(SvgPicture), findsWidgets);
      expect(find.text('Choose a bank'), findsOneWidget);
      expect(find.text('Choose the bank you want to pay with'), findsOneWidget);
      expect(find.byType(KCPrimaryButton), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('PartnerMobileExperience renders correctly', (tester) async {
      when(kcChangeNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first);
      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          ChangeNotifierProvider<KCChangeNotifier>.value(
            value: kcChangeNotifier,
            builder: (context, kcChangeNotifier) {
              return const PartnerMobileExperience();
            },
          ),
        ),
      );
      expect(find.byType(YSpace), findsWidgets);
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(Spacer), findsWidgets);
      expect(find.text('Use a computer for a better \npayment experience'),
          findsOneWidget);
      expect(find.byType(KCPrimaryButton), findsOneWidget);
    });

    testWidgets('PartnerLogin renders correctly', (tester) async {
      when(kcChangeNotifier.isBusy).thenAnswer((_) => false);
      when(kcChangeNotifier.isLive).thenAnswer((_) => false);
      when(kcChangeNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first);
      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          ChangeNotifierProvider<KCChangeNotifier>.value(
            value: kcChangeNotifier,
            builder: (context, kcChangeNotifier) {
              return const PartnerLogin();
            },
          ),
        ),
      );
      expect(find.byType(YSpace), findsWidgets);
      expect(find.byType(SvgPicture), findsWidgets);
      expect(find.byType(KCInputField), findsWidgets);
      expect(find.byType(Spacer), findsOneWidget);
      expect(find.byType(KCPrimaryButton), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });
    testWidgets('PartnerLoginOTP renders correctly', (tester) async {
      when(kcChangeNotifier.phoneNumber).thenAnswer((_) => phoneNumber);
      when(kcChangeNotifier.isLive).thenAnswer((_) => false);
      when(kcChangeNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first);
      when(kcChangeNotifier.isBusy).thenAnswer((_) => false);
      // when(kcChangeNotifier.verifyOTPNextStepData).thenAnswer((_) =>
      //     KCAPIResponse(
      //         nextStep: NextStepModel.fromJson(
      //             accountValidationJson['next_step'] as Map<String, dynamic>)));
      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          ChangeNotifierProvider<KCChangeNotifier>.value(
            value: kcChangeNotifier,
            builder: (context, kcChangeNotifier) {
              return const PartnerLoginOTP();
            },
          ),
        ),
      );
      expect(find.byType(YSpace), findsWidgets);
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(SvgPicture), findsWidgets);
      expect(find.byType(KCInputField), findsWidgets);
      expect(find.byType(Spacer), findsOneWidget);
      expect(find.byType(KCPrimaryButton), findsOneWidget);
      expect(find.text('Enter the code'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });
    testWidgets('PartnerTerms renders correctly', (tester) async {
      when(kcChangeNotifier.termsCondition).thenAnswer(
        (_) => const TermsAndCondition(
            title: '', doc: '', version: '1', channel: 'web', text: ''),
      );
      when(kcChangeNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first);
      when(kcChangeNotifier.isBusy).thenAnswer((_) => false);
      when(kcChangeNotifier.isLive).thenAnswer((_) => false);
      when(kcChangeNotifier.klumpUser).thenAnswer((_) =>
          KlumpUserModel.fromJson(
              (verifyOTPJson['data'] as Map<String, dynamic>)));
      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          ChangeNotifierProvider<KCChangeNotifier>.value(
            value: kcChangeNotifier,
            builder: (context, kcChangeNotifier) {
              return const PartnerTerms();
            },
          ),
        ),
      );
      await tester.pump(Duration.zero);
      expect(find.byType(YSpace), findsWidgets);
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(SvgPicture), findsWidgets);
      expect(find.byType(KCPrimaryButton), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });
    testWidgets('PartnerConfirmation renders correctly', (tester) async {
      when(kcChangeNotifier.isBusy).thenAnswer((_) => false);
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
      expect(find.text('Confirmation'), findsOneWidget);
      expect(
          find.text(
              'If you click continue, you can no \nlonger cancel your loan'),
          findsOneWidget);
      expect(find.byType(KCPrimaryButton), findsOneWidget);
      expect(find.byType(KCSecondaryButton), findsOneWidget);
    });

    testWidgets('PartnerPaymentSplit renders correctly', (tester) async {
      when(kcChangeNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first);
      when(kcChangeNotifier.isBusy).thenAnswer((_) => false);
      when(kcChangeNotifier.isLive).thenAnswer((_) => false);
      when(kcChangeNotifier.nextStepData).thenAnswer((_) => KCAPIResponse(
          nextStep: NextStepModel.fromJson(
              acceptTermsJson['next_step'] as Map<String, dynamic>)));
      when(kcChangeNotifier.paymentSplit).thenAnswer((_) => null);
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
      expect(find.byType(YSpace), findsWidgets);
      expect(find.byType(Image), findsNothing);
      expect(find.byType(PopupMenuButton<int>), findsWidgets);
      await tester.tap(find.byType(PopupMenuButton<int>).first);
      await tester.pump();
      expect(find.byType(KCInstallmentPopupMenuItemContent), findsWidgets);
      await tester.tap(find.byType(LayoutBuilder));
      await tester.pumpAndSettle();
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
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('PartnerAccountCredentials renders correctly', (tester) async {
      when(kcChangeNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first);
      when(kcChangeNotifier.isBusy).thenAnswer((_) => false);
      when(kcChangeNotifier.isLive).thenAnswer((_) => false);
      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          ChangeNotifierProvider<KCChangeNotifier>.value(
            value: kcChangeNotifier,
            builder: (context, kcChangeNotifier) {
              return const PartnerBioData();
            },
          ),
        ),
      );
      expect(find.byType(YSpace), findsWidgets);
      expect(find.byType(KCInputField), findsNWidgets(3));
      expect(find.byType(SvgPicture), findsOneWidget);
      expect(find.byType(Expanded), findsWidgets);
      expect(find.text('Complete your account'), findsOneWidget);
      expect(find.byType(KCPrimaryButton), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });
    testWidgets('PartnerInvoice renders correctly', (tester) async {
      when(kcChangeNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first);
      when(kcChangeNotifier.isBusy).thenAnswer((_) => false);
      when(kcChangeNotifier.isLive).thenAnswer((_) => false);
      when(kcChangeNotifier.finalLoanStep).thenAnswer((_) => KCAPIResponse(
              nextStep: NextStepModel.fromJson(
                  newLoanJson['next_step'] as Map<String, dynamic>))
          .nextStep);

      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          ChangeNotifierProvider<KCChangeNotifier>.value(
            value: kcChangeNotifier,
            builder: (context, kcChangeNotifier) {
              return const PartnerInvoice();
            },
          ),
        ),
      );
      expect(find.byType(YSpace), findsWidgets);
      expect(find.byType(SvgPicture), findsOneWidget);
      expect(find.byType(Expanded), findsWidgets);
      expect(find.byType(Spacer), findsOneWidget);
      expect(find.byType(Html), findsOneWidget);
      expect(find.byType(KCPrimaryButton), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });
    testWidgets('PartnerDecision renders correctly', (tester) async {
      when(kcChangeNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first);
      when(kcChangeNotifier.isLive).thenAnswer((_) => false);
      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          ChangeNotifierProvider<KCChangeNotifier>.value(
            value: kcChangeNotifier,
            builder: (context, kcChangeNotifier) {
              return const PartnerDecision();
            },
          ),
        ),
      );
      await tester.pump(Duration.zero);
      expect(find.byType(YSpace), findsWidgets);
      expect(find.byType(CircularPercentIndicator), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
      expect(find.byType(Expanded), findsWidgets);
      expect(find.text('Hang on!'), findsOneWidget);
      expect(find.byType(KCPrimaryButton), findsNothing);
    });

    testWidgets('PartnerDecision renders correctly', (tester) async {
      when(kcChangeNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first);
      when(kcChangeNotifier.isLive).thenAnswer((_) => false);
      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          ChangeNotifierProvider<KCChangeNotifier>.value(
            value: kcChangeNotifier,
            builder: (context, kcChangeNotifier) {
              return const PartnerDecision();
            },
          ),
        ),
      );
      await tester.pump(Duration.zero);
      expect(find.byType(YSpace), findsWidgets);
      expect(find.byType(CircularPercentIndicator), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
      expect(find.byType(Expanded), findsWidgets);
      expect(find.text('Hang on!'), findsOneWidget);
      expect(find.byType(KCPrimaryButton), findsNothing);
    });

    testWidgets('PartnerDisbursementStatus renders correctly', (tester) async {
      when(kcChangeNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first);
      when(kcChangeNotifier.isLive).thenAnswer((_) => false);
      when(kcChangeNotifier.disbursementStatusResponse).thenAnswer(
        (_) => const DisbursementStatusResponse(
          isCompleted: true,
          isSuccessful: true,
          message: 'Loan has been disbursed successfully',
          next_repayment_date: null,
        ),
      );
      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          ChangeNotifierProvider<KCChangeNotifier>.value(
            value: kcChangeNotifier,
            builder: (context, kcChangeNotifier) {
              return const PartnerDisbursementStatus();
            },
          ),
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
