import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:provider/provider.dart';

class WemaIllustration extends StatefulWidget {
  const WemaIllustration({super.key});

  @override
  State<WemaIllustration> createState() => _WemaIllustrationState();
}

class _WemaIllustrationState extends State<WemaIllustration> {
  late PageController _pageController;

  Timer? _timer;
  final ValueNotifier<int> _currentPage = ValueNotifier(0);

  void _startAutoScoll() {
    _timer = Timer.periodic(
      const Duration(seconds: 15),
      (Timer t) {
        if (_currentPage.value < 5) {
          _currentPage.value++;
        } else {
          _currentPage.value = 0;
        }
        _pageController.animateToPage(
          _currentPage.value,
          duration: const Duration(milliseconds: 500),
          curve: Curves.linear,
        );
      },
    );
  }

  @override
  void initState() {
    _pageController = PageController();
    Future.delayed(Duration.zero, _startAutoScoll);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lendersNotifier = Provider.of<KCLendersNotifier>(context);
    final stepData = lendersNotifier.redirectStepData?.nextStep ??
        lendersNotifier.selectedBankFlow?.nextStep;
    final carousel = stepData?.displayData?.carousel
        ?.map((e) => e as Map<String, dynamic>)
        .toList();
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
                    left: 16,
                    right: 16,
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  children: [
                    const YSpace(20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: lendersNotifier.prevPage,
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: SvgPicture.asset(
                                KCAssets.arrowBack,
                                package: KC_PACKAGE_NAME,
                              ),
                            ),
                          ),
                          KCNetworkImage(
                            url: lendersNotifier.selectedBankFlow!.logo,
                            height: 55,
                            width: 120,
                          ),
                          const SizedBox(width: 30),
                        ],
                      ),
                    ),
                    if (lendersNotifier.initiateResponse?.merchant != null)
                      KCHeadline4(
                        lendersNotifier.initiateResponse!.merchant.toString(),
                        fontWeight: FontWeight.w700,
                      ),
                    const YSpace(22.15),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: KCHeadline3(
                        stepData?.displayData?.title ?? '',
                      ),
                    ),
                    if (stepData?.displayData?.subTitle != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: KCHeadline5(
                            stepData?.displayData?.subTitle ?? '',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    const YSpace(16),
                    if (carousel != null)
                      SizedBox(
                        height: 267,
                        child: PageView(
                          allowImplicitScrolling: true,
                          scrollDirection: Axis.horizontal,
                          controller: _pageController,
                          onPageChanged: (page) {
                            _currentPage.value = page;
                          },
                          children: carousel
                              .map((e) => KCNetworkImage(
                                    url: e['url'],
                                    fit: BoxFit.fitWidth,
                                    height: null,
                                    width: null,
                                  ))
                              .toList(),
                        ),
                      ),
                    const YSpace(16),
                    if (carousel != null)
                      ValueListenableBuilder<int>(
                          valueListenable: _currentPage,
                          builder: (_, currentPage, __) {
                            return Column(
                              children: [
                                KCBodyText1(
                                  carousel[currentPage]['title'].toString(),
                                  fontWeight: FontWeight.w500,
                                ),
                                const YSpace(12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:
                                      List.generate(carousel.length, (index) {
                                    return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      height: 8,
                                      width: 8,
                                      decoration: BoxDecoration(
                                        color: index == currentPage
                                            ? KCColors.primary
                                            : KCColors.primary
                                                .withOpacity(0.20),
                                        shape: BoxShape.circle,
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            );
                          }),
                    const Spacer(),
                    const YSpace(23),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: KCPrimaryButton(
                        title: 'Complete payment',
                        disabled: lendersNotifier.isBusy,
                        loading: lendersNotifier.isBusy,
                        onTap: () {
                          lendersNotifier.wemaRedirect();
                        },
                      ),
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

class WemaIllusItem {
  final String text;
  final String image;

  WemaIllusItem({
    required this.text,
    required this.image,
  });
}
