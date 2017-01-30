//
//  AppDelegate.swift
//  GrammyPlus
//
//  Created by Alisson Enz Rossi on 1/30/17.
//  Copyright © 2017 br.com.EnzRossi.Coursera. All rights reserved.
//

import UIKit
import NXOAuth2Client

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let sharedOAuth = NXOAuth2AccountStore.sharedStore() as! NXOAuth2AccountStore

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        sharedOAuth.setClientID("902b95877cb641508348b45d19d48fd4",
                           secret: "dca109ff00c74ec1a637e589bb75daeb",
                           authorizationURL: URL(string: "https://api.instagram.com/oauth/authorize"),
                           tokenURL: URL(string: "https://api.instagram.com/oauth/access_token"),
                           redirectURL: URL(string: "http://djp3.westmont.edu/classes/2015-coursera-live/redirect.php/enzrossi/thing.com"),
                           forAccountType: "Instagram")

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return sharedOAuth.handleRedirectURL(url)
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return sharedOAuth.handleRedirectURL(url)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return sharedOAuth.handleRedirectURL(url)
    }

}

