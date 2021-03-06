//
//  ViewController.swift
//  Social Networking App
//
//  Created by Alisson Enz Rossi on 1/22/17.
//  Copyright © 2017 br.com.EnzRossi.Coursera. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController {

    @IBOutlet var twitterPost: UITextView!
    @IBOutlet var facebookPost: UITextView!
    @IBOutlet var otherPost: UITextView!
    @IBOutlet var twitterCount: UILabel!

    @IBAction func twitterShare(_ sender: Any) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            let twitterView = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
            if self.twitterPost.text.characters.count > 140 {
                let shortText = self.twitterPost.text[self.twitterPost.text.startIndex...self.twitterPost.text.index(self.twitterPost.text.startIndex, offsetBy: 140-1)]
                twitterView.setInitialText(shortText)
            } else {
                twitterView.setInitialText(self.twitterPost.text)
            }
            self.present(twitterView, animated: true, completion: nil)
        } else {
            self.showMessage(title: "Error!", message: "Please, login in Twitter first")
        }
    }
    
    @IBAction func facebookShare(_ sender: Any) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let facebookView = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
            facebookView.setInitialText(self.facebookPost.text)
            self.present(facebookView, animated: true, completion: nil)
        } else {
            self.showMessage(title: "Error!", message: "Please, login in Facebook first")
        }
    }

    @IBAction func otherShare(_ sender: Any) {
        let otherView = UIActivityViewController(activityItems: [otherPost.text], applicationActivities: nil)
        self.present(otherView, animated: true, completion: nil)
    }
    
    @IBAction func showMessage(_ sender: Any) {
        self.showMessage(title: "Just a message!", message: "Nothing to do here")
    }
    
    func showMessage(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okBtn)
        self.present(alert, animated: true, completion: nil)
    }

}

extension ViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == self.twitterPost {
            let count = 140 - self.twitterPost.text.characters.count
            if count < 0 {
                self.twitterCount.textColor = UIColor.red
            } else {
                self.twitterCount.textColor = UIColor.gray
            }
            self.twitterCount.text = "\(count)"
        }
    }
    
}

