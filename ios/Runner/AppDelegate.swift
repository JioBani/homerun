import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    //TODO Local Notification 설정 필요
    // https://totally-developer.tistory.com/88
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
