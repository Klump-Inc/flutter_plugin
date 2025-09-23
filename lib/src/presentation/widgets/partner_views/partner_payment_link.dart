import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klump_checkout/src/presentation/presentation.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PartnerPaymemtLink extends StatefulWidget {
  const PartnerPaymemtLink({super.key});

  @override
  State<PartnerPaymemtLink> createState() => _PartnerPaymemtLinkState();
}

class _PartnerPaymemtLinkState extends State<PartnerPaymemtLink> {
  late WebViewController _webViewController;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final checkoutNotifier =
        Provider.of<KCChangeNotifier>(context, listen: false);
    final stepData = checkoutNotifier.paymentLinkData?.nextStep;
    final redirectUrl = stepData?.redirectUrl;
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                setState(() {
                  _loading = false;
                });
              }
            });
          },
          onPageFinished: (String url) {
            Logger().d("Finished");
          },
          onHttpError: (HttpResponseError error) {
            Logger().d("Error");
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            Logger().d(request.url);
            Logger().d(request.isMainFrame);
            if (request.url.contains('status=successful') &&
                request.url.contains('processor=paystack') &&
                request.url.contains('trxref')) {
              checkoutNotifier.nextPage();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(redirectUrl ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: [
            WebViewWidget(
              controller: _webViewController,
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{}
                ..add(
                  Factory<TapGestureRecognizer>(
                    () => TapGestureRecognizer()
                      ..onTapDown = (tap) {
                        SystemChannels.textInput.invokeMethod(
                            'TextInput.hide'); //This will hide keyboard on tapdown
                      },
                  ),
                ),
            ),
            if (_loading)
              Center(
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: Platform.isIOS
                      ? const CupertinoActivityIndicator(
                          radius: 15.0,
                          color: Colors.black,
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 3,
                          ),
                        ),
                ),
              ),
          ],
        );
      },
    );
  }
}
