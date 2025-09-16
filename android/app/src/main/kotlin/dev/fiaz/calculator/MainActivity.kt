package dev.fiaz.calculator

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private lateinit var playIntegrityHandler: PlayIntegrityHandler

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Initialize Play Integrity Handler
        playIntegrityHandler = PlayIntegrityHandler(this, this)
        playIntegrityHandler.registerWith(flutterEngine)
    }

    override fun onDestroy() {
        super.onDestroy()
        if (::playIntegrityHandler.isInitialized) {
            playIntegrityHandler.dispose()
        }
    }
}
