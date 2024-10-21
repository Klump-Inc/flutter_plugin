import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klump_checkout/src/core/core.dart';
import 'package:klump_checkout/src/presentation/widgets/widgets.dart';

class KCDropdownInput extends StatelessWidget {
  const KCDropdownInput({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onSelected,
    required this.minWidth,
  });

  final String label;
  final List<String> items;
  final String? value;
  final void Function(String)? onSelected;
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      enabled: true,
      constraints: BoxConstraints(
        minWidth: minWidth,
        maxHeight: 250,
      ),
      padding: EdgeInsets.zero,
      elevation: 1,
      offset: const Offset(0, 54),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(
          horizontal: 16.11,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          border: Border.all(
              color: value == null
                  ? KCColors.grey1
                  : Colors.green.withOpacity(0.50)),
          borderRadius: BorderRadius.circular(4.4186),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (value == null)
              Expanded(
                child: KCBodyText1(
                  label,
                  color: KCColors.grey2,
                  fontSize: 15,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            else
              Expanded(
                child: KCBodyText1(
                  value!.capitalize(),
                  fontSize: 15,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
          items.length,
          (index) {
            return PopupMenuItem<String>(
              height: 0,
              padding: EdgeInsets.zero,
              child: KCPopupMenuItemContent(
                title: items[index].capitalize(),
                withBG: index % 2 == 0,
              ),
              onTap: () {
                onSelected!.call(items[index]);
              },
            );
          },
        );
      },
    );
  }
}

class KCPopupMenuItemContent extends StatelessWidget {
  const KCPopupMenuItemContent({
    super.key,
    required this.title,
    this.withBG = false,
  });

  final String title;
  final bool withBG;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49,
      color: withBG ? KCColors.grey3.withOpacity(0.15) : null,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: KCBodyText1(
          title,
        ),
      ),
    );
  }
}
