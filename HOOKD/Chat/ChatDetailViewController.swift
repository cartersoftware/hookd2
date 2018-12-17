//
//  ChatDetailViewController.swift
//  HOOKD
//
//  Created by Vladimir Bahtjak on 7/23/18.
//  Copyright © 2018 Zachary Carter. All rights reserved.
//

import UIKit

class ChatDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {

    @IBOutlet var chatTableView:UITableView!
    @IBOutlet var chatTextField:UITextField!
    @IBOutlet var chatBottomConstraint:NSLayoutConstraint!
    @IBOutlet var avatarImage:UIImageView!
    @IBOutlet var chattingWithTitle:UILabel!
    
    var chattingWith = ""
    var chatTimer:Timer!
    var hasShownBroadcastAlert = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.chatTableView.keyboardDismissMode = .onDrag
        self.chatTableView.estimatedRowHeight = 100
        self.chatTableView.rowHeight = UITableViewAutomaticDimension
        self.chatTableView.separatorColor = .black
        
        self.chatTextField.keyboardAppearance = .dark
        
        chatTextField.attributedPlaceholder = NSAttributedString(string: "Enter message",
                                                               attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.7)])
        
        chattingWithTitle.text = self.chattingWith
        
        avatarImage.layer.cornerRadius = avatarImage.frame.size.width / 2
        avatarImage.clipsToBounds = true
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            
            self.chatTimer = timer
            self.loadChatThread()
            
        }.fire()
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
        self.chatTimer.invalidate()
        
        UserManager.sharedManager.chatDetails = []
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
                //iPhone X
                
                self.chatBottomConstraint.constant = keyboardHeight - 96
                
            }else{
                
                self.chatBottomConstraint.constant = keyboardHeight
                
            }
            UIView.animate(withDuration: 0.3, animations: {
                
                self.view.layoutIfNeeded()
                
            })
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        self.chatBottomConstraint.constant = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        loadChatThread()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        hasShownBroadcastAlert = false
    }
    
    func reloadChatThread(){
        
        UserManager.sharedManager.getChatHistory { (done) in
            DispatchQueue.main.async {
                
                if done {
                    
                    self.chatTableView.reloadData()
                    
                }else{
                    
                }
            }
        }
    }
    
    
    func loadChatThread() {
        
        UserManager.sharedManager.getChatHistory { (done) in
            DispatchQueue.main.async {
                
                if done {
                    
                    self.chatTableView.reloadData()
                    
                    if(UserManager.sharedManager.chatDetails.count > 0) {
                        let indexPath = IndexPath(row: (UserManager.sharedManager.chatDetails.count-1), section: 0)
                        self.chatTableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
                        if BroadcastManager.sharedManager.shouldBroadcast == "true" {
                            if(self.hasShownBroadcastAlert == false) {
                                
                                BroadcastManager.sharedManager.personBroadcastingWith = self.chattingWith
                                self.hasShownBroadcastAlert = true
                                let cancelController = UIAlertController(title: "\(self.chattingWith) requested video", message: "Would you like to video chat with \(self.chattingWith)?", preferredStyle: .alert)
                                
                                cancelController.view.tintColor = HOOKDRED
                                
                                cancelController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (Take) in
                                    
                                        BroadcastManager.sharedManager.isRequestingBroadcast = false
                                        let broadcastViewController = self.storyboard?.instantiateViewController(withIdentifier: "broadcastViewController") as! BroadcastViewController
                                        self.present(broadcastViewController, animated: true, completion: nil)
                                    
                                    
                                }))
                                
                                cancelController.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (Take) in
                                    
                                    BroadcastManager.sharedManager.resetBroadcastSession(UserManager.sharedManager.username, completionBlock: { (done) in
                                        self.hasShownBroadcastAlert = false
                                    })
                                    
                                    
                                }))
                                
                                self.present(cancelController, animated: true, completion: nil)
                            }
                        }
                    }
                } else{
                
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return UserManager.sharedManager.chatDetails.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let chatCell = tableView.dequeueReusableCell(withIdentifier: "chatDetailCell", for: indexPath) as! ChatDetailCell
        
        if let chatInfo = UserManager.sharedManager.chatDetails[indexPath.item] as? NSDictionary{
            
            let username  = chatInfo["messagefrom"] as? String
            let timestamp = chatInfo["timestamp"] as? String
            let messageto = chatInfo["messageto"] as? String
            let message   = chatInfo["message"] as? String
            
            if username!.lowercased() == UserManager.sharedManager.username.lowercased() {
                
                //chatCell.lineSep.backgroundColor = UIColor.black
                chatCell.rightHook.alpha = 0
                chatCell.rightMessage.alpha = 0
                chatCell.rightBubbleBackground.alpha = 0
                chatCell.leftHook.alpha = 1
                chatCell.message.alpha = 1
                chatCell.bubbleBackground.alpha = 1
                
                if let avatarPath = chatInfo["messagefromProfilePic"] as? String {
                    
                    let urlToPic   = URL(string:AMZPROFILES + avatarPath)
                    
                    if urlToPic != nil {
                        
                        //chatCell.avatar.sd_setImage(with: urlToPic!, placeholderImage: nil, options: []) { (image, error, type, url) in
                            
                        //}
                    }
                    
                }
                
                
            }else{
    
              
                //chatCell.lineSep.backgroundColor = HOOKDRED
                chatCell.rightHook.alpha = 1
                chatCell.rightMessage.alpha = 1
                chatCell.rightBubbleBackground.alpha = 1
                chatCell.leftHook.alpha = 0
                chatCell.message.alpha = 0
                chatCell.bubbleBackground.alpha = 0
                
                if let avatarPath = chatInfo["messagetoProfilePic"] as? String {
                    
                    let urlToPic   = URL(string:AMZPROFILES + avatarPath)
                    
                    if urlToPic != nil {
                        
                        
                       avatarImage.sd_setImage(with: urlToPic!, placeholderImage: nil, options: []) { (image, error, type, url) in
                            
                        }
                    }
                    
                }
                
            
            }
            
            //chatCell.username.text  = username
           
            chatCell.message.layer.cornerRadius = 10.0
            chatCell.message.text = message
            chatCell.rightMessage.text = message
            chatCell.rightMessage.layer.cornerRadius = 10.0
            
            //chatCell.timestamp.text = timestamp
            
        }
        
        
        return chatCell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    @IBAction func requestVideoChat() {
        
        print("USER FROM: \(UserManager.sharedManager.username) AND USER TO: \(chattingWith)")
        
        BroadcastManager.sharedManager.postVideoRequest(UserManager.sharedManager.username, messageto: chattingWith) { (success,errmsg) in

            if(success) {
                DispatchQueue.main.async {

                print("SUCCESS!!!")
                BroadcastManager.sharedManager.isRequestingBroadcast = true
                let broadcastViewController = self.storyboard?.instantiateViewController(withIdentifier: "broadcastViewController") as! BroadcastViewController
                self.present(broadcastViewController, animated: true, completion: nil)
                }
            }
            else {
                print("FAIL!!!!")
            }
            
        }
    }
    
    @IBAction func sendMessaage() {
        
        if chatTextField.text?.replacingOccurrences(of: " ", with: "").characters.count == 0 {
            
            AlertManager.sharedManager.showError(title: "Oops!", subTitle: "Please fill out the message...", buttonTitle: "Okay")
            
            return
        }
        
        let messageToSend       = self.chatTextField.text!
        
        self.chatTextField.text = ""
        
        UserManager.sharedManager.sendChat(messageToSend,chattingWith) { (done, error) in
            
            DispatchQueue.main.async {
                if done {
                
                } else {
                    
                    AlertManager.sharedManager.showError(title: "Oops", subTitle: error, buttonTitle: "Okay")
                }
            }
        }
    }

    @IBAction func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
