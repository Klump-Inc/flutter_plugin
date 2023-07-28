import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:logger/logger.dart';
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
    Provider.of<KCChangeNotifier>(context, listen: false)
        .initiateTransaction(widget.isLive, widget.data);
  }

  @override
  Widget build(BuildContext context) {
    final checkoutNotfier = Provider.of<KCChangeNotifier>(context);
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
          const YSpace(16),
          LayoutBuilder(
            builder: (context, costraint) {
              return PopupMenuButton<KCBank>(
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
                            Image.asset(
                              checkoutNotfier.selectedBankFlow!.logo,
                              height: 20,
                              width: 17.09,
                              package: KC_PACKAGE_NAME,
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
                  return [
                    PopupMenuItem<KCBank>(
                      height: 0,
                      padding: EdgeInsets.zero,
                      child: KCBankPopupMenuItemContent(
                        title: 'Stanbic Bank',
                        logo: KCAssets.stanbicLogo,
                      ),
                      onTap: () {
                        checkoutNotfier.setBankFlow(
                          KCBank(
                            name: 'Stanbic Bank',
                            logo: KCAssets.stanbicLogo,
                          ),
                        );
                      },
                    ),
                    PopupMenuItem<KCBank>(
                      enabled: false,
                      height: 0,
                      padding: EdgeInsets.zero,
                      child: Container(
                        height: 49,
                        color: KCColors.grey3.withOpacity(0.15),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    ),
                  ];
                },
              );
            },
          ),
          if (checkoutNotfier.selectedBankFlow?.name == 'Stanbic Bank' &&
              checkoutNotfier.partnerInsurers?.isNotEmpty == true)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const YSpace(32),
                KCHeadline5('Choose your insurer'),
                const YSpace(16),
                LayoutBuilder(
                  builder: (context, costraint) {
                    return PopupMenuButton<PartnerInsurer>(
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
                            if (checkoutNotfier.selectedPartnerInsurer == null)
                              KCBodyText1(
                                'Choose insurer',
                                color: KCColors.grey2,
                                fontSize: 15,
                              )
                            else
                              Expanded(
                                child: KCAutoSizedText(
                                  checkoutNotfier.selectedPartnerInsurer!.name,
                                  fontSize: 15,
                                  maxLines: 1,
                                ),
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
                          checkoutNotfier.partnerInsurers!.length,
                          (index) => PopupMenuItem<PartnerInsurer>(
                            height: 0,
                            padding: EdgeInsets.zero,
                            child: KCBankPopupMenuItemContent(
                              title: 'Stanbic Bank',
                              logo: KCAssets.stanbicLogo,
                            ),
                            onTap: () {
                              checkoutNotfier.setPartnerInsurer(
                                  checkoutNotfier.partnerInsurers![index]);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          const YSpace(32),
          const Spacer(),
          KCPrimaryButton(
            disabled: checkoutNotfier.selectedBankFlow == null ||
                checkoutNotfier.isBusy,
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
