//
//  PreferencesViewController.swift
//  HOOKD
//
//  Created by Zachary Carter on 6/28/18.
//  Copyright © 2018 Zachary Carter. All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView : UITableView!
    @IBOutlet var saveButton : UIButton!
    @IBOutlet var profilePic : UIImageView!
    @IBOutlet var usernameLabel : UILabel!
    
    var imageOperation      = OperationQueue()
    var loading             = true
    var hasDataLoaded       = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        saveButton.layer.cornerRadius = 5.0
        saveButton.layer.borderWidth  = 1.0
        saveButton.layer.borderColor  = UIColor.white.cgColor
        
        profilePic.layer.borderWidth   = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor   = UIColor.white.cgColor
        profilePic.layer.cornerRadius  = profilePic.frame.height/2
        profilePic.clipsToBounds       = true
        
    
        usernameLabel.text             = UserManager.sharedManager.username
        
        // Do any additional setup after loading the view.
        imageOperation.maxConcurrentOperationCount = 1
        
        if(UserManager.sharedManager.cameFromWizard == true) {
            print("NEW URL: \(UserManager.sharedManager.profilePic)")
            profilePic.image = UserManager.sharedManager.savedImage
            self.loading = false
        }
        else {
            profilePic.image = UserManager.sharedManager.savedImage
            self.loading = true
        }
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        if(UserManager.sharedManager.cameFromWizard != true) {
            
            print("SOULD LOADING ");
            UserManager.sharedManager.getAccountSettings(UserManager.sharedManager.username) { (done, errormsg) in
                if(done) {
                    
                    print("DONE");
                    print("ACCOUNT SETTINGS : \(UserManager.sharedManager.accountSettings)");
                    
                    self.loading = false
                    self.hasDataLoaded = true
                    
                    //Lets make sure we set the defaults.
                    UserManager.sharedManager.gender        = UserManager.sharedManager.accountSettings.object(forKey: "gender") as! String
                    UserManager.sharedManager.lookingfor    = UserManager.sharedManager.accountSettings.object(forKey: "seeking") as! String
                    UserManager.sharedManager.notifications = UserManager.sharedManager.accountSettings.object(forKey: "notifications") as! String
                    UserManager.sharedManager.appsounds     = UserManager.sharedManager.accountSettings.object(forKey: "appsounds") as! String
                    UserManager.sharedManager.age           = UserManager.sharedManager.accountSettings.object(forKey: "age") as! String
                    UserManager.sharedManager.searchradius  = UserManager.sharedManager.accountSettings.object(forKey: "searchRadius") as! String
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(UserManager.sharedManager.cameFromWizard == true) {
            return 6
        }
        else if(self.loading == false) {
            return 6
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(self.loading == true) {
            let questionCell             = tableView.dequeueReusableCell(withIdentifier: "loadingpref", for: indexPath)
            //questionCell.textLabel?.text = "Loading Preferences. One moment.";
            return questionCell
        }
        else {
        
            if(indexPath.row == 0) {
                //Gender
                let questionCell           = tableView.dequeueReusableCell(withIdentifier: "truefalsecell", for: indexPath) as! TrueFalseCell
                questionCell.question.text = "Gender:"
                questionCell.identifier    = "Gender"
                questionCell.yesButton.setImage(UIImage.init(named: "HOOKDMaleNotFilled.png"), for: .normal)
                questionCell.noButton.setImage(UIImage.init(named: "HOOKDFemaleNotFilled.png"), for: .normal)
                
                if(self.hasDataLoaded == true) {
                    
                    if(UserManager.sharedManager.gender.count > 0) {
                        if(UserManager.sharedManager.gender == "male") {
                            questionCell.yesButton.setImage(UIImage.init(named: "HOOKDMaleFilled.png"), for: .normal)
                            questionCell.noButton.setImage(UIImage.init(named: "HOOKDFemaleNotFilled.png"), for: .normal)
                        }
                        else {
                            questionCell.noButton.setImage(UIImage.init(named: "HOOKDFemaleFilled.png"), for: .normal)
                            questionCell.yesButton.setImage(UIImage.init(named: "HOOKDMaleNotFilled.png"), for: .normal)
                        }
                    }
                }
                
                return questionCell
                
            }
            else if(indexPath.row == 1) {
                //Looking For
                let questionCell           = tableView.dequeueReusableCell(withIdentifier: "truefalsecell", for: indexPath) as! TrueFalseCell
                questionCell.question.text = "Looking For:"
                questionCell.identifier    = "LookingFor"
                questionCell.yesButton.setImage(UIImage.init(named: "HOOKDMaleNotFilled.png"), for: .normal)
                questionCell.noButton.setImage(UIImage.init(named: "HOOKDFemaleNotFilled.png"), for: .normal)
                
                if(self.hasDataLoaded == true) {
                    if(UserManager.sharedManager.lookingfor.count > 0) {
                        if(UserManager.sharedManager.lookingfor == "male") {
                            questionCell.yesButton.setImage(UIImage.init(named: "HOOKDMaleFilled.png"), for: .normal)
                            questionCell.noButton.setImage(UIImage.init(named: "HOOKDFemaleNotFilled.png"), for: .normal)
                        }
                        else {
                            questionCell.noButton.setImage(UIImage.init(named: "HOOKDFemaleFilled.png"), for: .normal)
                            questionCell.yesButton.setImage(UIImage.init(named: "HOOKDMaleNotFilled.png"), for: .normal)
                        }
                    }
                }
                
                return questionCell
            }
            else if(indexPath.row == 2) {
                //Notifications
                let questionCell           = tableView.dequeueReusableCell(withIdentifier: "truefalsecell", for: indexPath) as! TrueFalseCell
                questionCell.question.text = "Notifications:"
                questionCell.identifier    = "Notifications"
                questionCell.yesButton.setImage(UIImage.init(named: "HOOKDCheckmarkNotFilled.png"), for: .normal)
                questionCell.noButton.setImage(UIImage.init(named: "HOOKDXNotFilled.png"), for: .normal)
                
                if(self.hasDataLoaded == true) {
                    if(UserManager.sharedManager.notifications.count > 0) {
                        if(UserManager.sharedManager.notifications == "yes") {
                            questionCell.yesButton.setImage(UIImage.init(named: "HOOKDCheckmarkFilled.png"), for: .normal)
                            questionCell.noButton.setImage(UIImage.init(named: "HOOKDXNotFilled.png"), for: .normal)
                        }
                        else {
                            questionCell.yesButton.setImage(UIImage.init(named: "HOOKDCheckmarkNotFilled.png"), for: .normal)
                            questionCell.noButton.setImage(UIImage.init(named: "HOOKDXFilled.png"), for: .normal)
                        }
                    }
                }
                
                return questionCell
            }
            else if(indexPath.row == 3) {
                //App Sounds
                let questionCell           = tableView.dequeueReusableCell(withIdentifier: "truefalsecell", for: indexPath) as! TrueFalseCell
                questionCell.question.text = "AppSounds:"
                questionCell.identifier    = "AppSounds"
                questionCell.yesButton.setImage(UIImage.init(named: "HOOKDCheckmarkNotFilled.png"), for: .normal)
                questionCell.noButton.setImage(UIImage.init(named: "HOOKDXNotFilled.png"), for: .normal)
                
                if(self.hasDataLoaded == true) {
                    
                    if(UserManager.sharedManager.appsounds.count > 0) {
                        if(UserManager.sharedManager.appsounds == "yes") {
                            questionCell.yesButton.setImage(UIImage.init(named: "HOOKDCheckmarkFilled.png"), for: .normal)
                            questionCell.noButton.setImage(UIImage.init(named: "HOOKDXNotFilled.png"), for: .normal)
                        }
                        else {
                            questionCell.yesButton.setImage(UIImage.init(named: "HOOKDCheckmarkNotFilled.png"), for: .normal)
                            questionCell.noButton.setImage(UIImage.init(named: "HOOKDXFilled.png"), for: .normal)
                        }
                    }
                }
                
                return questionCell
            }
            else if(indexPath.row == 4) {
                //Slider - Age
                let questionCell           = tableView.dequeueReusableCell(withIdentifier: "slidercell", for: indexPath) as! SliderCell
                questionCell.question.text = "Age:"
                questionCell.identifier    = "Age"
                questionCell.slider.minimumValue = 18
                questionCell.minVal.text = "18"
                
                if(self.hasDataLoaded == true) {
                    
                    if(UserManager.sharedManager.age.count > 0) {
                        questionCell.slider.setValue(Float(UserManager.sharedManager.age)!, animated: false)
                        questionCell.maxVal.text = UserManager.sharedManager.age
                    }
                    else {
                        UserManager.sharedManager.age = "18"
                    }
                }
                
                return questionCell
            }
            else if(indexPath.row == 5) {
                //Slider - Search Radius
                let questionCell           = tableView.dequeueReusableCell(withIdentifier: "slidercell", for: indexPath) as! SliderCell
                questionCell.question.text = "Search Radius:"
                questionCell.identifier    = "SearchRadius"
                questionCell.slider.minimumValue = 10
                questionCell.minVal.text = "10"
                
                if(self.hasDataLoaded == true) {
                    if(UserManager.sharedManager.searchradius.count > 0) {
                        questionCell.slider.setValue(Float(UserManager.sharedManager.searchradius)!, animated: false)
                        questionCell.maxVal.text = UserManager.sharedManager.searchradius
                    }
                    else {
                        UserManager.sharedManager.searchradius = "10"
                    }
                }
                
                return questionCell
            }
        
        }
        let questionCell = tableView.cellForRow(at: indexPath)
        
        return questionCell!
        
    }
    
    @IBAction func saveNow() {
        /*let vc = self.storyboard!.instantiateViewController(withIdentifier: "hookdhome") as! HookdHome
        self.navigationController?.pushViewController(vc, animated: true)*/
         UserManager.sharedManager.shouldReloadMatches = true
        
        if(UserManager.sharedManager.gender.count > 0 && UserManager.sharedManager.lookingfor.count > 0 && UserManager.sharedManager.notifications.count > 0 && UserManager.sharedManager.appsounds.count > 0) {
            
            UserManager.sharedManager.updateAccountSettings(UserManager.sharedManager.username, gender: UserManager.sharedManager.gender, seeking: UserManager.sharedManager.lookingfor, notifications: UserManager.sharedManager.notifications, appsounds: UserManager.sharedManager.appsounds, age: UserManager.sharedManager.age, searchRadius: UserManager.sharedManager.searchradius)
            { (done, errormsg) in
                if(done) {
                    print("SUCCESS!!!")
                    if(UserManager.sharedManager.cameFromWizard == true) {
                        
                        DispatchQueue.main.async {
                            let vc = self.storyboard!.instantiateViewController(withIdentifier: "hookdhome") as! HookdHome
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    else {
                        
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true);
                        }
                    }
                    //AlertManager.sharedManager.showSuccess(title: "Settings Updated", subTitle: <#T##String#>, buttonTitle: <#T##String#>)
                }
                else {
                    
                }
            }
        }
        else {
            AlertManager.sharedManager.showError(title: "Missing Preferences", subTitle: "Please make sure you fill out all preferences.", buttonTitle: "Okay")
        }
    }
    
    @IBAction func close() {
        self.navigationController?.popViewController(animated: true);
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
