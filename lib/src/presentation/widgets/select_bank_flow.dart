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
          KCHeadline3('Select a lender'),
          const YSpace(8),
          KCHeadline5(
            'Can’t find your bank? Use Credit Direct to checkout',
            fontSize: 14,
          ),
          const YSpace(16),
          _LenderSearchDropdown(
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
              child: _BankSearchDropdown(
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

class _LenderSearchDropdown extends StatefulWidget {
  const _LenderSearchDropdown({
    required this.activeLoanPartners,
    required this.selectedBankFlow,
    required this.searchController,
    required this.focusNode,
    required this.onFilter,
    required this.onSelect,
  });

  final List<Partner> activeLoanPartners;
  final Partner? selectedBankFlow;
  final TextEditingController searchController;
  final FocusNode focusNode;
  final List<Partner> Function(
      List<Partner> partners, String query, String partnerName) onFilter;
  final void Function(Partner) onSelect;

  @override
  State<_LenderSearchDropdown> createState() => _LenderSearchDropdownState();
}

class _LenderSearchDropdownState extends State<_LenderSearchDropdown> {
  @override
  void didUpdateWidget(covariant _LenderSearchDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedBankFlow != null &&
        widget.selectedBankFlow != oldWidget.selectedBankFlow) {
      widget.searchController.text = widget.selectedBankFlow!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final showDropdown =
        widget.selectedBankFlow == null || widget.focusNode.hasFocus;
    final searchQuery =
        widget.focusNode.hasFocus ? widget.searchController.text : '';
    final filteredPartners = widget.onFilter(
      widget.activeLoanPartners,
      searchQuery,
      widget.selectedBankFlow?.name ?? '',
    );
    final loansToAnybody = filteredPartners
        .where((p) =>
            p.metadata?.customerType.toString().toLowerCase() == 'everyone')
        .toList();
    final loansToCustomersOnly = filteredPartners
        .where((p) =>
            p.metadata?.customerType.toString().toLowerCase() ==
            'its customers')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(color: KCColors.grey1),
            borderRadius: BorderRadius.circular(4.4186),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.searchController,
                  focusNode: widget.focusNode,
                  enabled: widget.activeLoanPartners.isNotEmpty,
                  onChanged: (_) => setState(() {}),
                  onTapOutside: (_) {
                    widget.focusNode.unfocus();
                  },
                  style: const TextStyle(
                    color: KCColors.black3,
                    fontSize: 15,
                    fontFamily: KCFonts.avenir,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Search by name',
                    hintStyle: TextStyle(
                      color: KCColors.grey2,
                      fontSize: 15,
                      fontFamily: KCFonts.avenir,
                      fontWeight: FontWeight.w400,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.11,
                      vertical: 16,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12, top: 2),
                child: SvgPicture.asset(
                  KCAssets.caretDown,
                  package: KC_PACKAGE_NAME,
                ),
              ),
            ],
          ),
        ),
        if (showDropdown && widget.activeLoanPartners.isNotEmpty) ...[
          const YSpace(8),
          TextFieldTapRegion(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 300),
              decoration: BoxDecoration(
                border: Border.all(color: KCColors.grey1),
                borderRadius: BorderRadius.circular(4.4186),
                color: Colors.white,
              ),
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  if (loansToAnybody.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: KCBodyText1(
                        'Loans to anybody',
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    ...loansToAnybody.asMap().entries.map((entry) {
                      final partner = entry.value;
                      return GestureDetector(
                        onTap: () {
                          if (partner.isActive &&
                              partner.isActiveForMobile == true) {
                            widget.onSelect(partner);
                            widget.searchController.text = partner.name;
                            widget.focusNode.unfocus();
                          }
                        },
                        child: KCPartnerPopupMenuItemContent(
                          title: partner.name,
                          logo: partner.logo,
                          // withBG: entry.key % 2 == 0,
                          isActive: partner.isActive &&
                              partner.isActiveForMobile == true,
                          message: partner.metadata?.dropdownMessage,
                        ),
                      );
                    }),
                  ],
                  if (loansToCustomersOnly.isNotEmpty &&
                      loansToAnybody.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      height: 0.75,
                      width: double.infinity,
                      color: KCColors.grey8,
                    ),
                  if (loansToCustomersOnly.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: KCBodyText1(
                        'Loans to only their customers',
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    ...loansToCustomersOnly.asMap().entries.map((entry) {
                      final partner = entry.value;
                      return GestureDetector(
                        onTap: () {
                          if (partner.isActive &&
                              partner.isActiveForMobile == true) {
                            widget.onSelect(partner);
                            widget.searchController.text = partner.name;
                            widget.focusNode.unfocus();
                          }
                        },
                        child: KCPartnerPopupMenuItemContent(
                          title: partner.name,
                          logo: partner.logo,
                          // withBG: entry.key % 2 == 0,
                          isActive: partner.isActive &&
                              partner.isActiveForMobile == true,
                          message: partner.metadata?.dropdownMessage,
                        ),
                      );
                    }),
                  ],
                  if (filteredPartners.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: KCBodyText1(
                        'No lenders found',
                        color: KCColors.grey4,
                        fontSize: 14,
                      ),
                    ),
                  Container(
                    height: 49,
                    color: KCColors.grey3.withAlpha((0.30 * 255).toInt()),
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
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _BankSearchDropdown extends StatefulWidget {
  const _BankSearchDropdown({
    required this.banks,
    required this.selectedBank,
    required this.searchController,
    required this.focusNode,
    required this.onFilter,
    required this.onSelect,
  });

  final List<dynamic> banks;
  final Map<String, dynamic>? selectedBank;
  final TextEditingController searchController;
  final FocusNode focusNode;
  final List<dynamic> Function(List<dynamic> banks, String query) onFilter;
  final void Function(Map<String, dynamic>) onSelect;

  @override
  State<_BankSearchDropdown> createState() => _BankSearchDropdownState();
}

class _BankSearchDropdownState extends State<_BankSearchDropdown> {
  @override
  void didUpdateWidget(covariant _BankSearchDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedBank != null &&
        widget.selectedBank != oldWidget.selectedBank) {
      widget.searchController.text =
          widget.selectedBank!['name'] as String? ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final showDropdown =
        widget.selectedBank == null || widget.focusNode.hasFocus;
    final searchQuery =
        widget.focusNode.hasFocus ? widget.searchController.text : '';
    final filteredBanks = widget.onFilter(widget.banks, searchQuery);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(color: KCColors.grey1),
            borderRadius: BorderRadius.circular(4.4186),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.searchController,
                  focusNode: widget.focusNode,
                  onChanged: (_) => setState(() {}),
                  onTapOutside: (_) => widget.focusNode.unfocus(),
                  style: const TextStyle(
                    color: KCColors.black3,
                    fontSize: 15,
                    fontFamily: KCFonts.avenir,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Search by name',
                    hintStyle: TextStyle(
                      color: KCColors.grey2,
                      fontSize: 15,
                      fontFamily: KCFonts.avenir,
                      fontWeight: FontWeight.w400,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.11,
                      vertical: 16,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12, top: 2),
                child: SvgPicture.asset(
                  KCAssets.caretDown,
                  package: KC_PACKAGE_NAME,
                ),
              ),
            ],
          ),
        ),
        if (showDropdown) ...[
          const YSpace(8),
          TextFieldTapRegion(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 250),
              decoration: BoxDecoration(
                border: Border.all(color: KCColors.grey1),
                borderRadius: BorderRadius.circular(4.4186),
                color: Colors.white,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: filteredBanks.isEmpty ? 1 : filteredBanks.length,
                itemBuilder: (context, index) {
                  if (filteredBanks.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: KCBodyText1(
                        'No banks found',
                        color: KCColors.grey4,
                        fontSize: 14,
                      ),
                    );
                  }
                  final bank = filteredBanks[index] as Map<String, dynamic>;
                  return GestureDetector(
                    onTap: () {
                      widget.onSelect(bank);
                      widget.searchController.text =
                          bank['name'] as String? ?? '';
                      widget.focusNode.unfocus();
                    },
                    child: KCBankPopupMenuItemContent(
                      title: bank['name'] as String? ?? '',
                      withBG: index % 2 == 0,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ],
    );
  }
}
