import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:klump_checkout/src/core/constant/colors.dart';
import 'package:klump_checkout/src/core/utils/util.dart';
import 'package:logger/logger.dart';

class KlumpWebview extends StatefulWidget {
  ///
  /// [KlumpWebview] - the actual payment webview that renders the checkout widget.
  ///

  final String pubilcKey;
  final KlumpCheckoutData data;
  const KlumpWebview({
    Key? key,
    required this.pubilcKey,
    required this.data,
  }) : super(key: key);

  @override
  KlumpWebviewState createState() => KlumpWebviewState();
}

class KlumpWebviewState extends State<KlumpWebview> {
  bool isLoading = true;
  late String _htmlContent;
  KlumpCheckoutResponse? _response;
  @override
  void initState() {
    super.initState();
    _htmlContent = genereteWebPage(widget.pubilcKey, widget.data);
  }

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  Future<void> _loadHtmlString(
      Completer<WebViewController> controller, String htmlContent) async {
    WebViewController ctr = await controller.future;
    await ctr.loadHtmlString(htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, _response);
        return Future(() => false);
      },
      child: AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
        ),
        child: Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                WebView(
                  initialUrl: '',
                  onWebViewCreated:
                      (WebViewController webViewController) async {
                    _controller.complete(webViewController);
                    _loadHtmlString(_controller, _htmlContent);
                  },
                  onPageFinished: (response) {},
                  javascriptMode: JavascriptMode.unrestricted,
                  javascriptChannels: <JavascriptChannel>{
                    JavascriptChannel(
                      name: 'FlutterCloseLoader',
                      onMessageReceived: (JavascriptMessage message) {
                        Future.delayed(const Duration(seconds: 2), () {
                          setState(() {
                            isLoading = false;
                          });
                        });
                      },
                    ),
                    JavascriptChannel(
                      name: 'FlutterOnError',
                      onMessageReceived: (JavascriptMessage message) {
                        final data = (jsonDecode(message.message))['data']
                            as Map<String, dynamic>;
                        Logger().d(data);
                        setState(() {
                          _response =
                              KlumpCheckoutResponse(CheckoutStatus.error, data);
                        });
                      },
                    ),
                    JavascriptChannel(
                      name: 'FlutterOnSuccess',
                      onMessageReceived: (JavascriptMessage message) {
                        final data = (jsonDecode(message.message))['data']
                            as Map<String, dynamic>;
                        Logger().d(data);
                        setState(() {
                          _response = KlumpCheckoutResponse(
                              CheckoutStatus.success, data);
                        });
                      },
                    ),
                    JavascriptChannel(
                      name: 'FlutterOnClose',
                      onMessageReceived: (JavascriptMessage message) {
                        Logger().d(message.message);
                        Navigator.pop(context, _response);
                      },
                    ),
                  },
                ),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: KlumpColors.primary,
                        ),
                      )
                    : Container(
                        width: 0,
                        height: 0,
                        color: Colors.transparent,
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
