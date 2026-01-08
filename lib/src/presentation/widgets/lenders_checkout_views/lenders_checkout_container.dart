import 'package:flutter/material.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class LendersCheckoutContainer extends StatefulWidget {
  const LendersCheckoutContainer({super.key, required this.params});

  final KCPaymentContainerParams params;

  @override
  State<LendersCheckoutContainer> createState() =>
      _LendersCheckoutContainerState();
}

class _LendersCheckoutContainerState extends State<LendersCheckoutContainer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight(context) - 67.48,
      child: ChangeNotifierProvider<KCLendersNotifier>(
        create: (_) => KCLendersNotifier(),
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
          child: PartnersPageviewContainer(params: widget.params),
        ),
      ),
    );
  }
}

class PartnersPageviewContainer extends StatefulWidget {
  const PartnersPageviewContainer({super.key, required this.params});
  final KCPaymentContainerParams params;

  @override
  State<PartnersPageviewContainer> createState() =>
      _PartnersPageviewContainerState();
}

class _PartnersPageviewContainerState extends State<PartnersPageviewContainer> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _getPartners);
  }

  Future<void> _getPartners() async {
    final lendersNotifier =
        Provider.of<KCLendersNotifier>(context, listen: false);
    lendersNotifier.getLoanPartners();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Consumer<KCLendersNotifier>(
            builder: (_, lendersNotifier, __) {
              var views = <Widget>[
                // if (widget.params.data.email == null ||
                //     widget.params.data.phone == null)
                //   AccountEmail(
                //     data: widget.params.data,
                //   ),
                SelectBankFlow(
                  data: widget.params.data,
                ),
                if (lendersNotifier.selectedBankFlow?.slug == 'polaris' ||
                    lendersNotifier.selectedBankFlow?.slug == 'specta')
                  const PartnerMobileExperience(),
                if (lendersNotifier.selectedBankFlow?.slug == 'polaris' ||
                    lendersNotifier.selectedBankFlow?.slug == 'first_bank' ||
                    lendersNotifier.selectedBankFlow?.slug == 'renmoney' ||
                    lendersNotifier.selectedBankFlow?.slug == 'fidelity' ||
                    lendersNotifier.selectedBankFlow?.slug ==
                        'fcmb_credit_direct' ||
                    lendersNotifier.selectedBankFlow?.slug == 'wema' ||
                    lendersNotifier.selectedBankFlow?.slug == 'klump')
                  const PartnerRequirements(),
                if (lendersNotifier.selectedBankFlow?.slug !=
                        'fcmb_credit_direct' &&
                    lendersNotifier.selectedBankFlow?.slug != 'first_bank')
                  const PartnerLogin(),
                if (lendersNotifier.selectedBankFlow?.slug == 'renmoney' &&
                    lendersNotifier.createPhoneNumberStepData != null)
                  const PartnerPhoneNumber(),
                if (lendersNotifier.selectedBankFlow?.slug == 'renmoney' &&
                    lendersNotifier.verifyPhoneOTPStepData != null)
                  const PartnerPhoneOTP(),
                if (lendersNotifier.selectedBankFlow?.slug == 'renmoney' &&
                    lendersNotifier.bioDataStepData != null)
                  const PartnerBioData(),
                if (lendersNotifier.accountNumberStepData != null)
                  const PartnerAccountNumber(),
                if (lendersNotifier.enterBVNStepData != null)
                  const PartnerBVN(),
                if (lendersNotifier.sendBVNOTPStepData != null)
                  const PartnerSendBVNOTP(),
                if (lendersNotifier.verifyBVNStepData != null)
                  const PartnerVerifyBVN(),
                if (lendersNotifier.verifyOTPStepData != null)
                  const PartnerLoginOTP(),
                if (lendersNotifier.selectedBankFlow?.slug == 'stanbic')
                  const PartnerTermsCondition(),
                if (lendersNotifier.selectedBankFlow?.slug != 'renmoney' &&
                    lendersNotifier.bioDataStepData != null)
                  const PartnerBioData(),
                if (lendersNotifier.selectedBankFlow?.slug == 'renmoney')
                  const PartnerKYC(),
                if (lendersNotifier.selectedBankFlow?.slug != 'specta' &&
                    lendersNotifier.selectedBankFlow?.slug !=
                        'fcmb_credit_direct' &&
                    lendersNotifier.selectedBankFlow?.slug != 'first_bank')
                  const PartnerPaymentSplit(),
                if (lendersNotifier.selectedBankFlow?.slug == 'first_bank')
                  const FirstbankWebview(),
                if (lendersNotifier.selectedBankFlow?.slug ==
                    'fcmb_credit_direct')
                  const CDLWebview(),
                if (lendersNotifier.selectedBankFlow?.slug == 'renmoney' &&
                    lendersNotifier.documentVerificationStepData != null)
                  const PartnerDocumentType(),
                if (lendersNotifier.selectedBankFlow?.slug == 'renmoney' &&
                    lendersNotifier.documentVerificationStepData != null)
                  const PartnerDocumentUpload(),
                if (lendersNotifier.selectedBankFlow?.slug == 'renmoney' &&
                    lendersNotifier.proofAddressStepData != null)
                  const PartnerAddressVerify(),
                if (lendersNotifier.selectedBankFlow?.slug == 'wema')
                  const WemaIllustration(),
                if (lendersNotifier.repaymentDetailsStepData != null)
                  const PartnerPaymentPreview(),
                if (lendersNotifier.selfieStepData != null)
                  const PartnerSelfieUpload(),
                if (lendersNotifier.selectedBankFlow?.slug == 'wema')
                  const PartnerTermsCondition(),
                if (lendersNotifier.selectedBankFlow?.slug == 'polaris')
                  const PartnerInvoice(),
                if (lendersNotifier.selectedBankFlow?.slug == 'stanbic')
                  const PartnerConfirmation(),
                if (lendersNotifier.paymentLinkData != null)
                  const PartnerPaymemtLink(),
                const PartnerDecision(),
                const PartnerDisbursementStatus(),
              ];
              return PageView(
                controller: lendersNotifier.pageController,
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
