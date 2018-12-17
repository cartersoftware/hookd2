//
//  ProfileParentViewController.swift
//  HOOKD
//
//  Created by Zachary Carter on 6/7/18.
//  Copyright © 2018 Zachary Carter. All rights reserved.
//

import UIKit

class ProfileParentViewController: UIViewController {

    @IBOutlet var aboutMe : UIButton!
    @IBOutlet var preferences : UIButton!
    @IBOutlet var account : UIButton!
    @IBOutlet var profilePicture : UIImageView!
    @IBOutlet var usersName : UILabel!
    
    var imageOperation      = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        aboutMe.layer.cornerRadius = 3.0
        aboutMe.layer.borderColor = UIColor.white.cgColor
        aboutMe.layer.borderWidth = 1.0
        
        preferences.layer.cornerRadius = 3.0
        preferences.layer.borderColor = UIColor.white.cgColor
        preferences.layer.borderWidth = 1.0
        
        account.layer.cornerRadius = 3.0
        account.layer.borderColor = UIColor.white.cgColor
        account.layer.borderWidth = 1.0
        
        profilePicture.layer.borderWidth   = 1
        profilePicture.layer.masksToBounds = false
        profilePicture.layer.borderColor   = UIColor.white.cgColor
        profilePicture.layer.cornerRadius  = profilePicture.frame.height/2
        profilePicture.clipsToBounds       = true
        
        usersName.text                     = UserManager.sharedManager.username

        profilePicture.image = UserManager.sharedManager.savedImage
        //loadProfilePic()

        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func gotoProfile() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
        UserManager.sharedManager.visitedFromHome = true
    }
    
    @IBAction func gotoPreferences() {
        
        UserManager.sharedManager.cameFromWizard  = false;
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "prefs") as! PreferencesViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func gotoAccount() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "useraccount") as! AccountViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func doneButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadProfilePic() {
        
        print("LOADING PIC")
        self.imageOperation.addOperation({
            
            let fullPath  = AMZPROFILES + UserManager.sharedManager.profilePic
            
            print("FULL PATH: \(fullPath)")
            
            let url       = URL(string:fullPath)
            let imageData = try? Data.init(contentsOf: url!)
            
            if(imageData != nil)
            {
                let img = UIImage(data: imageData!)
                
                if img == nil {
                    
                    let img = UIImage(named:"personAvatar.png")
                    
                    UserManager.sharedManager.cachedImages[fullPath] = img
                    OperationQueue.main.addOperation({
                        self.profilePicture.image = img
                    })
                    
                }
                else
                {
                    UserManager.sharedManager.cachedImages[fullPath] = img
                    
                    OperationQueue.main.addOperation({
                        self.profilePicture.image = img
                    })
                }
            }
            else {
                let img = UIImage(named:"personAvatar.png")
                
                UserManager.sharedManager.cachedImages[fullPath] = img
                
                OperationQueue.main.addOperation({
                    self.profilePicture.image = img
                })
            }
            
        });
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
