import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {

    // MARK: - Screen privacy state

    var secureTextField: UITextField?
    var privacyOverlayWindow: UIWindow?

    /// `true` when screen protection is active.
    var isScreenProtectionEnabled: Bool { secureTextField != nil }

    /// `true` when the recording-overlay window is visible.
    var isRecordingOverlayVisible: Bool { privacyOverlayWindow != nil }

    /// Messenger for the screen-privacy MethodChannel; set during engine init.
    private(set) var screenPrivacyMessenger: FlutterBinaryMessenger?

    // MARK: - App lifecycle

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(screenCaptureStatusDidChange),
            name: UIScreen.capturedDidChangeNotification,
            object: nil
        )
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

    // MARK: - MethodChannel

    private func setupScreenPrivacyChannel(engineBridge: FlutterImplicitEngineBridge) {
        guard let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "ScreenPrivacy") else { return }

        let messenger = registrar.messenger()
        screenPrivacyMessenger = messenger

        let channel = FlutterMethodChannel(
            name: "com.dhruvanbhalara.passvault/screen_privacy",
            binaryMessenger: messenger
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

    // MARK: - Screen protection

    /// Adds an invisible secure UITextField to mark the window as sensitive.
    /// UIKit prevents screenshots and app-switcher snapshots while it is present.
    func enableScreenProtection() {
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

        if UIScreen.main.isCaptured {
            showPrivacyOverlayWindow()
        }
    }

    func disableScreenProtection() {
        secureTextField?.removeFromSuperview()
        secureTextField = nil
        hidePrivacyOverlayWindow()
    }

    // MARK: - Recording overlay

    /// Shows an opaque black overlay above all content during screen recording.
    func showPrivacyOverlayWindow() {
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

    func hidePrivacyOverlayWindow() {
        privacyOverlayWindow?.isHidden = true
        privacyOverlayWindow = nil
    }

    // MARK: - Notifications

    @objc private func screenCaptureStatusDidChange(_ notification: Notification) {
        guard UIScreen.main.isCaptured else {
            hidePrivacyOverlayWindow()
            return
        }
        if secureTextField != nil {
            showPrivacyOverlayWindow()
        }
    }

    @objc private func externalDisplayDidConnect(_ notification: Notification) {
        guard UIScreen.screens.count > 1 else { return }
        showExternalDisplayWarning()
    }

    // MARK: - Helpers

    var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow })
        }
        return UIApplication.shared.keyWindow
    }

    func showExternalDisplayWarning() {
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
