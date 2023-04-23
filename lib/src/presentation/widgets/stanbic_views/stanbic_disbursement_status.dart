import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/src/src.dart';

class StanbicDisbursementStatus extends StatefulWidget {
  const StanbicDisbursementStatus({super.key});

  @override
  State<StanbicDisbursementStatus> createState() =>
      _StanbicDisbursementStatusState();
}

class _StanbicDisbursementStatusState extends State<StanbicDisbursementStatus> {
  final responseStatus = true;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
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
                      package: KC_PACKAGE_NAME,
                    ),
                    const YSpace(24),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 187.1,
                            width: 187.1,
                            child: SvgPicture.asset(
                              responseStatus
                                  ? KCAssets.successIllus
                                  : KCAssets.failureIllus,
                              package: KC_PACKAGE_NAME,
                            ),
                          ),
                          const YSpace(22),
                          KCHeadline3(
                            responseStatus ? 'Successful' : 'Unsuccessful',
                            fontSize: 27,
                            textAlign: TextAlign.center,
                            height: 1.4318,
                          ),
                          const YSpace(8),
                          KCBodyText1(
                            responseStatus
                                ? 'Loan disburse successful \nYour next pay date is March 3, 2022'
                                : 'We couldn’t verify your documents, please re-upload or email support@useklump.com',
                            fontSize: 16,
                            textAlign: TextAlign.center,
                            height: 1.36625,
                          ),
                        ],
                      ),
                    ),
                    const YSpace(24),
                    KCPrimaryButton(
                      title: responseStatus ? 'Continue' : 'Go back',
                      onTap: () => Navigator.pop(context),
                    ),
                    const YSpace(59)
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
