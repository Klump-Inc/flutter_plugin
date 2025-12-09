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
    return MaterialApp(
      theme: ThemeData(
        datePickerTheme: const DatePickerThemeData(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const FirstScreen(),
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
              context: context,
              data: const KlumpCheckoutData(
                merchantPublicKey:
                    'klp_pk_test_8dc412b18d2d402e96430e0108c5f83e46c974462e814102bbb858f7197f06c2',
                amount: 300000,
                shippingFee: 10000,
                merchantReference: "what-ever-you-want-this-to-be_ejerkjrj33ee",
                metaData: {
                  'customer': "Elon Musk",
                  'email': "test51@useklump.com",
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
                email: 'test51@useklump.com',
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
