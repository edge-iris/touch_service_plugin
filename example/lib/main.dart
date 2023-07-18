import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:touch_service_plugin/models.dart';
import 'package:touch_service_plugin/touch_api.g.dart';
import 'package:touch_service_plugin/touch_service_plugin.dart';
import 'package:touch_service_plugin_example/overlay_main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class TouchPoint {
  final double x;
  final double y;
  final int delay;

  TouchPoint(this.x, this.y, this.delay);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(child: OverlayMain()),
    ),
  );
}

class _MyHomePageState extends State<MyHomePage> {
  double _tabPositionX = 0;
  double _tabPositionY = 0;

  String _text = "No touch";

  static const String _kPortNameOverlay = 'OVERLAY';
  static const String _kPortNameHome = 'UI';
  final _receivePort = ReceivePort();
  SendPort? homePort;
  String? latestMessageFromOverlay;

  @override
  void initState() {
    super.initState();
    if (homePort != null) return;
    final res = IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      _kPortNameHome,
    );
    log("$res: OVERLAY");
    _receivePort.listen((message) {
      log("message from OVERLAY: $message");
      if (message == "Subscribe") {
        _subscribeAccessibility();
      } else if (message == "Cancel") {
        _cancelAccessibility();
      } else if (message == "Touch") {
        _touchToTheScreen();
      } else if (message == "Close") {
        _closeOverlay();
      }
    });
  }

  void _closeOverlay() async {
    FlutterOverlayWindow.closeOverlay();
  }

  void _showOverlay() async {
    var isEnable = await FlutterOverlayWindow.isPermissionGranted();
    if (!isEnable) {
      await FlutterOverlayWindow.requestPermission();
      return;
    }

    if (await FlutterOverlayWindow.isActive()) return;
    await FlutterOverlayWindow.showOverlay(
      enableDrag: true,
      overlayTitle: "demo",
      overlayContent: 'demo',
      flag: OverlayFlag.focusPointer,
      visibility: NotificationVisibility.visibilityPublic,
      positionGravity: PositionGravity.none,
      alignment: OverlayAlignment.center,
      height: 700,
      // width: WindowSize.matchParent,
      width: 200,
    );
  }

  void _sendMessageToOverlay(String message) {
    homePort ??= IsolateNameServer.lookupPortByName(_kPortNameOverlay);
    homePort?.send(message);
  }

  StreamSubscription<TouchEvent>? _subscription;
  final List<TouchEvent> _events = [];
  final List<TouchPoint> _touchEvents = [];

  final touchService = TouchServicePlugin.defaultInstance;

  void _subscribeAccessibility() async {
    final isEnable = await touchService.isPermissionGranted();
    if (isEnable) {
      _subscription = touchService.touchStream.listen((event) {
        log("$event");
        setState(() {
          _events.add(event);
        });
      });
    } else {
      await touchService.requestPermission();
    }
  }

  void _setTabPosition(TapDownDetails details) {
    setState(() {
      _tabPositionX = details.globalPosition.dx;
      _tabPositionY = details.globalPosition.dy;
    });
  }

  void _cancelAccessibility() {
    _touchEvents.clear();
    _subscription?.cancel();
    setState(() {
      var index = 0;
      for (final event in _events) {
        if (index == _events.length - 1) {
          break;
        }
        if (index == 0) {
          _touchEvents.add(TouchPoint(event.x!, event.y!, 0));
        } else {
          _touchEvents.add(TouchPoint(event.x!, event.y!, event.time!.difference(_events[index - 1].time!).inMilliseconds));
        }
        index++;
      }
      _events.clear();
    });
  }

  void _touchToTheScreen() async {
    for (var i = 0; i < _touchEvents.length; i++) {
      var touchEvent = _touchEvents[i];
      await Future.delayed(Duration(milliseconds: touchEvent.delay));
      await touchService.touch(Point(x: touchEvent.x, y: touchEvent.y));
    }
    // _touchEvents.clear();
  }

  void _onTouched(String text) async {
    setState(() {
      _text = text;
    });
  }

  void onTabCapture() async {
    await touchService.touch(Point(x: 101 * 2.5, y: 320 * 2.5));
  }

  void onSwipeCapture() async {
    await touchService.swipe(Point(x: 201 * 2.5, y: 590 * 2.5), Point(x: 201 * 2.5, y: 320 * 2.5));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _setTabPosition,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(widget.title),
          ),
          body: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Center(
                    child: Column(
                      children: [
                        Text('Tab position: $_tabPositionX, $_tabPositionY'),
                        const SizedBox(height: 8.0),
                        Text('Tab button: $_text'),
                        const SizedBox(height: 8.0),
                        Text('Touch events: ${_touchEvents.length}'),
                        const SizedBox(height: 8.0),
                        const TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Enter your username',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                // onTapDown: _setTabPosition,
                                child: Center(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        _onTouched("button 1");
                                      },
                                      child: const Text('Button 1')),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                // onTapDown: _setTabPosition,
                                child: Center(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        _onTouched("button 2");
                                      },
                                      child: const Text('Button 2')),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                // onTapDown: _setTabPosition,
                                child: Center(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        _onTouched("button 3");
                                      },
                                      child: const Text('Button 3')),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                // onTapDown: _setTabPosition,
                                child: Center(
                                  child: ElevatedButton(
                                    onPressed: onTabCapture,
                                    child: const Text('Button 4'),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                // onTapDown: _setTabPosition,
                                child: Center(
                                  child: ElevatedButton(
                                    onPressed: onSwipeCapture,
                                    child: const Text('Button 5'),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 10,
                    itemBuilder: (_, index) {
                      // int latestIndex = _events.length - index - 1;
                      if (_events.length > index) {
                        int latestIndex = index;
                        return ListTile(
                          title: Text("event time: ${_events[latestIndex].type}-${_events[latestIndex].time!.toIso8601String()}"),
                        );
                      }
                      return null;
                    },
                  ),
                )
              ],
            ),
          ),
          floatingActionButton: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: _subscribeAccessibility,
                  tooltip: 'Subscribe',
                  child: const Icon(Icons.add),
                ),
                const SizedBox(width: 8.0),
                FloatingActionButton(
                  onPressed: _cancelAccessibility,
                  tooltip: 'Stop',
                  child: const Icon(Icons.stop),
                ),
                const SizedBox(width: 8.0),
                FloatingActionButton(
                  onPressed: _showOverlay,
                  tooltip: 'Overlay',
                  child: const Icon(Icons.play_arrow),
                ),
                const SizedBox(width: 8.0),
                FloatingActionButton(
                  onPressed: _closeOverlay,
                  tooltip: 'Close',
                  child: const Icon(Icons.close),
                ),
              ],
            ),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ),
    );
  }
}
