import 'package:flutter/material.dart';
import 'package:klump_checkout/klump_checkout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FirstScreen(),
    );
  }
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Klump Checkout Sample'),
        centerTitle: false,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final klumpCheckout = KlumpCheckout();
            final res = await klumpCheckout.pay(
              isLive: false,
              context: context,
              data: const KlumpCheckoutData(
                merchantPublicKey:
                    'klp_pk_test_e4aaa1a8e96644ad9af23fa453ddd6ffa39a8233a88c4b93860f119c8cd9a332',
                amount: 100000,
                shippingFee: 0,
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
                    unitPrice: 50000,
                    quantity: 2,
                  )
                ],
                shippingData: {
                  "address": "Ediam road Akppa",
                  "landmark": "extras",
                  "city_id": "da513ab9-a28e-4451-af6b-16f029be2c37"
                },
              ),
            );
            // ignore: avoid_print
            print(res);
          },
          child: const Text('Text Checkout'),
        ),
      ),
    );
  }
}
