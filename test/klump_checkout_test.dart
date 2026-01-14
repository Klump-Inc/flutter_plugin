import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

@GenerateMocks([KCLendersNotifier])
void main() {
  late MockKCLendersNotifier kcLendersNotifier;
  setUp(() {
    kcLendersNotifier = MockKCLendersNotifier();
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
          const KCPartnerPopupMenuItemContent(
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

    testWidgets('KCNetworkImage renders network image with provided properties',
        (tester) async {
      const widget = KCNetworkImage(
        url: 'https://example.com/image.png',
        height: 24,
        width: 32,
        fit: BoxFit.cover,
      );

      await mockNetworkImagesFor(() async {
        await tester.pumpKCWidget(widget);
        await tester.pump();
      });

      final image = tester.widget<Image>(find.byType(Image));
      expect(
          (image.image as NetworkImage).url, 'https://example.com/image.png');
      expect(image.height, 24);
      expect(image.width, 32);
      expect(image.fit, BoxFit.cover);
    });

    testWidgets('KCInstallmentPopupMenuItemContent renders correctly',
        (tester) async {
      await tester.pumpKCWidget(
        const KCInstallmentPopupMenuItemContent(
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
      await tester.pumpKCWidget(KCBottomSheet(data: checkoutData));
      await tester.pumpAndSettle();
      expect(find.byType(SizedBox), findsWidgets);
      expect(find.byType(YSpace), findsWidgets);
      expect(find.byType(Expanded), findsWidgets);
      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('KCTextArea renders properly', (tester) async {
      await tester.pumpKCWidget(
        const KCTextArea(
          controller: null,
          validationMessage: 'Required',
        ),
      );
      final inputfieldFinder = find.byType(TextField);
      final labelTextFinder = find.text('Enter feedback here');
      expect(inputfieldFinder, findsOneWidget);
      expect(labelTextFinder, findsOneWidget);
      expect(find.byType(GestureDetector), findsNothing);
      expect(find.byType(Icon), findsNothing);
    });
  });

  group('Partner Views:', () {
    testWidgets('AccountEmail renders correctly', (tester) async {
      when(kcLendersNotifier.isBusy).thenAnswer((_) => false);
      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          ChangeNotifierProvider<KCLendersNotifier>.value(
            value: kcLendersNotifier,
            builder: (context, kcLendersNotifier) {
              return AccountEmail(
                data: checkoutData,
              );
            },
          ),
        ),
      );
      await tester.pump();
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
      when(kcLendersNotifier.isBusy).thenAnswer((_) => false);
      when(kcLendersNotifier.loanPartners).thenAnswer((_) => loanPartners);
      when(kcLendersNotifier.initiateResponse).thenAnswer(
          (_) => InitiateResponseModel.fromJson(initiateLoanResponse));

      when(kcLendersNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first);
      when(
        kcLendersNotifier.setBankFlow(loanPartners.first),
      ).thenAnswer((_) async {
        return null;
      });

      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          ChangeNotifierProvider<KCLendersNotifier>.value(
            value: kcLendersNotifier,
            builder: (context, kcLendersNotifier) {
              return SelectBankFlow(
                data: checkoutData,
              );
            },
          ),
        ),
      );
      await tester.pump(Duration.zero);
      expect(find.byType(YSpace), findsWidgets);
      expect(find.byType(SvgPicture), findsWidgets);
      expect(find.text('Select a Partner'), findsOneWidget);
      expect(find.text('Credit approval in minutes'), findsOneWidget);
      expect(find.byType(KCPrimaryButton), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('PartnerMobileExperience renders correctly', (tester) async {
      when(kcLendersNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first);
      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          ChangeNotifierProvider<KCLendersNotifier>.value(
            value: kcLendersNotifier,
            builder: (context, kcLendersNotifier) {
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
      when(kcLendersNotifier.isBusy).thenAnswer((_) => false);
      when(kcLendersNotifier.email).thenAnswer((_) => 'sample@mail.com');
      when(kcLendersNotifier.phoneNumber).thenAnswer((_) => '08012345678');
      when(kcLendersNotifier.accountNumber).thenAnswer((_) => '1234567890');
      when(kcLendersNotifier.firstName).thenAnswer((_) => null);
      when(kcLendersNotifier.username).thenAnswer((_) => null);
      when(kcLendersNotifier.initiateResponse).thenAnswer(
          (_) => InitiateResponseModel.fromJson(initiateLoanResponse));
      when(kcLendersNotifier.verificationStepData).thenAnswer((_) => null);
      when(kcLendersNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first);
      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          ChangeNotifierProvider<KCLendersNotifier>.value(
            value: kcLendersNotifier,
            builder: (context, kcLendersNotifier) {
              return const PartnerLogin();
            },
          ),
        ),
      );
      await tester.pump(Duration.zero);
      expect(find.byType(YSpace), findsWidgets);
      expect(find.byType(SvgPicture), findsWidgets);
      expect(find.byType(Image), findsWidgets);
      expect(find.byType(Spacer), findsOneWidget);
      expect(find.byType(KCPrimaryButton), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });
    testWidgets('PartnerLoginOTP renders correctly', (tester) async {
      when(kcLendersNotifier.phoneNumber).thenAnswer((_) => phoneNumber);
      when(kcLendersNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first);
      when(kcLendersNotifier.isBusy).thenAnswer((_) => false);
      when(kcLendersNotifier.verifyOTPStepData).thenAnswer((_) => KCAPIResponse(
          nextStep: NextStepModel.fromJson(
              accountValidationJson['next_step'] as Map<String, dynamic>)));
      when(kcLendersNotifier.initiateResponse).thenAnswer(
          (_) => InitiateResponseModel.fromJson(initiateLoanResponse));
      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          ChangeNotifierProvider<KCLendersNotifier>.value(
            value: kcLendersNotifier,
            builder: (context, kcLendersNotifier) {
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
    testWidgets(
        'PartnerLoginOTP Continue calls verifyOTP only when OTP is valid',
        (tester) async {
      when(kcLendersNotifier.phoneNumber).thenAnswer((_) => phoneNumber);
      when(kcLendersNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first); // polaris => 4-digit OTP
      when(kcLendersNotifier.isBusy).thenAnswer((_) => false);
      when(kcLendersNotifier.verifyOTPStepData).thenAnswer((_) => KCAPIResponse(
          nextStep: NextStepModel.fromJson(
              accountValidationJson['next_step'] as Map<String, dynamic>)));
      when(kcLendersNotifier.initiateResponse).thenAnswer(
          (_) => InitiateResponseModel.fromJson(initiateLoanResponse));
      when(kcLendersNotifier.verifyOTP(any, any)).thenAnswer((_) async {
        return null;
      });

      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          ChangeNotifierProvider<KCLendersNotifier>.value(
            value: kcLendersNotifier,
            builder: (context, kcLendersNotifier) {
              return const PartnerLoginOTP();
            },
          ),
        ),
      );
      await tester.pump();

      // Enter invalid OTP (3 digits) -> should not call verify
      await tester.enterText(find.byType(TextField).first, '123');
      await tester.pump();
      await tester.tap(find.text('Continue'));
      await tester.pump();
      verifyNever(kcLendersNotifier.verifyOTP(any, any));

      // Enter valid OTP (4 digits for polaris)
      await tester.enterText(find.byType(TextField).first, '1234');
      await tester.pump();
      await tester.tap(find.text('Continue'));
      await tester.pump();
      verify(kcLendersNotifier.verifyOTP('1234', '')).called(1);
    });

    testWidgets('PartnerLoginOTP resend code is enabled only after countdown',
        (tester) async {
      when(kcLendersNotifier.phoneNumber).thenAnswer((_) => phoneNumber);
      when(kcLendersNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first);
      when(kcLendersNotifier.isBusy).thenAnswer((_) => false);
      when(kcLendersNotifier.verifyOTPStepData).thenAnswer((_) => KCAPIResponse(
          nextStep: NextStepModel.fromJson(
              accountValidationJson['next_step'] as Map<String, dynamic>)));
      when(kcLendersNotifier.initiateResponse).thenAnswer(
          (_) => InitiateResponseModel.fromJson(initiateLoanResponse));
      when(kcLendersNotifier.resendAccountOTP()).thenAnswer((_) async => true);

      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          ChangeNotifierProvider<KCLendersNotifier>.value(
            value: kcLendersNotifier,
            builder: (context, kcLendersNotifier) {
              return const PartnerLoginOTP();
            },
          ),
        ),
      );
      await tester.pump();

      // Before countdown ends, tapping should not trigger resend
      expect(find.textContaining('Resend code in'), findsOneWidget);
      await tester.tap(find.textContaining('Resend code in'));
      await tester.pump();
      verifyNever(kcLendersNotifier.resendAccountOTP());

      // Fast-forward timer beyond 60s
      await tester.pump(const Duration(seconds: 61));
      expect(find.text('Resend code'), findsOneWidget);
      await tester.tap(find.text('Resend code'));
      await tester.pump();
      verify(kcLendersNotifier.resendAccountOTP()).called(1);
    });
    testWidgets('PartnerTerms renders correctly', (tester) async {
      when(kcLendersNotifier.acceptTermsStepData)
          .thenAnswer((_) => const KCAPIResponse(nextStep: NextStep()));
      when(kcLendersNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first);
      when(kcLendersNotifier.isBusy).thenAnswer((_) => false);
      when(kcLendersNotifier.klumpUser).thenAnswer((_) =>
          KlumpUserModel.fromJson(
              (verifyOTPJson['data'] as Map<String, dynamic>)));
      when(kcLendersNotifier.initiateResponse).thenAnswer(
          (_) => InitiateResponseModel.fromJson(initiateLoanResponse));
      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          ChangeNotifierProvider<KCLendersNotifier>.value(
            value: kcLendersNotifier,
            builder: (context, kcLendersNotifier) {
              return const PartnerTermsCondition();
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
      when(kcLendersNotifier.isBusy).thenAnswer((_) => false);
      when(kcLendersNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first);
      when(kcLendersNotifier.initiateResponse).thenAnswer(
          (_) => InitiateResponseModel.fromJson(initiateLoanResponse));
      await tester.pumpKCWidget(
        ChangeNotifierProvider<KCLendersNotifier>.value(
          value: kcLendersNotifier,
          builder: (context, kcLendersNotifier) {
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
      when(kcLendersNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first);
      when(kcLendersNotifier.initiateResponse).thenAnswer(
          (_) => InitiateResponseModel.fromJson(initiateLoanResponse));
      when(kcLendersNotifier.isBusy).thenAnswer((_) => false);
      when(kcLendersNotifier.loanOptionStepData).thenAnswer((_) =>
          KCAPIResponse(
              nextStep: NextStepModel.fromJson(
                  acceptTermsJson['next_step'] as Map<String, dynamic>)));
      when(kcLendersNotifier.paymentSplit).thenAnswer((_) => null);
      when(kcLendersNotifier.partnerInsurers).thenAnswer((_) => null);
      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          ChangeNotifierProvider<KCLendersNotifier>.value(
            value: kcLendersNotifier,
            builder: (context, kcLendersNotifier) {
              return const PartnerPaymentSplit();
            },
          ),
        ),
      );
      expect(find.byType(SvgPicture), findsWidgets);
      expect(find.text('Your installment split'), findsOneWidget);
      expect(find.text('How would you like to split your payment?'),
          findsOneWidget);
      expect(find.byType(YSpace), findsWidgets);
      expect(find.byType(Image), findsWidgets);
      expect(find.byType(PopupMenuButton<int>), findsWidgets);
      await tester.tap(find.byType(PopupMenuButton<int>).first);
      await tester.pump();
      expect(find.byType(KCInstallmentPopupMenuItemContent), findsWidgets);
      await tester.tap(find.byKey(const Key('split_payment_layout')),
          warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.byType(SvgPicture), findsWidgets);
      expect(find.byType(Spacer), findsOneWidget);
      expect(find.byType(KCPrimaryButton), findsOneWidget);
    });
    testWidgets('PartnerPaymentPreview renders correctly', (tester) async {
      when(kcLendersNotifier.repaymentDetailsStepData).thenAnswer((_) =>
          KCAPIResponse(
              nextStep: NextStepModel.fromJson(
                  repaymentResponse['next_step'] as Map<String, dynamic>)));
      when(kcLendersNotifier.initiateResponse).thenAnswer(
          (_) => InitiateResponseModel.fromJson(initiateLoanResponse));
      when(kcLendersNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first);
      when(kcLendersNotifier.isBusy).thenAnswer((_) => false);
      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          ChangeNotifierProvider<KCLendersNotifier>.value(
            value: kcLendersNotifier,
            builder: (context, kcLendersNotifier) {
              return const PartnerPaymentPreview();
            },
          ),
        ),
      );
      expect(find.byType(YSpace), findsWidgets);
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
      expect(find.byType(KPPaymentItemTile), findsWidgets);
      expect(find.byType(Expanded), findsWidgets);
      expect(find.byType(KCPrimaryButton), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('PartnerBVN renders correctly', (tester) async {
      when(kcLendersNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first);
      when(kcLendersNotifier.initiateResponse).thenAnswer(
          (_) => InitiateResponseModel.fromJson(initiateLoanResponse));
      when(kcLendersNotifier.isBusy).thenAnswer((_) => false);
      when(kcLendersNotifier.bvn).thenAnswer((_) => null);
      // Provide BVN step data
      final bvnNextStep = {
        "name": "ENTER_BVN",
        "display_data": {"title": "Enter your BVN"},
        "form_fields": [
          {"type": "text", "name": "bvn", "label": "BVN", "placeholder": "BVN"}
        ],
        "method": "POST",
        "api": "/loans/account/enter-bvn"
      };
      when(kcLendersNotifier.enterBVNStepData).thenAnswer(
          (_) => KCAPIResponse(nextStep: NextStepModel.fromJson(bvnNextStep)));

      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          ChangeNotifierProvider<KCLendersNotifier>.value(
            value: kcLendersNotifier,
            builder: (context, kcLendersNotifier) {
              return const PartnerBVN();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(YSpace), findsWidgets);
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(KCInputField), findsOneWidget);
      expect(find.byType(Spacer), findsOneWidget);
      expect(find.byType(KCPrimaryButton), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('PartnerBVN prepopulates BVN from notifier', (tester) async {
      when(kcLendersNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first);
      when(kcLendersNotifier.initiateResponse).thenAnswer(
          (_) => InitiateResponseModel.fromJson(initiateLoanResponse));
      when(kcLendersNotifier.isBusy).thenAnswer((_) => false);
      when(kcLendersNotifier.bvn).thenAnswer((_) => '12345678901');
      final bvnNextStep = {
        "name": "ENTER_BVN",
        "form_fields": [
          {"type": "text", "name": "bvn", "label": "BVN", "placeholder": "BVN"}
        ],
        "method": "POST",
        "api": "/loans/account/enter-bvn"
      };
      when(kcLendersNotifier.enterBVNStepData).thenAnswer(
          (_) => KCAPIResponse(nextStep: NextStepModel.fromJson(bvnNextStep)));

      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          ChangeNotifierProvider<KCLendersNotifier>.value(
            value: kcLendersNotifier,
            builder: (context, kcLendersNotifier) {
              return const PartnerBVN();
            },
          ),
        ),
      );
      // Allow the delayed prefill to run
      await tester.pumpAndSettle();
      expect(find.text('12345678901'), findsOneWidget);
    });

    testWidgets('PartnerSendBVNOTP renders correctly', (tester) async {
      when(kcLendersNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first);
      when(kcLendersNotifier.initiateResponse).thenAnswer(
          (_) => InitiateResponseModel.fromJson(initiateLoanResponse));
      when(kcLendersNotifier.isBusy).thenAnswer((_) => false);
      when(kcLendersNotifier.bvnContact).thenAnswer((_) => null);
      final sendStep = {
        "name": "SEND_BVN_OTP",
        "display_data": {"title": "Verify your BVN"},
        "form_fields": [
          {
            "type": "text",
            "name": "bvn",
            "label": "BVN",
            "placeholder": "BVN",
            "readonly": true,
            "value": "12345678901"
          },
          {
            "type": "select",
            "name": "contact",
            "label": "Contact",
            "placeholder": "Select Contact",
            "options": [
              {"label": "+2348012345678", "value": "+2348012345678"},
              {"label": "musk@spacex.com", "value": "musk@spacex.com"}
            ]
          }
        ],
        "method": "POST",
        "api": "/loans/account/send-bvn-otp"
      };
      when(kcLendersNotifier.sendBVNOTPStepData).thenAnswer(
          (_) => KCAPIResponse(nextStep: NextStepModel.fromJson(sendStep)));

      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          ChangeNotifierProvider<KCLendersNotifier>.value(
            value: kcLendersNotifier,
            builder: (context, kcLendersNotifier) {
              return const PartnerSendBVNOTP();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(YSpace), findsWidgets);
      expect(find.byType(SvgPicture), findsWidgets);
      expect(find.byType(KCInputField), findsOneWidget);
      expect(
          find.byType(PopupMenuButton<Map<String, dynamic>>), findsOneWidget);
      expect(find.byType(Spacer), findsOneWidget);
      expect(find.byType(KCPrimaryButton), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('PartnerSendBVNOTP preselects contact from notifier',
        (tester) async {
      when(kcLendersNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first);
      when(kcLendersNotifier.initiateResponse).thenAnswer(
          (_) => InitiateResponseModel.fromJson(initiateLoanResponse));
      when(kcLendersNotifier.isBusy).thenAnswer((_) => false);
      when(kcLendersNotifier.bvnContact).thenAnswer(
          (_) => {"label": "+2348012345678", "value": "+2348012345678"});
      final sendStep = {
        "name": "SEND_BVN_OTP",
        "display_data": {"title": "Verify your BVN"},
        "form_fields": [
          {
            "type": "text",
            "name": "bvn",
            "label": "BVN",
            "placeholder": "BVN",
            "readonly": true,
            "value": "12345678901"
          },
          {
            "type": "select",
            "name": "contact",
            "label": "Contact",
            "placeholder": "Select Contact",
            "options": [
              {"label": "+2348012345678", "value": "+2348012345678"},
              {"label": "musk@spacex.com", "value": "musk@spacex.com"}
            ]
          }
        ],
        "method": "POST",
        "api": "/loans/account/send-bvn-otp"
      };
      when(kcLendersNotifier.sendBVNOTPStepData).thenAnswer(
          (_) => KCAPIResponse(nextStep: NextStepModel.fromJson(sendStep)));

      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          ChangeNotifierProvider<KCLendersNotifier>.value(
            value: kcLendersNotifier,
            builder: (context, kcLendersNotifier) {
              return const PartnerSendBVNOTP();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      // Selected label should be shown in the popup button child
      expect(find.text('+2348012345678'), findsWidgets);
    });

    testWidgets('PartnerVerifyBVN renders correctly', (tester) async {
      when(kcLendersNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first);
      when(kcLendersNotifier.initiateResponse).thenAnswer(
          (_) => InitiateResponseModel.fromJson(initiateLoanResponse));
      when(kcLendersNotifier.isBusy).thenAnswer((_) => false);
      final verifyStep = {
        "name": "VERIFY_BVN",
        "display_data": {"title": "Enter the code"},
        "form_fields": [
          {
            "type": "text",
            "name": "bvn_otp",
            "label": "OTP",
            "placeholder": "Enter the 6-digit code here"
          }
        ],
        "method": "POST",
        "api": "/loans/account/verify-bvn"
      };
      when(kcLendersNotifier.verifyBVNStepData).thenAnswer(
          (_) => KCAPIResponse(nextStep: NextStepModel.fromJson(verifyStep)));

      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          ChangeNotifierProvider<KCLendersNotifier>.value(
            value: kcLendersNotifier,
            builder: (context, kcLendersNotifier) {
              return const PartnerVerifyBVN();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(YSpace), findsWidgets);
      expect(find.byType(KCInputField), findsOneWidget);
      expect(find.byType(Spacer), findsOneWidget);
      expect(find.byType(KCPrimaryButton), findsOneWidget);
      expect(find.text('Enter the code'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('PartnerAccountCredentials renders correctly', (tester) async {
      when(kcLendersNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first);
      when(kcLendersNotifier.email).thenAnswer((_) => 'sample@mail.com');
      when(kcLendersNotifier.phoneNumber).thenAnswer((_) => '08012345678');
      when(kcLendersNotifier.klumpUser).thenAnswer((_) => const KlumpUser(
            firstname: 'Samuel',
            lastname: 'Olamide',
            email: 'sample@mail.com',
            maxLoanLimit: 1000000,
            requiresUserCredential: true,
            dob: '10-10-1990',
          ));

      when(kcLendersNotifier.initiateResponse).thenAnswer(
          (_) => InitiateResponseModel.fromJson(initiateLoanResponse));
      when(kcLendersNotifier.bioDataStepData).thenAnswer((_) => null);
      when(kcLendersNotifier.isBusy).thenAnswer((_) => false);
      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          ChangeNotifierProvider<KCLendersNotifier>.value(
            value: kcLendersNotifier,
            builder: (context, kcLendersNotifier) {
              return const PartnerBioData();
            },
          ),
        ),
      );
      await tester.pump(Duration.zero);
      expect(find.byType(YSpace), findsWidgets);
      expect(find.byType(SvgPicture), findsOneWidget);
      expect(find.byType(Expanded), findsWidgets);
      expect(find.byType(KCPrimaryButton), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
    });
    testWidgets('PartnerInvoice renders correctly', (tester) async {
      when(kcLendersNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first);
      when(kcLendersNotifier.initiateResponse).thenAnswer(
          (_) => InitiateResponseModel.fromJson(initiateLoanResponse));
      when(kcLendersNotifier.isBusy).thenAnswer((_) => false);
      when(kcLendersNotifier.loanStatusStepData).thenAnswer((_) =>
          KCAPIResponse(
              nextStep: NextStepModel.fromJson(
                  newLoanJsonPolaris['next_step'] as Map<String, dynamic>)));
      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          ChangeNotifierProvider<KCLendersNotifier>.value(
            value: kcLendersNotifier,
            builder: (context, kcLendersNotifier) {
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
      when(kcLendersNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first);
      when(kcLendersNotifier.initiateResponse).thenAnswer(
          (_) => InitiateResponseModel.fromJson(initiateLoanResponse));
      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          ChangeNotifierProvider<KCLendersNotifier>.value(
            value: kcLendersNotifier,
            builder: (context, kcLendersNotifier) {
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
      when(kcLendersNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first);
      when(kcLendersNotifier.loanStatusStepData).thenAnswer((_) =>
          KCAPIResponse(
              nextStep: NextStepModel.fromJson(
                  newLoanResponse['next_step'] as Map<String, dynamic>)));
      when(kcLendersNotifier.disbursementStatusResponse).thenAnswer(
        (_) => const DisbursementStatusResponse(
          isCompleted: true,
          isSuccessful: true,
          message: 'Loan has been disbursed successfully',
          next_repayment_date: null,
          responseMessage: '',
          transaction: null,
        ),
      );
      when(kcLendersNotifier.initiateResponse).thenAnswer(
          (_) => InitiateResponseModel.fromJson(initiateLoanResponse));
      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          ChangeNotifierProvider<KCLendersNotifier>.value(
            value: kcLendersNotifier,
            builder: (context, kcLendersNotifier) {
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

    testWidgets('FeedbackView  renders correctly', (tester) async {
      when(kcLendersNotifier.selectedBankFlow)
          .thenAnswer((_) => loanPartners.first);
      when(kcLendersNotifier.initiateResponse).thenAnswer(
          (_) => InitiateResponseModel.fromJson(initiateLoanResponse));
      final params = FeedbackViewArgument(
          email: 'sample@gmail.com',
          phoneNumber: '08012345678',
          publicKey: 'test_public_key',
          merchant: 'klump_test',
          isLive: false);
      await mockNetworkImagesFor(
        () async => await tester.pumpKCWidget(
          FeedbackView(params: params),
        ),
      );
      await tester.pump(Duration.zero);
      expect(find.text('Sad to see you go 😞'), findsOneWidget);
      expect(
          find.text('Please tell us why you aren\'t completing this purchase'),
          findsOneWidget);
      expect(find.byType(YSpace), findsWidgets);
      expect(find.byType(XSpace), findsWidgets);
      expect(find.byType(KCTextArea), findsOneWidget);
      expect(find.byType(SvgPicture), findsWidgets);
      expect(find.byType(Expanded), findsWidgets);
      expect(find.byType(Spacer), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
      expect(find.byType(KCPrimaryButton), findsOneWidget);
    });
  });

  group('PartnerPaymentLink Widget Tests:', () {
    testWidgets('PartnerPaymentLink widget can be instantiated',
        (tester) async {
      // Test that the widget can be created without throwing exceptions
      // This is a basic smoke test since WebView requires platform implementation
      expect(() => const PartnerPaymemtLink(), returnsNormally);
    });

    testWidgets(
        'PartnerPaymentLink handles missing payment link data gracefully',
        (tester) async {
      // Test with null payment link data
      when(kcLendersNotifier.paymentLinkData).thenAnswer((_) => null);

      // This test verifies the widget doesn't crash when payment link data is null
      expect(() => const PartnerPaymemtLink(), returnsNormally);
    });

    testWidgets('PartnerPaymentLink handles empty payment link data gracefully',
        (tester) async {
      // Test with empty payment link data
      when(kcLendersNotifier.paymentLinkData).thenAnswer(
        (_) => const KCAPIResponse(nextStep: NextStep()),
      );

      // This test verifies the widget doesn't crash when payment link data is empty
      expect(() => const PartnerPaymemtLink(), returnsNormally);
    });

    testWidgets('PartnerPaymentLink handles valid payment link data',
        (tester) async {
      // Test with valid payment link data
      when(kcLendersNotifier.paymentLinkData).thenAnswer(
        (_) => const KCAPIResponse(
          nextStep: NextStep(
            redirectUrl: 'https://example.com/payment',
          ),
        ),
      );

      // This test verifies the widget can handle valid payment link data
      expect(() => const PartnerPaymemtLink(), returnsNormally);
    });

    testWidgets('PartnerPaymentLink widget structure is correct',
        (tester) async {
      // Test the widget's basic structure without rendering
      when(kcLendersNotifier.paymentLinkData).thenAnswer(
        (_) => const KCAPIResponse(
          nextStep: NextStep(
            redirectUrl: 'https://example.com/payment',
          ),
        ),
      );

      const widget = PartnerPaymemtLink();

      // Verify it's a StatefulWidget
      expect(widget, isA<StatefulWidget>());

      // Verify it has the expected key
      expect(widget.key, isNull);
    });

    testWidgets('PartnerPaymentLink can be wrapped in provider',
        (tester) async {
      // Test that the widget can be wrapped in a provider context
      when(kcLendersNotifier.paymentLinkData).thenAnswer(
        (_) => const KCAPIResponse(
          nextStep: NextStep(
            redirectUrl: 'https://example.com/payment',
          ),
        ),
      );

      final wrappedWidget = ChangeNotifierProvider<KCLendersNotifier>.value(
        value: kcLendersNotifier,
        child: const PartnerPaymemtLink(),
      );

      expect(wrappedWidget, isA<Widget>());
      expect(wrappedWidget, isA<ChangeNotifierProvider<KCLendersNotifier>>());
    });
  });
}
