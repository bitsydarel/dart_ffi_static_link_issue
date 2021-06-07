import Flutter
import UIKit

public class SwiftDartFfiiStaticLinkIssuePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "dart_ffii_static_link_issue", binaryMessenger: registrar.messenger())
    let instance = SwiftDartFfiiStaticLinkIssuePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
