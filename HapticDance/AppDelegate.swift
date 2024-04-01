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
    
    weak var viewController: ViewController?
    
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
        
        // Set up to get info from ViewController
        if let rootViewController = window?.rootViewController as? ViewController? {
            viewController = rootViewController
        }
        
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
    
    
    
    // set timer to play AHAP file
    private func scheduleAction(time: String, piece: String) {
        print(time)
        print(piece)
        
        if let viewController = viewController {
            
            // grab selected dancer from ViewController
            let dancerMain = viewController.dancerMain
            print(dancerMain)
            
            // set ahap file name
            let file = "AHAP/Choreos/" + piece + "_p" + dancerMain
            print(file)
            
            // set start time
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

            if let scheduledTime = dateFormatter.date(from: time) {
                print("Scheduled Time: \(scheduledTime)")

                // You can use scheduledTime here as needed
//                let file = "AHAP/Choreos/" + piece + "_p" + dancerMain
//                print("File: \(file)")

                // Schedule a timer to playHapticsFile at the scheduled time
                let timer = Timer(fireAt: scheduledTime, interval: 0, target: self, selector: #selector(playHaptics), userInfo: ["viewController": viewController, "file": file], repeats: false)
                RunLoop.main.add(timer, forMode: .common)
            }
//            viewController.playHapticsFile(named: file)
        }
    }

    @objc private func playHaptics(timer: Timer) {
        // Retrieve viewController and file from the timer's userInfo dictionary
        if let userInfo = timer.userInfo as? [String: Any],
           let viewController = userInfo["viewController"] as? ViewController,
           let file = userInfo["file"] as? String {
            // Call playHapticsFile method
            viewController.playHapticsFile(named: file)
        }
    }
}
