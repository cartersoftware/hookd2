//
//  YesNoCell.swift
//  HOOKD
//
//  Created by Zachary Carter on 5/16/18.
//  Copyright © 2018 Zachary Carter. All rights reserved.
//

import UIKit

class YesNoCell: UITableViewCell {

    @IBOutlet var yesButton : UIButton!
    @IBOutlet var noButton : UIButton!
    @IBOutlet var question : UILabel!

    var identifier = 0
    
    let grayButtonColor = UIColor(red: 86/255.0, green: 86/255.0, blue: 86/255.0, alpha: 1.0)

    override func awakeFromNib() {
        super.awakeFromNib()
        noButton.backgroundColor    = grayButtonColor
        yesButton.backgroundColor   = grayButtonColor
        
        noButton.imageView!.contentMode     = .scaleAspectFill
        yesButton.imageView!.contentMode    = .scaleAspectFill
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func hitYes() {
        print("HIT YES! \(identifier)")
        
        if(UserManager.sharedManager.arrayOfDict[identifier]["question_key"] == "pets") {
            yesButton.setImage(UIImage.init(named: "HOOKDDogFilled.png"), for: .normal)
            noButton.setImage(UIImage.init(named: "HOOKDCatNotFilled.png"), for: .normal)
        }
        else {
            yesButton.setImage(UIImage.init(named: "HOOKDCheckmarkFilled.png"), for: .normal)
            noButton.setImage(UIImage.init(named: "HOOKDXNotFilled.png"), for: .normal)
        }
        
        UserManager.sharedManager.arrayOfDict[identifier]["answer"] = "yes"
        print("\(UserManager.sharedManager.arrayOfDict)")
    }
    
    @IBAction func hitNo() {
        print("HIT NO! \(identifier)")
        if(UserManager.sharedManager.arrayOfDict[identifier]["question_key"] == "pets") {
            yesButton.setImage(UIImage.init(named: "HOOKDDogNotFilled.png"), for: .normal)
            noButton.setImage(UIImage.init(named: "HOOKDCatFilled.png"), for: .normal)
        }
        else {
            yesButton.setImage(UIImage.init(named: "HOOKDCheckmarkNotFilled.png"), for: .normal)
            noButton.setImage(UIImage.init(named: "HOOKDXFilled.png"), for: .normal)
        }
        UserManager.sharedManager.arrayOfDict[identifier]["answer"] = "no"
        print("\(UserManager.sharedManager.arrayOfDict)")
    }

}
