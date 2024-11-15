import Flutter
import AVFAudio
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      // 配置音频会话
//          do {
//            var audioSession = AVAudioSession.sharedInstance()
//            try audioSession.setCategory(.playback, mode:.default, options: [.mixWithOthers])
//            try audioSession.setActive(true)
//          } catch {
//            print("设置音频会话出错: \(error)")
//          }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
