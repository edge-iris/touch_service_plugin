import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:touch_service_plugin/touch_api.g.dart';

import 'models.dart';

class TouchServicePlugin {
  final TouchApi _api;

  final String _eventChannel = "dev.flutter.pigeon.TouchApi/touchEventChannel";

  TouchServicePlugin(this._api);

  Stream<TouchEvent> get touchStream {
    if (Platform.isAndroid) {
      return EventChannel(_eventChannel).receiveBroadcastStream(_eventChannel).map<TouchEvent>((event) {
        log('file: touch_service_plugin.dart:20 ~ TouchServicePlugin ~ returnEventChannel ~ event:  $event');
        return TouchEvent.fromMap(event);
      });
    } else {
      throw Exception("Accessibility API exclusively available on Android!");
    }
  }

  Future<bool> isPermissionGranted() async {
    return _api.isPermissionGranted();
  }

  Future<void> requestPermission() async {
    return _api.requestPermission();
  }

  Future<void> touch(Point point) async {
    return _api.touch(point);
  }

  Future<void> swipe(Point start, Point end) async {
    return _api.swipe(start, end);
  }

  static TouchServicePlugin get defaultInstance => TouchServicePlugin(TouchApi());
}
