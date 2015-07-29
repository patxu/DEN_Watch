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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController!
        self.pageViewController.dataSource = self
        
        var startVC = self.viewControllerAtIndex(0) as UIViewController
        var viewControllers = NSArray(object: startVC)
        
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
        var vc: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserListVC") as! UIViewController!
        print("view controller at index -> " + vc.description)
        return vc
    }
    
    
    // MARK: - Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        
        var vc = viewController as! UIViewController
//        var index = vc.pageIndex as Int
//        
//        
//        if (index == 0 || index == NSNotFound)
//        {
//            return nil
//            
//        }
        
//        index--
        return self.viewControllerAtIndex(0)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var vc = viewController as! UIViewController
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
        
        return self.viewControllerAtIndex(0)
        
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
}

