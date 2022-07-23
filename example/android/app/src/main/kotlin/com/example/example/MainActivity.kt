package com.example.example
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES

class MainActivity: FlutterActivity() {

    companion object {
        const val CHANNEL_MICRO_APP = "flutter/micro_app/app/events"
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        val appEventChannelMessenger =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_MICRO_APP)

        MethodChannel(flutterEngine.dartExecutor,CHANNEL_MICRO_APP).setMethodCallHandler {
            call,result ->
            when (call.method) {
                "app_event" -> {
                    if (call.argument<String?>("name") == "js_to_android") {
                        val message = call.argument<String?>("payload")
                        Toast.makeText(this@MainActivity, message, Toast.LENGTH_SHORT).show()
                    } else if (call.argument<String?>("name") == "request_battery_level"){

                        val batteryLevel = getBatteryLevel()

                        if (batteryLevel != -1) {
                            val arguments: MutableMap<String, Any> = HashMap()
                            arguments["name"] = "response_battery_level"
                            arguments["payload"] = batteryLevel
                            arguments["channels"] =  listOf("response_battery_level")
                            appEventChannelMessenger.invokeMethod("app_event", arguments)
                        } else {
                            Toast.makeText(this@MainActivity, "ERROR", Toast.LENGTH_SHORT).show()
                        }
                    }
                } else -> {
                    println("not found method: ${call.method}")
                }
            }
        }
    }

    private fun getBatteryLevel(): Int {
        val batteryLevel: Int
        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
          val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
          batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
          val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
          batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        }
    
        return batteryLevel
      }
}