//
//  ViewController.swift
//  GrammyPlus
//
//  Created by Alisson Enz Rossi on 1/30/17.
//  Copyright © 2017 br.com.EnzRossi.Coursera. All rights reserved.
//

import UIKit
import NXOAuth2Client

class ViewController: UIViewController {
    
    var sharedOAuth:NXOAuth2AccountStore!

    @IBOutlet var loginLogoutBtn: UIButton!
    @IBOutlet var refreshBtn: UIButton!
    @IBOutlet var imageView: UIImageView!
    
    var userLogged:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sharedOAuth = NXOAuth2AccountStore.sharedStore() as! NXOAuth2AccountStore
        
        self.userLogged = false
        self.refreshBtn.isEnabled = false
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NXOAuth2AccountStoreDidFailToRequestAccess, object: NXOAuth2AccountStore.sharedStore(), queue: nil) { (notification) in
            print("Error", notification)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NXOAuth2AccountStoreAccountsDidChange, object: NXOAuth2AccountStore.sharedStore(), queue: nil) { (notification) in
            print("Success", notification)
        }
    }

    @IBAction func loginLogoutPressed() {
        if !self.userLogged {
            sharedOAuth.requestAccessToAccount(withType: "Instagram")
            
            self.loginLogoutBtn.setTitle("Logout", for: .normal)
            self.refreshBtn.isEnabled = true
        } else {
            for account in self.sharedOAuth.accounts(withAccountType: "Instagram") as! [NXOAuth2Account] {
                self.sharedOAuth.removeAccount(account)
            }
            self.loginLogoutBtn.setTitle("Login", for: .normal)
            self.refreshBtn.isEnabled = false
            self.imageView.image = #imageLiteral(resourceName: "login")
            self.imageView.contentMode = .center
        }
        self.userLogged = !self.userLogged
    }
    
    @IBAction func refreshPressed() {
        
        guard sharedOAuth.accounts.count > 0 else {
            for a in sharedOAuth.accounts(withAccountType: "Instagram") as! [NXOAuth2Account] {
                print(a)
            }
            return
        }
        
        let account = sharedOAuth.accounts(withAccountType: "Instagram")[0] as! NXOAuth2Account
        let token = account.accessToken.accessToken!
        
        let urlString = "https://api.instagram.com/v1/users/self/media/recent/?access_token=\(token)"
        print(urlString)
        let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print(error ?? "Error")
                return
            }
            
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            if let data = json["data"] as? [Any] {
                if let first = data[0] as? [String: Any] {
                    if let images = first["images"] as? [String: Any] {
                        if let standard = images["standard_resolution"] as? [String: Any] {
                            if let urlString = standard["url"] as? String {
                                let url = URL(string: urlString)!
                                
                                let task2 = URLSession.shared.dataTask(with: url) { (data, response, error) in
                                    
                                    guard error == nil else {
                                        print(error ?? "Error")
                                        return
                                    }
                                    
                                    guard let data = data else {
                                        print("Data is empty")
                                        return
                                    }
                                    
                                    DispatchQueue.main.async {
                                        self.imageView.contentMode = .scaleAspectFit
                                        self.imageView.image = UIImage(data: data, scale: 1)
                                    }
                                }
                                task2.resume()
                            }
                        }
                    }
                }
            }
            
        }
        task.resume()
        
    }

}
