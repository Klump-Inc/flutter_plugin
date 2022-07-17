#include "include/klump_checkout/klump_checkout_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "klump_checkout_plugin.h"

void KlumpCheckoutPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  klump_checkout::KlumpCheckoutPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
