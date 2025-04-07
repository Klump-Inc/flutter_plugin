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
          checkoutNotfier.setWebViewFailed();
          checkoutNotfier.nextPage();
        },
      )
      ..addJavaScriptChannel(
        'FlutterOnError',
        onMessageReceived: (JavaScriptMessage message) {
          checkoutNotfier.setWebViewFailed();
          checkoutNotfier.nextPage();
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

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(
            child: KCPageLoaderWidget(),
          )
        : WebViewWidget(controller: _webViewController);
  }
}
