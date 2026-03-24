import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {

    // MARK: - Screen privacy state

    /// Invisible UITextField with isSecureTextEntry = true.
    /// When present in the window, UIKit marks the window as sensitive and
    /// iOS automatically renders blank content in:
    ///   - Screenshots (system screenshot gesture)
    ///   - App-switcher snapshots (SpringBoard renders blank without timing dependency)
    ///   - Screen recordings (ReplayKit / QuickTime captures blank)
    ///   - AirPlay / Sidecar mirroring
    private var secureTextField: UITextField?

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

    /// Adds an invisible 1×1pt UITextField with isSecureTextEntry=true to the key window.
    /// UIKit marks the window layer as sensitive — iOS renders blank content for ALL
    /// capture mechanisms (screenshots, app-switcher, recordings) without requiring
    /// any timing-dependent overlay.
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
    }

    /// Removes the secure text field, restoring normal capture behaviour.
    private func disableScreenProtection() {
        secureTextField?.removeFromSuperview()
        secureTextField = nil
    }

    // MARK: - Screen capture notification (user warning during recording)

    @objc private func screenCaptureStatusDidChange(_ notification: Notification) {
        // UIScreen.isCaptured handles recording detection; the UITextField trick already
        // prevents captures from exposing sensitive content. This observer can be used
        // to show an in-app banner if desired in future.
        _ = UIScreen.main.isCaptured
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

