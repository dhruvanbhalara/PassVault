import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {

    // MARK: - Privacy overlay (screen recording / AirPlay / Sidecar)

    /// Solid-black overlay shown while screen recording or mirroring is active.
    /// App-switcher protection is handled on the Dart side via AppLifecycleListener.
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

        let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)

        // If the app is launched while a capture is already active, apply overlay immediately.
        if UIScreen.main.isCaptured {
            showPrivacyOverlay()
        }

        return result
    }

    func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
        GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
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
        guard UIScreen.screens.count > 1 else { return }
        showExternalDisplayWarning()
    }

    // MARK: - Overlay helpers

    /// Returns the current key window, compatible with iOS 13+ scene-based apps
    /// and the legacy FlutterImplicitEngineBridge window setup.
    private var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow })
        }
        return UIApplication.shared.keyWindow
    }

    private func showPrivacyOverlay() {
        guard privacyOverlay == nil, let window = keyWindow else { return }

        let overlay = UIView(frame: window.bounds)
        overlay.backgroundColor = .black
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        window.addSubview(overlay)
        window.bringSubviewToFront(overlay)
        privacyOverlay = overlay
    }

    private func hidePrivacyOverlay() {
        privacyOverlay?.removeFromSuperview()
        privacyOverlay = nil
    }

    private func showExternalDisplayWarning() {
        guard let rootVC = keyWindow?.rootViewController else { return }
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

