// import 'package:flutter_test/flutter_test.dart';
// import 'package:klump_checkout/klump_checkout.dart';
// import 'package:klump_checkout/src/klump_checkout_platform_interface.dart';
// import 'package:klump_checkout/src/klump_checkout_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockKlumpCheckoutPlatform
//     with MockPlatformInterfaceMixin
//     implements KlumpCheckoutPlatform {
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final KlumpCheckoutPlatform initialPlatform = KlumpCheckoutPlatform.instance;

//   test('$MethodChannelKlumpCheckout is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelKlumpCheckout>());
//   });

//   test('getPlatformVersion', () async {
//     KlumpCheckout klumpCheckoutPlugin = KlumpCheckout();
//     MockKlumpCheckoutPlatform fakePlatform = MockKlumpCheckoutPlatform();
//     KlumpCheckoutPlatform.instance = fakePlatform;

//     expect(await klumpCheckoutPlugin.getPlatformVersion(), '42');
//   });
// }
