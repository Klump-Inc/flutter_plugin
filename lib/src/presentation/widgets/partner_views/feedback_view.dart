import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:klump_checkout/src/presentation/change_notifiers/kc_feedback_notifier.dart';
import 'package:provider/provider.dart';

const _feedbackReasons = [
  'I did not see my bank',
  'I changed my mind',
  'I do not understand how this works',
  'I use Opay, Palmpay, Kuda, Moniepoint',
  'Technical Issues',
  'Others',
];

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
  final ValueNotifier<String?> _selectedReason = ValueNotifier(null);

  bool get _canSubmit {
    final selected = _selectedReason.value;
    if (selected == null) return false;
    if (selected == 'Others') {
      return _textCtrl.text.trim().isNotEmpty;
    }
    return true;
  }

  @override
  void initState() {
    _textCtrl = TextEditingController();
    _textCtrl.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _selectedReason.dispose();
    super.dispose();
  }

  void _selectReason(String reason) {
    // Single selection: toggle off if same reason, otherwise select new one
    if (_selectedReason.value == reason) {
      _selectedReason.value = null;
    } else {
      _selectedReason.value = reason;
    }
  }

  String _buildFeedbackText() {
    final selected = _selectedReason.value;
    if (selected == null) return '';
    if (selected == 'Others') {
      return _textCtrl.text.trim();
    }
    return selected;
  }

  void _handleBack() {
    if (widget.params.backButtonClose) {
      const checkoutResponse = KlumpCheckoutResponse(
        CheckoutStatus.error,
        'Transaction unsuccessful',
        null,
      );
      Navigator.pop(context);
      Navigator.pop(context, checkoutResponse);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHeight(context) - 67.48,
      child: Padding(
        padding: EdgeInsets.only(
            left: 26,
            right: 26,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: ChangeNotifierProvider<KCFeedbackNotifier>(
          create: (_) => KCFeedbackNotifier(),
          child: Builder(
            builder: (context) {
              final checkoutNotifier = Provider.of<KCFeedbackNotifier>(context);
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DraggableBar(),
                    const YSpace(30.82),
                    _buildHeader(),
                    const YSpace(24.22),
                    _buildDemoSection(),
                    const YSpace(22),
                    const _DashedDivider(),
                    const YSpace(20),
                    _buildFeedbackSection(checkoutNotifier),
                    const YSpace(24),
                    _buildExitButton(checkoutNotifier),
                    const YSpace(59),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: _handleBack,
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
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: KCHeadline4(
                widget.params.merchant ?? 'Proud partner of Konga.',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const XSpace(30),
      ],
    );
  }

  Widget _buildDemoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KCHeadline3('Not sure how this works?'),
        const YSpace(8),
        KCHeadline5(
          'Watch a 60-second walkthrough of how to complete your purchase.',
          fontSize: 16,
        ),
        const YSpace(16),
        KCPrimaryButton(
          title: 'Watch Demo',
          onTap: () {
            if (KC_DEM0_VIDEO_URL.isNotEmpty) {
              launchUrlExternal(KC_DEM0_VIDEO_URL);
            }
          },
        ),
      ],
    );
  }

  Widget _buildFeedbackSection(KCFeedbackNotifier checkoutNotifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KCHeadline5(
          'Please tell us why you not completing this purchase',
          fontSize: 16,
        ),
        const YSpace(16),
        ValueListenableBuilder<String?>(
          valueListenable: _selectedReason,
          builder: (_, selected, __) {
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _feedbackReasons.map((reason) {
                final isSelected = selected == reason;
                return GestureDetector(
                  onTap: () => _selectReason(reason),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: KCColors.white,
                      border: Border.all(
                        color: isSelected ? KCColors.primary : KCColors.grey1,
                        width: 0.88,
                      ),
                      borderRadius: BorderRadius.circular(4.42),
                    ),
                    child: KCHeadline5(
                      reason,
                      fontSize: 14,
                      color: isSelected ? KCColors.primary : KCColors.black3,
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
        ValueListenableBuilder<String?>(
          valueListenable: _selectedReason,
          builder: (_, selected, __) {
            if (selected != 'Others') return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const YSpace(16),
                KCTextArea(
                  controller: _textCtrl,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildExitButton(KCFeedbackNotifier checkoutNotifier) {
    return ValueListenableBuilder<String?>(
      valueListenable: _selectedReason,
      builder: (_, __, ___) {
        return KCPrimaryButton(
          disabled: checkoutNotifier.isBusy || !_canSubmit,
          loading: checkoutNotifier.isBusy,
          title: 'Exit',
          onTap: () async {
            final feedback = _buildFeedbackText();
            if (feedback.isEmpty) return;

            final response = await checkoutNotifier.submitFeedback(
              feedback: feedback,
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
              if (mounted) {
                Navigator.pop(context);
                Navigator.pop(context, checkoutResponse);
              }
            }
          },
        );
      },
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 1,
      child: CustomPaint(
        painter: _DashedLinePainter(color: KCColors.ash),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;

  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 6;
    const dashSpace = 4;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset((startX + dashWidth).clamp(0.0, size.width), size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FeedbackViewArgument {
  final String email;
  final String phoneNumber;
  final String publicKey;
  final String? merchant;
  final bool isLive;
  final bool backButtonClose;
  final String? demoUrl;

  FeedbackViewArgument({
    required this.email,
    required this.phoneNumber,
    required this.publicKey,
    required this.merchant,
    required this.isLive,
    this.backButtonClose = false,
    this.demoUrl,
  });
}
