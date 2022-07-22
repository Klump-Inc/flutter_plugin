import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:klump_checkout/src/models/models.dart';
import 'package:klump_checkout/src/views/web_view.dart';

import 'helpers/helpers.dart';

void main() {
  group('Test Klump Checkout Plugin', () {
    testWidgets('Renders Klump Checkout webview', (tester) async {
      var data = const KlumpCheckoutData(
        amount: 45000,
        shippingFee: 5000,
        merchantReference: "what-ever-you-want-this-to-be",
        metaData: {
          'customer': "Elon Musk",
          'email': "musk@spacex.com",
        },
        items: [
          KlumpCheckoutItem(
            imageUrl:
                'https://s3.amazonaws.com/uifaces/faces/twitter/ladylexy/128.jpg',
            itemUrl: 'https://www.paypal.com/in/webapps/mpp/home',
            name: 'Awesome item',
            unitPrice: 20000,
            quantity: 2,
          )
        ],
      );
      await tester.pumpScreen(
        KlumpWebview(
          pubilcKey: '',
          data: data,
        ),
      );
      expect(find.byType(WebView), findsOneWidget);
    });
  });
}
