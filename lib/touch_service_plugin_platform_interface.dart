// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
// import 'package:touch_service_plugin/point.dart';

// import 'touch_service_plugin_method_channel.dart';

// abstract class TouchServicePluginPlatform extends PlatformInterface {
//   /// Constructs a TouchServicePluginPlatform.
//   TouchServicePluginPlatform() : super(token: _token);

//   static final Object _token = Object();

//   static TouchServicePluginPlatform _instance = MethodChannelTouchServicePlugin();

//   /// The default instance of [TouchServicePluginPlatform] to use.
//   ///
//   /// Defaults to [MethodChannelTouchServicePlugin].
//   static TouchServicePluginPlatform get instance => _instance;

//   /// Platform-specific implementations should set this with their own
//   /// platform-specific class that extends [TouchServicePluginPlatform] when
//   /// they register themselves.
//   static set instance(TouchServicePluginPlatform instance) {
//     PlatformInterface.verifyToken(instance, _token);
//     _instance = instance;
//   }

//   Future<String?> getPlatformVersion() {
//     throw UnimplementedError('platformVersion() has not been implemented.');
//   }

//   Future<bool> isPermissionGranted();
//   Future<void> requestPermission();
//   Future<void> touch(Point point);
//   Future<void> swipe(Point start, Point end);
// }
