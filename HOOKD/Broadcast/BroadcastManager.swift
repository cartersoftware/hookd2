//
//  BroadcastManager.swift
//  HelpMe
//
//  Created by Vladimir Bahtjak on 11/21/17.
//  Copyright © 2017 DellaCoreLLC. All rights reserved.
//

import UIKit

class BroadcastManager: NSObject {
    
    
    var broadcastFiles = NSMutableArray()
    var shouldDismissBroadcastView = false
    var isRequestingBroadcast = false
    var tokSessionID   = ""
    var tokToken       = ""
    var personBroadcastingWith = ""
    var shouldBroadcast = ""
    
    class var sharedManager :BroadcastManager{
        struct _Singleton{
            static let instance = BroadcastManager()
        }
        return _Singleton.instance
    }
    
    func userInBroadcast(_ usernameGetting:String, _ isInBroadcast:String, completionBlock:@escaping (_ success:Bool) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string:HOOKDAPI + "UpdateBroadcast.php?username=\(usernameGetting)&isInBroadcast=\(isInBroadcast)")!)
        print(urlRequest.url?.absoluteString)
        
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest) { (serverData, serverResponse, serverError) in
            
            if serverError == nil && serverData != nil {
                
                let data = String.init(data: serverData!, encoding: .utf8)
                
                print("DATA",data)
                
                if let jsonObject = try? JSONSerialization.jsonObject(with: serverData!, options: []) as? NSDictionary {
                    
                    if(jsonObject?.object(forKey: "Status") as? String == "Success") {
                        completionBlock(true)
                    }
                    else {
                        completionBlock(false)
                    }
                } else {
                    completionBlock(false)
                }
            } else {
                print("NIL DATA")
                completionBlock(false)
            }
            }.resume()
    }
    
    func createSessionForBroadcast(_ usernameGetting:String,completionBlock:@escaping (_ success:Bool) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string:HOOKDAPI + "GenerateTokSession.php?username=\(usernameGetting)")!)
        print(urlRequest.url?.absoluteString)
        
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest) { (serverData, serverResponse, serverError) in
            
            if serverError == nil && serverData != nil {
                
                let data = String.init(data: serverData!, encoding: .utf8)
                
                print("DATA",data)
                
                if let jsonObject = try? JSONSerialization.jsonObject(with: serverData!, options: []) as? NSDictionary{
                    
                    if(jsonObject?.object(forKey: "Status") as? String == "Success"){
                        
                        let sessionID = jsonObject?.object(forKey: "sessionID") as? String
                        let tokenID   = jsonObject?.object(forKey: "Token") as? String
                        
                        self.tokSessionID = sessionID!
                        self.tokToken     = tokenID!
                        
                        completionBlock(true)
                    }
                    else{
                        completionBlock(false)
                    }
                }else{
                    completionBlock(false)
                }
                
                
            }else{
                print("NIL DATA")
                completionBlock(false)
            }
            }.resume()
    }
    
    func getSessionForBroadcast(_ usernameGetting:String,completionBlock:@escaping (_ success:Bool) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string:HOOKDAPI + "GetTokenForBroadcast.php?username=\(usernameGetting)")!)
        print(urlRequest.url?.absoluteString)
        
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest) { (serverData, serverResponse, serverError) in
            
            if serverError == nil && serverData != nil {
                
                let data = String.init(data: serverData!, encoding: .utf8)
                
                print("DATA",data)
                
                if let jsonObject = try? JSONSerialization.jsonObject(with: serverData!, options: []) as? NSDictionary{
                    
                    
                    if(jsonObject?.object(forKey: "Status") as? String == "Success"){
                        
                        let sessionID = jsonObject?.object(forKey: "SessionID") as? String
                        let tokenID   = jsonObject?.object(forKey: "Token") as? String
                        
                        self.tokSessionID = sessionID!
                        self.tokToken     = tokenID!
                        
                        completionBlock(true)
                    }
                    else{
                        completionBlock(false)
                    }
                } else{
                    completionBlock(false)
                }
                
                
            }else{
                print("NIL DATA")
                completionBlock(false)
            }
            }.resume()
    }
    
    func postVideoRequest(_ username:String,messageto:String, completionBlock:@escaping (_ success:Bool, _ errormsg:String) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string:HOOKDAPI + "PostVideoRequest.php?")!)
        
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = "username=\(username)&messageto=\(messageto)".data(using: .utf8)
        
        URLSession.shared.dataTask(with: urlRequest) { (serverData, serverResponse, serverError) in
            
            if serverError == nil && serverData != nil {
                
                let data = String.init(data: serverData!, encoding: .utf8)
                print(data)
                
                if let jsonObject = try? JSONSerialization.jsonObject(with: serverData!, options: []) as? NSDictionary {
                    
                    if(jsonObject?.object(forKey: "Status") as? String == "Success") {
                        completionBlock(true,"")
                        print("SUCCESS")
                    }
                    else {
                        completionBlock(false, (jsonObject?.object(forKey: "Message") as? String)!)
                    }
                } else {
                    completionBlock(false, OURERROR)
                }
            } else {
                completionBlock(false, OURERROR)
            }
            
            }.resume()
    }
    
    func resetBroadcastSession(_ usernameGetting:String,completionBlock:@escaping (_ success:Bool) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string:HOOKDAPI + "RemoveSession.php?username=\(usernameGetting)")!)
        print(urlRequest.url?.absoluteString)
        
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest) { (serverData, serverResponse, serverError) in
            
            if serverError == nil && serverData != nil {
                
                let data = String.init(data: serverData!, encoding: .utf8)
                
                if let jsonObject = try? JSONSerialization.jsonObject(with: serverData!, options: []) as? NSDictionary{
                    
                    print("RESET DATA: \(jsonObject)")
                    if(jsonObject?.object(forKey: "Status") as? String == "Success"){
                        print("RESET DATA SUCCESS: \(jsonObject)")

                        completionBlock(true)
                    }
                    else{
                        completionBlock(false)
                    }
                } else{
                    completionBlock(false)
                }
                
                
            }else{
                print("NIL DATA")
                completionBlock(false)
            }
            }.resume()
    }
    
}
