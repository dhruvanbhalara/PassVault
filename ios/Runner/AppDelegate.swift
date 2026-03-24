import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {

    // MARK: - Screen privacy state

    /// Invisible UITextField with isSecureTextEntry = true.
    /// When present in the window, UIKit marks the window as sensitive so iOS
    /// renders blank content for screenshots and app‑switcher snapshots.
    ///
    /// Note: iOS 17+ screen recording (ReplayKit / Control Centre) bypasses UIKit
    /// window sensitivity. A separate `privacyOverlayWindow` covers that case.
    private var secureTextField: UITextField?

    /// Full‑screen black UIWindow shown during active screen recording.
    /// Elevated window level ensures it appears above all Flutter content.
    private var privacyOverlayWindow: UIWindow?

    // MARK: - App lifecycle

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Observe screen-capture state changes for user-visible notification.
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

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
        GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
        setupScreenPrivacyChannel(engineBridge: engineBridge)
    }

    // MARK: - MethodChannel setup

    private func setupScreenPrivacyChannel(engineBridge: FlutterImplicitEngineBridge) {
        guard let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "ScreenPrivacy") else { return }

        let channel = FlutterMethodChannel(
            name: "com.dhruvanbhalara.passvault/screen_privacy",
            binaryMessenger: registrar.messenger()
        )

        channel.setMethodCallHandler { [weak self] call, result in
            DispatchQueue.main.async {
                switch call.method {
                case "enableScreenProtection":
                    self?.enableScreenProtection()
                    result(nil)
                case "disableScreenProtection":
                    self?.disableScreenProtection()
                    result(nil)
                default:
                    result(FlutterMethodNotImplemented)
                }
            }
        }
    }

    // MARK: - Screen protection (UITextField isSecureTextEntry trick)

    /// Adds an invisible 1×1pt UITextField with isSecureTextEntry=true to the key window
    /// (prevents screenshots and app‑switcher snapshots), and also shows the full‑screen
    /// overlay if a screen recording is already in progress.
    private func enableScreenProtection() {
        guard secureTextField == nil, let window = keyWindow else { return }

        let field = UITextField()
        field.isSecureTextEntry = true
        field.isUserInteractionEnabled = false
        field.alpha = 0

        window.addSubview(field)
        field.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            field.widthAnchor.constraint(equalToConstant: 1),
            field.heightAnchor.constraint(equalToConstant: 1),
            field.centerXAnchor.constraint(equalTo: window.centerXAnchor),
            field.centerYAnchor.constraint(equalTo: window.centerYAnchor),
        ])

        secureTextField = field

        // If recording is already active when protection is enabled, cover immediately.
        if UIScreen.main.isCaptured {
            showPrivacyOverlayWindow()
        }
    }

    /// Removes the secure text field, restoring normal capture behaviour.
    private func disableScreenProtection() {
        secureTextField?.removeFromSuperview()
        secureTextField = nil
        // Always hide the recording overlay when protection is turned off.
        hidePrivacyOverlayWindow()
    }

    // MARK: - Recording overlay (covers screen during active screen recording)

    /// Shows an opaque black window on top of all content while recording is active.
    private func showPrivacyOverlayWindow() {
        guard privacyOverlayWindow == nil else { return }

        let windowScene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }

        let overlay: UIWindow
        if let scene = windowScene {
            overlay = UIWindow(windowScene: scene)
        } else {
            overlay = UIWindow(frame: UIScreen.main.bounds)
        }

        overlay.windowLevel = .alert + 1
        overlay.backgroundColor = .black
        let vc = UIViewController()
        vc.view.backgroundColor = .black
        overlay.rootViewController = vc
        overlay.isHidden = false
        privacyOverlayWindow = overlay
    }

    private func hidePrivacyOverlayWindow() {
        privacyOverlayWindow?.isHidden = true
        privacyOverlayWindow = nil
    }

    // MARK: - Screen capture notification (overlay during recording)

    @objc private func screenCaptureStatusDidChange(_ notification: Notification) {
        guard UIScreen.main.isCaptured else {
            // Recording stopped — always hide overlay.
            hidePrivacyOverlayWindow()
            return
        }
        // Recording started — show overlay only when protection is enabled.
        if secureTextField != nil {
            showPrivacyOverlayWindow()
        }
    }

    // MARK: - External display detection

    @objc private func externalDisplayDidConnect(_ notification: Notification) {
        guard UIScreen.screens.count > 1 else { return }
        showExternalDisplayWarning()
    }

    // MARK: - Helpers

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

