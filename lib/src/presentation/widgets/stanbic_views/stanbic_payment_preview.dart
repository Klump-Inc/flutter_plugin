import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:provider/provider.dart';

class StanbicPaymentPreview extends StatefulWidget {
  const StanbicPaymentPreview({super.key});

  @override
  State<StanbicPaymentPreview> createState() => _StanbicPaymentPreviewState();
}

class _StanbicPaymentPreviewState extends State<StanbicPaymentPreview> {
  final ValueNotifier<bool> _accepted = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final checkoutNotfier = Provider.of<KCChangeNotifier>(context);
    final repaymentDetails = checkoutNotfier.repaymentDetails;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ConstrainedBox(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: checkoutNotfier.prevPage,
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
                        child: Image.asset(
                          KCAssets.stanbicLogo,
                          height: 45,
                          width: 38.45,
                          package: KC_PACKAGE_NAME,
                        ),
                      ),
                      const XSpace(24)
                    ],
                  ),
                  const YSpace(22),
                  KCHeadline3(
                    '${repaymentDetails!.installment} instalments charged on your card over ${repaymentDetails.tenor} months',
                  ),
                  const YSpace(10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6.04, bottom: 20.5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            KPPaymentItemTile(
                              title: 'Due Now',
                              amount:
                                  'NGN${KCStringUtil.formatAmount(repaymentDetails.downpaymentAmount)}',
                              body: 'Paid at purchase',
                              bodyLines: 1,
                              firstItem: true,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                repaymentDetails.tenor,
                                (index) => KPPaymentItemTile(
                                  title:
                                      'Due: ${repaymentDetails.repaymentSchedules[index].repaymentDate}',
                                  amount:
                                      'NGN${KCStringUtil.formatAmount(repaymentDetails.repaymentSchedules[index].monthlyRepayment)}',
                                  body: index == repaymentDetails.tenor - 1
                                      ? 'Final payment, ${index + 1} months later'
                                      : 'Paid automatically ${index + 1} month later',
                                  bodyLines: 2,
                                  lastItem: index == repaymentDetails.tenor - 1,
                                ),
                              ),
                            ),
                            const YSpace(18),
                            KCHeadline5(
                              'Get your order immediately at only one fourth of the payment upfront. The balance will be split into three equal instalments over 3 months. ',
                              fontSize: 14,
                              height: 1.714,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const YSpace(10),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SizedBox(
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
                                fillColor:
                                    MaterialStateProperty.all(KCColors.primary),
                              );
                            },
                          ),
                        ),
                      ),
                      const XSpace(10.5),
                      const Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'I agree to this according to Klump’s ',
                              ),
                              TextSpan(
                                text: 'Customer Agreement',
                                style: TextStyle(
                                  color: KCColors.black3,
                                  fontWeight: FontWeight.w800,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(text: ' and'),
                              TextSpan(
                                text: ' Terms and Conditions',
                                style: TextStyle(
                                  color: KCColors.black3,
                                  fontWeight: FontWeight.w800,
                                  decoration: TextDecoration.underline,
                                ),
                              )
                            ],
                          ),
                          style: TextStyle(
                            color: KCColors.grey5,
                            fontSize: 12,
                            height: 1.818,
                            fontFamily: KCFonts.avenir,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    ],
                  ),
                  const YSpace(24),
                  ValueListenableBuilder<bool>(
                    valueListenable: _accepted,
                    builder: (_, accepted, __) {
                      return KCPrimaryButton(
                        title:
                            'Pay NGN${KCStringUtil.formatAmount(repaymentDetails.downpaymentAmount)}',
                        disabled: !accepted || checkoutNotfier.isBusy,
                        loading: checkoutNotfier.isBusy,
                        onTap: () => Provider.of<KCChangeNotifier>(context,
                                listen: false)
                            .createLoan(),
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

class KPPaymentItemTile extends StatelessWidget {
  const KPPaymentItemTile({
    super.key,
    required this.title,
    required this.amount,
    required this.body,
    required this.bodyLines,
    this.firstItem = false,
    this.lastItem = false,
  });

  final String title, amount, body;
  final int bodyLines;
  final bool firstItem, lastItem;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.49 + 4.95 + (bodyLines * 19.12) + (lastItem ? 0 : 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Column(
              children: [
                Container(
                  height: 11.34,
                  width: 11.34,
                  decoration: BoxDecoration(
                    color: firstItem ? KCColors.green : KCColors.grey6,
                    borderRadius: BorderRadius.circular(30.2483),
                  ),
                ),
                if (!lastItem)
                  Expanded(
                    child: Container(
                      width: 1.5,
                      color: KCColors.grey1,
                    ),
                  )
              ],
            ),
          ),
          const XSpace(8.66),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20.49,
                            child: KCAutoSizedText(
                              title,
                              color:
                                  firstItem ? KCColors.green : KCColors.primary,
                              fontWeight: FontWeight.w900,
                              height: 1.366,
                            ),
                          ),
                          const YSpace(4.95),
                          SizedBox(
                            height: bodyLines * 19.12,
                            child: KCAutoSizedText(
                              body,
                              fontSize: 14,
                              color: KCColors.grey5,
                              height: 1.3657,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const XSpace(30),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 20.49,
                            child: KCAutoSizedText(
                              amount,
                              color:
                                  firstItem ? KCColors.green : KCColors.primary,
                              fontWeight: FontWeight.w900,
                              height: 1.366,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                if (!lastItem) const YSpace(16),
              ],
            ),
          )
        ],
      ),
    );
  }
}
