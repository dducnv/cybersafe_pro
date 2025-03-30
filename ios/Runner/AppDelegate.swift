import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Ẩn nội dung ứng dụng khi chuyển sang nền
  override func applicationWillResignActive(_ application: UIApplication) {
    super.applicationWillResignActive(application)
    self.window.isHidden = true
  }
  
  // Hiển thị lại nội dung khi ứng dụng active
  override func applicationDidBecomeActive(_ application: UIApplication) {
    super.applicationDidBecomeActive(application)
    self.window.isHidden = false
  }
}
