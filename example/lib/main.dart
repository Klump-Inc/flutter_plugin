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
        title: const Text('Checkout example app'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            KlumpPlugin klumpPlugin = KlumpPlugin(
                publicKey:
                    'klp_pk_test_e4aaa1a8e96644ad9af23fa453ddd6ffa39a8233a88c4b93860f119c8cd9a332');
            final res = await klumpPlugin.checkout(
              context: context,
              data: KlumpCheckoutData(
                totalAmount: 10000,
                metaData: {},
                items: [],
              ),
            );
            print(res);
          },
          child: const Text('Text Checkout'),
        ),
      ),
    );
  }
}
