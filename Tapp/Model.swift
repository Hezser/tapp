//
//  Model.swift
//  Tapp
//
//  Created by Sergio Hernandez on 06/06/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import Foundation
import FacebookLogin
import FacebookCore
import Firebase
import FirebaseDatabase

class Model {
    
    private static var user: UserProfile!
    
    private static var currentFriend: UserProfile!
    
    public static var friends = [String:String]()
    
    private static var colorForFriend: [String:String]!
    
    public static func set(user: UserProfile) { Model.user = user}
    public static func getUser() -> UserProfile { return Model.user }
    
    public static func set(currentFriend: UserProfile) { Model.currentFriend = currentFriend}
    public static func getCurrentFriend() -> UserProfile { return Model.currentFriend }
    
    public static func set(friends: NSDictionary) { Model.friends = friends as! [String : String]}
    public static func getFriends() -> NSDictionary { return Model.friends as NSDictionary }
    
    public static func addFriend(name: String, id: String) {
        Model.friends[id] = name
    }

}
