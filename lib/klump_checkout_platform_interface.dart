import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'klump_checkout_method_channel.dart';

abstract class KlumpCheckoutPlatform extends PlatformInterface {
  /// Constructs a KlumpCheckoutPlatform.
  KlumpCheckoutPlatform() : super(token: _token);

  static final Object _token = Object();

  static KlumpCheckoutPlatform _instance = MethodChannelKlumpCheckout();

  /// The default instance of [KlumpCheckoutPlatform] to use.
  ///
  /// Defaults to [MethodChannelKlumpCheckout].
  static KlumpCheckoutPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [KlumpCheckoutPlatform] when
  /// they register themselves.
  static set instance(KlumpCheckoutPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
