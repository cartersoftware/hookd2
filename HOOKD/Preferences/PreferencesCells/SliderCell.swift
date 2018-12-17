//
//  YesNoCell.swift
//  HOOKD
//
//  Created by Zachary Carter on 5/16/18.
//  Copyright © 2018 Zachary Carter. All rights reserved.
//

import UIKit

class SliderCell: UITableViewCell {
    
    var identifier = "";
    
    @IBOutlet var question : UILabel!
    @IBOutlet var maxVal : UILabel!
    @IBOutlet var minVal : UILabel!
    @IBOutlet var slider : UISlider!
    
    let grayButtonColor = UIColor(red: 86/255.0, green: 86/255.0, blue: 86/255.0, alpha: 1.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        maxVal.text = "99"
        minVal.text = "0"
        slider.minimumValue = 0.0
        slider.maximumValue = 99.0
        
            
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func sliderChanged() {
        print("SLIDER VAL: \(Int(slider.value))")
        maxVal.text = "\(Int(slider.value))"
        
        if(identifier == "Age") {
            UserManager.sharedManager.age             = "\(Int(slider.value))"
        }
        if(identifier == "SearchRadius") {
            UserManager.sharedManager.searchradius    = "\(Int(slider.value))"
        }
    
    }
    
    
    
}
