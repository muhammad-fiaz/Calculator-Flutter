package dev.fiaz.calculator

import android.app.Activity
import android.content.Context
import android.util.Log
import com.google.android.gms.tasks.Task
import com.google.android.gms.tasks.Tasks
import com.google.android.play.core.integrity.IntegrityManagerFactory
import com.google.android.play.core.integrity.IntegrityTokenRequest
import com.google.android.play.core.integrity.IntegrityTokenResponse
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException
import kotlin.coroutines.suspendCoroutine

// Extension function to convert Task to suspend function
suspend fun <T> Task<T>.await(): T = suspendCoroutine { continuation ->
    addOnCompleteListener { task ->
        if (task.isSuccessful) {
            continuation.resume(task.result)
        } else {
            continuation.resumeWithException(task.exception ?: RuntimeException("Unknown error"))
        }
    }
}

class PlayIntegrityHandler(
    private val context: Context,
    private val activity: Activity
) : MethodChannel.MethodCallHandler {

    companion object {
        private const val TAG = "PlayIntegrityHandler"
        private const val CHANNEL_NAME = "play_integrity"
    }

    private val integrityManager = IntegrityManagerFactory.create(context)
    private lateinit var methodChannel: MethodChannel

    fun registerWith(flutterEngine: FlutterEngine) {
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
        methodChannel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "requestIntegrityVerdict" -> {
                requestIntegrityVerdict(result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun requestIntegrityVerdict(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                // Create integrity token request
                val integrityTokenResponse = suspendCoroutine { continuation ->
                    val integrityTokenTask = integrityManager
                        .requestIntegrityToken(
                            IntegrityTokenRequest.builder()
                                .setNonce("your-nonce-here") // You should generate a proper nonce
                                .build()
                        )

                    integrityTokenTask.addOnSuccessListener { response ->
                        continuation.resume(response)
                    }.addOnFailureListener { exception ->
                        continuation.resumeWithException(exception)
                    }
                }

                // Decrypt and verify the token on your server
                // For now, we'll return basic information
                val token = integrityTokenResponse.token()

                // In a real implementation, you would send this token to your server
                // for verification and get back the decoded integrity verdict
                val mockVerdict = mapOf(
                    "token" to token,
                    "deviceIntegrity" to "MEETS_BASIC_INTEGRITY", // Mock response
                    "appRecognitionVerdict" to "PLAY_RECOGNIZED",
                    "requestHash" to "mock-hash",
                    "packageName" to context.packageName,
                    "timestampMillis" to System.currentTimeMillis().toString()
                )

                withContext(Dispatchers.Main) {
                    result.success(mockVerdict)
                }

            } catch (e: Exception) {
                Log.e(TAG, "Error requesting integrity verdict", e)
                withContext(Dispatchers.Main) {
                    result.error("INTEGRITY_ERROR", e.message, null)
                }
            }
        }
    }

    fun dispose() {
        if (::methodChannel.isInitialized) {
            methodChannel.setMethodCallHandler(null)
        }
    }
}