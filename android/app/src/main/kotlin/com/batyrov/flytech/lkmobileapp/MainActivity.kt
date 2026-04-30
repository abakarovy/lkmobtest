package com.batyrov.flytech.lkmobileapp

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import androidx.annotation.NonNull
import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.net.Uri
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.ByteArrayOutputStream

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "sbp").setMethodCallHandler(MyMethodCallHandler(this))
    }

}


class MyMethodCallHandler(val context: Context) : MethodCallHandler {

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getInstalledBanks" -> {
                val pm: PackageManager = context.applicationContext.packageManager
                val installedApplications =
                    pm.getInstalledApplications(PackageManager.GET_META_DATA)

                val applicationPackageNames =
                    call.argument<List<String>>("application_package_names")!!
                val useAndroidLocalIcons =
                    call.argument<Boolean>("use_android_local_icons")!!
                val useAndroidLocalNames =
                    call.argument<Boolean>("use_android_local_names")!!

                val installedBanks = mutableListOf<Map<String, Any?>>()

                for (installedApplication in installedApplications) {
                    for (applicationPackageName in applicationPackageNames) {
                        if (installedApplication.packageName == applicationPackageName) {
                            var name:CharSequence? = null;
                            var byteArray: ByteArray? = null;
                            if(useAndroidLocalNames){
                                name = pm.getApplicationLabel(installedApplication)
                            }
                            if(useAndroidLocalIcons) {
                                val icon = installedApplication.loadIcon(pm)
                                val bitmap: Bitmap = if (icon is BitmapDrawable) {
                                    icon.bitmap
                                } else {
                                    val bitmap = Bitmap.createBitmap(
                                        icon.intrinsicWidth,
                                        icon.intrinsicHeight,
                                        Bitmap.Config.ARGB_8888
                                    )
                                    val canvas = Canvas(bitmap)
                                    icon.setBounds(0, 0, canvas.width, canvas.height)
                                    icon.draw(canvas)
                                    bitmap
                                }
                                val stream = ByteArrayOutputStream()
                                bitmap.compress(Bitmap.CompressFormat.PNG,100,stream)
                                byteArray = stream.toByteArray()
                            }
                            installedBanks.add(
                                mapOf(
                                    "package_name" to installedApplication.packageName,
                                    "name" to name?.toString(),
                                    "bitmap" to byteArray
                                )
                            )
                        }
                    }
                }
                result.success(installedBanks)
            }
            "openBank" -> {
                val packageName = call.argument<String>("package_name")!!
                val url = call.argument<String>("url")!!
                try {
                    val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    intent.setPackage(packageName)
                    context.startActivity(intent)
                    result.success(true)
                } catch (exception: java.lang.Exception) {
                    result.error(exception.localizedMessage, exception.message, "sbp")
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }
}