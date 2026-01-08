import 'package:flutter/material.dart';
import 'package:klump_checkout/klump_checkout.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CDLWebview extends StatefulWidget {
  const CDLWebview({super.key});

  @override
  State<CDLWebview> createState() => _CDLWebviewState();
}

class _CDLWebviewState extends State<CDLWebview> {
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

    final html = ''' <!DOCTYPE html>
  <html lang="en">
  <head>
    <title>Checkout Connect test</title>
    <style>
      .p-5 {
        padding: 5em;
      }
    </style>
  </head>
  <body>
    <div className="p-5">
    </div>
    <script type="application/javascript" src="https://checkout.creditdirect.ng/bnpl/checkout.min.js"></script> 
      <script
        src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.1.1/crypto-js.min.js"
        integrity="sha512-E8QSvWZ0eCLGk4km3hxSsNmGWbLtSCSUcewDQPQWZF6pEU8GlT8a5fF32wOl1i8ftdMhssTrF/OhyGWwonTcXA=="
        crossorigin="anonymous"
        referrerpolicy="no-referrer"></script>
      <script>
        let connect;
        const chr = 15;
        const sessionId = generateUniqueSessionId(chr);
        const transaction = {
          "totalAmount": ${checkoutNotfier.totalAmount},
          "customerEmail": "${checkoutNotfier.email}",
          "customerPhone": "${checkoutNotfier.phoneNumber}",
          sessionId,
          products: ${checkoutNotfier.productDetails},
          metaData: "${checkoutNotfier.tranxReference}"
        }
        let config = {
          publicKey: "$CDL_PUBLIC_KEY",
          transaction: transaction,
          isLive: ${checkoutNotfier.initiateResponse?.isLive == true},
          onSuccess: function (response) {
            console.log(JSON.stringify(response));
            FlutterOnSuccess.postMessage(JSON.stringify(data));
          },
          onClose: function () {
            console.log('User closed checkout widget.');
            FlutterOnClose.postMessage('User closed checkout widget.');
          },
          onError: function () {
            console.log('Error occurred');
            FlutterOnError.postMessage('Error occurred');
          },
          onPopup: function (response) {
            console.log('popup occurred', response);
          }
        };

        function generateUniqueSessionId(length) {
          const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
          let result = '';
          for (let i = 0; i < length; i++) {
            result += characters.charAt(Math.floor(Math.random() * characters.length));
          }
          return result;
        }

        function openCheckout() {
          console.log('sessionId', transaction);
          console.log('generateUniqueSessionId',  sessionId);
          transaction.sessionId = sessionId;
          config.signature = signTransaction(transaction);
          console.log('config',  config);
          connect = new Connect(config);
          connect.setup();
          connect.open();
        }
        // Server code sample
        function signTransaction(transaction) {
          const privateKey = "$CDL_PRIVATE_KEY";
          const sm = transaction.sessionId + transaction.customerEmail + transaction.totalAmount;
          const st = signTransactionRequest(sm, privateKey);
          return st;
        }

        function signTransactionRequest(message, privateKey) {
          const key = CryptoJS.enc.Utf8.parse(privateKey);
          const messageData = CryptoJS.enc.Utf8.parse(message);
          const signature = CryptoJS.enc.Hex.stringify(CryptoJS.HmacSHA256(messageData, key));
          return signature;
        }
        window.onload = openCheckout;
      </script>
  </body>
</html>''';
    _webViewController
        .loadRequest(Uri.dataFromString(html, mimeType: 'text/html'));
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
