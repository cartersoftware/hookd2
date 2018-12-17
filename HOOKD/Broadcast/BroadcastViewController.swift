//
//  BroadcastViewControlller.swift
//  HelpMe
//
//  Created by Vladimir Bahtjak on 10/30/17.
//  Copyright © 2017 DellaCoreLLC. All rights reserved.
//

import UIKit
import OpenTok
import FontAwesome_swift
import AVFoundation
import AVKit

// *** Fill the following variables using your own Project info  ***
// ***            https://tokbox.com/account/#/                  ***
// Replace with your OpenTok API key
let kApiKey = "45991122"
// Replace with your generated session ID
var kSessionId = "1_MX40NTk5MTEyMn5-MTUxODM3NjA2OTY1NX5tcFNaL0JIMnZ4MHNHajdURXd1U3RJME1-fg"
// Replace with your generated token
var kToken = "T1==cGFydG5lcl9pZD00NTk5MTEyMiZzaWc9MTI4NGVhMzE3ZTc4NGJiZjNmZmJiNjQ5ZWQ2NDQ4OTAxNGIzMTAxZDpzZXNzaW9uX2lkPTFfTVg0ME5UazVNVEV5TW41LU1UVXhPRE0zTmpBMk9UWTFOWDV0Y0ZOYUwwSklNblo0TUhOSGFqZFVSWGQxVTNSSk1FMS1mZyZjcmVhdGVfdGltZT0xNTE4Mzc2MTE0Jm5vbmNlPTAuODM0MDA3NDYwOTMwMjYyMSZyb2xlPXB1Ymxpc2hlciZleHBpcmVfdGltZT0xNTIwOTY0NTA5JmluaXRpYWxfbGF5b3V0X2NsYXNzX2xpc3Q9"

let kWidgetHeight = SCREENHEIGHT / 2
let kWidgetWidth = SCREENWIDTH

class BroadcastViewController: UIViewController,UINavigationControllerDelegate {
    
    @IBOutlet var broadcastView:UIView!
    @IBOutlet var endBroadcastButton:UIButton!
    
    var sessionStarted = false
    var bothUsersIn    = false

    @IBOutlet var closeOutButton:UIButton!
    
    var helpID = ""
    
    var session: OTSession!;
    var publisher: OTPublisher!;
    var subscriber: OTSubscriber?
    
    var didCancel = false
    
    var numSessionsConnected = 1;
    
    // Change to `false` to subscribe to streams other than your own.
    var subscribeToSelf = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        DispatchQueue.main.async {
            self.endBroadcastButton.layer.cornerRadius      = 35.0
            self.endBroadcastButton.clipsToBounds           = true
            self.endBroadcastButton.titleLabel?.font        = UIFont.fontAwesome(ofSize: 30, style: .solid)
            
            self.endBroadcastButton.setTitleColor(.white, for: .normal)
            
            self.endBroadcastButton.setTitle(String.fontAwesomeIcon(name: .phone), for: .normal)
            self.endBroadcastButton.setTitle(String.fontAwesomeIcon(name: .phone), for: .highlighted)
            self.endBroadcastButton.setTitle(String.fontAwesomeIcon(name: .phone), for: .selected)
            self.endBroadcastButton.setTitle(String.fontAwesomeIcon(name: .phone), for: .focused)
            self.endBroadcastButton.setTitle(String.fontAwesomeIcon(name: .phone), for: .disabled)

            self.endBroadcastButton.backgroundColor?.withAlphaComponent(0.8)
            
            self.closeOutButton.layer.cornerRadius = 20.0
            self.closeOutButton.clipsToBounds = true
            self.closeOutButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 18.0, style: .solid)
            self.closeOutButton.setTitle(String.fontAwesomeIcon(name: .times), for: .normal)
            self.closeOutButton.backgroundColor?.withAlphaComponent(0.8)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        endBroadcastButton.setTitle(String.fontAwesomeIcon(name: .phone), for: .normal)
        endBroadcastButton.setTitle(String.fontAwesomeIcon(name: .phone), for: .highlighted)
        endBroadcastButton.setTitle(String.fontAwesomeIcon(name: .phone), for: .selected)
        endBroadcastButton.setTitle(String.fontAwesomeIcon(name: .phone), for: .focused)
        endBroadcastButton.setTitle(String.fontAwesomeIcon(name: .phone), for: .disabled)
        
        if(BroadcastManager.sharedManager.shouldDismissBroadcastView == true) {
            DispatchQueue.main.async {
            self.dismiss(animated: false, completion: nil);
            }
        }
        
        UIApplication.shared.isStatusBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        BroadcastManager.sharedManager.userInBroadcast(UserManager.sharedManager.username, "yes", completionBlock: { (done) in
            //User is in the broadcast
        });
        
        if sessionStarted == false {
            
            sessionStarted = true
            getSessionAndToken()
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        BroadcastManager.sharedManager.userInBroadcast(UserManager.sharedManager.username, "no", completionBlock: { (done) in
            //User is in the broadcast
        });
    }
    
    func getSessionAndToken() {
        
        if(BroadcastManager.sharedManager.isRequestingBroadcast == true) {
            
            // Get Initial Feed
            BroadcastManager.sharedManager.createSessionForBroadcast(UserManager.sharedManager.username) { (done) in
                DispatchQueue.main.async {
                    
                    print("SUCCESS THE KEY SESSION IS: \(BroadcastManager.sharedManager.tokSessionID)");
                    kToken = BroadcastManager.sharedManager.tokToken;
                    
                    self.session    = OTSession(apiKey: kApiKey, sessionId: BroadcastManager.sharedManager.tokSessionID, delegate: self);
                    
                    let settings    = OTPublisherSettings()
                    
                    settings.name   = UIDevice.current.name
                    
                    self.publisher  = OTPublisher(delegate: self, settings: settings);
                    
                    
                    self.doConnect()
                }
            }
        }
        else {
            BroadcastManager.sharedManager.getSessionForBroadcast(BroadcastManager.sharedManager.personBroadcastingWith) { (done) in
                DispatchQueue.main.async {
                    
                    print("CONNECTING TO HELPEE: THE KEY SESSION IS: \(BroadcastManager.sharedManager.tokSessionID)");
                    
                    kToken = BroadcastManager.sharedManager.tokToken;
                    
                    self.session    = OTSession(apiKey: kApiKey, sessionId: BroadcastManager.sharedManager.tokSessionID, delegate: self);
                    
                    let settings    = OTPublisherSettings()
    
                    settings.name   = UIDevice.current.name
                    
                    self.publisher  = OTPublisher(delegate: self, settings: settings);
        
                    self.doConnect()
                }
            }
        }
        
    }
    
    func bothUsersAreIn() {
        bothUsersIn = true
    }
    
    @IBAction func closeOut() {
        
        let cancelController = UIAlertController(title: "End broadcast", message: "Are you sure you want to end this broadcast?", preferredStyle: .alert)
        
        cancelController.view.tintColor = HOOKDRED
        
        cancelController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (Take) in
            
            self.didCancel = true
            
            self.dismiss(animated: true, completion: nil)
            
           // UIApplication.shared.isStatusBarHidden = false
            
        }))
        
        cancelController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(cancelController, animated: true, completion: nil)
        
    }
    
    @IBAction func endBroadcast(){
        
        BroadcastManager.sharedManager.resetBroadcastSession(UserManager.sharedManager.username) { (done) in
            DispatchQueue.main.async {
            }
        }
        
        var error: OTError?
        defer {
            processError(error)
        }
        
        session.disconnect(&error)
        
        if(didCancel == false){
            //
        }
    }
    
    /**
     * Asynchronously begins the session connect process. Some time later, we will
     * expect a delegate method to call us back with the results of this action.
     */
    fileprivate func doConnect() {
        var error: OTError?
        defer {
            processError(error)
        }
        
        session.connect(withToken: kToken, error: &error)
    }
    
    /**
     * Sets up an instance of OTPublisher to use with this session. OTPubilsher
     * binds to the device camera and microphone, and will provide A/V streams
     * to the OpenTok session.
     */
    fileprivate func doPublish() {
        var error: OTError?
        defer {
            processError(error)
        }
        
        session.publish(publisher, error: &error)
        
        if let pubView = publisher.view {
            pubView.frame = CGRect(x: 0, y: 0, width: kWidgetWidth, height: kWidgetHeight)
            broadcastView.addSubview(pubView)
        }
    }
    
    /**
     * Instantiates a subscriber for the given stream and asynchronously begins the
     * process to begin receiving A/V content for this stream. Unlike doPublish,
     * this method does not add the subscriber to the view hierarchy. Instead, we
     * add the subscriber only after it has connected and begins receiving data.
     */
    fileprivate func doSubscribe(_ stream: OTStream) {
        
        numSessionsConnected = numSessionsConnected + 1;
        
        print("NUM SUBSCRIBERS \(numSessionsConnected)")
        
        var error: OTError?
        defer {
            processError(error)
        }
        subscriber = OTSubscriber(stream: stream, delegate: self)
        
        session.subscribe(subscriber!, error: &error)
    }
    
    fileprivate func cleanupSubscriber() {
        subscriber?.view?.removeFromSuperview()
        subscriber = nil
    }
    
    fileprivate func processError(_ error: OTError?) {
        if let err = error {
            DispatchQueue.main.async {
                let controller = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - OTSession delegate callbacks
extension BroadcastViewController: OTSessionDelegate {
    func sessionDidConnect(_ session: OTSession) {
        print("Session connected")
        doPublish()
    }
    
    func sessionDidDisconnect(_ session: OTSession) {
        print("Session disconnected")
    }
    
    func session(_ session: OTSession, streamCreated stream: OTStream) {
        print("Session streamCreated: \(stream.streamId)")
        
        if subscriber == nil && !subscribeToSelf {
            doSubscribe(stream)
        }
    }
    
    func session(_ session: OTSession, streamDestroyed stream: OTStream) {
        print("Session streamDestroyed: \(stream.streamId)")
        if let subStream = subscriber?.stream, subStream.streamId == stream.streamId {
            cleanupSubscriber()
        }
    }
    
    func session(_ session: OTSession, didFailWithError error: OTError) {
        print("session Failed to connect: \(error.localizedDescription)")
    }
    
}

// MARK: - OTPublisher delegate callbacks
extension BroadcastViewController: OTPublisherDelegate {
    func publisher(_ publisher: OTPublisherKit, streamCreated stream: OTStream) {
        if subscriber == nil && subscribeToSelf {
            doSubscribe(stream)
        }
    }
    
    func publisher(_ publisher: OTPublisherKit, streamDestroyed stream: OTStream) {
        if let subStream = subscriber?.stream, subStream.streamId == stream.streamId {
            cleanupSubscriber()
        }
    }
    
    func publisher(_ publisher: OTPublisherKit, didFailWithError error: OTError) {
        print("Publisher failed: \(error.localizedDescription)")
    }
}

// MARK: - OTSubscriber delegate callbacks
extension BroadcastViewController: OTSubscriberDelegate {
    func subscriberDidConnect(toStream subscriberKit: OTSubscriberKit) {
        if let subsView = subscriber?.view {
            subsView.frame = CGRect(x: 0, y: kWidgetHeight, width: kWidgetWidth, height: kWidgetHeight)
            broadcastView.addSubview(subsView)
        }
    }
    
    func subscriber(_ subscriber: OTSubscriberKit, didFailWithError error: OTError) {
        print("Subscriber failed: \(error.localizedDescription)")
    }
}
