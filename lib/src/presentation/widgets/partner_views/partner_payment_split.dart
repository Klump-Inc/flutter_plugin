import 'dart:async';

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
  late TextEditingController _amountCtrl;
  late StreamController<String> amountStreamCtrl;

  String? _installmentSplit;
  int? _repaymentDay;
  PartnerInsurer? _insurer;

  final ValueNotifier<bool> _enabled = ValueNotifier(false);

  void validateInputs() {
    final checkoutNotfier = context.read<KCChangeNotifier>();
    final stepData = checkoutNotfier.loanOptionStepData?.nextStep ??
        checkoutNotfier.selectedBankFlow?.nextStep;
    final formFields = stepData?.formFields?.map((e) => e.name).toList();
    final downPaymentFormList =
        stepData?.formFields?.where((e) => e.name == 'downpayment_amount');
    final downpaymentInputData = downPaymentFormList?.isNotEmpty == true
        ? downPaymentFormList?.first
        : null;

    final errorAmount = KCFormValidator.errorAmount(
      _amountCtrl.text.trim(),
      'Amount is required',
      min: downpaymentInputData == null
          ? 0
          : (double.tryParse(downpaymentInputData.min.toString()) ?? 0),
      max: downpaymentInputData == null
          ? 0
          : (double.tryParse(downpaymentInputData.max.toString()) ?? 0),
    );
    if ((errorAmount?.isEmpty == true ||
            formFields?.contains('downpayment_amount') != true) &&
        (_installmentSplit != null ||
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
        'environment': changeNotifier.initiateResponse?.isLive == true
            ? 'production'
            : 'staging',
        'partner': changeNotifier.selectedBankFlow?.slug,
      },
    );
    _amountCtrl = TextEditingController();
    amountStreamCtrl = StreamController<String>.broadcast();
    _amountCtrl.addListener(() {
      amountStreamCtrl.sink.add(_amountCtrl.text.trim());
      validateInputs();
    });
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    amountStreamCtrl.close();
    super.dispose();
  }

  void _loanInsurer() {
    Provider.of<KCChangeNotifier>(context, listen: false).getPartnerInsurer();
  }

  @override
  Widget build(BuildContext context) {
    final checkoutNotifier = Provider.of<KCChangeNotifier>(context);
    final stepData = checkoutNotifier.loanOptionStepData?.nextStep ??
        checkoutNotifier.selectedBankFlow?.nextStep;
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
                    const DraggableBar(),
                    const YSpace(24),
                    LogoHeaderWidget(
                      onTap: checkoutNotifier.prevPage,
                      logo: Image.network(
                        checkoutNotifier.selectedBankFlow!.logo ?? '',
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
                    if (stepData?.displayData?.title != null)
                      KCHeadline3(
                        stepData?.displayData?.title ?? '',
                      ),
                    if (stepData?.displayData?.subTitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child:
                            KCHeadline5(stepData?.displayData?.subTitle ?? ''),
                      ),
                    const YSpace(24),
                    if (formFields?.contains('downpayment_amount') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: StreamBuilder<String>(
                          stream: amountStreamCtrl.stream,
                          builder: (context, snapshot) {
                            final inputData = formMap!
                                .where((e) => e.name == 'downpayment_amount')
                                .first;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                KCInputField(
                                  controller: _amountCtrl,
                                  hint: inputData.label ?? '',
                                  textInputType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  validationMessage:
                                      KCFormValidator.errorAmount(
                                    snapshot.data,
                                    'Amount is required',
                                    min: double.tryParse(
                                            inputData.min.toString()) ??
                                        0,
                                    max: double.tryParse(
                                            inputData.max.toString()) ??
                                        0,
                                  ),
                                ),
                                if (inputData.smalltext != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: KCBodyText1(
                                      inputData.smalltext
                                          .toString()
                                          .replaceAll('<br>', '\n'),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: KCColors.primary,
                                    ),
                                  )
                              ],
                            );
                          },
                        ),
                      ),
                    if (formFields?.contains('installment') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
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
                    if (formFields?.contains('repaymentDay') == true)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const YSpace(32),
                          KCHeadline5(
                              'What day of the month would you like to pay?'),
                          const YSpace(16),
                          PopupMenuButton<int>(
                            color: Colors.white,
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
                                  if (_repaymentDay == null)
                                    KCBodyText1(
                                      'Choose day',
                                      color: KCColors.grey2,
                                    )
                                  else
                                    KCBodyText1(
                                      '$_repaymentDay',
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
                    if (formFields?.contains('insurerId') == true &&
                        checkoutNotifier.partnerInsurers?.isNotEmpty == true)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const YSpace(32),
                          KCHeadline5('Choose your insurer'),
                          const YSpace(8),
                          PopupMenuButton<PartnerInsurer>(
                            color: Colors.white,
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
                                  if (_insurer == null)
                                    KCBodyText1(
                                      'Choose insurer',
                                      color: KCColors.grey2,
                                      fontSize: 15,
                                    )
                                  else
                                    Expanded(
                                      child: KCAutoSizedText(
                                        _insurer!.insurance,
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
                                checkoutNotifier.partnerInsurers!.length,
                                (index) => PopupMenuItem<PartnerInsurer>(
                                  height: 0,
                                  padding: EdgeInsets.zero,
                                  child: KCInsurerPopupMenuItemContent(
                                    withBG: index % 2 != 0,
                                    title: checkoutNotifier
                                        .partnerInsurers![index].insurance,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _insurer = checkoutNotifier
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
                          disabled: !enabled || checkoutNotifier.isBusy,
                          loading: checkoutNotifier.isBusy,
                          onTap: () => checkoutNotifier.getRepaymentDetails(
                            downpaymentAmount:
                                formFields?.contains('downpayment_amount') ==
                                        true
                                    ? double.parse(_amountCtrl.text.trim())
                                    : null,
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
