#ifndef FLUTTER_PLUGIN_TOUCH_SERVICE_PLUGIN_H_
#define FLUTTER_PLUGIN_TOUCH_SERVICE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace touch_service_plugin {

class TouchServicePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  TouchServicePlugin();

  virtual ~TouchServicePlugin();

  // Disallow copy and assign.
  TouchServicePlugin(const TouchServicePlugin&) = delete;
  TouchServicePlugin& operator=(const TouchServicePlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace touch_service_plugin

#endif  // FLUTTER_PLUGIN_TOUCH_SERVICE_PLUGIN_H_
