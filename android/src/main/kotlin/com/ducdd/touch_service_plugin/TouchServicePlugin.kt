package com.ducdd.touch_service_plugin

/** TouchServicePlugin */

import Point
import TouchApi
import android.app.Activity
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.provider.Settings
import android.text.TextUtils
import android.util.Log
import androidx.annotation.NonNull
import com.ducdd.touch_service_plugin.AccessibilityServicePlugin.Companion.SWIPE
import com.ducdd.touch_service_plugin.AccessibilityServicePlugin.Companion.TOUCH
import com.ducdd.touch_service_plugin.AccessibilityServicePlugin.Companion.TOUCH_EXPLORATION
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry


/** FlutterTouchInteractionControllerPlugin */
class TouchServicePlugin : FlutterPlugin, TouchApi, PluginRegistry.ActivityResultListener,
    EventChannel.StreamHandler,
    ActivityAware {

    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var _context: Context? = null
    private var _activity: Activity? = null

    private val EVENT_CHANNEL_NAME = "dev.flutter.pigeon.TouchApi/touchEventChannel"

    private var motionReceiver: MotionEventReceiver? = null

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        _context = binding.applicationContext;
        Log.i("PLUGIN", "onAttachedToEngine touch service plugin");
        TouchApi.setUp(binding.binaryMessenger, this)

        eventChannel = EventChannel(binding.binaryMessenger, EVENT_CHANNEL_NAME)
        eventChannel.setStreamHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.i("PLUGIN", "onDetachedFromEngine touch service plugin");
        TouchApi.setUp(binding.binaryMessenger, null)
        eventChannel.setStreamHandler(null);
    }

    override fun isPermissionGranted(): Boolean {
        return isAccessibilityPermissionEnabled(_context!!)
    }

    override fun requestPermission() {
        val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        _context!!.startActivity(intent);
    }

    override fun touch(point: Point) {
        val position = FloatArray(2)
        position[0] = point.x.toFloat()
        position[1] = point.y.toFloat()

        val intent = Intent(_context, AccessibilityServicePlugin::class.java)
        intent.putExtra(TOUCH, position)
        _context!!.startService(intent).runCatching { true }.getOrElse { false }
    }

    override fun swipe(startPoint: Point, endPoint: Point) {
        val position = FloatArray(4)
        position[0] = startPoint.x.toFloat()
        position[1] = startPoint.y.toFloat()
        position[2] = endPoint.x.toFloat()
        position[3] = endPoint.y.toFloat()

        val intent = Intent(_context, AccessibilityServicePlugin::class.java)
        intent.putExtra(SWIPE, position)
        _context!!.startService(intent).runCatching { true }.getOrElse { false }
    }

    private fun isAccessibilityPermissionEnabled(context: Context): Boolean {
        val expectedComponentName = ComponentName(context, AccessibilityServicePlugin::class.java)

        val enabledServicesSetting: String =
            Settings.Secure.getString(
                context.contentResolver,
                Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES
            )
                ?: return false

        val colonSplitter = TextUtils.SimpleStringSplitter(':')
        colonSplitter.setString(enabledServicesSetting)

        while (colonSplitter.hasNext()) {
            val componentNameString = colonSplitter.next()
            val enabledService = ComponentName.unflattenFromString(componentNameString)
            if (enabledService != null && enabledService == expectedComponentName) return true
        }

        return false
    }

    private fun requestTouchExploration(status: Boolean) {
        val intent = Intent(_context, AccessibilityServicePlugin::class.java)
//        intent.putExtra(TOUCH_EXPLORATION, status)
        _context!!.startService(intent)
        Log.i("TouchServicePlugin", "Started the accessibility tracking service.");
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        TODO("Not yet implemented")
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        if (isAccessibilityPermissionEnabled(_context!!)) {
            /// Set up receiver
            val intentFilter = IntentFilter()
            intentFilter.addAction(MotionEventReceiver.ACCESSIBILITY_INTENT)
            motionReceiver = MotionEventReceiver(events!!)
            _context!!.registerReceiver(motionReceiver, intentFilter)

            /// Set up listener intent
            // requestTouchExploration(false);
            val intent = Intent(_context, AccessibilityServicePlugin::class.java)
            _context!!.startService(intent)
            Log.i("TouchServicePlugin", "Started the accessibility tracking service.");
        }
    }

    override fun onCancel(arguments: Any?) {
        _context!!.unregisterReceiver(motionReceiver);
        motionReceiver = null;
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        _activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        _activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        _activity = null
    }
}