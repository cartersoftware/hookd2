//
//  LoginViewController.swift
//  HOOKD
//
//  Created by Zachary Carter on 5/5/18.
//  Copyright © 2018 Zachary Carter. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var username : UITextField!
    @IBOutlet var password : UITextField!
    @IBOutlet var loginButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.borderWidth = 1.0
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.cornerRadius = 3.0
        loginButton.backgroundColor   = UIColor.black
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login() {
        
        DispatchQueue.main.async {

            print("WTF LOGIN ISNT WORKING..")
            
            UserManager.sharedManager.authenticateUser(self.username.text!, password: self.password.text!) { (done, errormsg) in
                if(done) {
                    DispatchQueue.main.async {
                        
                        if(UserManager.sharedManager.deviceToken != "") {
                            UserManager.sharedManager.updateDeviceToken(UserManager.sharedManager.username, deviceToken: UserManager.sharedManager.deviceToken) { (done) in
                                print("SHOULD BE STORING THE TOKEN!!")
                            }
                        }
                        
                        let vc = self.storyboard!.instantiateViewController(withIdentifier: "hookdhome") as! HookdHome
                        //let vc = self.storyboard!.instantiateViewController(withIdentifier: "video") as! VideoViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        AlertManager.sharedManager.showError(title: "Oops", subTitle: errormsg, buttonTitle: "Okay")
                    }
                }
            }
            
        }
    }
    
    @IBAction func hitUsername() {
        print("HIT USERNAME!!!")
        if self.username.text == "username" {
            self.username.text = ""
        }
    }
    
    @IBAction func userNameEditingEnded() {
        if (self.username.text?.count)! < 1 {
            self.username.text = "username"
        }
    }
    
    @IBAction func hitPassword() {
        if self.password.text == "password" {
            self.password.text = ""
        }
    }
    
    @IBAction func passwordDidEndEditing() {
        if (self.password.text?.count)! < 1 {
            self.password.text = "password"
        }
    }
    
    @IBAction func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func forgotUserPass() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "forgotuserpass") as! ForgotUserPassViewController
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
