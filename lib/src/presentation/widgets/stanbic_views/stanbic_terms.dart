import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class StanbicTerms extends StatefulWidget {
  const StanbicTerms({super.key});

  @override
  State<StanbicTerms> createState() => _StanbicTermsState();
}

class _StanbicTermsState extends State<StanbicTerms> {
  final ValueNotifier<bool> _accepted = ValueNotifier(false);

  void _fetchTerms() {
    Provider.of<KCChangeNotifier>(context, listen: false).fetchBankTC();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, _fetchTerms);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final checkoutNotifier = Provider.of<KCChangeNotifier>(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: constraints.maxWidth,
            minHeight: constraints.maxHeight,
          ),
          child: IntrinsicHeight(
            child: checkoutNotifier.stanbicUser?.maxLoanLimit == null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    child: Column(
                      children: [
                        const YSpace(32.59),
                        Image.network(
                          checkoutNotifier.selectedBankFlow!.logo ?? '',
                          height: 55,
                          width: 47,
                        ),
                        const YSpace(24),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 187.1,
                                width: 187.1,
                                child: SvgPicture.asset(
                                  KCAssets.failureIllus,
                                  package: KC_PACKAGE_NAME,
                                ),
                              ),
                              const YSpace(22),
                              Column(
                                children: [
                                  KCHeadline3(
                                    'Unsuccessful',
                                    fontSize: 27,
                                    textAlign: TextAlign.center,
                                    height: 1.4318,
                                  ),
                                  const YSpace(8),
                                  KCBodyText1(
                                    'We couldn’t get your transaction history at this time, please try again later.',
                                    fontSize: 16,
                                    textAlign: TextAlign.center,
                                    height: 1.36625,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const YSpace(24),
                        KCPrimaryButton(
                          title: 'Return to store',
                          onTap: () => Navigator.pop(context),
                        ),
                        const YSpace(59)
                      ],
                    ),
                  )
                : checkoutNotifier.stanbicTC == null
                    ? const KCPageLoaderWidget()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 26),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const YSpace(30.82),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () => checkoutNotifier.prevPage(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: SvgPicture.asset(
                                      KCAssets.arrowBack,
                                      package: KC_PACKAGE_NAME,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.6),
                                  child: Image.network(
                                    checkoutNotifier.selectedBankFlow!.logo ??
                                        '',
                                    height: 45,
                                    width: 38.45,
                                  ),
                                ),
                                const XSpace(24)
                              ],
                            ),
                            const YSpace(22),
                            KCHeadline3(
                              'Read and agree to the terms of service to continue',
                              fontSize: 15,
                            ),
                            const YSpace(8),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Html(
                                  data:
                                      "$KC_HTML_HEADER${checkoutNotifier.stanbicTC?.termsAndConditions ?? ''}$KC_HTML_FOOTER",
                                ),
                              ),
                            ),
                            const YSpace(24),
                            Row(
                              children: [
                                SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: ValueListenableBuilder<bool>(
                                    valueListenable: _accepted,
                                    builder: (_, accepted, __) {
                                      return Checkbox(
                                        value: accepted,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.padded,
                                        onChanged: (value) {
                                          _accepted.value = value ?? false;
                                        },
                                        fillColor: MaterialStateProperty.all(
                                            KCColors.primary),
                                      );
                                    },
                                  ),
                                ),
                                const XSpace(10.5),
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text:
                                              'I agree to this according to Klump’s ',
                                        ),
                                        TextSpan(
                                          text: 'Customer Agreement',
                                          style: const TextStyle(
                                            color: KCColors.black3,
                                            fontWeight: FontWeight.w800,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              if (!await launchUrl(
                                                Uri.parse(
                                                    "https://useklump.com/legal/terms-of-service-customer"),
                                                mode: LaunchMode
                                                    .externalApplication,
                                              )) {
                                                // ignore: avoid_print
                                                print('Could not open link');
                                              }
                                            },
                                        ),
                                        const TextSpan(text: ' and'),
                                        TextSpan(
                                          text: ' Terms and Conditions',
                                          style: const TextStyle(
                                            color: KCColors.black3,
                                            fontWeight: FontWeight.w800,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              if (!await launchUrl(
                                                Uri.parse(
                                                    "https://useklump.com/legal/terms-of-service"),
                                                mode: LaunchMode
                                                    .externalApplication,
                                              )) {
                                                // ignore: avoid_print
                                                print('Could not open link');
                                              }
                                            },
                                        )
                                      ],
                                    ),
                                    style: const TextStyle(
                                      color: KCColors.grey5,
                                      fontSize: 11,
                                      height: 1.818,
                                      fontFamily: KCFonts.avenir,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const YSpace(24),
                            ValueListenableBuilder<bool>(
                              valueListenable: _accepted,
                              builder: (_, accepted, __) {
                                return KCPrimaryButton(
                                  title: 'Continue',
                                  disabled: !accepted,
                                  onTap: () => checkoutNotifier.nextPage(),
                                );
                              },
                            ),
                            const YSpace(59)
                          ],
                        ),
                      ),
          ),
        );
      },
    );
  }
}

class KCPageLoaderWidget extends StatelessWidget {
  const KCPageLoaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: Platform.isIOS
          ? const CupertinoActivityIndicator(
              radius: 20.0,
              color: KCColors.primary,
            )
          : const Center(
              child: CircularProgressIndicator(
                color: KCColors.primary,
                strokeWidth: 3,
              ),
            ),
    );
  }
}
