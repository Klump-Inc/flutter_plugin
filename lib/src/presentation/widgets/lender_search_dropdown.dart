import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klump_checkout/src/src.dart';

class KCLenderSearchDropdown extends StatefulWidget {
  const KCLenderSearchDropdown({
    super.key,
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
  State<KCLenderSearchDropdown> createState() => _KCLenderSearchDropdownState();
}

class _KCLenderSearchDropdownState extends State<KCLenderSearchDropdown> {
  @override
  void didUpdateWidget(covariant KCLenderSearchDropdown oldWidget) {
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
    bool isActive(Partner p) =>
        p.isActive == true && p.isActiveForMobile == true;
    final loansToAnybody = filteredPartners
        .where((p) =>
            p.metadata?.customerType.toString().toLowerCase() == 'everyone')
        .toList()
      ..sort((a, b) {
        final aActive = isActive(a);
        final bActive = isActive(b);
        return aActive == bActive ? 0 : (aActive ? -1 : 1);
      });
    final loansToCustomersOnly = filteredPartners
        .where((p) =>
            p.metadata?.customerType.toString().toLowerCase() ==
            'its customers')
        .toList()
      ..sort((a, b) {
        final aActive = isActive(a);
        final bActive = isActive(b);
        return aActive == bActive ? 0 : (aActive ? -1 : 1);
      });

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
                          if (partner.isActive == true &&
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
                          isActive: partner.isActive == true &&
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
                          if (partner.isActive == true &&
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
                          isActive: partner.isActive == true &&
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
