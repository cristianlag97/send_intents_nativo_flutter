package com.example.final_app

import android.annotation.SuppressLint
import org.json.JSONArray
import org.json.JSONObject
import java.text.SimpleDateFormat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import java.util.*
import android.content.Intent

class EnviaData(
        private val activity: FlutterActivity
) : EnviaDataCallback {

    private lateinit var platform: MethodChannel
    private val event: ExecutorService = Executors.newFixedThreadPool(1)
    private val lock = Object()
    private var status: String = "NEW"

    override fun initialize(platform: MethodChannel) {
        this.platform = platform
        platform.setMethodCallHandler {call, result ->
            event.submit {
                synchronized(lock) {
                    try {
                        this.status = "SENDDATA_AWAIT"
                        when (call.method) {
                            "sendDataEvent" -> this.sendDataEvent(result, call.arguments as Map<String, String>)
                        }
                        this.status = "SENDDATA_ENDED"
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }
                }
            }
        }
    }

    public override fun sendDataEvent(result: MethodChannel.Result, params: Map<String, String>) {
        val merchantCode = if (params["merchantCode"] != null) {
            params["merchantCode"] as String
        } else {
            null
        }
        val tipoTarjeta = params["tipoTarjeta"] as String
        val valorDeTarjeta = params["valorDeTarjeta"] as String
        val valor = params["valor"] as String
        val packageName = params["packageName"] as String
        val email = params["email"] as String
        val password = params["password"] as String

        println("EVENT SENDDATA!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! merchant: $merchantCode... Tipo de Tarjeta: $tipoTarjeta... valor de Tarjeta: $valorDeTarjeta... valor: $valor... packageName: $packageName... email: $email... password: $password")
        try {
            val list = listOf(merchantCode,valor,tipoTarjeta, valorDeTarjeta, packageName, email, password )
            val message = list.joinToString(separator = ",")
            val sendIntent = Intent().apply {
                action = Intent.ACTION_SEND
                putExtra(Intent.EXTRA_TEXT, message)
                type = "text/plain"
                `package` = "com.example.example"
            };

            if(sendIntent.resolveActivity(activity.packageManager) != null)
                activity.startActivity(sendIntent)

            println("Teting send ============================================================================>")
            println("Si envía")
        } catch (ex: Exception){
            println(ex.message);
        }
    }

}