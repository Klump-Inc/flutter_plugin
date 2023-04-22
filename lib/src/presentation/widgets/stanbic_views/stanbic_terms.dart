import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/src/src.dart';
import 'package:provider/provider.dart';

class StanbicTerms extends StatefulWidget {
  const StanbicTerms({super.key});

  @override
  State<StanbicTerms> createState() => _StanbicTermsState();
}

class _StanbicTermsState extends State<StanbicTerms> {
  final ValueNotifier<bool> _accepted = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final checkoutNotfier = Provider.of<KCChangeNotifier>(context);
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const YSpace(30.82),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: checkoutNotfier.prevPage,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: SvgPicture.asset(KCAssets.arrowBack),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2.6),
                        child: Image.asset(
                          KCAssets.stanbicLogo,
                          height: 45,
                          width: 38.45,
                        ),
                      ),
                      const XSpace(24)
                    ],
                  ),
                  const YSpace(22),
                  KCHeadline3(
                    'Read and agree to the terms of service to continue',
                    fontSize: 15,
                  ),
                  const YSpace(8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: KCBodyText1(
                        'Lorem ipsum dolor sit amet consectetur. Varius pellentesque odio arcu mauris. Varius lectus tempor netus a. Lorem est donec ut pharetra proin sit. Condimentum adipiscing consectetur fringilla eget convallis augue. Interdum accumsan enim eu dolor tortor magna. Proin tellus enim lorem tincidunt. Velit mi ut habitant erat etiam vulputate tristique nunc. A pretium lorem nisl quis. Eu interdum cursus blandit morbi vitae gravida laoreet eu. Elementum quis adipiscing odio pretium risus elementum commodo tincidunt. Dictumst magna quam elit consectetur egestas turpis. Diam varius gravida a pharetra ultricies. Morbi tincidunt posuere nam suscipit lacinia. In pellentesque nunc pellentesque tempor eget. Sed egestas adipiscing mi eget. Malesuada at duis et arcu amet eu consequat at suspendisse. Lorem ipsum dolor sit amet consectetur. Varius pellentesque odio arcu mauris. Varius lectus tempor netus a. Lorem est donec ut pharetra proin sit. Condimentum adipiscing consectetur fringilla eget convallis augue. Interdum accumsan enim eu dolor tortor magna. Proin tellus enim lorem tincidunt. Velit mi ut habitant erat etiam vulputate tristique nunc. A pretium lorem nisl quis. Eu interdum cursus blandit morbi vitae gravida laoreet eu. Elementum quis adipiscing odio pretium risus elementum commodo tincidunt. Dictumst magna quam elit consectetur egestas turpis. Diam varius gravida a pharetra ultricies. Morbi tincidunt posuere nam suscipit lacinia. In pellentesque nunc pellentesque tempor eget. Sed egestas adipiscing mi eget. Malesuada at duis et arcu amet eu consequat at suspendisse.',
                        fontSize: 15,
                        height: 1.4666,
                      ),
                    ),
                  ),
                  const YSpace(24),
                  Row(
                    children: [
                      SizedBox(
                        height: 16,
                        width: 16,
                        child: ValueListenableBuilder<bool>(
                          valueListenable: _accepted,
                          builder: (_, accepted, __) {
                            return Checkbox(
                              value: accepted,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
                              onChanged: (value) {
                                _accepted.value = value ?? false;
                              },
                              fillColor:
                                  MaterialStateProperty.all(KCColors.primary),
                            );
                          },
                        ),
                      ),
                      const XSpace(10.5),
                      const Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'I agree to this according to Klump’s ',
                              ),
                              TextSpan(
                                text: 'Customer Agreement',
                                style: TextStyle(
                                  color: KCColors.black3,
                                  fontWeight: FontWeight.w800,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(text: ' and'),
                              TextSpan(
                                text: ' Terms and Conditions',
                                style: TextStyle(
                                  color: KCColors.black3,
                                  fontWeight: FontWeight.w800,
                                  decoration: TextDecoration.underline,
                                ),
                              )
                            ],
                          ),
                          style: TextStyle(
                            color: KCColors.grey5,
                            fontSize: 11,
                            height: 1.818,
                            fontFamily: KCFonts.avenir,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    ],
                  ),
                  const YSpace(24),
                  ValueListenableBuilder<bool>(
                    valueListenable: _accepted,
                    builder: (_, accepted, __) {
                      return KCPrimaryButton(
                        title: 'Continue',
                        disabled: !accepted,
                        onTap: () => Provider.of<KCChangeNotifier>(context,
                                listen: false)
                            .nextPage(),
                      );
                    },
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
