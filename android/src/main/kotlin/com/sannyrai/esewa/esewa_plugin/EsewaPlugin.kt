package com.sannyrai.esewa.esewa_plugin

import android.app.Activity
import android.content.Intent
import androidx.annotation.NonNull
import com.esewa.android.sdk.payment.ESewaConfiguration
import com.esewa.android.sdk.payment.ESewaPayment
import com.esewa.android.sdk.payment.ESewaPaymentActivity
import com.google.gson.Gson
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry


/** EsewaPlugin */
class EsewaPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
        PluginRegistry.ActivityResultListener {
    private val requestPaymentCode: Int = 205

    private lateinit var activity: Activity

    private lateinit var channel: MethodChannel

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        TODO("Not yet implemented")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        activity.finish()
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "esewa_plugin")
        channel.setMethodCallHandler(this)
    }


    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "payWithEsewa" -> {
                val arguments = call.arguments as ArrayList<*>
                val merchantInfo = arguments.elementAt(0) as HashMap<*, *>
                val paymentInfo = arguments.elementAt(1) as HashMap<*, *>

                // merchant/client detail
                val clientId = merchantInfo["clientId"] as String
                val clientSecretKey = merchantInfo["clientSecret"] as String

                // app environment and callback url
                val callbackUrl = merchantInfo["callbackUrl"] as String
                val appEnvironment = merchantInfo["environment"] as String

                // payment detail
                val amount = paymentInfo["amount"] as String
                val productName = paymentInfo["productName"] as String
                val referenceId = paymentInfo["referenceId"] as String

                val eSewaConfiguration = ESewaConfiguration()
                eSewaConfiguration.clientId(clientId)
                eSewaConfiguration.secretKey(clientSecretKey)
                if (appEnvironment == "live") {
                    eSewaConfiguration.environment(ESewaConfiguration.ENVIRONMENT_PRODUCTION)
                } else {
                    eSewaConfiguration.environment(ESewaConfiguration.ENVIRONMENT_TEST)
                }

                val eSewaPayment =
                        ESewaPayment(amount, productName, referenceId, callbackUrl)
                val intent = Intent(activity, ESewaPaymentActivity::class.java)
                intent.putExtra(ESewaConfiguration.ESEWA_CONFIGURATION, eSewaConfiguration)

                intent.putExtra(ESewaPayment.ESEWA_PAYMENT, eSewaPayment)
                activity.startActivityForResult(intent, requestPaymentCode)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        println("requestCode: $requestCode")
        if (requestCode == requestPaymentCode) {
            println("resultCode: $resultCode")
            when (resultCode) {
                Activity.RESULT_OK -> {
                    val successMessage = data?.getStringExtra(ESewaPayment.EXTRA_RESULT_MESSAGE)
                    val gson = Gson()
                    val map = gson.fromJson(successMessage, MutableMap::class.java)
                    channel.invokeMethod("onSuccess", map)
                }
                Activity.RESULT_CANCELED -> {
                    channel.invokeMethod("onCancel", "Process cancelled by user.")
                }
                ESewaPayment.RESULT_EXTRAS_INVALID -> {
                    val errorMessage = data?.getStringExtra(ESewaPayment.EXTRA_RESULT_MESSAGE)
                    channel.invokeMethod("onError", errorMessage)
                }
            }
        } else {
            println("called outside")
        }
        return true
    }
}

