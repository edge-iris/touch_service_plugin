package com.ducdd.touch_service_plugin


import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import io.flutter.plugin.common.EventChannel

class MotionEventReceiver(eventSink: EventChannel.EventSink) : BroadcastReceiver() {
    private var _eventSink: EventChannel.EventSink = eventSink;

    companion object {
        var ACCESSIBILITY_INTENT = "accessibility_event"
        var ACCESSIBILITY_NAME = "packageName"
        var ACCESSIBILITY_EVENT_TYPE = "eventType"
        var ACCESSIBILITY_TEXT = "capturedText"
        var ACCESSIBILITY_ACTION = "action"
        var ACCESSIBILITY_EVENT_TIME = "eventTime"
        var ACCESSIBILITY_CHANGES_TYPES = "contentChangeTypes"
        var ACCESSIBILITY_MOVEMENT = "movementGranularity"
        var ACCESSIBILITY_IS_ACTIVE = "isActive"
        var ACCESSIBILITY_IS_FOCUSED = "isFocused"
        var ACCESSIBILITY_IS_PIP = "isInPictureInPictureMode"
        var ACCESSIBILITY_WINDOW_TYPE = "windowType"
        var ACCESSIBILITY_SCREEN_BOUNDS = "screenBounds"
        var ACCESSIBILITY_NODES_TEXT = "nodesText"
        var POINT_X = "x"
        var POINT_Y = "y"
        var TOOL_TYPE = "toolType"
        var MOTION_ACTION = "motionAction"
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        Log.i("MotionEventReceiver - onReceive - Intent event", intent.toString())
        if (context != null && intent != null && intent.action == ACCESSIBILITY_INTENT) {
            /// Send data back via the Event Sink

            /// Send data back via the Event Sink
            val data: HashMap<String, Any?> = HashMap()
            data["packageName"] = intent.getStringExtra(ACCESSIBILITY_NAME)
            data["eventType"] =
                intent.getIntExtra(ACCESSIBILITY_EVENT_TYPE, -1)
            data["capturedText"] = intent.getStringExtra(ACCESSIBILITY_TEXT)
            data["actionType"] = intent.getIntExtra(ACCESSIBILITY_ACTION, -1)
            data["eventTime"] =
                intent.getLongExtra(ACCESSIBILITY_EVENT_TIME, -1)
            data["contentChangeTypes"] =
                intent.getIntExtra(ACCESSIBILITY_CHANGES_TYPES, -1)
            data["movementGranularity"] =
                intent.getIntExtra(ACCESSIBILITY_MOVEMENT, -1)
            data["isActive"] =
                intent.getBooleanExtra(ACCESSIBILITY_IS_ACTIVE, false)
            data["isFocused"] =
                intent.getBooleanExtra(ACCESSIBILITY_IS_FOCUSED, false)
            data["isPip"] =
                intent.getBooleanExtra(ACCESSIBILITY_IS_PIP, false)
            data["windowType"] =
                intent.getIntExtra(ACCESSIBILITY_WINDOW_TYPE, -1)
            data["screenBounds"] =
                intent.getSerializableExtra(ACCESSIBILITY_SCREEN_BOUNDS)
            data["nodesText"] =
                intent.getStringArrayListExtra(ACCESSIBILITY_NODES_TEXT)

            data[POINT_X] = intent.getFloatExtra(POINT_X, -1f)
            data[POINT_Y] = intent.getFloatExtra(POINT_Y, -1f)
            data[TOOL_TYPE] = intent.getIntExtra(TOOL_TYPE, -1)
            data[MOTION_ACTION] =
                intent.getIntExtra(MOTION_ACTION, -1)

            _eventSink.success(data)
        }
    }


}