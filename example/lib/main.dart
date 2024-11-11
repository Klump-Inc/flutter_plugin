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
      debugShowCheckedModeBanner: false,
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
                    'klp_pk_test_6159f64f478f4726bead7d1045f831999a872ca27fd148549e3032c0bf8005b4',
                amount: 300000,
                shippingFee: 10000,
                merchantReference: "what-ever-you-want-this-to-be",
                metaData: {
                  'customer': "Elon Musk",
                  'email': "sample@mail.com",
                },
                items: [
                  KlumpCheckoutItem(
                    imageUrl:
                        'https://s3.amazonaws.com/uifaces/faces/twitter/ladylexy/128.jpg',
                    itemUrl: 'https://www.paypal.com/in/webapps/mpp/home',
                    name: 'Awesome item',
                    unitPrice: 150000,
                    quantity: 2,
                  )
                ],
                shippingData: null,
                email: 'sample@mail.com',
                phone: '08012345678',
              ),
            );
            // ignore: avoid_print
            print(res);
            //Perform action based on response returned from the checkout.
          },
          child: const Text('Text Checkout'),
        ),
      ),
    );
  }
}
