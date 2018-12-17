//
//  YesNoCell.swift
//  HOOKD
//
//  Created by Zachary Carter on 5/16/18.
//  Copyright © 2018 Zachary Carter. All rights reserved.
//

import UIKit

class TrueFalseCell: UITableViewCell {
    
    var identifier = "";
    
    @IBOutlet var yesButton : UIButton!
    @IBOutlet var noButton : UIButton!
    @IBOutlet var question : UILabel!
    
    let grayButtonColor = UIColor(red: 86/255.0, green: 86/255.0, blue: 86/255.0, alpha: 1.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        noButton.backgroundColor    = grayButtonColor
        yesButton.backgroundColor   = grayButtonColor
        
        noButton.imageView!.contentMode     = .scaleAspectFill
        yesButton.imageView!.contentMode    = .scaleAspectFill
        
        self.contentView.backgroundColor = UIColor.black
        
        yesButton.setImage(UIImage.init(named: "HOOKDMaleFilled.png"), for: .normal)
        noButton.setImage(UIImage.init(named: "HOOKDFemaleNotFilled.png"), for: .normal)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func hitYes() {
        print("HIT YES! \(identifier)")
        
        if(identifier == "Gender" || identifier == "LookingFor") {
            yesButton.setImage(UIImage.init(named: "HOOKDMaleFilled.png"), for: .normal)
            noButton.setImage(UIImage.init(named: "HOOKDFemaleNotFilled.png"), for: .normal)
        }
        else {
            yesButton.setImage(UIImage.init(named: "HOOKDCheckmarkFilled.png"), for: .normal)
            noButton.setImage(UIImage.init(named: "HOOKDXNotFilled.png"), for: .normal)
        }
        
        if(identifier == "Gender") {
            UserManager.sharedManager.gender               = "male"
        }
        if(identifier == "LookingFor") {
            UserManager.sharedManager.lookingfor           = "male"
        }
        if(identifier == "Notifications") {
            UserManager.sharedManager.notifications        = "yes"
        }
        if(identifier == "AppSounds") {
            UserManager.sharedManager.appsounds            = "yes"
        }
        
    }
    
    @IBAction func hitNo() {
        print("HIT NO! \(identifier)")
        
        if(identifier == "Gender") {
            UserManager.sharedManager.gender               = "female"
        }
        if(identifier == "LookingFor") {
            UserManager.sharedManager.lookingfor           = "female"
        }
        if(identifier == "Notifications") {
            UserManager.sharedManager.notifications        = "no"
        }
        if(identifier == "AppSounds") {
            UserManager.sharedManager.appsounds            = "no"
        }
        
        if(identifier == "Gender" || identifier == "LookingFor") {
            yesButton.setImage(UIImage.init(named: "HOOKDMaleNotFilled.png"), for: .normal)
            noButton.setImage(UIImage.init(named: "HOOKDFemaleFilled.png"), for: .normal)
        }
        else {
            yesButton.setImage(UIImage.init(named: "HOOKDCheckmarkNotFilled.png"), for: .normal)
            noButton.setImage(UIImage.init(named: "HOOKDXFilled.png"), for: .normal)
        }
    }
    
}
