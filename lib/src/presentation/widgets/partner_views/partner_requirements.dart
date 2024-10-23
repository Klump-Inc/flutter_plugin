import 'package:flutter/material.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:provider/provider.dart';

class PartnerRequirements extends StatefulWidget {
  const PartnerRequirements({super.key});

  @override
  State<PartnerRequirements> createState() => _PartnerRequirementsState();
}

class _PartnerRequirementsState extends State<PartnerRequirements> {
  final ValueNotifier<bool> _accepted = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    final changeNotifier =
        Provider.of<KCChangeNotifier>(context, listen: false);
    MixPanelService.logEvent(
      '5 - PARTNER REQUIREMENTS MODAL',
      properties: {
        'environment': changeNotifier.isLive ? 'production' : 'staging',
        'payload': {'bank': changeNotifier.selectedBankFlow?.slug},
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final checkoutNotfier = Provider.of<KCChangeNotifier>(context);
    final nextStep = checkoutNotfier.selectedBankFlow?.nextStep;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const YSpace(32.6),
                    Align(
                      child: Image.network(
                        checkoutNotfier.selectedBankFlow?.logo ?? '',
                        height: 55,
                        width: 120,
                      ),
                    ),
                    if (checkoutNotfier.initiateResponse?.merchant != null)
                      Align(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: KCHeadline4(
                            checkoutNotfier.initiateResponse!.merchant
                                .toString(),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    const YSpace(22.15),
                    if (nextStep?.displayData?.title != null)
                      KCHeadline3(
                        nextStep?.displayData?.title ?? '',
                        fontSize: 24,
                      ),
                    if (nextStep?.displayData?.subTitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: KCHeadline4(
                          nextStep?.displayData?.subTitle ?? '',
                          fontWeight: FontWeight.w500,
                          maxLines: 3,
                        ),
                      ),
                    const YSpace(24),
                    if (nextStep?.displayData?.list?.isNotEmpty == true)
                      Column(
                        children: List.generate(
                          nextStep?.displayData?.list!.length ?? 0,
                          (index) => PartnerItemTile(
                            title: nextStep?.displayData?.list![index]
                                    ?['text'] ??
                                '',
                            subTitle: nextStep?.displayData?.list![index]
                                ?['smalltext'],
                            lastItem: index + 1 ==
                                (checkoutNotfier.selectedBankFlow?.nextStep
                                        ?.displayData?.list!.length ??
                                    0),
                          ),
                        ),
                      ),
                    if (nextStep?.formFields?.isNotEmpty == true)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          children: List.generate(
                            nextStep!.formFields!.length,
                            (index) {
                              final formData = nextStep.formFields![index];
                              return formData.type == 'checkbox'
                                  ? ValueListenableBuilder<bool>(
                                      valueListenable: _accepted,
                                      builder: (_, accepted, __) {
                                        return KCCheckBox(
                                          textWidget: KCBodyText1(
                                            ' I agree to this according to Klump’s Customer Agreement and  Terms and Conditions',
                                            fontSize: 12,
                                          ),
                                          value: accepted,
                                          onChanged: (val) {
                                            _accepted.value = val!;
                                          },
                                        );
                                      },
                                    )
                                  : const SizedBox();
                            },
                          ),
                        ),
                      ),
                    const YSpace(25),
                    const Spacer(),
                    ValueListenableBuilder<bool>(
                      valueListenable: _accepted,
                      builder: (_, accepted, __) {
                        return KCPrimaryButton(
                          loading: checkoutNotfier.isBusy,
                          disabled: (!accepted &&
                                  (checkoutNotfier.selectedBankFlow?.slug ==
                                          'first_bank' ||
                                      checkoutNotfier.selectedBankFlow?.slug ==
                                          'renmoney')) ||
                              checkoutNotfier.isBusy,
                          title: 'Continue',
                          onTap: () {
                            if (nextStep?.api ==
                                '/loans/account/verification') {
                              checkoutNotfier.validateAccount();
                            } else if (nextStep?.api
                                    ?.contains('/requirements') ==
                                true) {
                              checkoutNotfier.acceptRequirement();
                            } else {
                              checkoutNotfier.nextPage();
                            }
                          },
                        );
                      },
                    ),
                    const YSpace(16),
                    KCSecondaryButton(
                      title: 'Go back',
                      onTap: () => checkoutNotfier.prevPage(),
                    ),
                    const YSpace(59)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class PartnerItemTile extends StatelessWidget {
  const PartnerItemTile({
    super.key,
    required this.title,
    this.lastItem = false,
    this.subTitle,
  });

  final String title;
  final bool lastItem;
  final String? subTitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 41 + (!lastItem ? 40 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                height: 11.34,
                width: 11.34,
                decoration: BoxDecoration(
                  color: KCColors.primary,
                  borderRadius: BorderRadius.circular(30.2483),
                ),
              ),
              if (!lastItem)
                Expanded(
                  child: Container(
                    width: 1.5,
                    color: KCColors.grey1,
                  ),
                )
            ],
          ),
          const XSpace(8.66),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 41,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KCHeadline4(
                        title,
                        fontSize: 15,
                        height: 1,
                        maxLines: 2,
                        fontWeight: FontWeight.w800,
                      ),
                      if (subTitle != null)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: KCHeadline4(
                              subTitle!,
                              fontSize: 12,
                              height: 1,
                              maxLines: 2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
