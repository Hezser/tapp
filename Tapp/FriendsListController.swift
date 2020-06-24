//
//  FriendsListController.swift
//  Tapp
//
//  Created by Sergio Hernandez on 08/06/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FBSDKLoginKit
import UserNotifications

class FriendsListController: UITableViewController, UISearchResultsUpdating {

    var filtered = [String]()
    var friendsNames = [String]()
    var friendsIDs = [String]()
    
    var color: String!
    var selectedFriendID: String!
    var selectedFriend: String!
    
    var searchController : UISearchController!
    var resultsController = UITableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Listener in Firabase Database to send notification
        let ref = FIRDatabase.database().reference()
        ref.child("user-posts").child(FBSDKAccessToken.current().userID!).observe(.childChanged, with: { (snapshot) in
            // Give notification
            let content = UNMutableNotificationContent()
            content.title = "A friend has dared you!"
            content.subtitle = "Get green!"
            content.badge = 1
            content.sound = UNNotificationSound.default()
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
            let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        })
        // Not the best solution for the top spacing with the status bar problem (try removing this line: the table view controller will overlapp the top status iOS bar)
        tableView.contentInset.top = 20
        
        self.resultsController.tableView.dataSource = self
        self.resultsController.tableView.delegate = self
        
        self.searchController = UISearchController(searchResultsController: self.resultsController)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchResultsUpdater = self
        definesPresentationContext = true
        
        // Set up friendsNames list
        for (FBid, name) in Model.friends {
            friendsNames.append(name)
            friendsIDs.append(FBid)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FriendWasSelected" {
            let view = segue.destination as! SlidingController
            view.set(color: self.color!)
            view.set(friendID: selectedFriendID)
        }
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        // Filter through the cases
        filtered = []
        
        for friend in friendsNames {
            if ((friend.lowercased().contains(self.searchController.searchBar.text!.lowercased()))) {
                filtered.append(friend)
            }
        }
        // Update the results TableView
        self.resultsController.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return friendsNames.count
        } else {
            return self.filtered.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if tableView == self.tableView {
            cell.textLabel?.text = friendsNames[indexPath.row]
        } else {
            cell.textLabel?.text = self.filtered[indexPath.row]
        }
        return cell
    }
    
    // Selected a friend
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedFriendID = self.friendsIDs[indexPath.row]
        
        // Set the friend to the selected one
        let cell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        selectedFriend = cell.textLabel!.text
        
        // Save in Firebase
        let ref = FIRDatabase.database().reference()
        // Check if the users are already connected
        ref.child("user-posts").child(FBSDKAccessToken.current().userID!).child(self.selectedFriendID).child("Color").observeSingleEvent(of: .value, with: { (snapshot) in
            // The users are already connected
            if snapshot.exists() {
                self.color = snapshot.value! as! String
            }
            // The users are not yet connected
            else {
                self.color = "Green"
                // Configure the connection on the current user's data
                var key = ref.child(self.selectedFriendID).key
                var friend = ["Color" : "Green"]
                var childUpdates = ["/user-posts/\(String(describing: FBSDKAccessToken.current().userID!))/\(key)/": friend]
                ref.updateChildValues(childUpdates)
                // Configure the connection on the current user's friend's data
                key = ref.child(FBSDKAccessToken.current().userID!).key
                friend = ["Color" : "Red"]
                childUpdates = ["/user-posts/\(String(describing: self.selectedFriendID!))/\(key)/": friend]
                ref.updateChildValues(childUpdates)
            }
        })

        // Delay to let the app retrieve the color from the Firebase database (Try to do it based on "color" not being nil, rather than some arbitrary amount of time
        
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.performSegue(withIdentifier: "FriendWasSelected", sender: self)
        }
    }
}
