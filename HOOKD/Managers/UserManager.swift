//
//  UserManager.swift
//  HOOKD
//
//  Created by Zachary Carter on 5/5/18.
//  Copyright © 2018 Zachary Carter. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class UserManager : NSObject {
    
    var username             = ""
    var email                = ""
    var profilePic           = ""
    
    var savedImage           = UIImage()
    
    var isViewingTerms       = true
    var arrayOfDict          = [[String: String]]()
    var currentQuestionKey   = ""
    var currentQuestionIndex = 0
    var cachedImages         = NSMutableDictionary()
    var userInfo             = NSDictionary()
    var visitedFromHome      = false
    var loadedProfileOnce    = false
    var imageStrings         = NSMutableArray()
    var matches              = NSArray()

    var accountSettings      = NSDictionary()
    var chatThread           = NSMutableArray()
    var chatDetails          = NSMutableArray()
    var searchUsers          = NSMutableArray()
    var messageID            = ""

    var deviceToken          = ""
    
    /*The preferences*/
    var gender               = ""
    var lookingfor           = ""
    var notifications        = ""
    var appsounds            = ""
    var age                  = ""
    var searchradius         = ""
    var cameFromWizard       = true;
    var shouldReloadMatches  = false;
    
    var images = [SKPhoto]()
    
    class var sharedManager : UserManager {
        struct _Singleton {
            static let instance = UserManager()
        }
        return _Singleton.instance
    }
    
    func initProfileQuestions() {
        
        if(loadedProfileOnce == false) {
            loadedProfileOnce = true
            
            let dict1: [String: String] = ["question_key":"about_me", "question":"Say something about yourself: (100 character min*)", "answer":"na", "type":"freetext"]
            let dict3: [String: String] = ["question_key":"kids", "question":"Do you want kids?", "answer":"na", "type":"yesnomaybe"]
            let dict2: [String: String] = ["question_key":"marriage", "question":"Do you want to get married?", "answer":"na", "type":"yesnomaybe"]
            let dict5: [String: String] = ["question_key":"alcohol", "question":"Do you drink?", "answer":"na", "type":"yesno"]
            let dict4: [String: String] = ["question_key":"smoker", "question":"Do you smoke?", "answer":"na", "type":"yesno"]
            let dict6: [String: String] = ["question_key":"pets", "question":"Are you a dog or cat person?", "answer":"na", "type":"yesno"]
            let dict7: [String: String] = ["question_key":"freetime", "question":"What is your favorite thing to do in your freetime?", "answer":"na", "type":"freetext"]
            let dict8: [String: String] = ["question_key":"tvshow", "question":"What is your favorite movie/tv show?", "answer":"na", "type":"freetext"]
            
            arrayOfDict.append(dict1)
            arrayOfDict.append(dict2)
            arrayOfDict.append(dict3)
            arrayOfDict.append(dict4)
            arrayOfDict.append(dict5)
            arrayOfDict.append(dict6)
            arrayOfDict.append(dict7)
            arrayOfDict.append(dict8)
        }

    }
    
    func findQuestionIndexByKey(key:String) -> Int {
        
        var i = 0
        
        for dict in arrayOfDict {
            if dict["question_key"] == key {
                return i
            }
            
            i = i + 1
        }
        
        return -1
    }
    
    func registerUser(_ username:String,password:String,email:String,firstName:String, completionBlock:@escaping (_ success:Bool, _ errormsg:String) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string:HOOKDAPI + "RegisterUser.php")!)
        
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = "username=\(username)&password=\(password)&email=\(email)&firstName=\(firstName)".data(using: .utf8)
        
        URLSession.shared.dataTask(with: urlRequest) { (serverData, serverResponse, serverError) in
            
            if serverError == nil && serverData != nil {
                
               let data = String.init(data: serverData!, encoding: .utf8)
                print(data)
                
                if let jsonObject = try? JSONSerialization.jsonObject(with: serverData!, options: []) as? NSDictionary {
                    
                    if(jsonObject?.object(forKey: "Status") as? String == "Success") {
                        completionBlock(true,"")
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
    
    func updateAccountSettings(_ username:String,gender:String,seeking:String,notifications:String,appsounds:String,age:String,searchRadius:String, completionBlock:@escaping (_ success:Bool, _ errormsg:String) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string:HOOKDAPI + "UpdateAccountSettings.php?")!)
        
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = "username=\(username)&gender=\(gender)&seeking=\(seeking)&notifications=\(notifications)&appsounds=\(appsounds)&age=\(age)&searchRadius=\(searchRadius)".data(using: .utf8)
        
        URLSession.shared.dataTask(with: urlRequest) { (serverData, serverResponse, serverError) in
            
            if serverError == nil && serverData != nil {
                
                let data = String.init(data: serverData!, encoding: .utf8)
                print(data)
                
                if let jsonObject = try? JSONSerialization.jsonObject(with: serverData!, options: []) as? NSDictionary {
                    
                    if(jsonObject?.object(forKey: "Status") as? String == "Success") {
                        completionBlock(true,"")
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
    
    func likePerson(_ username:String,usernameLiking:String, completionBlock:@escaping (_ success:Bool, _ errormsg:String) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string:HOOKDAPI + "LikePerson.php?")!)
        
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = "username=\(username)&usernameLiking=\(usernameLiking)".data(using: .utf8)
        
        URLSession.shared.dataTask(with: urlRequest) { (serverData, serverResponse, serverError) in
            
            if serverError == nil && serverData != nil {
                
                let data = String.init(data: serverData!, encoding: .utf8)
                print(data)
                
                if let jsonObject = try? JSONSerialization.jsonObject(with: serverData!, options: []) as? NSDictionary {
                    
                    if(jsonObject?.object(forKey: "Status") as? String == "Success") {
                        completionBlock(true,"")
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
    
    func hideAccount(_ username:String, status:String, completionBlock:@escaping (_ success:Bool, _ errormsg:String) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string:HOOKDAPI + "HideAccount.php?")!)
        
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = "username=\(username)&status=\(status)".data(using: .utf8)
        
        URLSession.shared.dataTask(with: urlRequest) { (serverData, serverResponse, serverError) in
            
            if serverError == nil && serverData != nil {
                
                let data = String.init(data: serverData!, encoding: .utf8)
                print(data)
                
                if let jsonObject = try? JSONSerialization.jsonObject(with: serverData!, options: []) as? NSDictionary {
                    
                    if(jsonObject?.object(forKey: "Status") as? String == "Success") {
                        completionBlock(true,"")
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
    
    func deleteAccount(_ username:String, completionBlock:@escaping (_ success:Bool, _ errormsg:String) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string:HOOKDAPI + "DeleteAccount.php?")!)
        
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = "username=\(username)".data(using: .utf8)
        
        URLSession.shared.dataTask(with: urlRequest) { (serverData, serverResponse, serverError) in
            
            if serverError == nil && serverData != nil {
                
                let data = String.init(data: serverData!, encoding: .utf8)
                print(data)
                
                if let jsonObject = try? JSONSerialization.jsonObject(with: serverData!, options: []) as? NSDictionary {
                    
                    if(jsonObject?.object(forKey: "Status") as? String == "Success") {
                        completionBlock(true,"")
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
    
    func getAccountSettings(_ username:String, completionBlock:@escaping (_ success:Bool, _ errormsg:String) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string:HOOKDAPI + "GetAccountSettings.php?")!)
        
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = "username=\(username)".data(using: .utf8)
        
        URLSession.shared.dataTask(with: urlRequest) { (serverData, serverResponse, serverError) in
            
            if serverError == nil && serverData != nil {
                
                let data = String.init(data: serverData!, encoding: .utf8)
                print(data)
                
                if let jsonObject = try? JSONSerialization.jsonObject(with: serverData!, options: []) as? NSDictionary {
                    
                    if(jsonObject?.object(forKey: "Status") as? String == "Success") {
                        if((jsonObject?.object(forKey:"Data") as? NSDictionary) != nil) {
                            self.accountSettings = jsonObject?.object(forKey:"Data") as! NSDictionary
                            completionBlock(true,"")
                        }
                        else {
                            completionBlock(false, (jsonObject?.object(forKey: "Message") as? String)!)
                        }
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
    
    func updateDeviceToken(_ username:String,deviceToken:String, completionBlock:@escaping (_ success:Bool) -> Void) {
        
        var urlRequest        = URLRequest(url: URL(string:HOOKDAPI + "UpdateDeviceToken.php?")!)
        
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        //let localTimeZoneName =  TimeZone.current.identifier
        urlRequest.httpBody   = "username=\(username)&deviceToken=\(deviceToken)".data(using: .utf8)
        
        URLSession.shared.dataTask(with: urlRequest) { (serverData, serverResponse, serverError) in

            if serverError == nil && serverData != nil {
                
                let data = String.init(data: serverData!, encoding: .utf8)
                
                if let jsonObject = try? JSONSerialization.jsonObject(with: serverData!, options: []) as? NSDictionary{
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
                completionBlock(false)
            }
        }
    }
    
    func getMatches(_ username:String, completionBlock:@escaping (_ success:Bool, _ errormsg:String) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string:HOOKDAPI + "GetMatches.php?")!)
        
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = "username=\(username)".data(using: .utf8)
        
        URLSession.shared.dataTask(with: urlRequest) { (serverData, serverResponse, serverError) in
            
            if serverError == nil && serverData != nil {
                
                let data = String.init(data: serverData!, encoding: .utf8)
                print("THE DATA: \(data)")
                
                if let jsonObject = try? JSONSerialization.jsonObject(with: serverData!, options: []) as? NSDictionary {
                    
                    if(jsonObject?.object(forKey: "Status") as? String == "Success") {
                        if let matchArr = jsonObject?.object(forKey:"Data") as? NSArray {
                            self.matches = matchArr
                            completionBlock(true,"")
                        }
                        else {
                            completionBlock(false,"No data. Contact Support.")
                        }
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
    
    func updateLocation(_ username:String,latitude:String,longitude:String, completionBlock:@escaping (_ success:Bool, _ errormsg:String) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string:HOOKDAPI + "UpdateLatLon.php?")!)
        
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = "username=\(username)&latitude=\(latitude)&longitude=\(longitude)".data(using: .utf8)
        
        URLSession.shared.dataTask(with: urlRequest) { (serverData, serverResponse, serverError) in
            
            if serverError == nil && serverData != nil {
                
                let data = String.init(data: serverData!, encoding: .utf8)
                print(data)
                
                if let jsonObject = try? JSONSerialization.jsonObject(with: serverData!, options: []) as? NSDictionary {
                    
                    if(jsonObject?.object(forKey: "Status") as? String == "Success") {
                        completionBlock(true,"")
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
    
    func authenticateUser(_ username:String,password:String, completionBlock:@escaping (_ success:Bool, _ errormsg:String) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string:HOOKDAPI + "Login.php")!)
        
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = "username=\(username)&password=\(password)".data(using: .utf8)
        
        URLSession.shared.dataTask(with: urlRequest) { (serverData, serverResponse, serverError) in
            
            if serverError == nil && serverData != nil {
                
                let data = String.init(data: serverData!, encoding: .utf8)
                print("AUTH DATA \(data)")
                
                if let jsonObject = try? JSONSerialization.jsonObject(with: serverData!, options: []) as? NSDictionary {
                    
                    if(jsonObject?.object(forKey: "Status") as? String == "Success") {
                        
                        if let userData = jsonObject?.object(forKey:"UserData") as? NSDictionary {
                            
                            self.userInfo   = userData
                            self.username   = (userData.object(forKey: "username") as? String)!
                            self.profilePic = (userData.object(forKey: "profilePic") as? String)!
                            
                            // save necessary variables to local defaults
                            for allKeys in self.userInfo.allKeys {
                                
                                let key   = allKeys as! String
                                let value = self.userInfo[key] as! String
                                
                                UserDefaults.standard.set(value, forKey: key)
                                // Save the defaults
                                UserDefaults.standard.synchronize()
                            }
                            
                            UserDefaults.standard.set(self.userInfo, forKey: "userInfo")
                            UserDefaults.standard.synchronize()

                            
                            print("USER DATA: \(self.userInfo)")
                            completionBlock(true,"")
                            
                        } else {
                            completionBlock(false, "Login successful, however, unable to retrieve profile information")
                        }
                    
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
    
    
    func forgotUsername(_ email:String, completionBlock:@escaping (_ success:Bool, _ errormsg:String) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string:HOOKDAPI + "ForgotUsername.php")!)
        
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = "email=\(email)".data(using: .utf8)
        
        URLSession.shared.dataTask(with: urlRequest) { (serverData, serverResponse, serverError) in
            
            if serverError == nil && serverData != nil {
                
                // let data = String.init(data: serverData!, encoding: .utf8)
                
                if let jsonObject = try? JSONSerialization.jsonObject(with: serverData!, options: []) as? NSDictionary {
                    
                    if(jsonObject?.object(forKey: "Status") as? String == "Success") {
                        completionBlock(true,"")
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
    
    func forgotPassword(_ email:String, completionBlock:@escaping (_ success:Bool, _ errormsg:String) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string:HOOKDAPI + "ForgotPassword.php")!)
        
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = "email=\(email)".data(using: .utf8)
        
        URLSession.shared.dataTask(with: urlRequest) { (serverData, serverResponse, serverError) in
            
            if serverError == nil && serverData != nil {
                
                // let data = String.init(data: serverData!, encoding: .utf8)
                
                if let jsonObject = try? JSONSerialization.jsonObject(with: serverData!, options: []) as? NSDictionary {
                    
                    if(jsonObject?.object(forKey: "Status") as? String == "Success") {
                        completionBlock(true,"")
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
    
    func removePicture(username:String, picture:String, completionBlock:@escaping (_ success:Bool) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string:HOOKDAPI + "RemovePhoto.php?")!)
        
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = "username=\(username)&pictureName=\(picture)".data(using: .utf8)
        
        URLSession.shared.dataTask(with: urlRequest) { (serverData, serverResponse, serverError) in
            
            print("SERVER ERROR: \(serverError)")
            let dataString = NSString(data: serverData!, encoding: String.Encoding.utf8.rawValue)
            print("DATA STRING FOR PICTURE REMOVAL: \(dataString)")
            
            if serverError == nil && serverData != nil {
                
                if let jsonObject = try? JSONSerialization.jsonObject(with: serverData!, options: []) as? NSDictionary {
                    
                    if(jsonObject?.object(forKey: "Status") as? String == "Success") {
                            completionBlock(true)
                        }
                        else {
                            completionBlock(false)
                        }
                    }
                    else {
                        completionBlock(false)
                    }
                } else {
                    completionBlock(false)
                }
            
            }.resume()
    }
    
    func getUserPictures(username:String, completionBlock:@escaping (_ success:Bool) -> Void) {
            
            var urlRequest = URLRequest(url: URL(string:HOOKDAPI + "GetUserImages.php?")!)
            
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = "username=\(username)".data(using: .utf8)
        
            print("USERNAME TO POST: \(username)")
        
            URLSession.shared.dataTask(with: urlRequest) { (serverData, serverResponse, serverError) in
                
                if(serverError == nil) {
                let dataString = NSString(data: serverData!, encoding: String.Encoding.utf8.rawValue)
                print("DATA STRING ZAC: \(dataString)")
                
                if serverError == nil && serverData != nil {
                    
                    if let jsonObject = try? JSONSerialization.jsonObject(with: serverData!, options: []) as? NSDictionary {
                        
                        if(jsonObject?.object(forKey: "Status") as? String == "Success") {
                            
                            if let picArray = jsonObject?.object(forKey:"Pictures") as? [[String:String]] {
                                
                                self.images       = [SKPhoto]()
                                self.imageStrings = NSMutableArray()
                                
                                for dict in picArray {
                                
                                    let photoURL = AMZSTANDARDPICS + dict["picture"]!
                                    let photo = SKPhoto.photoWithImageURL(photoURL)
                                    photo.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
                                    self.images.append(photo)
                                    self.imageStrings.add(dict["picture"] ?? "")
                                }
                                
                                print("IMAGES: \(self.images)")
                                print("IMAGE STRINGS: \(self.imageStrings)")
                                
                                completionBlock(true)
                            }
                            else {
                                completionBlock(false)
                            }
                        }
                        else {
                            completionBlock(false)
                        }
                    } else {
                        completionBlock(false)
                    }
                } else {
                    completionBlock(false)
                }
                    
                }
                else {
                    completionBlock(false)
                    print("SERVER ERROR")
                }
                
                }.resume()
        }
    
    
    func updateProfile(about_me:String, kids:String, marriage:String, alcohol:String,smoker:String,pets:String,freetime:String,tvshow:String, completionBlock:@escaping (_ success:Bool) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string:HOOKDAPI + "UpdateProfileSettings.php?")!)
        
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = "username=\(self.username)&about_me=\(about_me)&kids=\(kids)&marriage=\(marriage)&alcohol=\(alcohol)&smoker=\(smoker)&pets=\(pets)&freetime=\(freetime)&tvshow=\(tvshow)".data(using: .utf8)
        
        URLSession.shared.dataTask(with: urlRequest) { (serverData, serverResponse, serverError) in
            
            let dataString = NSString(data: serverData!, encoding: String.Encoding.utf8.rawValue)
            print("DATA STRING: \(dataString)")
            
            if serverError == nil && serverData != nil {
                
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
                completionBlock(false)
            }
            
            }.resume()
    }
    
    func uploadProfilePic(_ profilePic:UIImage?,completionBlock:@escaping (_ isFinished:Bool) -> Void){
        
        let request        = NSMutableURLRequest(url: URL(string: HOOKDAPI + "UpdateProfilePic.php?")!)
        request.httpMethod = "POST"
        let boundary       = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body           = NSMutableData()
        var profileData    = NSMutableData()
        
        let targetSize     =  CGSize(width: 400, height: 400)
        let resizedImage   = resizeImage(image: profilePic!, targetSize: targetSize)
        
        if profilePic != nil {
            profileData =  NSMutableData(data: UIImageJPEGRepresentation(resizedImage, 1.0)!)
        }
        
        let fname    = "photo.jpg"
        let mimetype = "image/jpg"
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"profileImage\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("hi\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"username\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(username)\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"profileImage\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(profileData as Data)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        request.httpBody = body as Data
        
        let session = URLSession.shared
        
        
        let task = session.uploadTask(with: request as URLRequest, from: body as Data) { (data, response, error) in
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("DATA STRING: \(dataString)")
            
            if data == nil {
                completionBlock(false)
                return
            }
            do {
                if let jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    if jsonData["Status"] as! String == "Success" {
                        
                        self.profilePic = jsonData["NewURL"] as! String
                        
                        completionBlock(true)
                        
                    }else{
                        // Failed
                        completionBlock(false)
                    }
                }else{
                    completionBlock(false)
                }
            }catch{
                completionBlock(false)
            }
            
        }
        
        task.resume()
        
    }
    
    func uploadStandardPicture(_ pic:UIImage?,completionBlock:@escaping (_ isFinished:Bool) -> Void){
        
        let request        = NSMutableURLRequest(url: URL(string: HOOKDAPI + "UploadStandardPic.php?")!)
        request.httpMethod = "POST"
        let boundary       = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body           = NSMutableData()
        var profileData    = NSMutableData()
        
        let targetSize     =  CGSize(width: 400, height: 400)
        let resizedImage   = resizeImage(image: pic!, targetSize: targetSize)
        
        if pic != nil {
            profileData =  NSMutableData(data: UIImageJPEGRepresentation(resizedImage, 1.0)!)
        }
        
        let fname    = "photo.jpg"
        let mimetype = "image/jpg"
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"profileImage\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("hi\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"username\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(username)\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"profileImage\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(profileData as Data)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        request.httpBody = body as Data
        
        let session = URLSession.shared
        
        
        let task = session.uploadTask(with: request as URLRequest, from: body as Data) { (data, response, error) in
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("DATA STRING: \(dataString)")
            
            if data == nil {
                completionBlock(false)
                return
            }
            do {
                if let jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    if jsonData["Status"] as! String == "Success" {
                        
                        //self.profilePic = jsonData["NewURL"] as! String
                        
                        completionBlock(true)
                        
                    }else{
                        // Failed
                        completionBlock(false)
                    }
                }else{
                    completionBlock(false)
                }
            }catch{
                completionBlock(false)
            }
            
        }
        
        task.resume()
        
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width:size.width * heightRatio, height:size.height * heightRatio)
        } else {
            newSize = CGSize(width:size.width * widthRatio,  height:size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x:0, y:0, width:newSize.width, height:newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    
    func getChatThread(completionBlock:@escaping (_ success:Bool) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string:HOOKDAPI + "GetChatThread.php?username="+self.username)!)
        
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest) { (serverData, serverResponse, serverError) in
            
            if serverError == nil && serverData != nil {

                if let jsonObject = try? JSONSerialization.jsonObject(with: serverData!, options: []) as? NSArray {
                    
                    if jsonObject != nil {
                        
                        self.chatThread = NSMutableArray(array:jsonObject!)
                        
                        completionBlock(true)
                        
                    }else{
                        
                        completionBlock(false)
                    }
                    
                } else {
                    completionBlock(false)
                }
            } else {
                completionBlock(false)
            }
            
            }.resume()
    }
   
    func getChatHistory(completionBlock:@escaping (_ success:Bool) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string:HOOKDAPI + "GetChatMessages.php?userLoggedIn=\(self.username)&messageid="+self.messageID)!)
    
        
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest) { (serverData, serverResponse, serverError) in
            
            if serverError == nil && serverData != nil {
                
                if let jsonObject1 = try? JSONSerialization.jsonObject(with: serverData!, options: []) as? NSDictionary {
                    
                    if let chatDetails = jsonObject1?.object(forKey: "ChatDetails") as? NSArray {

                        if let shouldBroadcast = jsonObject1?.object(forKey: "BroadcastRequested") as? String {
                            self.chatDetails = NSMutableArray(array:chatDetails)
                            BroadcastManager.sharedManager.shouldBroadcast = shouldBroadcast
                            completionBlock(true)
                        }
                        else {
                            completionBlock(false)
                        }
                    }
                    else {
                        completionBlock(false)
                    }
                    
                } else {
                    completionBlock(false)
                }
            } else {
                completionBlock(false)
            }
            
            }.resume()
    }
  

    func sendChat(_ message:String, _ messageTo:String, completionBlock:@escaping (_ success:Bool, _ errormsg:String) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string:HOOKDAPI + "PostChatMessage.php?")!)
        
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = "message=\(message)&username=\(username)&messageto=\(messageTo)&messageid=\(messageID)".data(using: .utf8)
        
        URLSession.shared.dataTask(with: urlRequest) { (serverData, serverResponse, serverError) in
            
            if serverError == nil && serverData != nil {
                
                let dataString = NSString(data: serverData!, encoding: String.Encoding.utf8.rawValue)
                print("DATA STRING: \(dataString)")
                
                
                if let jsonObject = try? JSONSerialization.jsonObject(with: serverData!, options: []) as? NSDictionary {
                    
                    if(jsonObject?.object(forKey: "Status") as? String == "Success") {
                        
                        completionBlock(true,"")
                    }
                    else {
                        completionBlock(false,"Couldn't send message")
                    }
                } else {
                    completionBlock(false, OURERROR)
                }
            } else {
                completionBlock(false, OURERROR)
            }
            
            }.resume()
    }
    
    
    func getAllUsers(completionBlock:@escaping (_ success:Bool) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string:HOOKDAPI + "GetChatUsers.php")!)
        
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest) { (serverData, serverResponse, serverError) in
            
            if serverError == nil && serverData != nil {
                
                if let jsonObject = try? JSONSerialization.jsonObject(with: serverData!, options: []) as? NSArray {
                    
                    self.searchUsers = NSMutableArray(array:jsonObject!)
                    
                    completionBlock(true)
                    
                } else {
                    completionBlock(false)
                }
            } else {
                completionBlock(false)
            }
            
            }.resume()
    }
    

}
