//
//  ChatDetailCell.swift
//  HOOKD
//
//  Created by Vladimir Bahtjak on 7/23/18.
//  Copyright © 2018 Zachary Carter. All rights reserved.
//

import UIKit

class ChatDetailCell: UITableViewCell {
    
    @IBOutlet var username:UILabel!
    @IBOutlet var timestamp:UILabel!
    @IBOutlet var avatar:UIImageView!
    @IBOutlet var lineSep:UIView!
    @IBOutlet var message:UILabel!
    @IBOutlet var bubbleBackground:UIView!
    @IBOutlet var leftHook:UIImageView!
    @IBOutlet var rightHook:UIImageView!
    @IBOutlet var rightBubbleBackground:UIView!
    @IBOutlet var rightMessage:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       // avatar.layer.cornerRadius = avatar.frame.size.width / 2
        //avatar.clipsToBounds = true
        bubbleBackground.layer.cornerRadius = 10.0
        rightBubbleBackground.layer.cornerRadius = 10.0

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

