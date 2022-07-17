import 'klump_checkout_platform_interface.dart';

class KlumpCheckout {
  Future<String?> getPlatformVersion() {
    return KlumpCheckoutPlatform.instance.getPlatformVersion();
  }
}
