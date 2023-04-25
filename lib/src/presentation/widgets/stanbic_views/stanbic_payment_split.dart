import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:provider/provider.dart';

class StanbicPaymentSplit extends StatefulWidget {
  const StanbicPaymentSplit({super.key});

  @override
  State<StanbicPaymentSplit> createState() => _StanbicPaymentSplitState();
}

class _StanbicPaymentSplitState extends State<StanbicPaymentSplit> {
  int? _instalmentSplit;
  int? _paymentDay;

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
                    const YSpace(18.22),
                    KCHeadline3('Your installment split'),
                    const YSpace(8),
                    KCHeadline5('How would you like to split your payment?'),
                    const YSpace(16),
                    PopupMenuButton<int>(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth - 52,
                      ),
                      padding: EdgeInsets.zero,
                      elevation: 1,
                      offset: const Offset(0, 60),
                      child: Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.11,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: KCColors.grey1, width: 0.88),
                          borderRadius: BorderRadius.circular(4.4186),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_instalmentSplit == null)
                              KCBodyText1(
                                'Choose split',
                                color: KCColors.grey2,
                              )
                            else
                              KCBodyText1(
                                '$_instalmentSplit instalments',
                                fontSize: 15,
                              ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2, right: 5),
                              child: SvgPicture.asset(
                                KCAssets.caretDown,
                                package: KC_PACKAGE_NAME,
                              ),
                            ),
                          ],
                        ),
                      ),
                      itemBuilder: (context) {
                        return [2, 3, 4]
                            .map(
                              (e) => PopupMenuItem<int>(
                                height: 0,
                                padding: EdgeInsets.zero,
                                child: KCInstallmentPopupMenuItemContent(
                                  withBG: e == 2 || e == 4,
                                  title: '$e instalments',
                                  logo: KCAssets.stanbicLogo,
                                ),
                                onTap: () {
                                  setState(() {
                                    _instalmentSplit = e;
                                  });
                                },
                              ),
                            )
                            .toList();
                      },
                    ),
                    const YSpace(32),
                    KCHeadline5('What day of the month would you like to pay?'),
                    const YSpace(16),
                    PopupMenuButton<int>(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth - 52,
                        maxHeight: 309,
                      ),
                      padding: EdgeInsets.zero,
                      elevation: 1,
                      offset: const Offset(0, 60),
                      child: Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.11,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: KCColors.grey1, width: 0.88),
                          borderRadius: BorderRadius.circular(4.4186),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_paymentDay == null)
                              KCBodyText1(
                                'Choose day',
                                color: KCColors.grey2,
                              )
                            else
                              KCBodyText1(
                                '$_paymentDay',
                                fontSize: 15,
                              ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2, right: 5),
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
                          31,
                          (index) => PopupMenuItem<int>(
                            height: 0,
                            padding: EdgeInsets.zero,
                            child: KCInstallmentPopupMenuItemContent(
                              withBG: (index + 1) % 2 != 0,
                              title: '${index + 1}',
                              logo: KCAssets.stanbicLogo,
                            ),
                            onTap: () {
                              setState(() {
                                _paymentDay = index + 1;
                              });
                            },
                          ),
                        ).toList();
                      },
                    ),
                    const YSpace(24),
                    const Spacer(),
                    KCPrimaryButton(
                      title: 'Continue',
                      disabled: _instalmentSplit == null || _paymentDay == null,
                      onTap: () =>
                          Provider.of<KCChangeNotifier>(context, listen: false)
                              .nextPage(),
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
