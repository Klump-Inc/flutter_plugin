import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:provider/provider.dart';

class SelectBankFlow extends StatefulWidget {
  const SelectBankFlow({
    super.key,
    required this.data,
    required this.isLive,
  });
  final KlumpCheckoutData data;
  final bool isLive;

  @override
  State<SelectBankFlow> createState() => _SelectBankFlowState();
}

class _SelectBankFlowState extends State<SelectBankFlow> {
  @override
  void initState() {
    Future.delayed(Duration.zero, _initiatTranx);
    super.initState();
  }

  void _initiatTranx() {
    final changeNotifier =
        Provider.of<KCChangeNotifier>(context, listen: false);
    changeNotifier.getLoanPartners().then(
          (_) => changeNotifier.initiateTransaction(widget.isLive, widget.data),
        );
  }

  @override
  Widget build(BuildContext context) {
    final checkoutNotfier = Provider.of<KCChangeNotifier>(context);
    final activeLoanPartners = checkoutNotfier.loanPartners == null
        ? <Partner>[]
        : checkoutNotfier.loanPartners!
            .where((e) => e.isActive == true)
            .toList();
    return Padding(
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
          const YSpace(24.22),
          KCHeadline3('Choose a bank'),
          const YSpace(8),
          KCHeadline5('Choose the bank you want to pay with'),
          const YSpace(8),
          LayoutBuilder(
            builder: (context, costraint) {
              return PopupMenuButton<Partner>(
                constraints: BoxConstraints(
                  minWidth: costraint.maxWidth,
                ),
                padding: EdgeInsets.zero,
                elevation: 1,
                offset: const Offset(0, 76),
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.11,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: KCColors.grey1),
                    borderRadius: BorderRadius.circular(4.4186),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (checkoutNotfier.selectedBankFlow == null)
                        KCBodyText1(
                          'Select Bank',
                          color: KCColors.grey2,
                          fontSize: 15,
                        )
                      else
                        Row(
                          children: [
                            Image.network(
                              checkoutNotfier.selectedBankFlow!.logo ?? '',
                              height: 20,
                              width: 17.09,
                            ),
                            const XSpace(14),
                            KCBodyText1(
                              checkoutNotfier.selectedBankFlow!.name,
                              fontSize: 15,
                            )
                          ],
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
                    activeLoanPartners.length + 1,
                    (index) {
                      return index != activeLoanPartners.length
                          ? PopupMenuItem<Partner>(
                              height: 0,
                              padding: EdgeInsets.zero,
                              child: KCBankPopupMenuItemContent(
                                title: activeLoanPartners[index].name,
                                logo: activeLoanPartners[index].logo,
                                withBG: index % 2 == 0,
                              ),
                              onTap: () {
                                checkoutNotfier
                                    .setBankFlow(activeLoanPartners[index]);
                              },
                            )
                          : PopupMenuItem<Partner>(
                              enabled: false,
                              height: 0,
                              padding: EdgeInsets.zero,
                              child: Container(
                                height: 49,
                                color: KCColors.grey3.withOpacity(0.15),
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    KCBodyText1(
                                      'Others banks coming soon',
                                      color: KCColors.grey4,
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {},
                            );
                    },
                  );
                },
              );
            },
          ),
          const YSpace(32),
          const Spacer(),
          KCPrimaryButton(
            disabled: checkoutNotfier.isBusy ||
                checkoutNotfier.selectedBankFlow == null ||
                checkoutNotfier.selectedBankFlow?.slug != 'stanbic',
            loading: checkoutNotfier.isBusy,
            title: 'Continue',
            onTap: checkoutNotfier.nextPage,
          ),
          const YSpace(59)
        ],
      ),
    );
  }
}
