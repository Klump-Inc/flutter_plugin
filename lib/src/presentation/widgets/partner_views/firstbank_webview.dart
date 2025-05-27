import 'package:flutter/material.dart';
import 'package:klump_checkout/klump_checkout.dart';
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
    final checkoutNotfier = context.read<KCChangeNotifier>();
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
          checkoutNotfier.nextPage();
        },
      );

    _webViewController.loadRequest(Uri.parse(
        checkoutNotfier.redirectStepData?.nextStep.mobileCheckoutUrl ?? ''));
  }

  void showFeedbackModal() {
    final checkoutNotifier = context.read<KCChangeNotifier>();
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
          email: checkoutNotifier.email ?? '',
          phoneNumber: checkoutNotifier.phoneNumber ?? '',
          publicKey: checkoutNotifier.checkoutData!.merchantPublicKey,
          merchant: checkoutNotifier.initiateResponse?.merchant,
          isLive: checkoutNotifier.initiateResponse?.isLive == true,
          backButtonClose: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(
            child: KCPageLoaderWidget(),
          )
        : WebViewWidget(controller: _webViewController);
  }
}
