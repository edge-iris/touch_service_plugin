import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:touch_service_plugin_example/overlay_point.dart';

class OverlayMain extends StatefulWidget {
  const OverlayMain({Key? key}) : super(key: key);

  @override
  State<OverlayMain> createState() => _OverlayMainState();
}

class PointPosition {
  final double x;
  final double y;
  final Widget child;
  PointPosition(this.x, this.y, this.child);
}

class _OverlayMainState extends State<OverlayMain> {
  static const String _kPortNameOverlay = 'OVERLAY';
  static const String _kPortNameHome = 'UI';
  final _receivePort = ReceivePort();
  SendPort? homePort;
  String? messageFromOverlay;

  @override
  void initState() {
    super.initState();
    if (homePort != null) return;
    final res = IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      _kPortNameOverlay,
    );
    log("$res : HOME");
    _receivePort.listen((message) {
      log("message from UI: $message");
      setState(() {
        messageFromOverlay = 'message from UI: $message';
      });
    });
  }

  void _subscribeAccessibility() {
    _sendMessageToHome("Subscribe");
  }

  List<PointPosition> listPoints = [];

  void _addPoint() {
    // _sendMessageToHome("Add");
    // _showPointOverlay();
    setState(() {
      listPoints.add(PointPosition(0, 0, const OverlayPoint()));
    });
  }

  void _sendMessageToHome(String message) {
    homePort ??= IsolateNameServer.lookupPortByName(
      _kPortNameHome,
    );
    homePort?.send(message);
  }

  void _cancelAccessibility() {
    // _sendMessageToHome("Cancel");
    // _closePointOverlay();
  }

  void _touchToTheScreen() async {
    _sendMessageToHome("Touch");
  }

  void _closeOverlay() {
    _sendMessageToHome("Close");
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.red,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(4.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: FloatingActionButton(
                        onPressed: _addPoint,
                        tooltip: 'Add',
                        child: const Icon(Icons.add),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    SizedBox(
                      child: FloatingActionButton(
                        onPressed: _cancelAccessibility,
                        tooltip: 'Stop',
                        child: const Icon(Icons.stop),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    SizedBox(
                      child: FloatingActionButton(
                        onPressed: _touchToTheScreen,
                        tooltip: 'Playback',
                        child: const Icon(Icons.play_arrow),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    SizedBox(
                      child: FloatingActionButton(
                        onPressed: _closeOverlay,
                        tooltip: 'Close',
                        child: const Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ...listPoints
                .map((e) => Positioned(
                      left: e.x,
                      top: e.y,
                      child: e.child,
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
