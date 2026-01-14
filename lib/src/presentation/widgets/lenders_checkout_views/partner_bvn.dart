import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klump_checkout/src/core/core.dart';
import 'package:klump_checkout/src/presentation/presentation.dart';
import 'package:provider/provider.dart';

class PartnerBVN extends StatefulWidget {
  const PartnerBVN({super.key});

  @override
  State<PartnerBVN> createState() => _PartnerBVNState();
}

class _PartnerBVNState extends State<PartnerBVN> {
  late TextEditingController _bvnCtrl;

  late StreamController<String> bvnStreamCtrl;
  final ValueNotifier<bool> _enabled = ValueNotifier(false);

  void validateInputs() {
    final lendersNotifier = context.read<KCLendersNotifier>();
    final formFields = lendersNotifier.redirectStepData?.nextStep.formFields
        ?.map((e) => e.name)
        .toList();
    final bvnError = KCFormValidator.errorBVN(_bvnCtrl.text.trim(), 'Required');

    if ((bvnError?.isEmpty == true || formFields?.contains('bvn') != true)) {
      _enabled.value = true;
    } else {
      _enabled.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _bvnCtrl = TextEditingController();
    bvnStreamCtrl = StreamController<String>.broadcast();
    _bvnCtrl.addListener(() {
      bvnStreamCtrl.sink.add(_bvnCtrl.text.trim());
      validateInputs();
    });

    final lendersNotifier =
        Provider.of<KCLendersNotifier>(context, listen: false);
    MixPanelService.logEvent(
      '10 - FETCH_BVN_VERIFICATION_METHODS_MODAL',
      properties: {
        'environment': lendersNotifier.initiateResponse?.isLive == true
            ? 'production'
            : 'staging',
        'partner': lendersNotifier.selectedBankFlow?.slug,
      },
    );
    Future.delayed(Duration.zero, () {
      _bvnCtrl.text = lendersNotifier.bvn ?? '';
      validateInputs();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _bvnCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lendersNotifier = Provider.of<KCLendersNotifier>(context);
    final stepData = lendersNotifier.redirectStepData?.nextStep;
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
                        onTap: lendersNotifier.prevPage,
                        logo: KCNetworkImage(
                          url: lendersNotifier.selectedBankFlow!.logo,
                          height: 55,
                          width: 120,
                        ),
                      ),
                      if (lendersNotifier.initiateResponse?.merchant != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Align(
                            child: KCHeadline4(
                              lendersNotifier.initiateResponse!.merchant
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
                      if (formFields?.contains('bvn') == true)
                        Builder(
                          builder: (context) {
                            final form = formMap!
                                .where((e) => e.name == 'bvn')
                                .toList()
                                .first;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: StreamBuilder<String>(
                                stream: bvnStreamCtrl.stream,
                                builder: (context, snapshot) {
                                  return KCInputField(
                                    controller: _bvnCtrl,
                                    hint: form.placeholder ?? 'BVN',
                                    textInputType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                      LengthLimitingTextInputFormatter(11),
                                    ],
                                    textInputAction: TextInputAction.next,
                                    validationMessage: KCFormValidator.errorBVN(
                                      snapshot.data,
                                      'BVN is required',
                                    ),
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
                            disabled: !enabled || lendersNotifier.isBusy,
                            loading: lendersNotifier.isBusy,
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              lendersNotifier.enterBVN(
                                bvn: _bvnCtrl.text.trim(),
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
