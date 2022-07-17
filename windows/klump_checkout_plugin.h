#ifndef FLUTTER_PLUGIN_KLUMP_CHECKOUT_PLUGIN_H_
#define FLUTTER_PLUGIN_KLUMP_CHECKOUT_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace klump_checkout {

class KlumpCheckoutPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  KlumpCheckoutPlugin();

  virtual ~KlumpCheckoutPlugin();

  // Disallow copy and assign.
  KlumpCheckoutPlugin(const KlumpCheckoutPlugin&) = delete;
  KlumpCheckoutPlugin& operator=(const KlumpCheckoutPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace klump_checkout

#endif  // FLUTTER_PLUGIN_KLUMP_CHECKOUT_PLUGIN_H_
