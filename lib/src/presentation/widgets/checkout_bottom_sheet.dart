import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class KCBottomSheet extends StatefulWidget {
  final KlumpCheckoutData data;

  const KCBottomSheet({super.key, required this.data});

  static dynamic route(BuildContext context, KlumpCheckoutData data) {
    return showModalBottomSheet<void>(
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      context: context,
      backgroundColor: KCColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(9.92367),
          topRight: Radius.circular(9.92367),
        ),
      ),
      builder: (context) => KCBottomSheet(data: data),
    );
  }

  @override
  State<KCBottomSheet> createState() => _KCBottomSheetState();
}

class _KCBottomSheetState extends State<KCBottomSheet> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    MixPanelService.initMixpanel(
            !dev ? KC_MIX_PANEL_TOKEN_PROD : KC_MIX_PANEL_TOKEN_STAGING)
        .then(
      (value) => MixPanelService.logEvent(
        '1 - Checkout Widget Initiated',
        properties: {'environment': !dev ? 'production' : 'staging'},
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight(context) - 67.48,
      child: ChangeNotifierProvider<KCChangeNotifier>(
        create: (_) => KCChangeNotifier(),
        child: OKToast(
          animationDuration: const Duration(milliseconds: 300),
          animationCurve: Curves.easeIn,
          backgroundColor: Colors.black87,
          textPadding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 15,
          ),
          textStyle: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.white),
          radius: 30,
          duration: const Duration(seconds: 3),
          position: ToastPosition.center,
          textAlign: TextAlign.center,
          child: KCMainViewContainer(data: widget.data),
        ),
      ),
    );
  }
}

class KCMainViewContainer extends StatefulWidget {
  const KCMainViewContainer({
    super.key,
    required this.data,
  });

  final KlumpCheckoutData data;

  @override
  State<KCMainViewContainer> createState() => _KCMainViewContainerState();
}

class _KCMainViewContainerState extends State<KCMainViewContainer> {
  @override
  void initState() {
    Future.delayed(Duration.zero, _initiatTranx);
    super.initState();
  }

  void _initiatTranx() {
    final checkoutNotifier =
        Provider.of<KCChangeNotifier>(context, listen: false);
    Future.delayed(Duration.zero, () async {
      if (widget.data.email != null && widget.data.phone != null) {
        checkoutNotifier.setTransactionData(
          widget.data,
          email: widget.data.email!,
          phone: widget.data.phone!,
        );
        await checkoutNotifier.initiateTransaction();
      }
      checkoutNotifier.getLoanPartners();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Consumer<KCChangeNotifier>(
            builder: (_, checkoutNotifier, __) {
              var views = <Widget>[
                if (widget.data.email == null || widget.data.phone == null)
                  //User has not provided email and phone, show account email step
                  AccountEmail(data: widget.data),
                Container(),
                SelectBankFlow(
                  data: widget.data,
                ),
                if (checkoutNotifier.selectedBankFlow?.slug == 'polaris' ||
                    checkoutNotifier.selectedBankFlow?.slug == 'specta')
                  const PartnerMobileExperience(),
                if (checkoutNotifier.selectedBankFlow?.slug == 'polaris' ||
                    checkoutNotifier.selectedBankFlow?.slug == 'first_bank' ||
                    checkoutNotifier.selectedBankFlow?.slug == 'renmoney' ||
                    checkoutNotifier.selectedBankFlow?.slug == 'fidelity' ||
                    checkoutNotifier.selectedBankFlow?.slug ==
                        'fcmb_credit_direct' ||
                    checkoutNotifier.selectedBankFlow?.slug == 'wema' ||
                    checkoutNotifier.selectedBankFlow?.slug == 'klump')
                  const PartnerRequirements(),
                if (checkoutNotifier.selectedBankFlow?.slug !=
                        'fcmb_credit_direct' &&
                    checkoutNotifier.selectedBankFlow?.slug != 'first_bank')
                  const PartnerLogin(),
                if (checkoutNotifier.selectedBankFlow?.slug == 'renmoney' &&
                    checkoutNotifier.createPhoneNumberStepData != null)
                  const PartnerPhoneNumber(),
                if (checkoutNotifier.selectedBankFlow?.slug == 'renmoney' &&
                    checkoutNotifier.verifyPhoneOTPStepData != null)
                  const PartnerPhoneOTP(),
                if (checkoutNotifier.selectedBankFlow?.slug == 'renmoney' &&
                    checkoutNotifier.bioDataStepData != null)
                  const PartnerBioData(),
                if (checkoutNotifier.accountNumberStepData != null)
                  const PartnerAccountNumber(),
                if (checkoutNotifier.enterBVNStepData != null)
                  const PartnerBVN(),
                if (checkoutNotifier.sendBVNOTPStepData != null)
                  const PartnerSendBVNOTP(),
                if (checkoutNotifier.verifyBVNStepData != null)
                  const PartnerVerifyBVN(),
                if (checkoutNotifier.verifyOTPStepData != null)
                  const PartnerLoginOTP(),
                if (checkoutNotifier.selectedBankFlow?.slug == 'stanbic')
                  const PartnerTermsCondition(),
                if (checkoutNotifier.selectedBankFlow?.slug != 'renmoney' &&
                    checkoutNotifier.bioDataStepData != null)
                  const PartnerBioData(),
                if (checkoutNotifier.selectedBankFlow?.slug == 'renmoney')
                  const PartnerKYC(),
                if (checkoutNotifier.selectedBankFlow?.slug != 'specta' &&
                    checkoutNotifier.selectedBankFlow?.slug !=
                        'fcmb_credit_direct' &&
                    checkoutNotifier.selectedBankFlow?.slug != 'first_bank')
                  const PartnerPaymentSplit(),
                if (checkoutNotifier.selectedBankFlow?.slug == 'first_bank')
                  const FirstbankWebview(),
                if (checkoutNotifier.selectedBankFlow?.slug ==
                    'fcmb_credit_direct')
                  const CDLWebview(),
                if (checkoutNotifier.selectedBankFlow?.slug == 'renmoney' &&
                    checkoutNotifier.documentVerificationStepData != null)
                  const PartnerDocumentType(),
                if (checkoutNotifier.selectedBankFlow?.slug == 'renmoney' &&
                    checkoutNotifier.documentVerificationStepData != null)
                  const PartnerDocumentUpload(),
                if (checkoutNotifier.selectedBankFlow?.slug == 'renmoney' &&
                    checkoutNotifier.proofAddressStepData != null)
                  const PartnerAddressVerify(),
                if (checkoutNotifier.selectedBankFlow?.slug == 'wema')
                  const WemaIllustration(),
                if (checkoutNotifier.repaymentDetailsStepData != null)
                  const PartnerPaymentPreview(),
                if (checkoutNotifier.selfieStepData != null)
                  const PartnerSelfieUpload(),
                if (checkoutNotifier.selectedBankFlow?.slug == 'wema')
                  const PartnerTermsCondition(),
                if (checkoutNotifier.selectedBankFlow?.slug == 'polaris')
                  const PartnerInvoice(),
                if (checkoutNotifier.selectedBankFlow?.slug == 'stanbic')
                  const PartnerConfirmation(),
                if (checkoutNotifier.paymentLinkData != null)
                  const PartnerPaymemtLink(),
                const PartnerDecision(),
                const PartnerDisbursementStatus(),
              ];
              return PageView(
                controller: checkoutNotifier.pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: views,
              );
            },
          ),
        ),
      ],
    );
  }
}
