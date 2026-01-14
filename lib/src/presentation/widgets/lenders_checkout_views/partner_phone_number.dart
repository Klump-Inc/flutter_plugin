import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:provider/provider.dart';

class PartnerPhoneNumber extends StatefulWidget {
  const PartnerPhoneNumber({super.key});

  @override
  State<PartnerPhoneNumber> createState() => _PartnerPhoneNumberState();
}

class _PartnerPhoneNumberState extends State<PartnerPhoneNumber> {
  late TextEditingController _phoneNoCtrl;

  late StreamController<String> phoneNoStreamCtrl;

  final ValueNotifier<bool> _enabled = ValueNotifier(false);

  void validateInputs() {
    final lendersNotifier =
        Provider.of<KCLendersNotifier>(context, listen: false);
    final formFields = lendersNotifier
        .createPhoneNumberStepData!.nextStep.formFields!
        .map((e) => e.name);

    final phoneNoError =
        KCFormValidator.errorPhoneNumber(_phoneNoCtrl.text.trim(), 'Required');
    if ((phoneNoError?.isEmpty == true ||
        formFields.contains('phone') != true)) {
      _enabled.value = true;
    } else {
      _enabled.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _phoneNoCtrl = TextEditingController();
    phoneNoStreamCtrl = StreamController<String>.broadcast();
    validateInputs();
    _phoneNoCtrl.addListener(() {
      phoneNoStreamCtrl.sink.add(_phoneNoCtrl.text.trim());
      validateInputs();
    });
    final lendersNotifier = context.read<KCLendersNotifier>();
    MixPanelService.logEvent(
      '7 - CREATE_PHONE_OTP MODAL',
      properties: {
        'environment': lendersNotifier.initiateResponse?.isLive == true
            ? 'production'
            : 'staging',
        'partner': lendersNotifier.selectedBankFlow?.slug,
      },
    );
    Future.delayed(Duration.zero, () {
      _phoneNoCtrl.text = lendersNotifier.phoneNumber ?? '';
      validateInputs();
    });
  }

  @override
  void dispose() {
    _phoneNoCtrl.dispose();
    phoneNoStreamCtrl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lendersNotifier = Provider.of<KCLendersNotifier>(context);
    final stepData = lendersNotifier.createPhoneNumberStepData?.nextStep;
    final formFields = stepData?.formFields?.map((e) => e.name).toList();
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
                padding: EdgeInsets.only(
                    left: 26,
                    right: 26,
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DraggableBar(),
                    const YSpace(24),
                    LogoHeaderWidget(
                      onTap: lendersNotifier.prevPage,
                      logo: KCNetworkImage(
                        url: lendersNotifier.selectedBankFlow?.logo,
                        height: 55,
                        width: 120,
                      ),
                    ),
                    if (lendersNotifier.initiateResponse?.merchant != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Align(
                          child: KCHeadline4(
                            lendersNotifier.initiateResponse!.merchant
                                .toString(),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    const YSpace(22),
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
                    if (formFields?.contains('phone') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: StreamBuilder<String>(
                          stream: phoneNoStreamCtrl.stream,
                          builder: (context, snapshot) {
                            return KCInputField(
                              controller: _phoneNoCtrl,
                              hint: 'Phone Number',
                              textInputType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                                LengthLimitingTextInputFormatter(11),
                              ],
                              textInputAction: TextInputAction.next,
                              validationMessage:
                                  KCFormValidator.errorPhoneNumber(
                                snapshot.data,
                                'Phone Number is required',
                              ),
                            );
                          },
                        ),
                      ),
                    const YSpace(25),
                    const Spacer(),
                    ValueListenableBuilder<bool>(
                      valueListenable: _enabled,
                      builder: (_, enabled, __) {
                        return KCPrimaryButton(
                          title: 'Continue',
                          disabled: !enabled || lendersNotifier.isBusy,
                          loading: lendersNotifier.isBusy,
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            lendersNotifier.createPhoneNumber(
                              phoneNumber: _phoneNoCtrl.text.trim(),
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
    );
  }
}
