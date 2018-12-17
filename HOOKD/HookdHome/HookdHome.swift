//
//  HookdHome.swift
//  HOOKD
//
//  Created by Zachary Carter on 5/5/18.
//  Copyright © 2018 Zachary Carter. All rights reserved.
//

import UIKit
import CoreLocation

class HookdHome: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var profileImage : UIImageView!
    @IBOutlet var tableView : UITableView!
    @IBOutlet var navBar : UIView!
    @IBOutlet var actionButton : UIView!
    
    var imageOperation      = OperationQueue()
    var currentLocation: CLLocation!
    var locManager = CLLocationManager()
    var hasLoadedMatches = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BroadcastManager.sharedManager.resetBroadcastSession(UserManager.sharedManager.username) { (done) in
        }
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.registerForPushNotifications(application:UIApplication.shared)
        
        profileImage.image = profileImage.image!.withRenderingMode(.alwaysTemplate)
        profileImage.tintColor = UIColor.white
        
        tableView.layoutMargins  = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        
        navBar.backgroundColor = UIColor.black
        actionButton.backgroundColor = UIColor.black
        
        self.locManager.requestWhenInUseAuthorization()
        self.imageOperation.maxConcurrentOperationCount = 10

        UserManager.sharedManager.getMatches(UserManager.sharedManager.username) { (done, errmsg) in
            print("err: \(errmsg)")
            if(done) {
                DispatchQueue.main.async {
                    print("SHOULD RELOAD!!!")
                    print("MATCHES: \(UserManager.sharedManager.matches)")
                    self.hasLoadedMatches = true
                    self.tableView.reloadData()
                }
            }
            else {
                print("SOMETHING WENT WRONG...")
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        if(UserManager.sharedManager.shouldReloadMatches == true) {
            
            UserManager.sharedManager.shouldReloadMatches = false
            
            UserManager.sharedManager.getMatches(UserManager.sharedManager.username) { (done, errmsg) in
                print("err: \(errmsg)")
                if(done) {
                    DispatchQueue.main.async {
                        print("SHOULD RELOAD!!!")
                        print("MATCHES: \(UserManager.sharedManager.matches)")
                        self.hasLoadedMatches = true
                        self.tableView.reloadData()
                    }
                }
                else {
                    print("SOMETHING WENT WRONG...")
                }
            }
        }
        
        loadProfilePic();
        
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func gotoAlerts() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "alerts") as! AlertsViewController
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func gotoLikes() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "likes") as! MyLikesViewController
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func gotoProfile() {
        print("CLICKING WTF")
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "profileParent") as! ProfileParentViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(UserManager.sharedManager.matches.count == 0 && self.hasLoadedMatches == true) {
            return 1
        }
        
        return UserManager.sharedManager.matches.count
    }
    
    func loadProfilePic() {
        
        self.imageOperation.addOperation({
            
            let fullPath  = AMZPROFILES + UserManager.sharedManager.profilePic
            
            let url       = URL(string:fullPath)
            let imageData = try? Data.init(contentsOf: url!)
            
            if(imageData != nil)
            {
                let img = UIImage(data: imageData!)
                
                if img == nil {
                    
                    let img = UIImage(named:"personAvatar.png")
                    
                    UserManager.sharedManager.cachedImages[fullPath] = img
                    OperationQueue.main.addOperation({
                        UserManager.sharedManager.savedImage = img!
                    })
                    
                }
                else
                {
                    UserManager.sharedManager.cachedImages[fullPath] = img
                    
                    OperationQueue.main.addOperation({
                        UserManager.sharedManager.savedImage = img!
                    })
                }
            }
            else {
                let img = UIImage(named:"personAvatar.png")
                
                UserManager.sharedManager.cachedImages[fullPath] = img
                
                OperationQueue.main.addOperation({
                    UserManager.sharedManager.savedImage = img!
                })
            }
            
        });
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(hasLoadedMatches == true && UserManager.sharedManager.matches.count == 0) {
            let matchCell        = tableView.dequeueReusableCell(withIdentifier: "nomatches", for: indexPath) as! UITableViewCell
            return matchCell
        }
        
        let matchCell        = tableView.dequeueReusableCell(withIdentifier: "match", for: indexPath) as! MatchCell
        
        var currentMatch     = UserManager.sharedManager.matches.object(at: indexPath.row) as? NSDictionary
        let profilePic       = currentMatch?.object(forKey: "profilePic") as! String
        
        matchCell.likeButton.tag = indexPath.row
        
        print("MATCHES: \(UserManager.sharedManager.matches)")
        
        self.imageOperation.addOperation({
            let fullPath  = AMZPROFILES + profilePic
            
            let url       = URL(string:fullPath)
            let imageData = try? Data.init(contentsOf: url!)
            
            if(imageData != nil)
            {
                let img = UIImage(data: imageData!)
                
                if img == nil {
                    
                    let img = UIImage(named:"personAvatar.png")
                    
                    UserManager.sharedManager.cachedImages[fullPath] = img
                    OperationQueue.main.addOperation({
                        matchCell.mainImage.image = img!
                    })
                    
                }
                else
                {
                    UserManager.sharedManager.cachedImages[fullPath] = img
                    
                    OperationQueue.main.addOperation({
                        matchCell.mainImage.image = img!
                    })
                }
            }
            else {
                let img = UIImage(named:"personAvatar.png")
                
                UserManager.sharedManager.cachedImages[fullPath] = img
                
                OperationQueue.main.addOperation({
                    matchCell.mainImage.image = img!
                })
            }
            
        });
        
        let alreadyliked = currentMatch?.object(forKey: "hasLiked") as? String
        
        if alreadyliked == "true" {
            matchCell.likeButton.setImage(UIImage.init(named: "heartblue"), for: .normal)
        }
        
        matchCell.age.text = "21"
        matchCell.desc.text = currentMatch?.object(forKey: "about_me") as? String
        matchCell.name.text = currentMatch?.object(forKey: "username") as? String
        
        /*searchCell.eventTitle.text       = currentSearchDict?.object(forKey: "Title") as? String
        searchCell.eventSubTitle.text    = currentSearchDict?.object(forKey: "SubTitle") as? String
        searchCell.eventDescription.text = currentSearchDict?.object(forKey: "Description") as? String*/
        
        return matchCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
