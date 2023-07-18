// import 'package:flutter_test/flutter_test.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
// import 'package:touch_service_plugin/point.dart';
// import 'package:touch_service_plugin/touch_service_plugin.dart';
// import 'package:touch_service_plugin/touch_service_plugin_method_channel.dart';
// import 'package:touch_service_plugin/touch_service_plugin_platform_interface.dart';

// class MockTouchServicePluginPlatform with MockPlatformInterfaceMixin implements TouchServicePluginPlatform {
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');

//   @override
//   Future<bool> isPermissionGranted() {
//     // TODO: implement isPermissionGranted
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> requestPermission() {
//     // TODO: implement requestPermission
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> swipe(Point start, Point end) {
//     // TODO: implement swipe
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> touch(Point point) {
//     // TODO: implement touch
//     throw UnimplementedError();
//   }
// }

// void main() {
//   final TouchServicePluginPlatform initialPlatform = TouchServicePluginPlatform.instance;

//   test('$MethodChannelTouchServicePlugin is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelTouchServicePlugin>());
//   });

//   test('getPlatformVersion', () async {
//     TouchServicePlugin touchServicePlugin = TouchServicePlugin();
//     MockTouchServicePluginPlatform fakePlatform = MockTouchServicePluginPlatform();
//     TouchServicePluginPlatform.instance = fakePlatform;

//     expect(await touchServicePlugin.getPlatformVersion(), '42');
//   });
// }
