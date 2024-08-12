import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/src/core/core.dart';
import 'package:klump_checkout/src/data/models/models.dart';
import 'package:klump_checkout/src/presentation/change_notifiers/kc_change_notifier.dart';
import 'package:klump_checkout/src/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';

class AccountEmail extends StatefulWidget {
  const AccountEmail({super.key, required this.data, required this.isLive});
  final KlumpCheckoutData data;
  final bool isLive;

  @override
  State<AccountEmail> createState() => _AccountEmailState();
}

class _AccountEmailState extends State<AccountEmail> {
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;

  late StreamController<String> emailStreamCtrl;
  late StreamController<String> phoneStreamCtrl;
  final ValueNotifier<bool> _enabled = ValueNotifier(false);

  void validateInputs() {
    final phoneError =
        KCFormValidator.errorPhoneNumber(_phoneCtrl.text.trim(), 'Required');
    final emailError =
        KCFormValidator.errorEmail(_emailCtrl.text.trim(), 'Required');
    if (phoneError?.isEmpty == true && emailError?.isEmpty == true) {
      _enabled.value = true;
    } else {
      _enabled.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    emailStreamCtrl = StreamController<String>.broadcast();
    phoneStreamCtrl = StreamController<String>.broadcast();

    _emailCtrl.addListener(() {
      emailStreamCtrl.sink.add(_emailCtrl.text.trim());
      validateInputs();
    });
    _phoneCtrl.addListener(() {
      phoneStreamCtrl.sink.add(_phoneCtrl.text.trim());
      validateInputs();
    });
    Future.delayed(Duration.zero, () {
      final changeNotifier =
          Provider.of<KCChangeNotifier>(context, listen: false);
      changeNotifier.setTransactionData(widget.isLive, widget.data);
      changeNotifier.getLoanPartners();
    });
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkoutNotifier = Provider.of<KCChangeNotifier>(context);
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
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: SvgPicture.asset(
                            KCAssets.arrowBack,
                            package: 'klump_checkout',
                          ),
                        ),
                      ),
                    ),
                    const YSpace(16),
                    Align(
                      child: SvgPicture.asset(
                        KCAssets.klumpLogo,
                        height: 30,
                        width: 47,
                        package: KC_PACKAGE_NAME,
                      ),
                    ),
                    const YSpace(24),
                    KCHeadline5(
                        'Please enter your email and phone number to check out'),
                    const YSpace(24),
                    StreamBuilder<String>(
                      stream: emailStreamCtrl.stream,
                      builder: (context, snapshot) {
                        return KCInputField(
                          controller: _emailCtrl,
                          hint: 'Email',
                          textInputType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validationMessage: KCFormValidator.errorEmail(
                            snapshot.data,
                            'Email is required',
                          ),
                        );
                      },
                    ),
                    const YSpace(24),
                    StreamBuilder<String>(
                      stream: phoneStreamCtrl.stream,
                      builder: (context, snapshot) {
                        return KCInputField(
                          controller: _phoneCtrl,
                          hint: 'Phone Number',
                          textInputType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            LengthLimitingTextInputFormatter(11),
                          ],
                          textInputAction: TextInputAction.done,
                          validationMessage: KCFormValidator.errorPhoneNumber(
                            snapshot.data,
                            'Phone Number is required',
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
                            checkoutNotifier
                                .initiateTransaction(
                              email: _emailCtrl.text.trim(),
                              phone: _phoneCtrl.text.trim(),
                            )
                                .then((value) {
                              if (value) {
                                checkoutNotifier.nextPage();
                              }
                            });
                          },
                        );
                      },
                    ),
                    const YSpace(59),
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
