import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:klump_checkout/src/core/core.dart';
import 'package:klump_checkout/src/presentation/presentation.dart';
import 'package:provider/provider.dart';

class PartnerDocumentType extends StatefulWidget {
  const PartnerDocumentType({super.key});

  @override
  State<PartnerDocumentType> createState() => _PartnerDocumentTypeState();
}

class _PartnerDocumentTypeState extends State<PartnerDocumentType> {
  @override
  Widget build(BuildContext context) {
    final checkoutNotfier = Provider.of<KCChangeNotifier>(context);
    final stepData = checkoutNotfier.documentVerificationStepData?.nextStep ??
        checkoutNotfier.selectedBankFlow?.nextStep;
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
                padding: EdgeInsets.only(
                    left: 26,
                    right: 26,
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const YSpace(30.82),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: checkoutNotfier.prevPage,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: SvgPicture.asset(
                            KCAssets.arrowBack,
                            package: KC_PACKAGE_NAME,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      child: Image.network(
                        checkoutNotfier.selectedBankFlow?.logo ?? '',
                        height: 40,
                        width: 120,
                      ),
                    ),
                    if (checkoutNotfier.initiateResponse?.merchant != null)
                      Align(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: KCHeadline4(
                            checkoutNotfier.initiateResponse!.merchant
                                .toString(),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    const YSpace(16),
                    if (stepData?.displayData?.title != null)
                      KCHeadline3(
                        stepData?.displayData?.title ?? '',
                        fontSize: 20,
                      ),
                    if (stepData?.displayData?.subTitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child:
                            KCHeadline5(stepData?.displayData?.subTitle ?? ''),
                      ),
                    const YSpace(16),
                    DocumentTypeButton(
                      image: KCAssets.intlPassport,
                      title: 'Passport',
                      onTap: () {
                        checkoutNotfier.selectDocumentType(
                          INTERNATIONAL_PASSPORT,
                        );
                      },
                    ),
                    DocumentTypeButton(
                      image: KCAssets.ninCard,
                      title: 'National Identity Card',
                      onTap: () {
                        checkoutNotfier.selectDocumentType(
                          NATIONAL_ID_CARD,
                        );
                      },
                    ),
                    DocumentTypeButton(
                      image: KCAssets.votersCard,
                      title: 'Voter’s Card',
                      onTap: () {
                        checkoutNotfier.selectDocumentType(
                          VOTERS_CARD,
                        );
                      },
                    ),
                    DocumentTypeButton(
                      image: KCAssets.driversLicense,
                      title: 'Driver’s License',
                      onTap: () {
                        checkoutNotfier.selectDocumentType(
                          DRIVER_LICENSE,
                        );
                      },
                    ),
                    const YSpace(25),
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

class DocumentTypeButton extends StatelessWidget {
  const DocumentTypeButton({
    super.key,
    required this.image,
    required this.title,
    required this.onTap,
  });

  final String image;
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color: KCColors.grey1,
            width: 0.7,
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              image,
              width: 48,
              height: 30,
              package: KC_PACKAGE_NAME,
            ),
            const XSpace(16),
            KCHeadline5(
              title,
              fontSize: 14,
            )
          ],
        ),
      ),
    );
  }
}
