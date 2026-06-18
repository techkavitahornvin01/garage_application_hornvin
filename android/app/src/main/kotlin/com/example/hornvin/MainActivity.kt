package com.example.hornvin

import android.content.ActivityNotFoundException
import android.content.ClipData
import android.content.ClipDescription
import android.content.ComponentName
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val channelName = "hornvin/whatsapp_share"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName
        ).setMethodCallHandler { call, result ->
            if (call.method != "shareFiles") {
                result.notImplemented()
                return@setMethodCallHandler
            }

            val text = call.argument<String>("text").orEmpty()
            val paths = call.argument<List<String>>("paths").orEmpty()
            result.success(openWhatsApp(text, paths))
        }
    }

    private fun openWhatsApp(text: String, paths: List<String>): Boolean {
        val uris = ArrayList<Uri>()
        paths.forEach { path ->
            val file = File(path)
            if (file.exists()) {
                uris.add(
                    FileProvider.getUriForFile(
                        this,
                        "${applicationContext.packageName}.fileprovider",
                        file
                    )
                )
            }
        }
        if (uris.isEmpty()) return false

        return startWhatsAppIntent("com.whatsapp", text, uris) ||
            startWhatsAppIntent("com.whatsapp.w4b", text, uris) ||
            startResolvedWhatsAppIntent(text, uris)
    }

    private fun startWhatsAppIntent(
        packageName: String,
        text: String,
        uris: ArrayList<Uri>
    ): Boolean {
        val intent = Intent(
            if (uris.size > 1) Intent.ACTION_SEND_MULTIPLE else Intent.ACTION_SEND
        ).apply {
            type = "*/*"
            setPackage(packageName)
            putExtra(Intent.EXTRA_TEXT, text)
            putExtra(Intent.EXTRA_MIME_TYPES, arrayOf("application/pdf"))
            if (uris.size > 1) {
                putParcelableArrayListExtra(Intent.EXTRA_STREAM, uris)
            } else {
                putExtra(Intent.EXTRA_STREAM, uris.first())
            }
            clipData = buildClipData(uris)
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }

        return try {
            uris.forEach { uri ->
                grantUriPermission(packageName, uri, Intent.FLAG_GRANT_READ_URI_PERMISSION)
            }
            startActivity(intent)
            true
        } catch (_: ActivityNotFoundException) {
            false
        } catch (_: Exception) {
            false
        }
    }

    private fun startResolvedWhatsAppIntent(text: String, uris: ArrayList<Uri>): Boolean {
        val baseIntent = buildShareIntent(text, uris)
        val activities = packageManager.queryIntentActivities(baseIntent, PackageManager.MATCH_DEFAULT_ONLY)
        val whatsAppActivity = activities.firstOrNull { info ->
            val packageName = info.activityInfo.packageName.lowercase()
            val activityName = info.activityInfo.name.lowercase()
            packageName.contains("whatsapp") || activityName.contains("whatsapp")
        } ?: return false

        val packageName = whatsAppActivity.activityInfo.packageName
        val intent = buildShareIntent(text, uris).apply {
            component = ComponentName(packageName, whatsAppActivity.activityInfo.name)
            setPackage(packageName)
        }

        return try {
            uris.forEach { uri ->
                grantUriPermission(packageName, uri, Intent.FLAG_GRANT_READ_URI_PERMISSION)
            }
            startActivity(intent)
            true
        } catch (_: Exception) {
            false
        }
    }

    private fun buildShareIntent(text: String, uris: ArrayList<Uri>): Intent {
        return Intent(
            if (uris.size > 1) Intent.ACTION_SEND_MULTIPLE else Intent.ACTION_SEND
        ).apply {
            type = "*/*"
            putExtra(Intent.EXTRA_TEXT, text)
            putExtra(Intent.EXTRA_MIME_TYPES, arrayOf("application/pdf"))
            if (uris.size > 1) {
                putParcelableArrayListExtra(Intent.EXTRA_STREAM, uris)
            } else if (uris.isNotEmpty()) {
                putExtra(Intent.EXTRA_STREAM, uris.first())
            }
            clipData = buildClipData(uris)
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }
    }

    private fun buildClipData(uris: ArrayList<Uri>): ClipData? {
        if (uris.isEmpty()) return null

        val clipData = ClipData(
            ClipDescription("Hornvin documents", arrayOf("application/pdf")),
            ClipData.Item(uris.first())
        )

        uris.drop(1).forEach { uri ->
            clipData.addItem(ClipData.Item(uri))
        }

        return clipData
    }
}
