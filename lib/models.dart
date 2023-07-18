// ignore_for_file: constant_identifier_names

class TouchEvent {
  final TouchSource? source;
  final double? x;
  final double? y;
  final TouchType? type;
  DateTime? time;

  TouchEvent({this.source, this.x, this.y, this.type, this.time});

  factory TouchEvent.fromMap(Map<dynamic, dynamic> map) {
    final type = map[TouchSource.INTENT_NAME];
    final source = map[TouchType.INTENT_NAME];
    final time = DateTime.fromMillisecondsSinceEpoch(map['eventTime']);
    return TouchEvent(
      source: source,
      x: map['x'],
      y: map['y'],
      type: TouchType.getByValue(type),
      time: time,
    );
  }
}

class TouchType {
  static const INTENT_NAME = "MOTIONACTION";
  final String name;
  final int value;

  const TouchType(this.name, this.value);

  static List<TouchType> allTypes = <TouchType>[
    const TouchType('actionCancel', 3),
    const TouchType('actionDown', 0),
    const TouchType('actionHoverEnter', 9),
    const TouchType('actionHoverExit', 10),
    const TouchType('actionHoverMove', 7),
    const TouchType('actionMask', 255),
    const TouchType('actionMove', 2),
    const TouchType('actionOutside', 4),
    const TouchType('actionPointerUp', 6),
    const TouchType('actionScroll', 8),
    const TouchType('actionUp', 1),
    const TouchType('undefined', -1)
  ];

  static TouchType? getByValue(int value) => allTypes.where((e) => e.value == value).firstOrNull;
}

class TouchSource {
  static const INTENT_NAME = "eventType";
  final String name;
  final int value;

  const TouchSource(this.name, this.value);

  static List<TouchSource> allTypes = <TouchSource>[
    const TouchSource('toolTypeEraser', 4),
    const TouchSource('toolTypeFinger', 1),
    const TouchSource('toolTypeMouse', 3),
    const TouchSource('toolTypeStylus', 2),
    const TouchSource('toolTypeUnknown', 0)
  ];

  static TouchSource? getByValue(int value) => allTypes.where((e) => e.value == value).firstOrNull;
}
