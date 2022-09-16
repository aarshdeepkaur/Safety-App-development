import UIKit
import Flutter
//for google maps
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    //gmaps api keys
    // TODO: replace this with the main one
    GMSServices.provideAPIKey("AIzaSyBmFqHSAlIBvcG4zSNNwZtAzwdpQn1RKoI")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
