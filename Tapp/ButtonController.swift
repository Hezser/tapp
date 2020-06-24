//
//  ButtonViewController.swift
//  Tapp
//
//  Created by Sergio Hernandez on 05/06/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FBSDKLoginKit
import UserNotifications

class ButtonController: UIViewController {
    
    var button: UIButton!
    
    private var color: String!
    private var friendID: String!
    
    public func set(color: String) {
        self.color = color
    }
    public func set(friendID: String) {
        self.friendID = friendID
    }
    
    func buttonWasTapped(_ sender: UIButton) {
        if button == nil {
            print("nil")
        }
        let ref = FIRDatabase.database().reference()
        if (button.backgroundColor == UIColor.init(red: 61/255, green: 179/255, blue: 59/255, alpha: 0.75)) {
            
            // DO NOTHING -> BUTTON IS GREEN
            
//            // UI Changes
//            button.backgroundColor = UIColor.red
//            view.backgroundColor = UIColor.init(red: 1, green: 92/255, blue: 94/255, alpha: 1)
//            
//            // Database Changes
//            
//            // Configure the connection on the current user's data
//            var key = ref.child(self.friendID!).key
//            var friend = ["Color": "Red"]
//            var childUpdates = ["/user-posts/\(String(describing: FBSDKAccessToken.current().userID!))/\(key)/": friend]
//            ref.updateChildValues(childUpdates)
//            // Configure the connection on the current user's friend's data
//            key = ref.child(FBSDKAccessToken.current().userID!).key
//            friend = ["Color": "Green"]
//            childUpdates = ["/user-posts/\(String(describing: self.friendID!))/\(key)/": friend]
//            ref.updateChildValues(childUpdates)
        }
        else {
            // UI Changes
            self.button.isHighlighted = true
            button.backgroundColor = UIColor.init(red: 61/255, green: 179/255, blue: 59/255, alpha: 0.75)
            view.backgroundColor = UIColor.init(red: 206/255, green: 1, blue: 204/255, alpha: 1)
            
            // Database Changes
            
            // Configure the connection on the current user's data
            var key = ref.child(self.friendID!).key
            var friend = ["Color": "Green"]
            var childUpdates = ["/user-posts/\(String(describing: FBSDKAccessToken.current().userID!))/\(key)/": friend]
            ref.updateChildValues(childUpdates)
            // Configure the connection on the current user's friend's data
            key = ref.child(FBSDKAccessToken.current().userID!).key
            friend = ["Color": "Red"]
            childUpdates = ["/user-posts/\(String(describing: self.friendID!))/\(key)/": friend]
            ref.updateChildValues(childUpdates)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Fixed UI Configuration
        button = UIButton(type: UIButtonType.custom) as UIButton
        button.frame = CGRect(x:200, y:200, width:200, height:200)
        button.center = view.center
        button.addTarget(self, action: #selector(ButtonController.buttonWasTapped(_:)), for:.touchUpInside)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.layer.borderWidth = 7
        button.layer.borderColor = UIColor.init(red: 150/255, green: 150/255, blue: 150/255, alpha: 1).cgColor
        self.view.addSubview(button)
        // Friend's profile image
        let imageUrl = "https://graph.facebook.com/\(friendID!)/picture?type=large"
        let url = URL(string: imageUrl)
        let data = try? Data(contentsOf: url!)
        let image = UIImage(data: data!)
        button.setImage(image, for: .normal)
        // Depending on the color shown in the database
        switch color {
        case "Green" :
            self.button.isHighlighted = true
            button.backgroundColor = UIColor.init(red: 61/255, green: 179/255, blue: 59/255, alpha: 0.75)
            view.backgroundColor = UIColor.init(red: 206/255, green: 1, blue: 204/255, alpha: 1)
        case "Red" :
            self.button.isHighlighted = false
            button.backgroundColor = UIColor.red
            view.backgroundColor = UIColor.init(red: 1, green: 92/255, blue: 94/255, alpha: 1)
        default :
            print("Error: no color given")
        }
        // Set Listener in Firabase Database to change the color when the other user does
        let ref = FIRDatabase.database().reference()
        ref.child("user-posts").child(FBSDKAccessToken.current().userID!).child(self.friendID).observe(.childChanged, with: { (snapshot) in
            // Change color
            if (snapshot.value! as! String) == "Red" {
                self.button.isHighlighted = false
                self.button.backgroundColor = UIColor.red
                self.view.backgroundColor = UIColor.init(red: 1, green: 92/255, blue: 94/255, alpha: 1)
            }
            else {
                self.button.isHighlighted = true
                self.button.backgroundColor = UIColor.init(red: 61/255, green: 179/255, blue: 59/255, alpha: 0.75)
                self.view.backgroundColor = UIColor.init(red: 206/255, green: 1, blue: 204/255, alpha: 1)
            }
        })
    }
}
