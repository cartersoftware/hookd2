//
//  ProfileViewController.swift
//  HOOKD
//
//  Created by Zachary Carter on 5/16/18.
//  Copyright © 2018 Zachary Carter. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SKPhotoBrowserDelegate {
    
    @IBOutlet var profilePic : UIImageView!
    @IBOutlet var profileTV  : UITableView!
    @IBOutlet var usernameLabel : UILabel!
    @IBOutlet var navBar : UIView!
    
    var picToUpload : UIImage?
    
    var imageOperation      = OperationQueue()
    var standardPhotoPicker = UIImagePickerController()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        // Create a dictionary and add it to the array.
        UserManager.sharedManager.initProfileQuestions()
        
        profilePic.layer.borderWidth   = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor   = UIColor.white.cgColor
        profilePic.layer.cornerRadius  = profilePic.frame.height/2
        profilePic.clipsToBounds       = true
                
        usernameLabel.text             = UserManager.sharedManager.username

        navBar.backgroundColor         = HOOKDNAV
        
        // Do any additional setup after loading the view.
        imageOperation.maxConcurrentOperationCount = 1
        
        if(UserManager.sharedManager.visitedFromHome == true) {
            
            print("NEW URL: \(UserManager.sharedManager.profilePic)")
            profilePic.image = UserManager.sharedManager.savedImage
            //loadProfilePic()
        }
        else {
            profilePic.image = UserManager.sharedManager.savedImage
        }
        
        print("LOADED AGAIN...")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("wtf why am I not reloading..?")
        self.profileTV.reloadData()
        
        if(UserManager.sharedManager.visitedFromHome == false) {
            profilePic.image = UserManager.sharedManager.savedImage
        }
        
        UserManager.sharedManager.getUserPictures(username: UserManager.sharedManager.username) { (done) in
            if(done) {
                print("GOT THE PICTURES!!!")
            }
            else {
                print("WTf DIDNT WORK")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let customIdentifer  = UserManager.sharedManager.arrayOfDict[indexPath.row]["type"];
        
        if(customIdentifer == "yesno" || customIdentifer == "yesnomaybe") {
            return false
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let customIdentifer  = UserManager.sharedManager.arrayOfDict[indexPath.row]["type"];
        
        if(customIdentifer == "yesnomaybe" || customIdentifer == "yesno") {
            return 68
        }
        else {
            return UITableViewAutomaticDimension
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return UserManager.sharedManager.arrayOfDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let customIdentifer  = UserManager.sharedManager.arrayOfDict[indexPath.row]["type"];
        let customIdentifer2 = UserManager.sharedManager.arrayOfDict[indexPath.row]["question_key"];

        if(customIdentifer == "yesnomaybe") {
            let questionCell           = tableView.dequeueReusableCell(withIdentifier: customIdentifer!, for: indexPath) as! YesNoMaybeCell
            questionCell.question.text = UserManager.sharedManager.arrayOfDict[indexPath.row]["question"]
            questionCell.identifier    = indexPath.row
            
            if UserManager.sharedManager.arrayOfDict[indexPath.row]["answer"] == "na" {
                
                UserManager.sharedManager.arrayOfDict[indexPath.row]["answer"] = UserManager.sharedManager.userInfo[UserManager.sharedManager.arrayOfDict[indexPath.row]["question_key"] ?? "na"] as? String
            }
            
            if UserManager.sharedManager.visitedFromHome {
                
                let currentValue = UserManager.sharedManager.arrayOfDict[indexPath.row]["answer"]
                print("CURRENT ANSWER: \(currentValue)")
                
                if currentValue == "yes" {
                    questionCell.yesButton.setImage(UIImage.init(named: "HOOKDCheckmarkFilled.png"), for: .normal)
                } else if currentValue == "no" {
                    questionCell.noButton.setImage(UIImage.init(named: "HOOKDXFilled.png"), for: .normal)
                } else if currentValue == "maybe" {
                    questionCell.maybeButton.setImage(UIImage.init(named: "HOOKDUnknownFilled.png"), for: .normal)
                }
            }
            
            
            
            return questionCell
        }
        
        if(customIdentifer == "yesno") {
            
            let questionCell           = tableView.dequeueReusableCell(withIdentifier: customIdentifer!, for: indexPath) as! YesNoCell
            questionCell.question.text = UserManager.sharedManager.arrayOfDict[indexPath.row]["question"]
            questionCell.identifier    = indexPath.row
            
            if UserManager.sharedManager.arrayOfDict[indexPath.row]["answer"] == "na" {
                
                UserManager.sharedManager.arrayOfDict[indexPath.row]["answer"] = UserManager.sharedManager.userInfo[UserManager.sharedManager.arrayOfDict[indexPath.row]["question_key"] ?? "na"] as? String
            }
            
            if(customIdentifer2 == "pets")
            {
                questionCell.yesButton.setImage(UIImage.init(named: "HOOKDDogNotFilled.png"), for: .normal)
                questionCell.noButton.setImage(UIImage.init(named: "HOOKDCatNotFilled.png"), for: .normal)
            }
            
            if UserManager.sharedManager.visitedFromHome {
                
                let currentValue = UserManager.sharedManager.arrayOfDict[indexPath.row]["answer"]
                print("CURRENT ANSWER: \(currentValue)")
                
                if currentValue == "yes"  {
                    if(customIdentifer2 == "pets")
                    {
                        questionCell.yesButton.setImage(UIImage.init(named: "HOOKDDogFilled.png"), for: .normal)
                        questionCell.noButton.setImage(UIImage.init(named: "HOOKDCatNotFilled.png"), for: .normal)
                    }
                    else {
                        questionCell.yesButton.setImage(UIImage.init(named: "HOOKDCheckmarkFilled.png"), for: .normal)
                    }
                } else if currentValue == "no" {
                    if(customIdentifer2 == "pets")
                    {
                        questionCell.yesButton.setImage(UIImage.init(named: "HOOKDDogNotFilled.png"), for: .normal)
                        questionCell.noButton.setImage(UIImage.init(named: "HOOKDCatFilled.png"), for: .normal)
                    }
                    else {
                        questionCell.noButton.setImage(UIImage.init(named: "HOOKDXFilled.png"), for: .normal)
                    }
                }
            }
            
            
            return questionCell
        }
        
        if(customIdentifer == "freetext") {
            let questionCell           = tableView.dequeueReusableCell(withIdentifier: customIdentifer!, for: indexPath) as! FreeTextCell
            questionCell.question.text = UserManager.sharedManager.arrayOfDict[indexPath.row]["question"]
            
            if UserManager.sharedManager.arrayOfDict[indexPath.row]["answer"] == "na" && UserManager.sharedManager.visitedFromHome == false {
                questionCell.mainQuestionAnswer.text = "Tap to answer question"
            }
            else if UserManager.sharedManager.visitedFromHome == true {
                
                if UserManager.sharedManager.arrayOfDict[indexPath.row]["answer"] == "na" {
                    
                    questionCell.mainQuestionAnswer.text = UserManager.sharedManager.userInfo[UserManager.sharedManager.arrayOfDict[indexPath.row]["question_key"] ?? "na"] as? String
                    
                    UserManager.sharedManager.arrayOfDict[indexPath.row]["answer"] = UserManager.sharedManager.userInfo[UserManager.sharedManager.arrayOfDict[indexPath.row]["question_key"] ?? "na"] as? String
                }
                else {
                    questionCell.mainQuestionAnswer.text = UserManager.sharedManager.arrayOfDict[indexPath.row]["answer"] as? String
                }
            }
            else {
                questionCell.mainQuestionAnswer.text = UserManager.sharedManager.arrayOfDict[indexPath.row]["answer"]
            }
            
            if UserManager.sharedManager.arrayOfDict[indexPath.row]["question_key"] != "about_me" {
                questionCell.contentView.backgroundColor = UIColor.black
            }
            questionCell.identifier    = indexPath.row
            return questionCell
        }
        //
        
        
        /*searchCell.eventTitle.text       = currentSearchDict?.object(forKey: "Title") as? String
         searchCell.eventSubTitle.text    = currentSearchDict?.object(forKey: "SubTitle") as? String
         searchCell.eventDescription.text = currentSearchDict?.object(forKey: "Description") as? String*/
        
        let questionCell = tableView.cellForRow(at: indexPath)
        
        return questionCell!
        
    }
    
    func didDismissAtPageIndex(_ index: Int) {
        // when PhotoBrowser did dismissed
        UserManager.sharedManager.getUserPictures(username: UserManager.sharedManager.username) { (done) in
            if(done) {
                print("GOT THE PICTURES!!!")
            }
            else {
                print("WTf DIDNT WORK")
            }
        }
    }
    
    func removePhoto(_ browser: SKPhotoBrowser, index: Int, reload: @escaping (() -> Void)) {
        print("SHOULD REMOVE...")
        UserManager.sharedManager.removePicture(username: UserManager.sharedManager.username, picture: UserManager.sharedManager.imageStrings.object(at: index) as! String) { (done) in
            if(done) {
                print("Picture successfully removed.")
                reload()
            }
            else {
                
                DispatchQueue.main.async {
                    AlertManager.sharedManager.showError(title: "Oops", subTitle: "Could not remove photo. Try contacting support if this keeps happening.", buttonTitle: "Okay")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customIdentifer  = UserManager.sharedManager.arrayOfDict[indexPath.row]["type"];
        
        if(customIdentifer == "freetext") {
            //Take them to the detail view
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "question") as! QuestionViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
            UserManager.sharedManager.currentQuestionIndex = indexPath.row
            
        }
    }
    
    @IBAction func updateProfilePicture() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func showPics() {
        
        if(UserManager.sharedManager.images.count > 0) {
            
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "photoscollection") as! PhotosCollectionViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            AlertManager.sharedManager.showError(title: "No Pictures", subTitle: "You have no pictures yet. Tap Add Photo to add your first photo.", buttonTitle: "Okay")
        }
        
    }
    
    @IBAction func addPhoto() {
        
        let alertController = UIAlertController(title: "Add Photo", message: "Where would you like to add a photo from?", preferredStyle: .actionSheet)
        
        let sendButton = UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            self.standardPhotoPicker = UIImagePickerController()
            self.standardPhotoPicker.delegate      = self
            self.standardPhotoPicker.sourceType    = .camera
            self.standardPhotoPicker.allowsEditing = false
            
            self.present(self.standardPhotoPicker, animated:true, completion:nil)
        })
        
        let  deleteButton = UIAlertAction(title: "Photo Album", style: .default, handler: { (action) -> Void in
            self.standardPhotoPicker = UIImagePickerController()
            self.standardPhotoPicker.delegate      = self
            self.standardPhotoPicker.sourceType    = .photoLibrary
            self.standardPhotoPicker.allowsEditing = false
            
            self.present(self.standardPhotoPicker, animated:true, completion:nil)
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        
        alertController.addAction(sendButton)
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if(picker == standardPhotoPicker) {
            print("image retrieved")
            picker.dismiss(animated: true, completion: nil)
            self.picToUpload = info[UIImagePickerControllerOriginalImage] as? UIImage
            
            UserManager.sharedManager.uploadStandardPicture(self.picToUpload, completionBlock: { (done) in
                
                if(done) {
                    print("SUCCESS UPDATING THE PROFILE PICTURE!")
                    UserManager.sharedManager.getUserPictures(username: UserManager.sharedManager.username) { (done) in
                        if(done) {
                            print("GOT THE PICTURES!!!")
                        }
                        else {
                            print("WTf DIDNT WORK")
                        }
                    }
                }
                else {
                    print("SOMETHING WENT WRONG UPDATING THE PROFILE PICTURE!")
                }
            })
            //self.detectStandard()
        }
            
        else {
            print("image retrieved")
            picker.dismiss(animated: true, completion: nil)
            self.profilePic.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            self.detect()
        }
        
        
    }
    
    
    func detect() {
        
        let faces         = detectFaces(from: self.profilePic.image!)
        
        print("FACES COUNT")
        print(faces.count)
        
        if(faces.count == 1) {
            
            //Begin the upload
            UserManager.sharedManager.savedImage = self.profilePic.image!
            UserManager.sharedManager.uploadProfilePic(self.profilePic.image, completionBlock: { (done) in
                
                if(done) {
                    print("SUCCESS UPDATING THE PROFILE PICTURE!")
                }
                else {
                    print("SOMETHING WENT WRONG UPDATING THE PROFILE PICTURE!")
                }
            })
        }
        else if(faces.count > 1) {
            let alert = UIAlertController(title: "Whoops!", message: "You need to be the only one in the picture!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            
            let alert = UIAlertController(title: "Manual Review", message: "Don't worry, we'll send your profile picture in for manual review with our staff, and your profile picture will be approved shortly!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func detectFaces(from image: UIImage) -> [UIImage] {
        guard let ciimage = CIImage(image: image) else { return [] }
        var orientation: NSNumber {
            switch image.imageOrientation {
            case .up:            return 1
            case .upMirrored:    return 2
            case .down:          return 3
            case .downMirrored:  return 4
            case .leftMirrored:  return 5
            case .right:         return 6
            case .rightMirrored: return 7
            case .left:          return 8
            }
        }
        return CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow])?
            .features(in: ciimage, options: [CIDetectorImageOrientation: orientation])
            .flatMap {
                let rect = $0.bounds.insetBy(dx: -10, dy: -10)
                let ciimage = ciimage.cropped(to: rect)
                UIGraphicsBeginImageContextWithOptions(rect.size, false, image.scale)
                defer { UIGraphicsEndImageContext() }
                UIImage(ciImage: ciimage).draw(in: CGRect(origin: .zero, size: rect.size))
                guard let face = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
                // now that you have your face image you need to properly apply a circle mask to it
                let size = face.size
                let breadth = min(size.width, size.height)
                let breadthSize = CGSize(width: breadth, height: breadth)
                UIGraphicsBeginImageContextWithOptions(breadthSize, false, image.scale)
                defer { UIGraphicsEndImageContext() }
                guard let cgImage = face.cgImage?.cropping(to: CGRect(origin:
                    CGPoint(x: size.width > size.height ? (size.width-size.height).rounded(.down) / 2 : 0,
                            y: size.height > size.width ? (size.height-size.width).rounded(.down) / 2 : 0),
                                                                      size: breadthSize)) else { return nil }
                let faceRect = CGRect(origin: .zero, size: CGSize(width: min(size.width, size.height), height: min(size.width, size.height)))
                UIBezierPath(ovalIn: faceRect).addClip()
                UIImage(cgImage: cgImage).draw(in: faceRect)
                return UIGraphicsGetImageFromCurrentImageContext()
            } ?? []
    }
    

    @IBAction func saveProfile() {
        
        if(UserManager.sharedManager.visitedFromHome == false) {
            UserManager.sharedManager.uploadProfilePic(self.profilePic.image, completionBlock: { (done) in
                if(done) {
                    print("SUCCESS WITH PROFILE")
                }
                else {
                    print("NO GO NO GO!")
                }
            })
        }
        
        let aboutMe  = UserManager.sharedManager.arrayOfDict[UserManager.sharedManager.findQuestionIndexByKey(key:"about_me")]["answer"]
        let kids     = UserManager.sharedManager.arrayOfDict[UserManager.sharedManager.findQuestionIndexByKey(key:"kids")]["answer"]
        let marriage = UserManager.sharedManager.arrayOfDict[UserManager.sharedManager.findQuestionIndexByKey(key:"marriage")]["answer"]
        let alcohol  = UserManager.sharedManager.arrayOfDict[UserManager.sharedManager.findQuestionIndexByKey(key:"alcohol")]["answer"]
        let smoker   = UserManager.sharedManager.arrayOfDict[UserManager.sharedManager.findQuestionIndexByKey(key:"smoker")]["answer"]
        let pets     = UserManager.sharedManager.arrayOfDict[UserManager.sharedManager.findQuestionIndexByKey(key:"pets")]["answer"]
        let freetime = UserManager.sharedManager.arrayOfDict[UserManager.sharedManager.findQuestionIndexByKey(key:"freetime")]["answer"]
        let tvshow   = UserManager.sharedManager.arrayOfDict[UserManager.sharedManager.findQuestionIndexByKey(key:"tvshow")]["answer"]
        
        if((aboutMe?.count)! > 3 && (kids?.count)! > 0 && (marriage?.count)! > 0 && (alcohol?.count)! > 0 && (smoker?.count)! > 0 && (pets?.count)! > 0 && (freetime?.count)! > 3 && (tvshow?.count)! > 3) {
            
            UserManager.sharedManager.updateProfile(about_me: aboutMe!, kids: kids!, marriage: marriage!, alcohol: alcohol!, smoker: smoker!, pets: pets!, freetime: freetime!, tvshow: tvshow!) { (done) in
                if(done) {
                    print("Profile Updated!")
                }
                else {
                    print("Failed to update profile.")
                }
            }
            
            if UserManager.sharedManager.visitedFromHome == true {
                self.navigationController?.popViewController(animated: true)
            }
            else {
                
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "prefs") as! PreferencesViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else {
            AlertManager.sharedManager.showError(title: "Missing Profile Information", subTitle: "You must fill out all parts of your profile before it can be saved.", buttonTitle: "Okay")
        }
    }
    
    @IBAction func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
