//
//  SelectUserViewController.swift
//  HOOKD
//
//  Created by Vladimir Bahtjak on 7/23/18.
//  Copyright © 2018 Zachary Carter. All rights reserved.
//
//comment

import UIKit

class SelectUserViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var searchTableView:UITableView!
    //nice
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        searchTableView.keyboardDismissMode = .onDrag
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        loadUsers()
    }
    
    func loadUsers(){
        
        UserManager.sharedManager.getAllUsers { (done) in
            DispatchQueue.main.async {
                
                if done {
                    
                    self.searchTableView.reloadData()
                }else{
                    
                    AlertManager.sharedManager.showError(title: "Oops!", subTitle: OURERROR, buttonTitle: "Okay")
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return UserManager.sharedManager.searchUsers.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let chatCell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchCell
        
        if let userInfo = UserManager.sharedManager.searchUsers[indexPath.item] as? NSDictionary{
            
            let username = userInfo["username"] as? String
            
            chatCell.username.text  = username
            
            if let avatarPath = userInfo["profilePic"] as? String {
                
                
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
        
        if let userInfo = UserManager.sharedManager.searchUsers[indexPath.item] as? NSDictionary{
            
            let id = UUID().uuidString
            
            let chatDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "chatDetailViewController") as! ChatDetailViewController
            
            chatDetailViewController.chattingWith = userInfo["username"] as! String
            
            UserManager.sharedManager.messageID = id
            
            self.navigationController?.pushViewController(chatDetailViewController, animated: true)
        }
        
    }
    
    @IBAction func goBack(){
        
        self.navigationController?.popViewController(animated: true)
    }
}
