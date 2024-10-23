import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:provider/provider.dart';

class PartnerPaymentSplit extends StatefulWidget {
  const PartnerPaymentSplit({super.key});

  @override
  State<PartnerPaymentSplit> createState() => _PartnerPaymentSplitState();
}

class _PartnerPaymentSplitState extends State<PartnerPaymentSplit> {
  String? _installmentSplit;
  int? _repaymentDay;
  PartnerInsurer? _insurer;

  final ValueNotifier<bool> _enabled = ValueNotifier(false);

  void validateInputs() {
    final checkoutNotfier = context.read<KCChangeNotifier>();
    final formFields = (checkoutNotfier.loanOptionStepData?.nextStep ??
            checkoutNotfier.selectedBankFlow?.nextStep)
        ?.formFields
        ?.map((e) => e.name)
        .toList();
    if ((_installmentSplit != null ||
            formFields?.contains('installment') != true) &&
        (_repaymentDay != null ||
            formFields?.contains('repayment_day') != true) &&
        (_insurer != null || formFields?.contains('insurerId') != true)) {
      _enabled.value = true;
    } else {
      _enabled.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _loanInsurer);
    final changeNotifier =
        Provider.of<KCChangeNotifier>(context, listen: false);
    MixPanelService.logEvent(
      '8 - LOAN OPTIONS MODAL',
      properties: {
        'environment': changeNotifier.isLive ? 'production' : 'staging',
        'partner': changeNotifier.selectedBankFlow?.slug,
      },
    );
  }

  void _loanInsurer() {
    Provider.of<KCChangeNotifier>(context, listen: false).getPartnerInsurer();
  }

  @override
  Widget build(BuildContext context) {
    final checkoutNotfier = Provider.of<KCChangeNotifier>(context);
    final stepData = checkoutNotfier.loanOptionStepData?.nextStep ??
        checkoutNotfier.selectedBankFlow?.nextStep;
    final formFields = stepData?.formFields?.map((e) => e.name).toList();
    final formMap = stepData?.formFields;
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
                    const YSpace(30.82),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: checkoutNotfier.prevPage,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: SvgPicture.asset(
                            KCAssets.arrowBack,
                            package: KC_PACKAGE_NAME,
                          ),
                        ),
                      ),
                    ),
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
                    const YSpace(16),
                    if (stepData?.displayData?.title != null)
                      KCHeadline3(
                        stepData?.displayData?.title ?? '',
                        fontSize: 20,
                      ),
                    if (stepData?.displayData?.subTitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child:
                            KCHeadline5(stepData?.displayData?.subTitle ?? ''),
                      ),
                    const YSpace(24),
                    if (formFields?.contains('installment') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Builder(
                          builder: (context) {
                            final inputData = formMap!
                                .where((e) => e.name == 'installment')
                                .first;
                            return KCDropdownInput(
                              label: inputData.label ?? "Please select",
                              items: inputData.options!
                                  .map((e) => e['value'].toString())
                                  .toList(),
                              value: _installmentSplit,
                              onSelected: (value) {
                                setState(() {
                                  _installmentSplit = value;
                                });
                                validateInputs();
                              },
                              minWidth: constraints.maxWidth - 52,
                            );
                          },
                        ),
                      ),
                    if (checkoutNotfier.selectedBankFlow?.slug == 'stanbic')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const YSpace(32),
                          KCHeadline5(
                              'What day of the month would you like to pay?'),
                          const YSpace(16),
                          PopupMenuButton<int>(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth - 52,
                              maxHeight: 309,
                            ),
                            padding: EdgeInsets.zero,
                            elevation: 1,
                            offset: const Offset(0, 60),
                            child: Container(
                              height: 60,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.11,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: KCColors.grey1, width: 0.88),
                                borderRadius: BorderRadius.circular(4.4186),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (checkoutNotfier.paymentDay == null)
                                    KCBodyText1(
                                      'Choose day',
                                      color: KCColors.grey2,
                                    )
                                  else
                                    KCBodyText1(
                                      '${checkoutNotfier.paymentDay}',
                                      fontSize: 15,
                                    ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 2, right: 5),
                                    child: SvgPicture.asset(
                                      KCAssets.caretDown,
                                      package: KC_PACKAGE_NAME,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            itemBuilder: (context) {
                              return List.generate(
                                31,
                                (index) => PopupMenuItem<int>(
                                  height: 0,
                                  padding: EdgeInsets.zero,
                                  child: KCInstallmentPopupMenuItemContent(
                                    withBG: (index + 1) % 2 != 0,
                                    title: '${index + 1}',
                                    logo: KCAssets.stanbicLogo,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _repaymentDay = index + 1;
                                    });
                                    validateInputs();
                                  },
                                ),
                              ).toList();
                            },
                          ),
                        ],
                      ),
                    if (checkoutNotfier.selectedBankFlow?.slug == 'stanbic' &&
                        checkoutNotfier.partnerInsurers?.isNotEmpty == true)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const YSpace(32),
                          KCHeadline5('Choose your insurer'),
                          const YSpace(8),
                          PopupMenuButton<PartnerInsurer>(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth - 52,
                              maxWidth: constraints.maxWidth - 52,
                            ),
                            padding: EdgeInsets.zero,
                            elevation: 1,
                            offset: const Offset(0, 76),
                            child: Container(
                              height: 60,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.11,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: KCColors.grey1),
                                borderRadius: BorderRadius.circular(4.4186),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (checkoutNotfier.selectedPartnerInsurer ==
                                      null)
                                    KCBodyText1(
                                      'Choose insurer',
                                      color: KCColors.grey2,
                                      fontSize: 15,
                                    )
                                  else
                                    Expanded(
                                      child: KCAutoSizedText(
                                        checkoutNotfier
                                            .selectedPartnerInsurer!.name,
                                        fontSize: 15,
                                        maxLines: 1,
                                      ),
                                    ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 2, right: 5),
                                    child: SvgPicture.asset(
                                      KCAssets.caretDown,
                                      package: KC_PACKAGE_NAME,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            itemBuilder: (context) {
                              return List.generate(
                                checkoutNotfier.partnerInsurers!.length,
                                (index) => PopupMenuItem<PartnerInsurer>(
                                  height: 0,
                                  padding: EdgeInsets.zero,
                                  child: KCInsurerPopupMenuItemContent(
                                    withBG: index % 2 != 0,
                                    title: checkoutNotfier
                                        .partnerInsurers![index].name,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _insurer = checkoutNotfier
                                          .partnerInsurers![index];
                                    });
                                    validateInputs();
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    const YSpace(24),
                    const Spacer(),
                    ValueListenableBuilder<bool>(
                      valueListenable: _enabled,
                      builder: (_, enabled, __) {
                        return KCPrimaryButton(
                          title: 'Continue',
                          disabled: !enabled || checkoutNotfier.isBusy,
                          loading: checkoutNotfier.isBusy,
                          onTap: () => checkoutNotfier.getRepaymentDetails(
                            installments: _installmentSplit,
                            repaymentDay: _repaymentDay,
                            insurer: _insurer,
                          ),
                        );
                      },
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
