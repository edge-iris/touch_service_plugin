package com.ducdd.touch_service_plugin

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.accessibilityservice.GestureDescription
import android.accessibilityservice.GestureDescription.StrokeDescription
import android.content.Intent
import android.graphics.Path
import android.graphics.Rect
import android.os.Build
import android.util.Log
import android.view.accessibility.AccessibilityEvent
import android.view.accessibility.AccessibilityNodeInfo
import android.view.accessibility.AccessibilityWindowInfo
import java.io.Serializable


class AccessibilityServicePlugin : AccessibilityService(), Serializable {
    companion object {
        const val TOUCH_EXPLORATION = "touchExploration"
        const val TOUCH = "touch"
        const val SWIPE = "swipe"
    }

//    private var _flags = 0

    override fun onServiceConnected() {
        super.onServiceConnected()
//        _flags = serviceInfo.flags

        val info = serviceInfo
        info.flags = AccessibilityServiceInfo.FLAG_REQUEST_TOUCH_EXPLORATION_MODE
        info.flags = AccessibilityServiceInfo.FLAG_REQUEST_MULTI_FINGER_GESTURES

        serviceInfo = info
    }

//    override fun onAccessibilityEvent(event: AccessibilityEvent?) {}
//
//    override fun onInterrupt() {}

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {

        if (intent?.extras?.containsKey(TOUCH) == true) {
            val position = intent.getFloatArrayExtra(TOUCH)!!
            touch(position[0], position[1])
        }

        if (intent?.extras?.containsKey(SWIPE) == true) {
            val position = intent.getFloatArrayExtra(SWIPE)!!
            swipe(position[0], position[1], position[2], position[3])
        }

//        if (intent?.extras?.containsKey(TOUCH_EXPLORATION) == true) {
//            val status = intent.getBooleanExtra(TOUCH_EXPLORATION, false)
//
//            if (!status) {
//                val info = serviceInfo
//                info.flags =
//                    _flags + AccessibilityServiceInfo.FLAG_REQUEST_TOUCH_EXPLORATION_MODE
//                serviceInfo = info
//
//                setTouchExplorationPassthroughRegion(
//                    Display.DEFAULT_DISPLAY, getRegionOfFullScreen(
//                        applicationContext
//                    )
//                )
//
//                getTouchInteractionController(Display.DEFAULT_DISPLAY).registerCallback(null, this)
//            } else {
//                val info = serviceInfo
//                info.flags = _flags
//                serviceInfo = info
//
//                setTouchExplorationPassthroughRegion(
//                    Display.DEFAULT_DISPLAY, Region()
//                )
//
//                getTouchInteractionController(Display.DEFAULT_DISPLAY).unregisterAllCallbacks()
//            }
//        }

        return super.onStartCommand(intent, flags, startId)
    }

//    private fun getRegionOfFullScreen(context: Context): Region {
//        val metrics: WindowMetrics? =
//            context.getSystemService(WindowManager::class.java)?.currentWindowMetrics
//        return if (metrics == null) {
//            Region()
//        } else {
//            Region(0, 0, metrics.bounds.width(), metrics.bounds.height())
//        }
//    }

    // TouchInteractionController.Callback start
//    override fun onMotionEvent(motionEvent: MotionEvent) {
//        val touchIntent = Intent("Motion")
//
//        val actionType: Int = motionEvent.action
//        touchIntent.putExtra(IntentName.MOTIONACTION.name, actionType)
//
//        val x: Float = motionEvent.x
//        touchIntent.putExtra(IntentName.X.name, x)
//
//        val y: Float = motionEvent.y
//        touchIntent.putExtra(IntentName.Y.name, y)
//
//        val toolType: Int = motionEvent.getToolType(0) // set to 0 for one finger
//        touchIntent.putExtra(IntentName.TOOLTYPE.name, toolType)
//
//        val eventTime: Long = System.currentTimeMillis()
//        touchIntent.putExtra(IntentName.EVENTTIME.name, eventTime)

//        sendBroadcast(touchIntent)
//    }

//    override fun onStateChanged(state: Int) {}
    // TouchInteractionController.Callback end

    private fun gestureDescriptionAction(path: Path, intentName: String, duration: Long) {
        val gestureBuilder = GestureDescription.Builder()
        gestureBuilder.addStroke(StrokeDescription(path, 0, duration, false))
        dispatchGesture(
            gestureBuilder.build(), object : GestureResultCallback() {
                override fun onCancelled(gestureDescription: GestureDescription) {
                    val touchIntent = Intent(intentName)
                    touchIntent.putExtra(intentName, false)

                    sendBroadcast(touchIntent)
                    super.onCancelled(gestureDescription)
                }

                override fun onCompleted(gestureDescription: GestureDescription) {
                    val touchIntent = Intent(intentName)
                    touchIntent.putExtra(intentName, true)

                    sendBroadcast(touchIntent)
                    super.onCompleted(gestureDescription)
                }
            }, null
        )
    }

    private fun touch(x: Float, y: Float) {
        Log.i("touch - X - Y", "$x-$y");
        val path = Path()
        path.moveTo(x, y)
        gestureDescriptionAction(path, TOUCH, 1)
    }

    private fun swipe(x1: Float, y1: Float, x2: Float, y2: Float) {
        Log.i("swipe - X1 - Y1 - X2 - Y2", "$x1-$y1-$x2-$y2");
        val path = Path()
        path.moveTo(x1, y1)
        path.lineTo(x2, y2)
        gestureDescriptionAction(path, SWIPE, 1000)
    }

    override fun onAccessibilityEvent(accessibilityEvent: AccessibilityEvent) {
        Log.i("onAccessibilityEvent - receive an intent event", accessibilityEvent.toString());

        try {
            val eventType = accessibilityEvent.eventType
            val parentNodeInfo: AccessibilityNodeInfo? = accessibilityEvent.source
            var windowInfo: AccessibilityWindowInfo? = null
            val nextTexts: MutableList<String?> = ArrayList()

            val intent: Intent = Intent(MotionEventReceiver.ACCESSIBILITY_INTENT)

            //Gets the event type
            intent.putExtra(MotionEventReceiver.ACCESSIBILITY_EVENT_TYPE, eventType)
            //Gets the performed action that triggered this event.
            intent.putExtra(MotionEventReceiver.ACCESSIBILITY_ACTION, accessibilityEvent.action)
            //Gets The event time.
            intent.putExtra(MotionEventReceiver.ACCESSIBILITY_EVENT_TIME, accessibilityEvent.eventTime)
            //Gets the movement granularity that was traversed.
            intent.putExtra(MotionEventReceiver.ACCESSIBILITY_MOVEMENT, accessibilityEvent.movementGranularity)
            //Gets the package name of the source
            intent.putExtra(MotionEventReceiver.ACCESSIBILITY_NAME, accessibilityEvent.packageName)

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                //Gets the bit mask of change types signaled by a TYPE_WINDOW_CONTENT_CHANGED event or TYPE_WINDOW_STATE_CHANGED. A single event may represent multiple change types.
                intent.putExtra(
                    MotionEventReceiver.ACCESSIBILITY_CHANGES_TYPES,
                    accessibilityEvent.contentChangeTypes
                )
            }

            if (accessibilityEvent.text != null) {
                //Gets the text of this node.
                intent.putExtra(
                    MotionEventReceiver.ACCESSIBILITY_TEXT,
                    accessibilityEvent.text.toString()
                )
            }

            // Gets the node bounds in screen coordinates.
            if (parentNodeInfo != null) {
//                val packageName: String = parentNodeInfo.packageName.toString()
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    windowInfo = parentNodeInfo.window
                }


                val rect = Rect()
                parentNodeInfo.getBoundsInScreen(rect)
                intent.putExtra(
                    MotionEventReceiver.ACCESSIBILITY_SCREEN_BOUNDS,
                    getBoundingPoints(rect)
                )


                getNextTexts(parentNodeInfo, nextTexts)
            }

            //Gets the text of sub nodes.
            intent.putStringArrayListExtra(MotionEventReceiver.ACCESSIBILITY_NODES_TEXT, nextTexts as ArrayList<String?>)

            if (windowInfo != null) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    // Gets if this window is active.
                    intent.putExtra(MotionEventReceiver.ACCESSIBILITY_IS_ACTIVE, windowInfo.isActive)
                    // Gets if this window has input focus.
                    intent.putExtra(MotionEventReceiver.ACCESSIBILITY_IS_FOCUSED, windowInfo.isFocused)
                    // Gets the type of the window.
                    intent.putExtra(MotionEventReceiver.ACCESSIBILITY_WINDOW_TYPE, windowInfo.type)
                    // Check if the window is in picture-in-picture mode.
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        intent.putExtra(MotionEventReceiver.ACCESSIBILITY_IS_PIP, windowInfo.isInPictureInPictureMode)
                    }
                }
            }
            Log.i("onAccessibilityEvent - intent", intent.toString());

            sendBroadcast(intent)
        }
        catch (e: Exception) {
            Log.i("onAccessibilityEvent - error", e.toString());
        }


//
//
//        val actionType: Int = motionEvent.action
//        touchIntent.putExtra(IntentName.MOTIONACTION.name, actionType)
//
//        val x: Float = motionEvent.x
//        touchIntent.putExtra(IntentName.X.name, x)
//
//        val y: Float = motionEvent.y
//        touchIntent.putExtra(IntentName.Y.name, y)
//
//        val toolType: Int = motionEvent.getToolType(0) // set to 0 for one finger
//        touchIntent.putExtra(IntentName.TOOLTYPE.name, toolType)
//
//        val eventTime: Long = System.currentTimeMillis()
//        touchIntent.putExtra(IntentName.EVENTTIME.name, eventTime)


    }


    fun getNextTexts(node: AccessibilityNodeInfo?, arr: MutableList<String?>) {
        if (node!!.text != null && node!!.text.isNotEmpty()) arr.add(
            node!!.text.toString()
        )
        for (i in 0 until node.childCount) {
            val child: AccessibilityNodeInfo = node.getChild(i) ?: continue
            getNextTexts(child, arr)
        }
    }

    private fun getBoundingPoints(rect: Rect): HashMap<String, Int>? {
        val frame: HashMap<String, Int> = HashMap()
        frame["left"] = rect.left
        frame["right"] = rect.right
        frame["top"] = rect.top
        frame["bottom"] = rect.bottom
        frame["width"] = rect.width()
        frame["height"] = rect.height()
        return frame
    }

    override fun onInterrupt() {}
}