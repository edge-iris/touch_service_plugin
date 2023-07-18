//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <touch_service_plugin/touch_service_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) touch_service_plugin_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "TouchServicePlugin");
  touch_service_plugin_register_with_registrar(touch_service_plugin_registrar);
}
