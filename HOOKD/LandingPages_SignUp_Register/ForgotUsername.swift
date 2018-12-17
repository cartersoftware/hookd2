//
//  ForgotUsername.swift
//  HOOKD
//
//  Created by Zachary Carter on 5/5/18.
//  Copyright © 2018 Zachary Carter. All rights reserved.
//

import UIKit

class ForgotUsername: UIViewController {

    @IBOutlet var emailAddress : UITextField!
    @IBOutlet var getUsername : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getUsername.layer.cornerRadius = 5.0
        getUsername.backgroundColor = HOOKDRED
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func forgotUsername() {
        UserManager.sharedManager.forgotUsername(emailAddress.text!) { (done, errormsg) in
            if(done) {
                DispatchQueue.main.async {
                    AlertManager.sharedManager.showSuccess(title: "Success", subTitle: "An email is on the way. Please check it for your username!", buttonTitle: "Okay")
                    
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else {
                DispatchQueue.main.async {
                    AlertManager.sharedManager.showError(title: "Whoops", subTitle: errormsg, buttonTitle: "Okay")
                }
            }
        }
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
