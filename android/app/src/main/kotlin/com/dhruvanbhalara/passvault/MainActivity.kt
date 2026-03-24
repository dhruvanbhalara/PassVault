package com.dhruvanbhalara.passvault

import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // Apply FLAG_SECURE before super.onCreate() attaches the Flutter surface.
        // This prevents screenshots, screen recordings, and screen sharing from
        // capturing any vault content across the entire app lifecycle.
        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
        super.onCreate(savedInstanceState)
    }
}
