import Flutter
import UIKit
import GoogleMaps
import FirebaseMessaging
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
  private func pushLog(_ message: String) {
    let line = "[PUSH_IOS] \(message)"
    print(line)
    NSLog("%@", line)
  }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    pushLog("didFinishLaunching started")
    GMSServices.provideAPIKey("AIzaSyAa5p3GlJAlUHr6Tm6ePW-IhhEPocFnHzc")
    GeneratedPluginRegistrant.register(with: self)

    // Register for remote notifications so APNS token is forwarded to FCM
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      pushLog("UNUserNotificationCenter delegate attached")
    }
    Messaging.messaging().delegate = self
    pushLog("Firebase Messaging delegate attached")
    application.registerForRemoteNotifications()
    pushLog("registerForRemoteNotifications called")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Forward APNS token to Firebase Messaging
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    pushLog("APNS didRegisterForRemoteNotifications tokenBytes=\(deviceToken.count)")
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  override func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    pushLog("APNS didFailToRegisterForRemoteNotifications error=\(error.localizedDescription)")
    super.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
  }

  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    if let token = fcmToken, !token.isEmpty {
      pushLog("Firebase Messaging registration token len=\(token.count)")
    } else {
      pushLog("Firebase Messaging registration token is empty")
    }
  }
}
