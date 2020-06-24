//
//  SlidingController.swift
//  Tapp
//
//  Created by Sergio Hernandez on 08/06/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit

class SlidingController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    var views = [UIViewController]()
    
    private var color: String!
    private var friendID: String!
    
    public func set(color: String) {
        self.color = color
    }
    public func set(friendID: String) {
        self.friendID = friendID
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        let friendsListView = storyboard?.instantiateViewController(withIdentifier: "FriendsListView") as! FriendsListController
        let buttonView = storyboard?.instantiateViewController(withIdentifier: "ButtonView") as! ButtonController
        
        views.append(friendsListView)
        views.append(buttonView)
        
        buttonView.set(color: self.color)
        buttonView.set(friendID: self.friendID)
        
        setViewControllers([buttonView], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = views.index(of: viewController)!
        var previousIndex = abs((currentIndex - 1) % views.count)
        if (currentIndex == 0)
        {
            previousIndex = 1
        }
        
        return views[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = views.index(of: viewController)!
        let nextIndex = abs((currentIndex + 1) % views.count)
        return views[nextIndex]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return views.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 1
    }
}
