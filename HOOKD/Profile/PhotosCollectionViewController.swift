//
//  PhotosCollectionViewController.swift
//  HOOKD
//
//  Created by Zachary Carter on 6/8/18.
//  Copyright © 2018 Zachary Carter. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class PhotosCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, SKPhotoBrowserDelegate {

    var imageOperation = OperationQueue()
    @IBOutlet var collectionView : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // 1
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 2
        return UserManager.sharedManager.imageStrings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SKPhotoBrowserOptions.displayDeleteButton       = true
        SKPhotoBrowserOptions.swapCloseAndDeleteButtons = true
        
        let browser = SKPhotoBrowser(photos: UserManager.sharedManager.images)
        browser.initializePageIndex(indexPath.row)
        browser.delegate = self
        self.present(browser, animated: true, completion: {})
    }
    
    @IBAction func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func removePhoto(_ browser: SKPhotoBrowser, index: Int, reload: @escaping (() -> Void)) {
        print("SHOULD REMOVE...")
        reload()

        let imageCopy = UserManager.sharedManager.imageStrings.object(at: index) as? String
        
        UserManager.sharedManager.imageStrings.removeObject(at: index)
        collectionView.reloadData()
        
        UserManager.sharedManager.removePicture(username: UserManager.sharedManager.username, picture: imageCopy!) { (done) in
            if(done) {
                print("Picture successfully removed.")
                UserManager.sharedManager.getUserPictures(username: UserManager.sharedManager.username) { (done) in
                    if(done) {
                        print("GOT THE PICTURES!!!")
                    }
                    else {
                        AlertManager.sharedManager.showError(title: "Oops", subTitle: "We tried to remove this photo, but something went wrong. Please try again later or contact support.", buttonTitle: "Okay")
                    }
                }
            }
            else {
                
                DispatchQueue.main.async {
                    AlertManager.sharedManager.showError(title: "Oops", subTitle: "Could not remove photo. Try contacting support if this keeps happening.", buttonTitle: "Okay")
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionCell", for: indexPath) as! PhotoCollectionViewCell
        
        let pictureReference = UserManager.sharedManager.imageStrings.object(at: indexPath.row) as! String
        let fullPath         = AMZSTANDARDPICS + pictureReference
        
        cell.backgroundColor = UIColor.darkGray

        if(UserManager.sharedManager.cachedImages[fullPath] != nil) {
            cell.userPic.image = UserManager.sharedManager.cachedImages[fullPath] as? UIImage
        }
        else {
            self.imageOperation.addOperation({
            
                print("FULL PATH: \(fullPath)")
                
                let url       = URL(string:fullPath)
                let imageData = try? Data.init(contentsOf: url!)
                
                if(imageData != nil)
                {
                    let img = UIImage(data: imageData!)
                    
                    if img == nil {
                        
                        let img = UIImage(named:"personAvatar.png")
                        
                        UserManager.sharedManager.cachedImages[fullPath] = img
                        OperationQueue.main.addOperation({
                            cell.userPic.image = img
                        })
                        
                    }
                    else
                    {
                        UserManager.sharedManager.cachedImages[fullPath] = img
                        
                        OperationQueue.main.addOperation({
                            cell.userPic.image = img
                        })
                    }
                }
                else {
                    let img = UIImage(named:"personAvatar.png")
                    
                    UserManager.sharedManager.cachedImages[fullPath] = img
                    
                    OperationQueue.main.addOperation({
                        cell.userPic.image = img
                    })
                }
                
            });
        }
        
        return cell
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
