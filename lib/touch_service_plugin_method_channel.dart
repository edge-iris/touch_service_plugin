// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
// import 'package:touch_service_plugin/point.dart';

// import 'touch_service_plugin_platform_interface.dart';

// /// An implementation of [TouchServicePluginPlatform] that uses method channels.
// class MethodChannelTouchServicePlugin extends TouchServicePluginPlatform {
//   /// The method channel used to interact with the native platform.
//   @visibleForTesting
//   final methodChannel = const MethodChannel('touch_service_plugin/touch_channel');
//   final eventChannel = const MethodChannel('touch_service_plugin/touch_event_channel');

//   @override
//   Future<String?> getPlatformVersion() async {
//     final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
//     return version;
//   }

//   @override
//   Future<bool> isPermissionGranted() async {
//     final result = await methodChannel.invokeMethod<bool>('isPermissionGranted');
//     return result ?? false;
//   }

//   @override
//   Future<void> requestPermission() {
//     return methodChannel.invokeMethod<void>('requestPermission');
//   }

//   @override
//   Future<void> swipe(Point start, Point end) {
//     return methodChannel.invokeMethod<void>('swipe', {
//       'start': {'x': start.x, 'y': start.y},
//       'end': {'x': end.x, 'y': end.y},
//     });
//   }

//   @override
//   Future<void> touch(Point point) {
//     return methodChannel.invokeMethod<void>('touch', {
//       'point': {'x': point.x, 'y': point.y},
//     });
//   }
// }
