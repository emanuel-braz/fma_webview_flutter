package com.example.example
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {

    companion object {
        const val CHANNEL_MICRO_APP = "flutter/micro_app/app/events"
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        MethodChannel(flutterEngine.dartExecutor,CHANNEL_MICRO_APP).setMethodCallHandler {
            call,result ->
            when (call.method) {
                "app_event" -> {
                    if (call.argument<String?>("name") == "js_to_android") {
                        
                        val message = call.argument<String?>("payload")
                        Toast.makeText(this@MainActivity, message, Toast.LENGTH_SHORT).show()
                    }
                } else -> {
                    println("not found method: ${call.method}")
                }
            }
        }
    }
}