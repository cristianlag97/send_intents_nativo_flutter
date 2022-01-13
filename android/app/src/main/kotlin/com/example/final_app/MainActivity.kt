package com.example.final_app

import io.flutter.plugin.common.ActivityLifecycleListener
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugins.GeneratedPluginRegistrant
import androidx.annotation.NonNull
import java.nio.ByteBuffer
import java.io.BufferedReader
import java.io.InputStreamReader
import android.content.Intent
import android.os.Bundle
import android.os.PersistableBundle
import android.annotation.SuppressLint

class MainActivity: FlutterActivity() {



    private val sendData: EnviaDataCallback = EnviaData(this)

    companion object {
        private const val CHANNEL_SENDDATA = "com.example.send_data_intents/sendData"
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        initializeSendDataChannel(flutterEngine)

    }

    override fun onRequestPermissionsResult(
            requestCode: Int,
            permissions: Array<out String>,
            grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }


    private fun initializeSendDataChannel(flutterEngine: FlutterEngine) {
        println("SENDDATA SDK --> Initialized")
        val platform = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_SENDDATA)
        sendData.initialize(platform)
    }

}
