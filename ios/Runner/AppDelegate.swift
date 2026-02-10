import Flutter
import UIKit
import GoogleMaps   // ✅ must be imported

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // ✅ Register Flutter plugins
    GeneratedPluginRegistrant.register(with: self)

    // ✅ Google Maps API Key
    GMSServices.provideAPIKey("AIzaSyDdTSK2ZYsXBQMa-PnFx4BHRfE5RIM0uNs")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

//import Flutter
//import UIKit
//// import GoogleMaps
//
//
//@main
//@objc class AppDelegate: FlutterAppDelegate {
//  override func application(
//    _ application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//  ) -> Bool {
//    GeneratedPluginRegistrant.register(with: self)
//   
//    // GMSServices.provideAPIKey("AIzaSyDdTSK2ZYsXBQMa-PnFx4BHRfE5RIM0uNs")
//    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//  }
//}
