// ignore_for_file: constant_identifier_names

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/touch_api.g.dart',
  kotlinOut: 'android/src/main/kotlin/com/ducdd/touch_service_plugin/TouchApi.g.kt',
))
class Point {
  final double x;
  final double y;

  Point({required this.x, required this.y});
}

@HostApi()
abstract class TouchApi {
  bool isPermissionGranted();
  void requestPermission();
  void touch(Point point);
  void swipe(Point start, Point end);
}
