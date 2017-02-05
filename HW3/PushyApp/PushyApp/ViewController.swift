//
//  ViewController.swift
//  PushyApp
//
//  Created by Alisson Enz Rossi on 2/4/17.
//  Copyright © 2017 br.com.EnzRossi. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    @IBAction func alertBtnPressed(_ sender: Any) {
        
        self.scheduleNotification()
    }
    
    func scheduleNotification() {
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Homework 3"
        content.body = "Just a simple notification"
        content.subtitle = "Just a simple notification"
        content.sound = UNNotificationSound.default()
        content.badge = 100
        content.categoryIdentifier = "myCategory"
        
        let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            guard error == nil else {
                print("Uh oh! We had an error: \(error)")
                return
            }
        }
    }

}

