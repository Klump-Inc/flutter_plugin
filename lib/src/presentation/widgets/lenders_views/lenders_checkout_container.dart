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
      child: ChangeNotifierProvider<KCPartnersNotifier>(
        create: (_) => KCPartnersNotifier(),
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
    final partnersNotifier =
        Provider.of<KCPartnersNotifier>(context, listen: false);
    partnersNotifier.getLoanPartners();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Consumer<KCPartnersNotifier>(
            builder: (_, partnersNotifier, __) {
              var views = <Widget>[
                // if (widget.params.data.email == null ||
                //     widget.params.data.phone == null)
                //   AccountEmail(
                //     data: widget.params.data,
                //   ),
                SelectBankFlow(
                  data: widget.params.data,
                ),
                if (partnersNotifier.selectedBankFlow?.slug == 'polaris' ||
                    partnersNotifier.selectedBankFlow?.slug == 'specta')
                  const PartnerMobileExperience(),
                if (partnersNotifier.selectedBankFlow?.slug == 'polaris' ||
                    partnersNotifier.selectedBankFlow?.slug == 'first_bank' ||
                    partnersNotifier.selectedBankFlow?.slug == 'renmoney' ||
                    partnersNotifier.selectedBankFlow?.slug == 'fidelity' ||
                    partnersNotifier.selectedBankFlow?.slug ==
                        'fcmb_credit_direct' ||
                    partnersNotifier.selectedBankFlow?.slug == 'wema' ||
                    partnersNotifier.selectedBankFlow?.slug == 'klump')
                  const PartnerRequirements(),
                if (partnersNotifier.selectedBankFlow?.slug !=
                        'fcmb_credit_direct' &&
                    partnersNotifier.selectedBankFlow?.slug != 'first_bank')
                  const PartnerLogin(),
                if (partnersNotifier.selectedBankFlow?.slug == 'renmoney' &&
                    partnersNotifier.createPhoneNumberStepData != null)
                  const PartnerPhoneNumber(),
                if (partnersNotifier.selectedBankFlow?.slug == 'renmoney' &&
                    partnersNotifier.verifyPhoneOTPStepData != null)
                  const PartnerPhoneOTP(),
                if (partnersNotifier.selectedBankFlow?.slug == 'renmoney' &&
                    partnersNotifier.bioDataStepData != null)
                  const PartnerBioData(),
                if (partnersNotifier.accountNumberStepData != null)
                  const PartnerAccountNumber(),
                if (partnersNotifier.enterBVNStepData != null)
                  const PartnerBVN(),
                if (partnersNotifier.sendBVNOTPStepData != null)
                  const PartnerSendBVNOTP(),
                if (partnersNotifier.verifyBVNStepData != null)
                  const PartnerVerifyBVN(),
                if (partnersNotifier.verifyOTPStepData != null)
                  const PartnerLoginOTP(),
                if (partnersNotifier.selectedBankFlow?.slug == 'stanbic')
                  const PartnerTermsCondition(),
                if (partnersNotifier.selectedBankFlow?.slug != 'renmoney' &&
                    partnersNotifier.bioDataStepData != null)
                  const PartnerBioData(),
                if (partnersNotifier.selectedBankFlow?.slug == 'renmoney')
                  const PartnerKYC(),
                if (partnersNotifier.selectedBankFlow?.slug != 'specta' &&
                    partnersNotifier.selectedBankFlow?.slug !=
                        'fcmb_credit_direct' &&
                    partnersNotifier.selectedBankFlow?.slug != 'first_bank')
                  const PartnerPaymentSplit(),
                if (partnersNotifier.selectedBankFlow?.slug == 'first_bank')
                  const FirstbankWebview(),
                if (partnersNotifier.selectedBankFlow?.slug ==
                    'fcmb_credit_direct')
                  const CDLWebview(),
                if (partnersNotifier.selectedBankFlow?.slug == 'renmoney' &&
                    partnersNotifier.documentVerificationStepData != null)
                  const PartnerDocumentType(),
                if (partnersNotifier.selectedBankFlow?.slug == 'renmoney' &&
                    partnersNotifier.documentVerificationStepData != null)
                  const PartnerDocumentUpload(),
                if (partnersNotifier.selectedBankFlow?.slug == 'renmoney' &&
                    partnersNotifier.proofAddressStepData != null)
                  const PartnerAddressVerify(),
                if (partnersNotifier.selectedBankFlow?.slug == 'wema')
                  const WemaIllustration(),
                if (partnersNotifier.repaymentDetailsStepData != null)
                  const PartnerPaymentPreview(),
                if (partnersNotifier.selfieStepData != null)
                  const PartnerSelfieUpload(),
                if (partnersNotifier.selectedBankFlow?.slug == 'wema')
                  const PartnerTermsCondition(),
                if (partnersNotifier.selectedBankFlow?.slug == 'polaris')
                  const PartnerInvoice(),
                if (partnersNotifier.selectedBankFlow?.slug == 'stanbic')
                  const PartnerConfirmation(),
                if (partnersNotifier.paymentLinkData != null)
                  const PartnerPaymemtLink(),
                const PartnerDecision(),
                const PartnerDisbursementStatus(),
              ];
              return PageView(
                controller: partnersNotifier.pageController,
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
