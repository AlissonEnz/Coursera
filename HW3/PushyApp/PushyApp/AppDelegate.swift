//
//  AppDelegate.swift
//  PushyApp
//
//  Created by Alisson Enz Rossi on 2/4/17.
//  Copyright © 2017 br.com.EnzRossi. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {(accepted, error) in
            UNUserNotificationCenter.current().delegate = self
            if !accepted {
                print("Notification access denied.")
            }
        }
        
        let action = UNNotificationAction(identifier: "action1", title: "Remind me later", options: [])
        let action2 = UNNotificationAction(identifier: "action2", title: "Destroy", options: [.destructive])
        
        let category = UNNotificationCategory(identifier: "myCategory", actions: [action, action2], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let alert = UIAlertController(title: "Homework 3", message: "Just a simple notification", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okBtn)
        
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        
    }

}

