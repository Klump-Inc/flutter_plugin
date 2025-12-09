import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/src/core/core.dart';
import 'package:klump_checkout/src/presentation/presentation.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class PartnerSendBVNOTP extends StatefulWidget {
  const PartnerSendBVNOTP({super.key});

  @override
  State<PartnerSendBVNOTP> createState() => _PartnerSendBVNOTPState();
}

class _PartnerSendBVNOTPState extends State<PartnerSendBVNOTP> {
  final ValueNotifier<bool> _enabled = ValueNotifier(false);
  Map<String, dynamic>? _selectedContact;

  void validateInputs() {
    final checkoutNotifier = context.read<KCChangeNotifier>();
    final formFields = checkoutNotifier.sendBVNOTPStepData?.nextStep.formFields
        ?.map((e) => e.name)
        .toList();
    if (_selectedContact != null || formFields?.contains('contact') != true) {
      _enabled.value = true;
    } else {
      _enabled.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    final changeNotifier =
        Provider.of<KCChangeNotifier>(context, listen: false);
    MixPanelService.logEvent(
      '10 - SEND_BVN_OTP_MODAL',
      properties: {
        'environment': changeNotifier.initiateResponse?.isLive == true
            ? 'production'
            : 'staging',
        'partner': changeNotifier.selectedBankFlow?.slug,
      },
    );
    Future.delayed(Duration.zero, () {
      if (changeNotifier.bvnContact != null) {
        setState(() {
          _selectedContact = changeNotifier.bvnContact;
        });
        validateInputs();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkoutNotifier = Provider.of<KCChangeNotifier>(context);
    final stepData = checkoutNotifier.sendBVNOTPStepData?.nextStep;
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
                      if (formFields?.contains('bvn') == true)
                        Builder(
                          builder: (context) {
                            final form = formMap!
                                .where((e) => e.name == 'bvn')
                                .toList()
                                .first;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: KCInputField(
                                readOnly: form.readonly == true,
                                controller: TextEditingController(
                                    text: form.value.toString()),
                                hint: form.placeholder ?? 'BVN',
                                textInputType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                  LengthLimitingTextInputFormatter(11),
                                ],
                                textInputAction: TextInputAction.next,
                                validationMessage: '',
                              ),
                            );
                          },
                        ),
                      if (formFields?.contains('contact') == true)
                        Builder(
                          builder: (context) {
                            final form = formMap!
                                .where((e) => e.name == 'contact')
                                .toList()
                                .first;
                            final contactList = form.options ?? [];
                            Logger().d(contactList);
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
                                        color: _selectedContact != null
                                            ? Colors.green
                                                .withAlpha((0.50 * 255).round())
                                            : KCColors.grey1),
                                    borderRadius: BorderRadius.circular(4.4186),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (_selectedContact == null)
                                        KCBodyText1(
                                          form.placeholder ?? 'Select Contact',
                                          color: KCColors.grey2,
                                          fontSize: 15,
                                        )
                                      else
                                        KCBodyText1(
                                          _selectedContact!['label'],
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
                                    contactList.length,
                                    (index) {
                                      return PopupMenuItem<
                                          Map<String, dynamic>>(
                                        height: 0,
                                        padding: EdgeInsets.zero,
                                        child: KCBankPopupMenuItemContent(
                                          title: contactList[index]?['label'],
                                          withBG: index % 2 == 0,
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _selectedContact =
                                                contactList[index]
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
                              checkoutNotifier.sendBVNOTP(
                                bvn: formFields?.contains('bvn') == true
                                    ? formMap!
                                        .where((e) => e.name == 'bvn')
                                        .toList()
                                        .first
                                        .value
                                        .toString()
                                    : null,
                                contact: _selectedContact!,
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
