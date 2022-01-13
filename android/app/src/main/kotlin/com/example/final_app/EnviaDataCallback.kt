package com.example.final_app

import io.flutter.plugin.common.MethodChannel

interface EnviaDataCallback {

    fun initialize(platform: MethodChannel)

    fun sendDataEvent(result: MethodChannel.Result, params: Map<String, String>)

}