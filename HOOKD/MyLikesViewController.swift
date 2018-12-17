//
//  MyLikesViewController.swift
//  HOOKD
//
//  Created by Zachary Carter on 5/5/18.
//  Copyright © 2018 Zachary Carter. All rights reserved.
//

import UIKit

class MyLikesViewController: UIViewController {

    @IBOutlet var profileImage : UIImageView!
    @IBOutlet var navBar : UIView!
    @IBOutlet var actionButton : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.image = profileImage.image!.withRenderingMode(.alwaysTemplate)
        profileImage.tintColor = UIColor.white
        
        navBar.backgroundColor = UIColor.black
        actionButton.backgroundColor = UIColor.black
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func gotoHookd() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "hookdhome") as! HookdHome
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func gotoAlerts() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "alerts") as! AlertsViewController
        self.navigationController?.pushViewController(vc, animated: false)
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
