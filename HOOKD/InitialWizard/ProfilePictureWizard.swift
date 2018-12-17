//
//  ProfilePictureWizard.swift
//  HOOKD
//
//  Created by Zachary Carter on 5/13/18.
//  Copyright © 2018 Zachary Carter. All rights reserved.
//

import UIKit

class ProfilePictureWizard: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var analyzeLabel : CLTypingLabel!
    @IBOutlet var uploadProfilePicButton : UIButton!
    @IBOutlet var savedImageView : UIImageView!
    @IBOutlet var saveAndContinue : UIButton!
    
    var numCounts = 0
    var numMisses = 0
    
    var typeWriterTimer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        uploadProfilePicButton.layer.cornerRadius = 5.0
        analyzeLabel.alpha    = 0.0
        saveAndContinue.alpha = 0.0
        
        savedImageView.alpha  = 0.0
        savedImageView.layer.borderWidth   = 1
        savedImageView.layer.masksToBounds = false
        savedImageView.layer.borderColor   = UIColor.white.cgColor
        savedImageView.layer.cornerRadius  = savedImageView.frame.height/2
        savedImageView.clipsToBounds       = true
        
        
        uploadProfilePicButton.layer.borderWidth = 1.0
        uploadProfilePicButton.layer.borderColor = UIColor.white.cgColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openCameraButton(sender: AnyObject) {
        
        self.savedImageView.alpha = 0.0

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        print("image retrieved")
        picker.dismiss(animated: true, completion: nil)
        self.savedImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        UIView.animate(withDuration: 1.0, animations: {
            self.savedImageView.alpha = 1.0
        })
        
        uploadProfilePicButton.setTitle("Retake Photo", for: .normal)
        analyzeLabel.text = "Analyzing..."
        analyzeLabel.alpha = 1.0
        self.analyzeLabel.charInterval = 0.1
        
        self.typeWriterTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { (timer) in
            if(self.numCounts < 2) {
                self.analyzeLabel.text = ""
                self.analyzeLabel.text = "Analyzing..."
                self.numCounts = self.numCounts + 1;
            }
            else {
                self.typeWriterTimer!.invalidate()
                self.detect()
                self.numCounts = 0
            }
        }
    }
    
    
    func detect() {
        
        let faces         = detectFaces(from: self.savedImageView.image!)

        print("FACES COUNT")
        print(faces.count)
        
        if(faces.count == 1) {
            self.analyzeLabel.charInterval = 0.0
            self.analyzeLabel.text         = "Face Detected!"
            
            UIView.animate(withDuration: 1.0, animations: {
                self.saveAndContinue.alpha = 1.0
                UserManager.sharedManager.savedImage = self.savedImageView.image!
            })
        }
        else if(faces.count > 1) {
            let alert = UIAlertController(title: "Whoops!", message: "You need to be the only one in the picture!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            self.analyzeLabel.charInterval = 0.0
            self.analyzeLabel.text         = "Multiple Faces Detected!"
            
            UIView.animate(withDuration: 1.0, animations: {
                self.saveAndContinue.alpha = 0.0
            })
            
        }
        else {
            
            self.numMisses = self.numMisses + 1
            
            if(self.numMisses == 2) {
                let alert = UIAlertController(title: "Trouble?", message: "Try taking a photo of your face in better light. Give it one more shot, if you're still having trouble having your face detected, we'll send the picture in for manual review.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            if(self.numMisses == 3) {
                let alert = UIAlertController(title: "Manual Review", message: "Don't worry, we'll send your profile picture in for manual review with our staff, and your profile picture will be approved shortly!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                uploadProfilePicButton.isEnabled = false
                uploadProfilePicButton.backgroundColor = UIColor.lightGray
                uploadProfilePicButton.setTitleColor(UIColor.darkGray, for: .normal)
                
                UIView.animate(withDuration: 1.0, animations: {
                    self.saveAndContinue.alpha = 1.0
                })
            }
        
            self.analyzeLabel.charInterval = 0.0
            self.analyzeLabel.text = "No Face Detected!"
            
            self.uploadProfilePicButton.setTitle("Try Again", for: .normal)
            
            if(self.numMisses < 3) {
                UIView.animate(withDuration: 1.0, animations: {
                    self.saveAndContinue.alpha = 0.0
                })
            }
            
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
    
    @IBAction func continueToVideo() { 
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
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
