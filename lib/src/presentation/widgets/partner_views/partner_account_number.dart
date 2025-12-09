import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/src/core/core.dart';
import 'package:klump_checkout/src/presentation/presentation.dart';
import 'package:provider/provider.dart';

class PartnerAccountNumber extends StatefulWidget {
  const PartnerAccountNumber({super.key});

  @override
  State<PartnerAccountNumber> createState() => _PartnerAccountNumberState();
}

class _PartnerAccountNumberState extends State<PartnerAccountNumber> {
  late TextEditingController _accountNumberCtrl;

  late StreamController<String> accountNumberStreamCtrl;
  Map<String, dynamic>? _selectedBank;
  final ValueNotifier<bool> _enabled = ValueNotifier(false);

  void validateInputs() {
    final checkoutNotifier = context.read<KCChangeNotifier>();
    final formFields = checkoutNotifier
        .accountNumberStepData?.nextStep.formFields
        ?.map((e) => e.name)
        .toList();
    final accountNumberError = KCFormValidator.errorAccountNumber(
        _accountNumberCtrl.text.trim(), 'Required');

    if ((accountNumberError?.isEmpty == true ||
            formFields?.contains('accountNumber') != true) &&
        (_selectedBank != null || formFields?.contains('bank_code') != true)) {
      _enabled.value = true;
    } else {
      _enabled.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _accountNumberCtrl = TextEditingController();
    accountNumberStreamCtrl = StreamController<String>.broadcast();
    _accountNumberCtrl.addListener(() {
      accountNumberStreamCtrl.sink.add(_accountNumberCtrl.text.trim());
      validateInputs();
    });
    final changeNotifier =
        Provider.of<KCChangeNotifier>(context, listen: false);
    MixPanelService.logEvent(
      '10 - VERIFY_ACCOUNT_NUMBER MODAL',
      properties: {
        'environment': changeNotifier.initiateResponse?.isLive == true
            ? 'production'
            : 'staging',
        'partner': changeNotifier.selectedBankFlow?.slug,
      },
    );
    Future.delayed(Duration.zero, () {
      if (changeNotifier.accountNumber != null) {
        _accountNumberCtrl.text = changeNotifier.accountNumber!;
      }
      if (changeNotifier.selectedBank != null) {
        setState(() {
          _selectedBank = changeNotifier.selectedBank;
        });
      }
      validateInputs();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _accountNumberCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkoutNotifier = Provider.of<KCChangeNotifier>(context);
    final stepData = checkoutNotifier.accountNumberStepData?.nextStep;
    final formMap = stepData?.formFields;
    final formFields = formMap?.map((e) => e.name).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const DraggableBar(),
                      const YSpace(24),
                      LogoHeaderWidget(
                        onTap: checkoutNotifier.prevPage,
                        logo: KCNetworkImage(
                          url: checkoutNotifier.selectedBankFlow!.logo,
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
                          child: KCHeadline5(
                              stepData?.displayData?.subTitle ?? ''),
                        ),
                      const YSpace(24),
                      if (formFields?.contains('accountNumber') == true)
                        Builder(
                          builder: (context) {
                            final form = formMap!
                                .where((e) => e.name == 'accountNumber')
                                .toList()
                                .first;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: StreamBuilder<String>(
                                stream: accountNumberStreamCtrl.stream,
                                builder: (context, snapshot) {
                                  return KCInputField(
                                    controller: _accountNumberCtrl,
                                    hint: form.placeholder ?? 'Account Number',
                                    textInputType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    textInputAction: TextInputAction.next,
                                    validationMessage:
                                        KCFormValidator.errorAccountNumber(
                                      snapshot.data,
                                      'Account Number is required',
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      Builder(
                        builder: (context) {
                          final form = formMap!
                              .where((e) => e.name == 'bank_code')
                              .toList()
                              .first;
                          final bankList = form.options ?? [];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: PopupMenuButton<Map<String, dynamic>>(
                              color: Colors.white,
                              enabled: true,
                              constraints: BoxConstraints(
                                minWidth: constraints.maxWidth,
                                maxHeight: 250,
                              ),
                              padding: EdgeInsets.zero,
                              elevation: 1,
                              offset: const Offset(0, 66),
                              child: Container(
                                height: 60,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.11,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: _selectedBank != null
                                          ? Colors.green
                                              .withAlpha((0.50 * 255).round())
                                          : KCColors.grey1),
                                  borderRadius: BorderRadius.circular(4.4186),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (_selectedBank == null)
                                      KCBodyText1(
                                        form.placeholder ?? 'Select Bank',
                                        color: KCColors.grey2,
                                        fontSize: 15,
                                      )
                                    else
                                      KCBodyText1(
                                        _selectedBank!['label'],
                                        fontSize: 15,
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2, right: 5),
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
                                  bankList.length,
                                  (index) {
                                    return PopupMenuItem<Map<String, dynamic>>(
                                      height: 0,
                                      padding: EdgeInsets.zero,
                                      child: KCBankPopupMenuItemContent(
                                        title: bankList[index]?['label'],
                                        withBG: index % 2 == 0,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _selectedBank = bankList[index]
                                              as Map<String, dynamic>;
                                        });
                                        validateInputs();
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                      const YSpace(25),
                      const Spacer(),
                      ValueListenableBuilder<bool>(
                        valueListenable: _enabled,
                        builder: (_, enabled, __) {
                          return KCPrimaryButton(
                            title: 'Continue',
                            disabled: !enabled || checkoutNotifier.isBusy,
                            loading: checkoutNotifier.isBusy,
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              checkoutNotifier.verifyAccountNumber(
                                accountNumber: _accountNumberCtrl.text.trim(),
                                bank: _selectedBank!,
                              );
                            },
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
      ),
    );
  }
}
