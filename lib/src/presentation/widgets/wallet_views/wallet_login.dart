import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:provider/provider.dart';

class WalletLogin extends StatefulWidget {
  const WalletLogin({super.key});

  @override
  State<WalletLogin> createState() => _WalletLoginState();
}

class _WalletLoginState extends State<WalletLogin> {
  late TextEditingController _emailCtrl;
  late TextEditingController _passwordCtrl;

  late StreamController<String> emailStreamCtrl;
  late StreamController<String> passwordStreamCtrl;

  final ValueNotifier<bool> _enabled = ValueNotifier(false);

  void validateInputs() {
    final checkoutNotfier = context.read<KCChangeNotifier>();
    final formFieldsNames = checkoutNotfier
        .verificationStepData?.nextStep.formFields
        ?.map((e) => e.name)
        .toList();
    final emailError =
        KCFormValidator.errorEmail(_emailCtrl.text.trim(), 'Required');
    final passwordError =
        KCFormValidator.errorPassword(_passwordCtrl.text.trim(), 'Required');
    if ((emailError?.isEmpty == true ||
            formFieldsNames?.contains('email') != true) &&
        (passwordError?.isEmpty == true ||
            formFieldsNames?.contains('password') != true)) {
      _enabled.value = true;
    } else {
      _enabled.value = false;
    }
  }

  @override
  void initState() {
    super.initState();

    _emailCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();

    validateInputs();

    emailStreamCtrl = StreamController<String>.broadcast();
    passwordStreamCtrl = StreamController<String>.broadcast();

    _emailCtrl.addListener(() {
      emailStreamCtrl.sink.add(_emailCtrl.text.trim());
      validateInputs();
    });
    _passwordCtrl.addListener(() {
      passwordStreamCtrl.sink.add(_passwordCtrl.text.trim());
      validateInputs();
    });

    Future.delayed(Duration.zero, () {
      //prepolute saved data
      if (mounted) {
        final changeNotifier = context.read<KCChangeNotifier>();
        if (changeNotifier.email != null) {
          _emailCtrl.text = changeNotifier.email!;
          emailStreamCtrl.sink.add(_emailCtrl.text.trim());
        }
        validateInputs();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final changeNotifier = Provider.of<KCChangeNotifier>(context);
    final stepData = changeNotifier.verificationStepData?.nextStep;
    final formFields = stepData?.formFields;
    final formFieldsNames = formFields?.map((e) => e.name).toList();

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
                    const YSpace(30.82),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: SvgPicture.asset(
                              KCAssets.arrowBack,
                              package: 'klump_checkout',
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              KCAssets.klumpLogo,
                              package: 'klump_checkout',
                            ),
                            if (changeNotifier.initiateResponse?.merchant !=
                                null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text.rich(
                                  TextSpan(children: [
                                    const TextSpan(text: 'Proud partner of '),
                                    TextSpan(
                                        text: changeNotifier
                                            .initiateResponse?.merchant
                                            .toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700)),
                                  ]),
                                  style: const TextStyle(
                                    color: KCColors.black1,
                                    fontSize: 16,
                                    fontFamily: KCFonts.avenir,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            else
                              const YSpace(26),
                          ],
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                      ],
                    ),
                    const YSpace(24),
                    KCHeadline3(
                      stepData?.displayData?.title ??
                          'Login to your Klump account',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: KCHeadline5(stepData?.displayData?.subTitle ??
                          'We’ll only ask you for this information once and you can choose to easily update it in the Klump app later.'),
                    ),
                    const YSpace(24),
                    if (formFieldsNames?.contains('email') == true)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: StreamBuilder<String>(
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
                      ),
                    if (formFieldsNames?.contains('password') == true)
                      Builder(builder: (context) {
                        final form = formFields!
                            .where((e) => e.name == 'password')
                            .toList()
                            .first;
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: StreamBuilder<String>(
                                stream: passwordStreamCtrl.stream,
                                builder: (context, snapshot) {
                                  return KCInputField(
                                    controller: _passwordCtrl,
                                    hint: 'Password',
                                    textInputType: TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                    validationMessage:
                                        KCFormValidator.errorPassword(
                                      snapshot.data,
                                      'Password is required',
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (form.smalltext != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: Html(
                                  data: form.smalltext,
                                  style: {
                                    "*": Style(
                                      fontSize:
                                          FontSize(12), // Global font size
                                    ),
                                  },
                                ),
                              ),
                          ],
                        );
                      }),
                    const YSpace(25),
                    const Spacer(),
                    ValueListenableBuilder<bool>(
                      valueListenable: _enabled,
                      builder: (_, enabled, __) {
                        return KCPrimaryButton(
                          title: 'Login',
                          disabled: !enabled || changeNotifier.isBusy,
                          loading: changeNotifier.isBusy,
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            FocusScope.of(context).unfocus();
                            Provider.of<KCChangeNotifier>(context,
                                    listen: false)
                                .validateAccount(
                              email: _emailCtrl.text.trim(),
                              password: _passwordCtrl.text.trim(),
                            );
                          },
                        );
                      },
                    ),
                    const YSpace(10),
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
