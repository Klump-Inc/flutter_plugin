import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class StanbicDecision extends StatefulWidget {
  const StanbicDecision({super.key});

  @override
  State<StanbicDecision> createState() => _StanbicDecisionState();
}

class _StanbicDecisionState extends State<StanbicDecision> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      Provider.of<KCChangeNotifier>(context, listen: false).nextPage();
    });
    super.initState();
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
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Column(
                children: [
                  const YSpace(32.59),
                  Image.asset(
                    KCAssets.stanbicLogo,
                    height: 55,
                    width: 47,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                            animationDuration: 60 * 10,
                            circularStrokeCap: CircularStrokeCap.round,
                            backgroundColor: Colors.transparent,
                            progressColor: KCColors.blue,
                            center: Container(
                              height: 86.57,
                              width: 86.57,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: KCColors.blue.withOpacity(0.10),
                              ),
                              child: Center(
                                child: SvgPicture.asset(KCAssets.secureCredit),
                              ),
                            ),
                          ),
                        ),
                        const YSpace(24),
                        KCHeadline2('Hang on!'),
                        const YSpace(8),
                        const Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text:
                                      'Please wait, while we run you \nthrough our decision engine. This \nmay take up to '),
                              TextSpan(
                                text: '2 minutes',
                                style: TextStyle(fontWeight: FontWeight.w800),
                              )
                            ],
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            color: KCColors.black3,
                            fontFamily: KCFonts.avenir,
                            fontWeight: FontWeight.w400,
                            height: 1.875,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const YSpace(59)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
