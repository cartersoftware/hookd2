//
//  AppDelegate.swift
//  HOOKD
//
//  Created by Zachary Carter on 5/4/18.
//  Copyright © 2018 Zachary Carter. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

protocol GotDeviceToken {
    func gotToken()
}

let HOOKDAPI        = "http://hookd.info/API/V1/"
let HOOKEDTERMS     = "http://hookd.info/terms.php"
let HOOKEDPRIV      = "http://hookd.info/privacypolicy.php"
let HOOKDRED        = UIColor(red: 200.0/255.0, green: 0.0/255.0, blue: 52.0/255.0, alpha: 1.0)
let HOOKDNAV        = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
let OURERROR        = "Something went wrong on our side.";
let AMZPROFILES     = "https://s3-us-west-2.amazonaws.com/hookd/GRAPHICS/PROFILEPICS/"
let AMZSTANDARDPICS = "https://s3-us-west-2.amazonaws.com/hookd/GRAPHICS/STANDARDPICS/"
let SCREENWIDTH = UIScreen.main.bounds.size.width
let SCREENHEIGHT = UIScreen.main.bounds.size.height

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    var delegateToken:GotDeviceToken?
    var currentLocation: CLLocation!
    var locManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        application.statusBarStyle = .lightContent // .default
        let navbarFont             = UIFont(name: "System", size: 17) ?? UIFont.systemFont(ofSize: 17)
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: navbarFont, NSAttributedStringKey.foregroundColor:UIColor.white]
        
        if let username = UserDefaults.standard.object(forKey: "username") as? String {
            
            let email      = UserDefaults.standard.object(forKey: "email") as? String
            let profilePic = UserDefaults.standard.object(forKey: "profilePic") as? String
            let userInfo   = UserDefaults.standard.object(forKey: "userInfo") as? NSDictionary

            UserManager.sharedManager.username                  = username
            UserManager.sharedManager.email                     = email!
            UserManager.sharedManager.profilePic                = profilePic!
            UserManager.sharedManager.userInfo                  = userInfo!

            // Override point for customization after application launch.
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController:UINavigationController = storyboard.instantiateInitialViewController() as! UINavigationController
            let parentVC = storyboard.instantiateViewController(withIdentifier: "hookdhome") as! HookdHome
            navigationController.viewControllers = [parentVC]
            self.window?.rootViewController = navigationController
        
            window?.makeKeyAndVisible()
            
            if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways){
                
                self.locManager.startUpdatingLocation()
                
                currentLocation = self.locManager.location
                
                print("CURRENT LOC: \(currentLocation)")
                
                if(currentLocation != nil)
                {
                    
                    print("SENDING LOCATION UPDATES")
                    print("\(currentLocation.coordinate.latitude)")
                    
                    UserManager.sharedManager.updateLocation(UserManager.sharedManager.username, latitude: "\(currentLocation.coordinate.latitude)", longitude: "\(currentLocation.coordinate.longitude)") { (done, errmsg) in
                        
                    }
                }
            }
            
            return true
            
        }
    
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func registerForPushNotifications(application: UIApplication) {
        
        if #available(iOS 10.0, *){
            
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                if (granted)
                {
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                    
                }
                else{
                    //Do stuff if unsuccessful...
                }
            })
        }
            
        else{ //If user is not on iOS 10 use the old methods we've been using
            let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            
            application.registerUserNotificationSettings(notificationSettings)
            
            application.registerForRemoteNotifications()
            
        }
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        print("SHOULD BE STORING THE TOKEN!!")
        var token: String = ""
        
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        
        UserManager.sharedManager.deviceToken = token
        
        delegateToken?.gotToken()
        
        if(UserManager.sharedManager.deviceToken != ""){
            
            UserDefaults.standard.set(UserManager.sharedManager.deviceToken, forKey: "deviceToken")
            UserDefaults.standard.synchronize()
            
        }
    }


}

