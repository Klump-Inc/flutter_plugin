import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:klump_checkout/src/presentation/change_notifiers/kc_feedback_notifier.dart';
import 'package:provider/provider.dart';

class FeedbackView extends StatefulWidget {
  const FeedbackView({
    super.key,
    required this.params,
  });

  final FeedbackViewArgument params;

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  late TextEditingController _textCtrl;
  final ValueNotifier<bool> _canSubmit = ValueNotifier(false);

  @override
  void initState() {
    _textCtrl = TextEditingController();
    _textCtrl.addListener(_validateInput);
    super.initState();
  }

  void _validateInput() {
    if (_textCtrl.text.trim().isNotEmpty) {
      _canSubmit.value = true;
    } else {
      _canSubmit.value = false;
    }
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight(context) - 67.48,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: ChangeNotifierProvider<KCFeedbackNotifier>(
          create: (_) => KCFeedbackNotifier(),
          child: Builder(builder: (context) {
            final checkoutNotifier = Provider.of<KCFeedbackNotifier>(context);
            return Column(
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
                        if (widget.params.merchant != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Align(
                              child: KCHeadline4(
                                widget.params.merchant.toString(),
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
                KCHeadline3('Sad to see you go 😞'),
                const YSpace(8),
                KCHeadline5(
                  'Please tell us why you aren\'t completing this purchase',
                  fontSize: 16,
                ),
                const YSpace(16),
                TextField(
                  controller: _textCtrl,
                  minLines: 6,
                  maxLines: 8,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: KCFonts.avenir,
                    color: KCColors.black3,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter feedback here',
                    hintStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: KCFonts.avenir,
                      color: KCColors.grey2,
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: KCColors.grey1,
                        width: 0.88,
                      ),
                      borderRadius: BorderRadius.circular(4.42),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: KCColors.grey1,
                        width: 0.88,
                      ),
                      borderRadius: BorderRadius.circular(4.42),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: KCColors.grey1,
                        width: 0.88,
                      ),
                      borderRadius: BorderRadius.circular(4.42),
                    ),
                  ),
                ),
                const YSpace(12),
                const YSpace(32),
                const Spacer(),
                ValueListenableBuilder(
                  valueListenable: _canSubmit,
                  builder: (_, canSubmit, __) {
                    return KCPrimaryButton(
                      disabled: checkoutNotifier.isBusy || !canSubmit,
                      loading: checkoutNotifier.isBusy,
                      title: 'Continue',
                      onTap: () async {
                        final response = await checkoutNotifier.submitFeedback(
                          feedback: _textCtrl.text.trim(),
                          publicKey: widget.params.publicKey,
                          email: widget.params.email,
                          phoneNumber: widget.params.phoneNumber,
                          isLive: widget.params.isLive,
                        );
                        if (context.mounted) {
                          final checkoutResponse = KlumpCheckoutResponse(
                            CheckoutStatus.error,
                            response ?? 'Transaction unsuccessful',
                            null,
                          );
                          Navigator.pop(context);
                          Navigator.pop(context, checkoutResponse);
                        }
                      },
                    );
                  },
                ),
                const YSpace(59)
              ],
            );
          }),
        ),
      ),
    );
  }
}

class FeedbackViewArgument {
  final String email;
  final String phoneNumber;
  final String publicKey;
  final String? merchant;
  final bool isLive;

  FeedbackViewArgument({
    required this.email,
    required this.phoneNumber,
    required this.publicKey,
    required this.merchant,
    required this.isLive,
  });
}
