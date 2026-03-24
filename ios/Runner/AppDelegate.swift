import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {

    // MARK: - Privacy overlay

    /// Solid-black overlay shown during screen recording, mirroring,
    /// or when the app moves to the background (app-switcher protection).
    private var privacyOverlay: UIView?

    // MARK: - App lifecycle

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Observe screen-capture state changes (recording + AirPlay/Sidecar).
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(screenCaptureStatusDidChange),
            name: UIScreen.capturedDidChangeNotification,
            object: nil
        )

        // Observe external display connect / disconnect.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(externalDisplayDidConnect),
            name: UIScreen.didConnectNotification,
            object: nil
        )

        // If the app is launched while a capture is already active, apply overlay immediately.
        if UIScreen.main.isCaptured {
            showPrivacyOverlay()
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
        GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    }

    // MARK: - App-switcher protection

    /// Called just before the app moves to the background.
    /// iOS takes its app-switcher snapshot during this window, so we cover the UI.
    override func applicationWillResignActive(_ application: UIApplication) {
        showPrivacyOverlay()
        super.applicationWillResignActive(application)
    }

    /// Called when the app returns to the foreground.
    override func applicationDidBecomeActive(_ application: UIApplication) {
        super.applicationDidBecomeActive(application)
        // Only remove the overlay if screen is no longer captured.
        if !UIScreen.main.isCaptured {
            hidePrivacyOverlay()
        }
    }

    // MARK: - Screen capture detection

    /// Fires whenever `UIScreen.isCaptured` changes on any screen.
    @objc private func screenCaptureStatusDidChange(_ notification: Notification) {
        if UIScreen.main.isCaptured {
            showPrivacyOverlay()
        } else {
            hidePrivacyOverlay()
        }
    }

    // MARK: - External display detection

    @objc private func externalDisplayDidConnect(_ notification: Notification) {
        // If more than the built-in screen is connected, warn the user.
        guard UIScreen.screens.count > 1 else { return }
        showExternalDisplayWarning()
    }

    // MARK: - Overlay helpers

    private func showPrivacyOverlay() {
        guard privacyOverlay == nil else { return }
        guard let window = self.window else { return }

        let overlay = UIView(frame: window.bounds)
        overlay.backgroundColor = .black
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Place above all other subviews including Flutter's surface.
        window.addSubview(overlay)
        privacyOverlay = overlay
    }

    private func hidePrivacyOverlay() {
        privacyOverlay?.removeFromSuperview()
        privacyOverlay = nil
    }

    private func showExternalDisplayWarning() {
        // Find the topmost presented view controller to present the alert.
        guard let rootVC = window?.rootViewController else { return }
        var topVC = rootVC
        while let presented = topVC.presentedViewController {
            topVC = presented
        }

        let alert = UIAlertController(
            title: "External Display Detected",
            message: "PassVault has detected an untrusted external display. Vault content may be visible on the connected screen. Disconnect it to ensure your data remains private.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        topVC.present(alert, animated: true)
    }
}
