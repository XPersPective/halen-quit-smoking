package com.crazypenguin.halenquitsmoking

import android.provider.Settings
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.crazypenguin.halen/trial",
        ).setMethodCallHandler { call, result ->
            if (call.method != "androidId") {
                result.notImplemented()
                return@setMethodCallHandler
            }

            val androidId = Settings.Secure.getString(
                contentResolver,
                Settings.Secure.ANDROID_ID,
            )
            if (androidId.isNullOrBlank()) {
                result.error("unavailable", "Device identifier is unavailable", null)
            } else {
                result.success(androidId)
            }
        }
    }
}
