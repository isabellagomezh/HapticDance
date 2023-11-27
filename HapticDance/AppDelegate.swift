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
            scheduleAction(startTime: startTime)
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
            scheduleAction(startTime: startTime)
        }
        
        // Since you're using the notification to send data, you might not need to present the notification
        completionHandler(.newData)
    }
    
    private func scheduleAction(startTime: String) {
        // Schedule your action here based on the start time
    }

}
