//
//  LogInViewController.swift
//  Tapp
//
//  Created by Sergio Hernandez on 05/06/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import Firebase
import FirebaseAuth

class LogInViewController: UIViewController, LoginButtonDelegate {
    
    
    // PARSER
//    for (key, value) in userData {
//    if key == "data" {
//    for elem in (value as! NSArray) {
//    for (_, v) in (elem as! NSDictionary) {
//    print((v))
//    }
//    }
//    }
//    }
//    
    
    //        FIRAuth.auth()?.currentUser!.uid
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
        loginButton.center = view.center
        loginButton.delegate = self
        view.addSubview(loginButton)
        if AccessToken.current != nil {
            performSegue(withIdentifier: "LogedIn", sender: self)
            print("LOL")
        }
    }

    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
//        Model.set(user: UserProfile.current!)
//        let params = ["fields": "id, first_name, last_name, name, email, picture"]
//        
//        let graphRequest = GraphRequest(graphPath: "/me/friends", parameters: params)
//        let connection = GraphRequestConnection()
//        connection.add(graphRequest)
//        connection.start()
        // Firebase
//        let credential = FIRFacebookAuthProvider.credential(withAccessToken: (AccessToken.current?.authenticationToken)!
//        )
//        FIRAuth.auth()?.signIn(with: credential, completion: true)
        
        // Friends List
        let params = ["fields": "id, first_name, last_name, name, email, picture"]
        let request = GraphRequest(graphPath: "me/friends", parameters: params)
        request.start { (connection, result) in
            if result != nil {
                print(result)
            }
        }
        performSegue(withIdentifier: "LogedIn", sender: self)
        print("LOGEDIN")
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("LogedOut")
    }
    
}
