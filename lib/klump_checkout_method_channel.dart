import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'klump_checkout_platform_interface.dart';

/// An implementation of [KlumpCheckoutPlatform] that uses method channels.
class MethodChannelKlumpCheckout extends KlumpCheckoutPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('klump_checkout');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
