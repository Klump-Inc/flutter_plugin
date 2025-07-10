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
                    // 'klp_pk_58f87474152b4d93babf9682e90724287d05e0c7af2c4756907425c47f52767d',
                    // 'klp_pk_test_9d7e5259a162417ead4f7743f516a71c7d05e0c7af2c4756907425c47f52767d',
                    'klp_pk_9ab98d0ddf0e447c9e0a615f4e546604a39a8233a88c4b93860f119c8cd9a332',
                amount: 300000,
                shippingFee: 10000,
                merchantReference: "what-ever-you-want-this-to-be",
                metaData: {
                  'customer': "Elon Musk",
                  'email': "test55@useklump.com",
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
                email: 'test55@useklump.com',
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
