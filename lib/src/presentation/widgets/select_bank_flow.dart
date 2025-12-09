import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:provider/provider.dart';

class SelectBankFlow extends StatefulWidget {
  const SelectBankFlow({
    super.key,
    required this.data,
  });
  final KlumpCheckoutData data;

  @override
  State<SelectBankFlow> createState() => _SelectBankFlowState();
}

class _SelectBankFlowState extends State<SelectBankFlow> {
  @override
  void initState() {
    Future.delayed(Duration.zero, _initiatTranx);
    super.initState();
  }

  void _getCameras() async {
    cameras = await availableCameras();
  }

  void _initiatTranx() {
    final checkoutNotifier =
        Provider.of<KCChangeNotifier>(context, listen: false);
    Future.delayed(Duration.zero, () async {
      if (widget.data.email != null && widget.data.phone != null) {
        checkoutNotifier.setTransactionData(widget.data);
        await checkoutNotifier.initiateTransaction(
          email: widget.data.email!,
          phone: widget.data.phone!,
        );
      }
      checkoutNotifier.getLoanPartners();
    });
  }

  @override
  Widget build(BuildContext context) {
    final checkoutNotfier = Provider.of<KCChangeNotifier>(context);
    final activeLoanPartners = checkoutNotfier.loanPartners == null
        ? <Partner>[]
        : checkoutNotfier.loanPartners!;
    final banks = ((checkoutNotfier.selectedBankFlow?.config
                    as Map<String, dynamic>?)?['extra_form_fields'] as List?)
                ?.isNotEmpty ==
            true
        ? ((checkoutNotfier.selectedBankFlow?.config
                as Map<String, dynamic>?)?['extra_form_fields'] as List)
            .first['options'] as List
        : [];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DraggableBar(),
          const YSpace(30.82),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 30,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    KCAssets.klumpLogo,
                    package: 'klump_checkout',
                  ),
                  if (checkoutNotfier.initiateResponse?.merchant != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Align(
                        child: KCHeadline4(
                          checkoutNotfier.initiateResponse!.merchant.toString(),
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
                child: CloseViewButton(),
              ),
            ],
          ),
          const YSpace(30.22),
          KCHeadline3('Select a Partner'),
          const YSpace(8),
          KCHeadline5(
            'Credit approval in minutes',
            fontSize: 16,
          ),
          const YSpace(16),
          LayoutBuilder(
            builder: (context, costraint) {
              return PopupMenuButton<Partner>(
                color: Colors.white,
                enabled: activeLoanPartners.isNotEmpty,
                constraints: BoxConstraints(
                  minWidth: costraint.maxWidth,
                  maxWidth: costraint.maxWidth,
                  maxHeight: 300,
                ),
                padding: EdgeInsets.zero,
                elevation: 1,
                offset: const Offset(0, 70),
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
                        Expanded(
                          child: Row(
                            children: [
                              KCNetworkImage(
                                url: checkoutNotfier.selectedBankFlow?.logo,
                                height: 20,
                                width: 17.09,
                              ),
                              const XSpace(14),
                              Expanded(
                                child: KCBodyText1(
                                  checkoutNotfier.selectedBankFlow!.name,
                                  fontSize: 15,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
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
                    activeLoanPartners.length + 1,
                    (index) {
                      return index != activeLoanPartners.length
                          ? PopupMenuItem<Partner>(
                              height: 0,
                              padding: EdgeInsets.zero,
                              child: KCPartnerPopupMenuItemContent(
                                title: activeLoanPartners[index].name,
                                logo: activeLoanPartners[index].logo,
                                withBG: index % 2 == 0,
                                isActive: activeLoanPartners[index].isActive &&
                                    activeLoanPartners[index]
                                            .isActiveForMobile ==
                                        true,
                                message: activeLoanPartners[index]
                                    .metadata?['dropdown_message'],
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
                                color: KCColors.grey3.withOpacity(0.30),
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
          const YSpace(12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: SvgPicture.asset(
                  KCAssets.info,
                  package: 'klump_checkout',
                ),
              ),
              const XSpace(8),
              const Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Can’t find your bank? Use '),
                      TextSpan(
                        text: 'Renmoney ',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      TextSpan(text: 'or '),
                      TextSpan(
                        text: 'CDL ',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      TextSpan(text: 'to checkout'),
                    ],
                  ),
                  style: TextStyle(
                    fontFamily: KCFonts.avenir,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          if (banks.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 35),
              child: LayoutBuilder(
                builder: (context, costraint) {
                  return PopupMenuButton<Partner>(
                    enabled: true,
                    constraints: BoxConstraints(
                      minWidth: costraint.maxWidth,
                      maxHeight: 250,
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
                          if (checkoutNotfier.selectedBank == null)
                            KCBodyText1(
                              'Select Bank',
                              color: KCColors.grey2,
                              fontSize: 15,
                            )
                          else
                            KCBodyText1(
                              checkoutNotfier.selectedBank!['name'],
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
                        banks.length,
                        (index) {
                          return PopupMenuItem<Partner>(
                            height: 0,
                            padding: EdgeInsets.zero,
                            child: KCBankPopupMenuItemContent(
                              title: banks[index]['name'],
                              withBG: index % 2 == 0,
                            ),
                            onTap: () {
                              checkoutNotfier.selectBank(banks[index]);
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          const YSpace(32),
          const Spacer(),
          KCPrimaryButton(
            disabled: checkoutNotfier.isBusy ||
                checkoutNotfier.initiateResponse == null ||
                checkoutNotfier.selectedBankFlow?.isActive != true ||
                checkoutNotfier.selectedBankFlow?.isActiveForMobile != true ||
                (banks.isNotEmpty && checkoutNotfier.selectedBank == null),
            loading: checkoutNotfier.isBusy,
            title: 'Continue',
            onTap: () {
              MixPanelService.logEvent(
                '4 - Selected Payment institution',
                properties: {
                  'environment':
                      checkoutNotfier.initiateResponse?.isLive == true
                          ? 'production'
                          : 'staging',
                  'partner': checkoutNotfier.selectedBankFlow?.name,
                  'payload': {'bank': checkoutNotfier.selectedBankFlow?.slug},
                },
              );
              if (checkoutNotfier.selectedBankFlow?.slug == 'renmoney' ||
                  checkoutNotfier.selectedBankFlow?.slug == 'klump') {
                _getCameras();
              }
              checkoutNotfier.selectBankSubmitted();
            },
          ),
          const YSpace(59)
        ],
      ),
    );
  }
}
