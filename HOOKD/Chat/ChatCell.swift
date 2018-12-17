//
//  ChatCell.swift
//  HOOKD
//
//  Created by Vladimir Bahtjak on 7/23/18.
//  Copyright © 2018 Zachary Carter. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet var username:UILabel!
    @IBOutlet var timestamp:UILabel!
    @IBOutlet var avatar:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        avatar.layer.cornerRadius = avatar.frame.size.width / 2
        avatar.clipsToBounds = true
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
