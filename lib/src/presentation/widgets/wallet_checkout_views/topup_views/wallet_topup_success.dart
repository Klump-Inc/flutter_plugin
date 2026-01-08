import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:provider/provider.dart';

class WalletTopupSuccess extends StatefulWidget {
  const WalletTopupSuccess({super.key, required this.initiateResponse});
  final InitiateResponseModel initiateResponse;

  @override
  State<WalletTopupSuccess> createState() => _WalletTopupSuccessState();
}

class _WalletTopupSuccessState extends State<WalletTopupSuccess> {
  @override
  Widget build(BuildContext context) {
    final topupNotifier = Provider.of<KCTopupNotifier>(context);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: constraints.maxWidth,
            minHeight: constraints.maxHeight,
          ),
          child: IntrinsicHeight(
            child: Padding(
              padding: EdgeInsets.only(
                  left: 26,
                  right: 26,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const DraggableBar(),
                  const YSpace(30.82),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 30),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            KCAssets.klumpLogo,
                            package: 'klump_checkout',
                          ),
                          if (widget.initiateResponse.merchant != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text.rich(
                                TextSpan(children: [
                                  const TextSpan(text: 'Proud partner of '),
                                  TextSpan(
                                      text: widget.initiateResponse.merchant
                                          .toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700)),
                                ]),
                                style: const TextStyle(
                                  color: KCColors.black1,
                                  fontSize: 16,
                                  fontFamily: KCFonts.avenir,
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
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          KCAssets.successIllus,
                          package: KC_PACKAGE_NAME,
                        ),
                        const YSpace(24),
                        KCBodyText1(
                          'The amount has been added \nto your wallet',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: KCColors.black3,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const YSpace(50),
                  KCPrimaryButton(
                    title: 'Complete checkout',
                    disabled: topupNotifier.isBusy,
                    loading: topupNotifier.isBusy,
                    onTap: () {
                      // Handle topup completion
                      Navigator.pop(context);
                    },
                  ),
                  const YSpace(16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
