//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <klump_checkout/klump_checkout_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) klump_checkout_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "KlumpCheckoutPlugin");
  klump_checkout_plugin_register_with_registrar(klump_checkout_registrar);
}
