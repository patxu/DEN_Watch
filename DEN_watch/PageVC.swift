//
//  ViewController.swift
//  UIPageViewController
//
//  Created by PJ Vea on 3/27/15.
//  Copyright (c) 2015 Vea Software. All rights reserved.
//

import UIKit
import CoreLocation

class PageVC: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
//    var pageViewController: UIPageViewController!
    var index = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController!
//        self.pageViewController.dataSource = self
        
        self.dataSource = self
        self.delegate = self
        
        let startVC = self.viewControllerAtIndex(index) as UIViewController
        let viewControllers: NSArray = [startVC]
        
        self.setViewControllers(viewControllers as! [UIViewController], direction: .Forward, animated: true, completion: nil)
        print("Transition style is" , self.transitionStyle.rawValue)
//        self.pageViewController.setViewControllers(viewControllers as! [UIViewController], direction: .Forward, animated: true, completion: nil)
        
//        self.addChildViewController(self.pageViewController)
//        self.view.addSubview(self.pageViewController.view)
//        self.pageViewController.didMoveToParentViewController(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController
    {
        print("index is ", index)
        if (index == 0) {
            return self.storyboard?.instantiateViewControllerWithIdentifier("UserListVC") as! UserListVC!
        }
        else {
            return self.storyboard?.instantiateViewControllerWithIdentifier("ProfileVC") as! ProfileVC!
        }
    }
    
    
    // MARK: - Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        
//        var vc = viewController as! UIViewController
//        var index = vc.pageIndex as Int
//        
//        
        if (self.index == 0)
        {
            return nil
            
        }
        
        self.index--

        return self.viewControllerAtIndex(index)
//        return self.viewControllerAtIndex((index + 1)%2)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
//        var vc = viewController as! UIViewController
//        var index = vc.pageIndex as Int
//        
//        if (index == NSNotFound)
//        {
//            return nil
//        }
        
        
        if (self.index == 1)
        {
            return nil
        }
        self.index++

        return self.viewControllerAtIndex(index)
//        return self.viewControllerAtIndex((index + 1)%2)
        
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 2
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return index
    }
    
}

