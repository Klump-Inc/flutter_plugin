import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter_webview_pro/platform_interface.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:klump_checkout/src/core/constant/colors.dart';
import 'package:logger/logger.dart';
// <script src="https://klump-js.netlify.app/klump.js" defer></script>
// <script src="https://staging-js.useklump.com/klump.js" defer></script>
// <script src="https://staging-js.useklump.com/klump.js" defer></script>
//  redirect_url: 'https://verygoodmerchant.com/checkout/confirmation',

class KlumpWebview extends StatefulWidget {
  const KlumpWebview({Key? key}) : super(key: key);

  @override
  KlumpWebviewState createState() => KlumpWebviewState();
}

class KlumpWebviewState extends State<KlumpWebview> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    // if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  var webpage = '''
<!DOCTYPE html>
<html>
<script src="https://staging-js.useklump.com/klump.js" defer></script>
<body>
<div style ="width: 500px; margin: 100px auto;">
  <div id="klump__checkout"></div>
  <div id="klump__ad">
      <input type="number" value="45000" id="klump__price">
      <input type="text" value="klp_pk_test_e4aaa1a8e96644ad9af23fa453ddd6ffa39a8233a88c4b93860f119c8cd9a332" id="klump__merchant__public__key">
      <input type="text" value="NGN" id="klump__currency">
  </div>
</div>
<script>
    CloseLoader.postMessage(true);
    const payload = {
        publicKey: 'klp_pk_test_e4aaa1a8e96644ad9af23fa453ddd6ffa39a8233a88c4b93860f119c8cd9a332',
        data: {
            amount: 45000,
            shipping_fee: 5000,
            currency: 'NGN',
            merchant_reference: 'what-ever-you-want-this-to-be',
            meta_data: {
              customer: 'Elon Musk',
              email: 'musk@spacex.com'
            },
            source: 'mobile',
            items: [
                {
                    image_url:
                        'https://s3.amazonaws.com/uifaces/faces/twitter/ladylexy/128.jpg',
                    item_url: 'https://www.paypal.com/in/webapps/mpp/home',
                    name: 'Awesome item',
                    unit_price: '20000',
                    quantity: 2,
                }
            ]
        },
        onSuccess: (data) => {
            console.log('html onSuccess will be handled by the merchant');
            console.log(data);
         Print.postMessage(JSON.stringify(data.data));
        },
        onError: (data) => {
            console.log('html onError will be handled by the merchant');
            console.log(data);
           Print.postMessage(JSON.stringify(data));
        },
        onLoad: (data) => {
            console.log('html onLoad will be handled by the merchant');
            console.log(data);
          Print.postMessage(JSON.stringify(data));
        },
        onOpen: (data) => {
            console.log('html OnOpen will be handled by the merchant');
            console.log(data);
         Print.postMessage(JSON.stringify(data));
        },
        onClose: (data) => {
            console.log('html onClose will be handled by the merchant');
            console.log(data);
          Print.postMessage(JSON.stringify(data));
        }
    }
    document.getElementById('klump__checkout').addEventListener('click', function () {
        const klump = new Klump(payload);
    });
</script>
</body>

</html> 
''';

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  Future<void> _loadHtmlString(
      Completer<WebViewController> controller, String htmlContent) async {
    WebViewController ctr = await controller.future;
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
                  _loadHtmlString(_controller, webpage);
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
