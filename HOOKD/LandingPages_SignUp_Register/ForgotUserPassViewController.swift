//
//  ForgotUserPassViewController.swift
//  HOOKD
//
//  Created by Zachary Carter on 6/7/18.
//  Copyright © 2018 Zachary Carter. All rights reserved.
//

import UIKit

class ForgotUserPassViewController: UIViewController {

    @IBOutlet var forgotUser : UIButton!
    @IBOutlet var forgotPass : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        forgotUser.layer.cornerRadius = 3.0
        forgotUser.layer.borderColor = UIColor.white.cgColor
        forgotUser.layer.borderWidth = 1.0
        
        forgotPass.layer.cornerRadius = 3.0
        forgotPass.layer.borderColor = UIColor.white.cgColor
        forgotPass.layer.borderWidth = 1.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func forgotPassword() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "forgotpass") as! ForgotPassword
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func forgotUsername() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "forgotuser") as! ForgotUsername
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func goBack() {
        self.navigationController?.popViewController(animated: true)
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
