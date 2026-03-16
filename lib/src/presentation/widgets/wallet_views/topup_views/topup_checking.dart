import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class TopupChecking extends StatefulWidget {
  const TopupChecking({super.key});

  @override
  State<TopupChecking> createState() => _TopupCheckingState();
}

class _TopupCheckingState extends State<TopupChecking> {
  Timer? _pollingTimer;

  static const _pollInterval = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    final topupNotifier = Provider.of<KCTopupNotifier>(context, listen: false);

    _pollingTimer = Timer.periodic(_pollInterval, (_) async {
      final response = await topupNotifier.confirmWallet();
      if (response && mounted) {
        _cancelTimers();
        topupNotifier.nextPage();
      }
    });
  }

  void _cancelTimers() {
    _pollingTimer?.cancel();
  }

  @override
  void dispose() {
    _cancelTimers();
    super.dispose();
  }

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
                          if (topupNotifier.initiateResponse.merchant != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text.rich(
                                TextSpan(children: [
                                  const TextSpan(text: 'Proud partner of '),
                                  TextSpan(
                                      text: topupNotifier
                                          .initiateResponse.merchant
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
