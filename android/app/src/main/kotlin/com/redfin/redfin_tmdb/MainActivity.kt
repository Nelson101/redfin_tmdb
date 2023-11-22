package com.redfin.redfin_tmdb

import io.flutter.embedding.android.FlutterActivity

// import FlutterEngine and MethodChannel
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    // add flavor method
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "flavor").setMethodCallHandler { call, result ->
            result.success(BuildConfig.FLAVOR)
        }
    }
}
