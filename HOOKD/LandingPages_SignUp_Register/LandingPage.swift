//
//  ViewController.swift
//  HOOKD
//
//  Created by Zachary Carter on 5/4/18.
//  Copyright © 2018 Zachary Carter. All rights reserved.
//

import UIKit

class LandingPage: UIViewController, GotDeviceToken {
    
    //@IBOutlet var pageControl: UIPageControl!
    //@IBOutlet var scrollView: UIScrollView!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var signInButton: UIButton!

    var pageContainer: UIPageViewController!
    var pages = [UIViewController]()
    var currentIndex: Int?
    
    private var pendingIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.delegateToken = self
        
        // Do any additional setup after loading the view, typically from a nib.
        //setupScroller()
        
        signUpButton.layer.cornerRadius = 3.0
        signInButton.layer.cornerRadius = 3.0
        
        signUpButton.layer.cornerRadius = 3.0
        signUpButton.layer.borderColor = UIColor.white.cgColor
        signUpButton.layer.borderWidth = 1.0
        
        signInButton.layer.cornerRadius = 3.0
        signInButton.layer.borderColor = UIColor.white.cgColor
        signInButton.layer.borderWidth = 1.0
        
    }
    
    func gotToken() {
        
        UserManager.sharedManager.updateDeviceToken(UserManager.sharedManager.username, deviceToken: UserManager.sharedManager.deviceToken) { (done) in
            print("SHOULD BE STORING THE TOKEN!!")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setupScroller() {
        
       /* let page1                = self.storyboard!.instantiateViewController(withIdentifier: "swipePage1")
        let page2                = self.storyboard!.instantiateViewController(withIdentifier: "swipePage2")
        let page3                = self.storyboard!.instantiateViewController(withIdentifier: "swipePage3")
        
        page1.view.backgroundColor = .clear
        page2.view.backgroundColor = .clear
        page3.view.backgroundColor = .clear

        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        pageContainer            = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageContainer.delegate   = self
        pageContainer.dataSource = self
        pageContainer.setViewControllers([page1], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
                
        // Add it to the view
        scrollView.addSubview(pageContainer.view)
        
        // Configure our custom pageControl
        scrollView.bringSubview(toFront: pageControl)
        
        pageControl.numberOfPages = pages.count
        pageControl.currentPage   = 0*/
    }

    /*
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        if currentIndex == 0 {
            return nil
        }
        let previousIndex = abs((currentIndex - 1 + pages.count) % pages.count)
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        if currentIndex == pages.count-1 {
            return nil
        }
        let nextIndex = abs((currentIndex + 1) % pages.count)
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = pages.index(of: pendingViewControllers.first!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentIndex = pendingIndex
            if let index = currentIndex {
                pageControl.currentPage = index
            }
        }
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUp() {
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "signUp") as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func signIn() {
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "login") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func gotoTerms() {
        UserManager.sharedManager.isViewingTerms = true
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "terms") as! TermsPrivacyViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func gotoPrivacy() {
        UserManager.sharedManager.isViewingTerms = false
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "terms") as! TermsPrivacyViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }


}

