#import "KlumpCheckoutPlugin.h"
#if __has_include(<klump_checkout/klump_checkout-Swift.h>)
#import <klump_checkout/klump_checkout-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "klump_checkout-Swift.h"
#endif

@implementation KlumpCheckoutPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftKlumpCheckoutPlugin registerWithRegistrar:registrar];
}
@end
