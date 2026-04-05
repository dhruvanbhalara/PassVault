import Flutter
import UIKit
import XCTest

@testable import Runner

class ScreenPrivacyTests: XCTestCase {

    var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }

    override func tearDown() {
        super.tearDown()
        appDelegate.disableScreenProtection()
    }

    // MARK: - Initial state

    func test_initialState_protectionIsDisabled() {
        XCTAssertFalse(appDelegate.isScreenProtectionEnabled)
    }

    func test_initialState_overlayIsHidden() {
        XCTAssertFalse(appDelegate.isRecordingOverlayVisible)
    }

    // MARK: - enableScreenProtection

    func test_enable_setsProtectionEnabled() {
        appDelegate.enableScreenProtection()
        XCTAssertTrue(appDelegate.isScreenProtectionEnabled)
    }

    func test_enable_addsSecureTextFieldToKeyWindow() {
        appDelegate.enableScreenProtection()
        let hasSecureField = appDelegate.keyWindow?.subviews.contains { $0 is UITextField } ?? false
        XCTAssertTrue(hasSecureField)
    }

    func test_enable_secureTextFieldHasSecureEntry() {
        appDelegate.enableScreenProtection()
        XCTAssertEqual(appDelegate.secureTextField?.isSecureTextEntry, true)
    }

    func test_enable_secureTextFieldIsInvisibleAndNonInteractive() {
        appDelegate.enableScreenProtection()
        let field = appDelegate.secureTextField
        XCTAssertNotNil(field)
        XCTAssertEqual(field!.alpha, 0)
        XCTAssertFalse(field!.isUserInteractionEnabled)
    }

    func test_enable_idempotent() {
        appDelegate.enableScreenProtection()
        let first = appDelegate.secureTextField

        appDelegate.enableScreenProtection()
        let second = appDelegate.secureTextField

        XCTAssertTrue(first === second)
        let fieldCount = appDelegate.keyWindow?.subviews.filter { $0 is UITextField }.count ?? 0
        XCTAssertEqual(fieldCount, 1)
    }

    // MARK: - disableScreenProtection

    func test_disable_clearsProtection() {
        appDelegate.enableScreenProtection()
        appDelegate.disableScreenProtection()
        XCTAssertFalse(appDelegate.isScreenProtectionEnabled)
    }

    func test_disable_removesSecureTextFieldFromWindow() {
        appDelegate.enableScreenProtection()
        appDelegate.disableScreenProtection()
        let hasField = appDelegate.keyWindow?.subviews.contains { $0 is UITextField } ?? false
        XCTAssertFalse(hasField)
    }

    func test_disable_withoutPriorEnable_isHarmless() {
        XCTAssertNoThrow(appDelegate.disableScreenProtection())
        XCTAssertFalse(appDelegate.isScreenProtectionEnabled)
    }

    func test_disable_hidesRecordingOverlay() {
        appDelegate.enableScreenProtection()
        appDelegate.showPrivacyOverlayWindow()
        appDelegate.disableScreenProtection()
        XCTAssertFalse(appDelegate.isRecordingOverlayVisible)
    }

    // MARK: - Recording overlay

    func test_showOverlay_createsWindow() {
        appDelegate.showPrivacyOverlayWindow()
        XCTAssertTrue(appDelegate.isRecordingOverlayVisible)
        appDelegate.hidePrivacyOverlayWindow()
    }

    func test_showOverlay_windowLevelAboveAlert() {
        appDelegate.showPrivacyOverlayWindow()
        XCTAssertGreaterThan(appDelegate.privacyOverlayWindow!.windowLevel, UIWindow.Level.alert)
        appDelegate.hidePrivacyOverlayWindow()
    }

    func test_showOverlay_idempotent() {
        appDelegate.showPrivacyOverlayWindow()
        let first = appDelegate.privacyOverlayWindow

        appDelegate.showPrivacyOverlayWindow()
        XCTAssertTrue(first === appDelegate.privacyOverlayWindow)
        appDelegate.hidePrivacyOverlayWindow()
    }

    func test_hideOverlay_removesWindow() {
        appDelegate.showPrivacyOverlayWindow()
        appDelegate.hidePrivacyOverlayWindow()
        XCTAssertFalse(appDelegate.isRecordingOverlayVisible)
    }

    func test_hideOverlay_whenNotVisible_isHarmless() {
        XCTAssertNoThrow(appDelegate.hidePrivacyOverlayWindow())
    }

    // MARK: - Screen capture notification

    func test_captureNotification_whenNotCaptured_hidesOverlay() {
        appDelegate.enableScreenProtection()
        appDelegate.showPrivacyOverlayWindow()

        // UIScreen.main.isCaptured == false in tests → overlay must be hidden
        NotificationCenter.default.post(
            name: UIScreen.capturedDidChangeNotification,
            object: UIScreen.main
        )

        XCTAssertFalse(appDelegate.isRecordingOverlayVisible)
    }

    func test_captureNotification_whenProtectionDisabled_doesNotShowOverlay() {
        NotificationCenter.default.post(
            name: UIScreen.capturedDidChangeNotification,
            object: UIScreen.main
        )
        XCTAssertFalse(appDelegate.isRecordingOverlayVisible)
    }

    // MARK: - MethodChannel

    func test_methodChannel_enableScreenProtection() {
        guard let messenger = appDelegate.screenPrivacyMessenger else { return }

        let channel = FlutterMethodChannel(
            name: "com.dhruvanbhalara.passvault/screen_privacy",
            binaryMessenger: messenger
        )
        let exp = expectation(description: "enable")
        channel.invokeMethod("enableScreenProtection", arguments: nil) { _ in exp.fulfill() }
        waitForExpectations(timeout: 3)
        XCTAssertTrue(appDelegate.isScreenProtectionEnabled)
    }

    func test_methodChannel_disableScreenProtection() {
        guard let messenger = appDelegate.screenPrivacyMessenger else { return }

        appDelegate.enableScreenProtection()
        let channel = FlutterMethodChannel(
            name: "com.dhruvanbhalara.passvault/screen_privacy",
            binaryMessenger: messenger
        )
        let exp = expectation(description: "disable")
        channel.invokeMethod("disableScreenProtection", arguments: nil) { _ in exp.fulfill() }
        waitForExpectations(timeout: 3)
        XCTAssertFalse(appDelegate.isScreenProtectionEnabled)
    }

    func test_methodChannel_unknownMethod_returnsNotImplemented() {
        guard let messenger = appDelegate.screenPrivacyMessenger else { return }

        let channel = FlutterMethodChannel(
            name: "com.dhruvanbhalara.passvault/screen_privacy",
            binaryMessenger: messenger
        )
        let exp = expectation(description: "not-implemented")
        var received: Any? = "not-set"
        channel.invokeMethod("nonExistentMethod", arguments: nil) { result in
            received = result
            exp.fulfill()
        }
        waitForExpectations(timeout: 3)
        XCTAssertTrue(received is FlutterError)
    }

    // MARK: - keyWindow

    func test_keyWindow_isNonNil() {
        XCTAssertNotNil(appDelegate.keyWindow)
    }
}
