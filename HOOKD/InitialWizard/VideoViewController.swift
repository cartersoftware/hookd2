//
//  VideoViewController.swift
//  HOOKD
//
//  Created by Zachary Carter on 5/17/18.
//  Copyright © 2018 Zachary Carter. All rights reserved.
//

import UIKit
import AVKit

class VideoViewController: UIViewController {

    var videoWatched = false
    @IBOutlet var continueButton : UIButton!
    @IBOutlet var instructionLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        continueButton.alpha = 0.0
        instructionLabel.alpha = 0.0
        
       // continueButton.backgroundColor = HOOKDRED

        if let path = Bundle.main.path(forResource: "video", ofType: "mp4")
        {
            print("SHOULD BE PRESENTING HERE..")
            let video = AVPlayer(url: URL(fileURLWithPath: path))
            let videoPlayer = AVPlayerViewController()
            videoPlayer.player = video
            
            present(videoPlayer, animated: true, completion:
                {
                    video.play()
            })
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        if(videoWatched == false) {
            videoWatched = true
        }
        else {
            instructionLabel.alpha = 1.0
            continueButton.alpha = 1.0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func gotoProfile() {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "profilePic") as! ProfilePictureWizard
        self.navigationController?.pushViewController(vc, animated: true)
        UserManager.sharedManager.visitedFromHome = false
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
