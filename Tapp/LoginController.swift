//
//  Login2ViewController.swift
//  Tapp
//
//  Created by Sergio Hernandez on 07/06/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit
import UserNotifications

class LoginController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Ask for notifications' permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {authorised, error in
            if !authorised {
                print("The user did not authorise notifications")
            }
        })
        
        // User is already logged in
        if (FBSDKAccessToken.current() != nil)
        {
            self.configureUser()
        }
        // Else configure facebook login button
        facebookLoginButton.delegate = self
        facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        try! FIRAuth.auth()!.signOut()
        print("User Logged Out")
    }


    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error!.localizedDescription)
            return
        }
            // Handle the login process being cancelled
        else if result.isCancelled {
            print("Result Cancelled")
        }
            // Handle all permissions not being granted
        else if !result.grantedPermissions.contains("email") {
            print("The email permission was not granted")
        }
        else if !result.grantedPermissions.contains("public_profile") {
            print("The public_profile permission was not granted")
        }
        else if !result.grantedPermissions.contains("user_friends") {
            print("The user_friends permission was not granted")
        }
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            print("User Logged In")
            self.configureUser()
        })
        
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func configureUser() {
        // Friends
        let params = ["fields": "id, first_name, last_name, name, picture"]
        let graphRequest = FBSDKGraphRequest(graphPath: "/me/friends", parameters: params)
        let connection = FBSDKGraphRequestConnection()
        connection.add(graphRequest, completionHandler: { (connection, result, error) in
            if error == nil {
                if let userData = result as? [String:Any] {
                    if let friends = userData["data"] as? [NSDictionary] {
                        for friend in friends {
                            print("Count 1: \(Model.friends.count)")
                            Model.addFriend(name: (friend["name"] as! NSString) as String, id: (friend["id"] as! NSString) as String)
                        }
                    }
                }
            } else {
                print("Error Getting Friends: \(String(describing: error))");
            }
        })
        connection.start()
        // This delay produces problems, but performSegue needs to be async and if it is, then it will perform before configureUser() finishes, so no friends will be added to Model.friends (and hence, no friends will appear on the list). Need a better solution
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        self.performSegue(withIdentifier: "LogedIn", sender: self)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
