//
//  AccountViewController.swift
//  HOOKD
//
//  Created by Zachary Carter on 6/28/18.
//  Copyright © 2018 Zachary Carter. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet var profileButton : UIButton!
    @IBOutlet var vipButton : UIButton!
    @IBOutlet var supportButton : UIButton!
    @IBOutlet var logoutButton : UIButton!
    @IBOutlet var hideAccountButton : UIButton!
    @IBOutlet var deleteAccountButton : UIButton!
    @IBOutlet var profilePic : UIImageView!
    
    var shouldHide : String = "hide"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileButton.layer.cornerRadius = 5.0
        profileButton.layer.borderWidth  = 1.0
        profileButton.layer.borderColor  = UIColor.white.cgColor
        
        vipButton.layer.cornerRadius = 5.0
        vipButton.layer.borderWidth  = 1.0
        vipButton.layer.borderColor  = UIColor.white.cgColor
        
        supportButton.layer.cornerRadius = 5.0
        supportButton.layer.borderWidth  = 1.0
        supportButton.layer.borderColor  = UIColor.white.cgColor
        
        logoutButton.layer.cornerRadius = 5.0
        logoutButton.layer.borderWidth  = 1.0
        logoutButton.layer.borderColor  = UIColor.white.cgColor
        
        hideAccountButton.layer.cornerRadius = 5.0
        hideAccountButton.layer.borderWidth  = 1.0
        hideAccountButton.layer.borderColor  = UIColor.white.cgColor
        
        deleteAccountButton.layer.cornerRadius = 5.0
        deleteAccountButton.layer.borderWidth  = 1.0
        deleteAccountButton.layer.borderColor  = UIColor.white.cgColor
        
        profilePic.layer.borderWidth   = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor   = UIColor.white.cgColor
        profilePic.layer.cornerRadius  = profilePic.frame.height/2
        profilePic.clipsToBounds       = true
        profilePic.image               = UserManager.sharedManager.savedImage
        
        if let hideOrShow = UserDefaults.standard.object(forKey: "accountHidden") as? String {
            if(hideOrShow != "hide") {
                hideAccountButton.setTitle("HIDE ACCOUNT", for: .normal)
                shouldHide = "hide"
            }
            else {
                hideAccountButton.setTitle("UNHIDE ACCOUNT", for: .normal)
                shouldHide = "show"
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hitProfile() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func hitVIP() {
        AlertManager.sharedManager.showSuccess(title: "Another Milestone", subTitle: "This feature is currently being brewed up by the best developer in the world.", buttonTitle: "Thanks")
    }
    
    @IBAction func hitSupport() {
        AlertManager.sharedManager.showSuccess(title: "Another Milestone", subTitle: "This feature is currently being brewed up by the best developer in the world.", buttonTitle: "Thanks")
    }
    
    @IBAction func hitLogout() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "landingmain") as! LandingPage
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func hitHide() {
        UserManager.sharedManager.hideAccount(UserManager.sharedManager.username, status: shouldHide) { (done, errmsg) in
            if(done) {
                
                UserDefaults.standard.set(self.shouldHide, forKey: "accountHidden")
                // Save the defaults
                UserDefaults.standard.synchronize()
                
                var textHide = "hidden"
                
                if(self.shouldHide == "hide") {
                    textHide = "hidden"
                    self.shouldHide = "show"
                    DispatchQueue.main.async {
                        self.hideAccountButton.setTitle("UNHIDE ACCOUNT", for: .normal)
                    }
                }
                else {
                    textHide = "un-hidden"
                    self.shouldHide = "hide"
                    DispatchQueue.main.async {
                        self.hideAccountButton.setTitle("HIDE ACCOUNT", for: .normal)
                    }
                }
                DispatchQueue.main.async {
                    AlertManager.sharedManager.showSuccess(title: "Account Hidden", subTitle: "Your Account has been " + textHide + ".", buttonTitle: "Okay");
                }
            }
        }
    }
    
    @IBAction func goBack() {
        self.navigationController?.popViewController(animated: true);
    }
    
    @IBAction func hitDelete() {
        
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to Delete your account? This cannot be undone.", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button click...")
            UserManager.sharedManager.deleteAccount(UserManager.sharedManager.username) { (done, errmsg) in
                if(done) {
                    DispatchQueue.main.async {
                        AlertManager.sharedManager.showSuccess(title: "Account Deleted", subTitle: "Your Account has been deleted.", buttonTitle: "Okay");
                        
                        let vc = self.storyboard!.instantiateViewController(withIdentifier: "landingmain") as! LandingPage
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button click...")
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
       
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
