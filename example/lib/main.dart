import 'package:flutter/material.dart';
import 'dart:async';

import 'package:klump_checkout/klump_checkout.dart';
import 'package:klump_checkout_example/web_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _klumpCheckoutPlugin = KlumpCheckout();

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
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return const WebViewExample();
              }),
            );
          },
          child: const Text('Text Webview'),
        ),
        // child: Text('Running on: $_platformVersion\n'),
      ),
    );
  }
}
