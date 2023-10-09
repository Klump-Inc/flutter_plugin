import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PartnerInvoice extends StatefulWidget {
  const PartnerInvoice({super.key});

  @override
  State<PartnerInvoice> createState() => _PartnerInvoiceState();
}

class _PartnerInvoiceState extends State<PartnerInvoice> {
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
              child: checkoutNotifier.finalLoanStep == null
                  ? const KCPageLoaderWidget()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const YSpace(30.82),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: () => checkoutNotifier.prevPage(),
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
                          KCHeadline3(
                            checkoutNotifier
                                    .finalLoanStep!.displayData?.title ??
                                '',
                            fontSize: 22,
                            height: 1.4318,
                            textAlign: TextAlign.left,
                          ),
                          const YSpace(8),
                          SizedBox(
                            height: 50,
                            child: Html(
                              data:
                                  "$KC_HTML_HEADER${checkoutNotifier.finalLoanStep!.displayData?.subTitle ?? ''}$KC_HTML_FOOTER",
                            ),
                          ),
                          if (checkoutNotifier.finalLoanStep!.displayData?.list
                                  ?.isNotEmpty ==
                              true)
                            Column(
                              children: List.generate(
                                  checkoutNotifier.finalLoanStep!.displayData!
                                      .list!.length, (index) {
                                final item = checkoutNotifier
                                    .finalLoanStep!
                                    .displayData!
                                    .list![index] as Map<String, dynamic>;
                                return KCCopyItemWidget(
                                  text: item['display'],
                                  copyText: item['value'].toString(),
                                );
                              }),
                            ),
                          const YSpace(24),
                          const Spacer(),
                          KCPrimaryButton(
                            title: 'Continue',
                            onTap: () async {
                              if (checkoutNotifier.finalLoanStep!.redirectUrl !=
                                  null) {
                                if (!await launchUrl(
                                  Uri.parse(checkoutNotifier
                                      .finalLoanStep!.redirectUrl!),
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  showToast('Could not open link!');
                                } else {
                                  checkoutNotifier.nextPage();
                                }
                              } else {
                                showToast('Error occured. Try again later!');
                              }
                            },
                            disabled: checkoutNotifier.isBusy,
                            loading: checkoutNotifier.isBusy,
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

class KCCopyItemWidget extends StatelessWidget {
  const KCCopyItemWidget({
    super.key,
    required this.text,
    required this.copyText,
  });
  final String text, copyText;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 14.21),
      decoration: BoxDecoration(
        border: Border.all(color: KCColors.grey1, width: 0.88),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          KCBodyText1(
            text,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          InkWell(
            onTap: () {
              FlutterClipboard.copy(copyText).then(
                (value) => showToast(
                  'Copied to clipboard',
                  position: ToastPosition.bottom,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: SvgPicture.asset(
                KCAssets.copy,
                package: KC_PACKAGE_NAME,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
