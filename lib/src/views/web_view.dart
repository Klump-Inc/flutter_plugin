import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:klump_checkout/src/core/constant/colors.dart';
import 'package:klump_checkout/src/core/utils/util.dart';
import 'package:logger/logger.dart';
// <script src="https://klump-js.netlify.app/klump.js" defer></script>
// <script src="https://staging-js.useklump.com/klump.js" defer></script>

class KlumpWebview extends StatefulWidget {
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
  @override
  void initState() {
    super.initState();
    _htmlContent = genereteWebPage(widget.pubilcKey, widget.data);
    // if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  Future<void> _loadHtmlString(
      Completer<WebViewController> controller, String htmlContent) async {
    WebViewController ctr = await controller.future;
    Logger().d(_htmlContent);
    await ctr.loadHtmlString(htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              WebView(
                initialUrl: '',
                onWebViewCreated: (WebViewController webViewController) async {
                  _controller.complete(webViewController);
                  _loadHtmlString(_controller, _htmlContent);
                },
                onPageFinished: (response) {
                  Logger().d(response);
                },
                javascriptMode: JavascriptMode.unrestricted,
                javascriptChannels: <JavascriptChannel>{
                  JavascriptChannel(
                    name: 'CloseLoader',
                    onMessageReceived: (JavascriptMessage message) {
                      Future.delayed(const Duration(seconds: 2), () {
                        setState(() {
                          isLoading = false;
                        });
                      });
                    },
                  ),
                  JavascriptChannel(
                    name: 'Print',
                    onMessageReceived: (JavascriptMessage message) {
                      // final data = (jsonDecode(message.message))['data']
                      // as Map<String, dynamic>;
                      Logger().d(message.message);
                    },
                  ),
                },
              ),
              isLoading
                  ? Center(
                      child:
                          CircularProgressIndicator(color: KlumpColors.primary),
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
    );
  }
}
