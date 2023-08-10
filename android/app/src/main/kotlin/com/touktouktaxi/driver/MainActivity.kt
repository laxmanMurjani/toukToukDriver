package com.touktouktaxi.driver

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.widget.Toast
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL = "com.example.my_flutter_app/native"
    private val DRAW_OVER_OTHER_APP_PERMISSION = 123

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method.equals("sayHello")) {
                    val message = "Hello from Java!"
                    Toast.makeText(this, "Method Sucess", Toast.LENGTH_SHORT).show()
                    askForSystemOverlayPermission()
                    result.success(message)
                } else if (call.method.equals("second")) {
                    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M || android.provider.Settings.canDrawOverlays(
                            this@MainActivity
                        )
                    ) {
                        startService(Intent(this@MainActivity, FloatingWidgetService::class.java))
                    } else {
                        errorToast()
                    }
                } else if (call.method.equals("closeMethod")) {
                    stopService(Intent(this@MainActivity, FloatingWidgetService::class.java))
                } else {
                    result.notImplemented()
                }
            }
    }


    private fun askForSystemOverlayPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !android.provider.Settings.canDrawOverlays(
                this
            )
        ) {

            //If the draw over permission is not available open the settings screen
            //to grant the permission.
            val intent = Intent(
                android.provider.Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:" + getPackageName())
            )
            startActivityForResult(intent, DRAW_OVER_OTHER_APP_PERMISSION)
        }
    }


     override fun onPause() {
        super.onPause()


        // To prevent starting the service if the required permission is NOT granted.
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M || android.provider.Settings.canDrawOverlays(
                this
            )
        ) {
            startService(Intent(this@MainActivity, FloatingWidgetService::class.java))
        } else {
            errorToast()
        }
    }


     override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == DRAW_OVER_OTHER_APP_PERMISSION) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                if (!android.provider.Settings.canDrawOverlays(this)) {
                    //Permission is not available. Display error text.
                    errorToast()
                    finish()
                }
            }
        } else {
            super.onActivityResult(requestCode, resultCode, data)
        }
    }

    private fun errorToast() {
        Toast.makeText(
            this,
            "Draw over other app permission not available. Can't start the application without the permission.",
            Toast.LENGTH_LONG
        ).show()
    }

}
