import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:logger/logger.dart';
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
        'environment': changeNotifier.initiateResponse?.isLive == true
            ? 'production'
            : 'staging',
        'payload': {'bank': changeNotifier.selectedBankFlow?.slug},
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final checkoutNotifier = Provider.of<KCChangeNotifier>(context);
    final nextStep = checkoutNotifier.selectedBankFlow?.nextStep;
    final formFields = nextStep?.formFields?.map((e) => e.name).toList();
    Logger().d(nextStep?.displayData?.list);
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
                    const DraggableBar(),
                    const YSpace(24),
                    Align(
                      child: Image.network(
                        checkoutNotifier.selectedBankFlow?.logo ?? '',
                        height: 55,
                        width: 120,
                      ),
                    ),
                    if (checkoutNotifier.initiateResponse?.merchant != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Align(
                          child: KCHeadline4(
                            checkoutNotifier.initiateResponse!.merchant
                                .toString(),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    const YSpace(24),
                    if (nextStep?.displayData?.title != null)
                      KCHeadline3(
                        nextStep?.displayData?.title ?? '',
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
                                nextStep?.displayData?.list![index]?['tooltip']
                                    ?['text'],
                            subTitle: nextStep?.displayData?.list![index]
                                ?['smalltext'],
                            lastItem: index + 1 ==
                                (checkoutNotifier.selectedBankFlow?.nextStep
                                        ?.displayData?.list!.length ??
                                    0),
                            onTap: nextStep?.displayData?.list![index]
                                        ?['tooltip'] !=
                                    null
                                ? () {
                                    final imageUrl = nextStep?.displayData
                                        ?.list![index]?['tooltip']['image_url'];
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return LoanCitiesDialog(
                                          imageUrl: imageUrl,
                                        );
                                      },
                                    );
                                  }
                                : null,
                          ),
                        ),
                      ),
                    if (nextStep?.displayData?.smallText != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: KCHeadline4(
                          nextStep?.displayData?.smallText ?? '',
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          maxLines: 3,
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
                          loading: checkoutNotifier.isBusy,
                          disabled: (!accepted &&
                                  formFields?.contains('is_accepted') ==
                                      true) ||
                              checkoutNotifier.isBusy,
                          title: 'Continue',
                          onTap: () {
                            if (nextStep?.api ==
                                '/loans/account/verification') {
                              checkoutNotifier.validateAccount();
                            } else if (nextStep?.api
                                    ?.contains('/requirements') ==
                                true) {
                              checkoutNotifier.acceptRequirement();
                            } else {
                              checkoutNotifier.nextPage();
                            }
                          },
                        );
                      },
                    ),
                    const YSpace(16),
                    KCSecondaryButton(
                      title: 'Back',
                      onTap: () => checkoutNotifier.prevPage(),
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
    this.onTap,
  });

  final String title;
  final bool lastItem;
  final String? subTitle;
  final void Function()? onTap;

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
                  child: GestureDetector(
                    onTap: onTap,
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
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class LoanCitiesDialog extends StatelessWidget {
  const LoanCitiesDialog({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 0.5,
        sigmaY: 0.5,
      ),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const YSpace(12),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                ),
              ),
              const YSpace(12),
              SizedBox(
                height: 300,
                child: Image.network(
                  imageUrl,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(
                        color: KCColors.primary,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
