//
//  AppDelegate.swift
//  HapticDance
//
//  Created by Isabella Gomez on 11/16/23.
//

import Firebase
//import FirebaseAuth
import FirebaseCore
//import FirebaseFirestone
import FirebaseMessaging
import UserNotifications
import UIKit
import CoreHaptics
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var supportsHaptics: Bool = true
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Configure push notifications
        FirebaseApp.configure()

        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, _ in guard success else {
            return
        }
            print("Success in APNS registry")
        }

        application.registerForRemoteNotifications()

        // Stop screen from sleeping
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Check if the device supports haptics.
        let hapticCapability = CHHapticEngine.capabilitiesForHardware()
        supportsHaptics = hapticCapability.supportsHaptics
        
        return true
    }


    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, _ in
            guard let token = token else {
                return
            }
            print("Token: \(token)")
        }
    }
    
    // Handle foreground notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        let userInfo = notification.request.content.userInfo
        // Process your "start time" data here
        if let startTime = userInfo["startTime"] as? String {
            // Trigger the action based on start time
            print(startTime)
            
            let info = startTime.split(separator: ",")
            let time = String(info[0])
            let piece = String(info[1])
            
            scheduleAction(time: time, piece: piece)
        }
        
        // Since you're using the notification to send data, you might not need to present the notification
        completionHandler([])
    }

    // Handle background notifications
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let startTime = userInfo["startTime"] as? String {
            // Trigger the action based on start time
            print(startTime)
            
            let info = startTime.split(separator: ",")
            let time = String(info[0])
            let piece = String(info[1])
            
            scheduleAction(time: time, piece: piece)
        }
        
        // Since you're using the notification to send data, you might not need to present the notification
        completionHandler(.newData)
    }
    
    
    
    // Set timer to play AHAP file
    private func scheduleAction(time: String, piece: String) {
        print(time)
        print(piece)
        
        // grab selected dancer from ViewController
        var ViewController = ViewController()
//        let dancerMain = ViewController.dancerMain
        
        let dancerMain = ViewController.segDancersMain.selectedSegmentIndex
        print(dancerMain)
        
//        let file = "AHAP/Choreos/" + piece + "_p" + dancerMain
//        print(file)
//        ViewController.playHapticsFile(named: file)
        
        // change time format
//        let start = "23, Nov 27, " + time
//        let DateFormatter = DateFormatter()
//        DateFormatter.dateFormat = "YY, MMM dd, hh:mm"
//        let sttime = DateFormatter.date(from: start)!
//        print(sttime)
        
        // set timer to play ahap file
//        let timer = Timer(fireAt: sttime, interval: 0, target: self, selector: #selector(playAHAP), userInfo: nil, repeats: false)
    }

}
