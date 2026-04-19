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
  final TextEditingController _lenderSearchController = TextEditingController();
  final FocusNode _lenderSearchFocusNode = FocusNode();
  final TextEditingController _bankSearchController = TextEditingController();
  final FocusNode _bankSearchFocusNode = FocusNode();

  @override
  void initState() {
    Future.delayed(Duration.zero, _initiatTranx);
    super.initState();
    _lenderSearchFocusNode.addListener(() => setState(() {}));
    _bankSearchFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _lenderSearchController.dispose();
    _lenderSearchFocusNode.dispose();
    _bankSearchController.dispose();
    _bankSearchFocusNode.dispose();
    super.dispose();
  }

  List<Partner> _filterPartners(
      List<Partner> partners, String query, String partnerName) {
    if (query.isEmpty) return partners;
    final lowerQuery = query.toLowerCase();
    return partners
        .where((p) =>
            p.name.toLowerCase().contains(lowerQuery) ||
            partnerName.toLowerCase() == lowerQuery)
        .toList();
  }

  List<dynamic> _filterBanks(
    List<dynamic> banks,
    String query,
  ) {
    if (query.isEmpty) return banks;
    final lowerQuery = query.toLowerCase();
    return banks
        .where((b) => (b['name'] as String).toLowerCase().contains(lowerQuery))
        .toList();
  }

  void _getCameras() async {
    cameras = await availableCameras();
  }

  void _initiatTranx() {
    final checkoutNotifier =
        Provider.of<KCChangeNotifier>(context, listen: false);
    Future.delayed(Duration.zero, () async {
      if (checkoutNotifier.selectedBankFlow != null) {
        _lenderSearchController.text = checkoutNotifier.selectedBankFlow!.name;
      }
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

    final loansToAnybody = activeLoanPartners
        .where((p) =>
            p.metadata?.customerType.toString().toLowerCase() == 'everyone' &&
            p.isAvailable == true &&
            p.isActive == true)
        .toList();

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
                child: CloseViewButton(fromSelectBank: true),
              ),
            ],
          ),
          const YSpace(30.22),
          KCHeadline3('Select a lender'),
          const YSpace(8),
          KCHeadline5(
            'Can’t find your bank? Use Credit Direct to checkout',
            fontSize: 14,
          ),
          KCHeadline5(
            'First ${loansToAnybody.length} below lends to all customers',
            fontSize: 14,
          ),
          const YSpace(16),
          KCLenderSearchDropdown(
            activeLoanPartners: activeLoanPartners,
            selectedBankFlow: checkoutNotfier.selectedBankFlow,
            searchController: _lenderSearchController,
            focusNode: _lenderSearchFocusNode,
            onFilter: _filterPartners,
            onSelect: checkoutNotfier.setBankFlow,
          ),
          // const YSpace(12),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.only(top: 2),
          //       child: SvgPicture.asset(
          //         KCAssets.info,
          //         package: 'klump_checkout',
          //       ),
          //     ),
          //     const XSpace(8),
          //     const Expanded(
          //       child: Text.rich(
          //         TextSpan(
          //           children: [
          //             TextSpan(text: 'Can’t find your bank? Use '),
          //             TextSpan(
          //               text: 'Renmoney ',
          //               style: TextStyle(fontWeight: FontWeight.w800),
          //             ),
          //             TextSpan(text: 'or '),
          //             TextSpan(
          //               text: 'CDL ',
          //               style: TextStyle(fontWeight: FontWeight.w800),
          //             ),
          //             TextSpan(text: 'to checkout'),
          //           ],
          //         ),
          //         style: TextStyle(
          //           fontFamily: KCFonts.avenir,
          //           fontSize: 15,
          //           fontWeight: FontWeight.w400,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          if (banks.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 35),
              child: KCBankSearchDropdown(
                banks: banks,
                selectedBank: checkoutNotfier.selectedBank,
                searchController: _bankSearchController,
                focusNode: _bankSearchFocusNode,
                onFilter: _filterBanks,
                onSelect: checkoutNotfier.selectBank,
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
