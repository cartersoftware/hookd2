//
//  ChatViewController.swift
//  HOOKD
//
//  Created by Vladimir Bahtjak on 7/23/18.
//  Copyright © 2018 Zachary Carter. All rights reserved.
//

import UIKit
import SDWebImage

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet var chatTableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        loadChatThread()
    }
    
    func loadChatThread(){
        
        UserManager.sharedManager.getChatThread { (done) in
            DispatchQueue.main.async {
                
                if done {
                    
                    self.chatTableView.reloadData()
                }else{
                    
                    AlertManager.sharedManager.showError(title: "Oops!", subTitle: OURERROR, buttonTitle: "Okay")
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return UserManager.sharedManager.chatThread.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let chatCell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatCell
        
        if let chatInfo = UserManager.sharedManager.chatThread[indexPath.item] as? NSDictionary{
            
            let username = chatInfo["messagefrom"] as? String
            let timestamp = chatInfo["timestamp"] as? String
        
            chatCell.username.text  = username
            chatCell.timestamp.text = timestamp
            
            if let avatarPath = chatInfo["threadProfilePic"] as? String {
                
                let urlToPic   = URL(string:AMZPROFILES + avatarPath)
                
                if urlToPic != nil {
                    
                    chatCell.avatar.sd_setImage(with: urlToPic!, placeholderImage: nil, options: []) { (image, error, type, url) in
                        
                    }
                }
            }
        }
        
        
        return chatCell

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let chatInfo = UserManager.sharedManager.chatThread[indexPath.item] as? NSDictionary{
            
            let id = chatInfo["messageid"] as! String
            
            let chatDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "chatDetailViewController") as! ChatDetailViewController
            
            chatDetailViewController.chattingWith = chatInfo["messageto"] as! String
          
            UserManager.sharedManager.messageID = id
            
            self.navigationController?.pushViewController(chatDetailViewController, animated: true)
        }

    }

    @IBAction func goBack(){
        
        self.navigationController?.popViewController(animated: true)
    }
}
