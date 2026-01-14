import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class WalletLoading extends StatefulWidget {
  const WalletLoading({super.key, required this.initiateResponse});
  final InitiateResponseModel initiateResponse;

  @override
  State<WalletLoading> createState() => _WalletLoadingState();
}

class _WalletLoadingState extends State<WalletLoading> {
  @override
  void initState() {
    super.initState();
    final changeNotifier =
        Provider.of<KCChangeNotifier>(context, listen: false);
    Future.delayed(const Duration(seconds: 5), () {
      changeNotifier.nextPage();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 116,
                          width: 116,
                          child: CircularPercentIndicator(
                            radius: 58,
                            lineWidth: 7.5,
                            animation: true,
                            restartAnimation: true,
                            percent: 1,
                            startAngle: 180,
                            animationDuration: 60 * 30,
                            circularStrokeCap: CircularStrokeCap.round,
                            backgroundColor: Colors.transparent,
                            progressColor: KCColors.blue,
                            center: Container(
                              height: 86.57,
                              width: 86.57,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: KCColors.blue
                                    .withAlpha((0.10 * 255).round()),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  KCAssets.secureCredit,
                                  package: KC_PACKAGE_NAME,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const YSpace(24),
                        KCHeadline2('Hang on!'),
                      ],
                    ),
                  ),
                  const YSpace(50),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
