import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klump_checkout/src/src.dart';

class NoBankFoundView extends StatelessWidget {
  const NoBankFoundView({super.key, required this.params});

  final NoBankFoundViewArgument params;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight(context) - 67.48,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DraggableBar(),
            const YSpace(30.82),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: SvgPicture.asset(
                      KCAssets.arrowBack,
                      package: 'klump_checkout',
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      KCAssets.klumpLogo,
                      package: 'klump_checkout',
                    ),
                    if (params.merchant != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Align(
                          child: KCHeadline4(
                            params.merchant.toString(),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    else
                      const YSpace(26),
                  ],
                ),
                const XSpace(30),
              ],
            ),
            const YSpace(24.22),
            KCHeadline3('Don’t see your bank?'),
            const YSpace(8),
            KCHeadline5(
              'You can continue with lenders that work with all banks.',
              fontSize: 16,
            ),
            const YSpace(24),
            const Spacer(),
            KCPrimaryButton(
              title: 'View eligible lenders',
              onTap: () => Navigator.pop(context),
            ),
            const YSpace(16),
            KCSecondaryButton(
              title: 'Exit anyway',
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet<void>(
                  isScrollControlled: true,
                  isDismissible: false,
                  enableDrag: false,
                  context: context,
                  backgroundColor: KCColors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(9.92367),
                      topRight: Radius.circular(9.92367),
                    ),
                  ),
                  builder: (context) => FeedbackView(
                    params: FeedbackViewArgument(
                      email: params.email,
                      phoneNumber: params.phoneNumber,
                      publicKey: params.publicKey,
                      merchant: params.merchant,
                      isLive: params.isLive,
                      backButtonClose: true,
                    ),
                  ),
                );
              },
            ),
            const YSpace(59)
          ],
        ),
      ),
    );
  }
}

class NoBankFoundViewArgument {
  final String email;
  final String phoneNumber;
  final String publicKey;
  final String? merchant;
  final bool isLive;

  NoBankFoundViewArgument({
    required this.email,
    required this.phoneNumber,
    required this.publicKey,
    required this.merchant,
    required this.isLive,
  });
}
