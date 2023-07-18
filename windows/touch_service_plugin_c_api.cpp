#include "include/touch_service_plugin/touch_service_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "touch_service_plugin.h"

void TouchServicePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  touch_service_plugin::TouchServicePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
