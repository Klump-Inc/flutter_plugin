import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:klump_checkout/klump_checkout_method_channel.dart';

void main() {
  MethodChannelKlumpCheckout platform = MethodChannelKlumpCheckout();
  const MethodChannel channel = MethodChannel('klump_checkout');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
