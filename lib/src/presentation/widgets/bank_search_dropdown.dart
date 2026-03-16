import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/src/src.dart';

class KCBankSearchDropdown extends StatefulWidget {
  const KCBankSearchDropdown({
    super.key,
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
  State<KCBankSearchDropdown> createState() => _KCBankSearchDropdownState();
}

class _KCBankSearchDropdownState extends State<KCBankSearchDropdown> {
  @override
  void didUpdateWidget(covariant KCBankSearchDropdown oldWidget) {
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
