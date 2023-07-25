import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:provider/provider.dart';

class StanbicAccountInformation extends StatefulWidget {
  const StanbicAccountInformation({super.key});

  @override
  State<StanbicAccountInformation> createState() =>
      _StanbicAccountInformationState();
}

class _StanbicAccountInformationState extends State<StanbicAccountInformation> {
  late TextEditingController _firstnameCtrl;
  late TextEditingController _lastnameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _passwordCtrl;

  late StreamController<String> firstnameStreamCtrl;
  late StreamController<String> lastnameStreamCtrl;
  late StreamController<String> emailStreamCtrl;
  late StreamController<String> passwordStreamCtrl;
  final ValueNotifier<bool> _enabled = ValueNotifier(false);

  void validateInputs() {
    final firstnameError =
        KCFormValidator.errorGeneric(_firstnameCtrl.text.trim(), 'Required');
    final lastnameError =
        KCFormValidator.errorGeneric(_lastnameCtrl.text.trim(), 'Required');
    final emailError =
        KCFormValidator.errorEmail(_emailCtrl.text.trim(), 'Required');
    final passwordError =
        KCFormValidator.errorPassword(_passwordCtrl.text.trim(), 'Required');
    if (firstnameError?.isEmpty == true &&
        lastnameError?.isEmpty == true &&
        emailError?.isEmpty == true &&
        passwordError?.isEmpty == true) {
      _enabled.value = true;
    } else {
      _enabled.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _firstnameCtrl = TextEditingController();
    _lastnameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
    firstnameStreamCtrl = StreamController<String>.broadcast();
    lastnameStreamCtrl = StreamController<String>.broadcast();
    emailStreamCtrl = StreamController<String>.broadcast();
    passwordStreamCtrl = StreamController<String>.broadcast();
    _firstnameCtrl.addListener(() {
      firstnameStreamCtrl.sink.add(_firstnameCtrl.text.trim());
      validateInputs();
    });
    _lastnameCtrl.addListener(() {
      lastnameStreamCtrl.sink.add(_lastnameCtrl.text.trim());
      validateInputs();
    });
    _emailCtrl.addListener(() {
      emailStreamCtrl.sink.add(_emailCtrl.text.trim());
      validateInputs();
    });
    _passwordCtrl.addListener(() {
      passwordStreamCtrl.sink.add(_passwordCtrl.text.trim());
      validateInputs();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _firstnameCtrl.dispose();
    _lastnameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    firstnameStreamCtrl.close();
    lastnameStreamCtrl.close();
    emailStreamCtrl.close();
    passwordStreamCtrl.close();
  }

  @override
  Widget build(BuildContext context) {
    final checkoutNotfier = Provider.of<KCChangeNotifier>(context);
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
                    const YSpace(14),
                    KCHeadline3('Complete your account'),
                    const YSpace(8),
                    KCHeadline5(
                        'We’ll only ask you for this information once and you can choose to easily update it in the Klump app later.'),
                    const YSpace(18),
                    StreamBuilder<String>(
                      stream: firstnameStreamCtrl.stream,
                      builder: (context, snapshot) {
                        return KCInputField(
                          controller: _firstnameCtrl,
                          hint: 'First Name',
                          textInputType: TextInputType.text,
                          validationMessage: KCFormValidator.errorGeneric(
                            snapshot.data,
                            'First Name is required',
                          ),
                        );
                      },
                    ),
                    const YSpace(16),
                    StreamBuilder<String>(
                      stream: lastnameStreamCtrl.stream,
                      builder: (context, snapshot) {
                        return KCInputField(
                          controller: _lastnameCtrl,
                          hint: 'Last Name',
                          textInputType: TextInputType.text,
                          validationMessage: KCFormValidator.errorGeneric(
                            snapshot.data,
                            'Last Name is required',
                          ),
                        );
                      },
                    ),
                    const YSpace(16),
                    StreamBuilder<String>(
                      stream: emailStreamCtrl.stream,
                      builder: (context, snapshot) {
                        return KCInputField(
                          controller: _emailCtrl,
                          hint: 'Email Address',
                          textInputType: TextInputType.emailAddress,
                          validationMessage: KCFormValidator.errorEmail(
                            snapshot.data,
                            'Email Address is required',
                          ),
                        );
                      },
                    ),
                    const YSpace(16),
                    StreamBuilder<String>(
                      stream: passwordStreamCtrl.stream,
                      builder: (context, snapshot) {
                        return KCInputField(
                          controller: _passwordCtrl,
                          hint: 'Password',
                          password: true,
                          textInputType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          validationMessage: KCFormValidator.errorPassword(
                            snapshot.data,
                            'Password is required',
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
                          disabled: !enabled || checkoutNotfier.isBusy,
                          loading: checkoutNotfier.isBusy,
                          onTap: () => Provider.of<KCChangeNotifier>(context,
                                  listen: false)
                              .validateAccount(_emailCtrl.text.trim(),
                                  _passwordCtrl.text.trim()),
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
