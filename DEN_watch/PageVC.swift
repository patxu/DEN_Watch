//
//  ViewController.swift
//  UIPageViewController
//
//  Created by PJ Vea on 3/27/15.
//  Copyright (c) 2015 Vea Software. All rights reserved.
//

import UIKit

class PageVC: UIViewController, UIPageViewControllerDataSource {
    
    var pageViewController: UIPageViewController!
    var pageTitles: NSArray!
    var pageImages: NSArray!
    var index: Int!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController!
        self.pageViewController.dataSource = self
        
        index = 1
        let startVC = self.viewControllerAtIndex(index) as UIViewController
        let viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as! [UIViewController], direction: .Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.width, self.view.frame.size.height - 60)

        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController
    {

        if (index == 0) {
            var vc: UserListVC = self.storyboard?.instantiateViewControllerWithIdentifier("UserListVC") as! UserListVC!
            print("view controller at index -> " + vc.description)
//            vc.pageIndex = index
            return vc
        } else {
            var vc: ProfileVC = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileVC") as! ProfileVC!
            print("view controller at index -> " + vc.description)
//            vc.pageIndex = index
            return vc
        }
    }
    
    
    // MARK: - Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        
//        var vc = viewController as! UIViewController
//        var index = vc.pageIndex as Int
//        
//        
//        if (index == 0 || index == NSNotFound)
//        {
//            return nil
//            
//        }
        
//        index--
        if (index == 1) {
            index = 0
        }
        else if (index == 0) {
            index = 1
        }
        return self.viewControllerAtIndex((index + 1)%2)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
//        var vc = viewController as! UIViewController
//        var index = vc.pageIndex as Int
//        
//        if (index == NSNotFound)
//        {
//            return nil
//        }
        
//        index++
//        
//        if (index == self.pageTitles.count)
//        {
//            return nil
//        }
        if (index == 1) {
            index = 0
        }
        else if (index == 0) {
            index = 1
        }
        print((index + 1)%2)
        return self.viewControllerAtIndex((index + 1)%2)
        
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 2
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
}

