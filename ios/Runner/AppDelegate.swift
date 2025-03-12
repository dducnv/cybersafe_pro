import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.cybersafe_pro/secure_app", binaryMessenger: controller.binaryMessenger)
    
    channel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      switch call.method {
      case "blockScreenshots":
        // Ngăn chặn chụp màn hình trên iOS
        if #available(iOS 13.0, *) {
          let scene = UIApplication.shared.connectedScenes.first
          if let windowScene = scene as? UIWindowScene {
            windowScene.windows.first?.makeSecure(true)
          }
        } else {
          // Fallback cho iOS < 13
          UIApplication.shared.windows.first?.makeSecure(true)
        }
        result(true)
        
      case "allowScreenshots":
        // Cho phép chụp màn hình trên iOS
        if #available(iOS 13.0, *) {
          let scene = UIApplication.shared.connectedScenes.first
          if let windowScene = scene as? UIWindowScene {
            windowScene.windows.first?.makeSecure(false)
          }
        } else {
          // Fallback cho iOS < 13
          UIApplication.shared.windows.first?.makeSecure(false)
        }
        result(true)
        
      default:
        result(FlutterMethodNotImplemented)
      }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

// Extension để thêm phương thức makeSecure cho UIWindow
extension UIWindow {
  func makeSecure(_ secure: Bool) {
    if secure {
      // Ngăn chặn chụp màn hình và ghi màn hình
      self.windowLevel = .statusBar + 1
    } else {
      // Cho phép chụp màn hình và ghi màn hình
      self.windowLevel = .normal
    }
  }
}