package com.perikopico.fiestapp

import android.content.Intent
import android.net.Uri
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.perikopico.fiestapp/deep_link"
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Canal para comunicar deep links a Flutter
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getInitialLink") {
                val intent = intent
                val deepLink = if (intent != null && Intent.ACTION_VIEW == intent.action) {
                    intent.data?.toString()
                } else {
                    null
                }
                result.success(deepLink)
            } else {
                result.notImplemented()
            }
        }
        
        // Manejar deep links cuando el engine ya está configurado
        handleDeepLink(intent)
    }
    
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleDeepLink(intent)
    }
    
    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        handleDeepLink(intent)
    }
    
    private fun handleDeepLink(intent: Intent?) {
        if (intent != null && Intent.ACTION_VIEW == intent.action) {
            val data = intent.data
            if (data != null && data.scheme == "io.supabase.fiestapp") {
                Log.d("MainActivity", "Deep link recibido: ${data.toString()}")
                // El deep link será procesado automáticamente por Supabase Flutter
                // pero también lo registramos para debugging
            }
        }
    }
}
