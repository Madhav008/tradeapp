package live.fanxange.app

import android.content.Intent
import android.net.Uri
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class   MainActivity: FlutterActivity() {
    private val CHANNEL = "live.fanxange.app/channel"

        // Inside MainActivity or your main Flutter activity
        override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
            super.configureFlutterEngine(flutterEngine)
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "live.fanxange.app/channel").setMethodCallHandler {
                // Note: this method is invoked on the main thread.
                call, result ->
                if (call.method == "launchAppByPackageName") {
                    val packageName = call.argument<String>("packageName")
                    launchApp(packageName, result)
                } else {
                    result.notImplemented()
                }
            }
        }

        private fun launchApp(packageName: String?, result: MethodChannel.Result) {
            packageName?.let {
                val launchIntent = packageManager.getLaunchIntentForPackage(it)
                if (launchIntent != null) {
                    startActivity(launchIntent)
                    result.success(null)
                } else {
                    result.error("UNAVAILABLE", "App not installed", null)
                }
            }
        }
}

