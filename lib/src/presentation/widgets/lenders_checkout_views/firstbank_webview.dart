import 'package:flutter/material.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FirstbankWebview extends StatefulWidget {
  const FirstbankWebview({super.key});

  @override
  State<FirstbankWebview> createState() => _FirstbankWebviewState();
}

class _FirstbankWebviewState extends State<FirstbankWebview> {
  late WebViewController _webViewController;
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    final lendersNotifier = context.read<KCLendersNotifier>();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            setState(() {
              _loading = false;
            });
          },
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..addJavaScriptChannel(
        'FlutterOnClose',
        onMessageReceived: (JavaScriptMessage message) {
          showFeedbackModal();
        },
      )
      ..addJavaScriptChannel(
        'FlutterOnError',
        onMessageReceived: (JavaScriptMessage message) {
          showFeedbackModal();
        },
      )
      ..addJavaScriptChannel(
        'FlutterOnSuccess',
        onMessageReceived: (JavaScriptMessage message) {
          lendersNotifier.nextPage();
        },
      );
    _webViewController.loadRequest(Uri.parse(
        lendersNotifier.redirectStepData?.nextStep.mobileCheckoutUrl ?? ''));
  }

  void showFeedbackModal() {
    final lendersNotifier = context.read<KCLendersNotifier>();
    showModalBottomSheet<void>(
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      context: context,
      backgroundColor: KCColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(9.92367),
          topRight: Radius.circular(9.92367),
        ),
      ),
      builder: (context) => FeedbackView(
        params: FeedbackViewArgument(
          email: lendersNotifier.email ?? '',
          phoneNumber: lendersNotifier.phoneNumber ?? '',
          publicKey: lendersNotifier.checkoutData!.merchantPublicKey,
          merchant: lendersNotifier.initiateResponse?.merchant,
          isLive: lendersNotifier.initiateResponse?.isLive == true,
          backButtonClose: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lendersNotifier = context.read<KCLendersNotifier>();

    Logger()
        .d(lendersNotifier.redirectStepData?.nextStep.mobileCheckoutUrl ?? '');
    return _loading
        ? const Center(
            child: KCPageLoaderWidget(),
          )
        : WebViewWidget(controller: _webViewController);
  }
}
