//
//  TermsPrivacyViewController.swift
//  HOOKD
//
//  Created by Zachary Carter on 5/9/18.
//  Copyright © 2018 Zachary Carter. All rights reserved.
//

import UIKit

class TermsPrivacyViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet var webView : UIWebView!
    @IBOutlet var navBar : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: false)

        // Do any additional setup after loading the view.
        if(UserManager.sharedManager.isViewingTerms == true) {
            self.title = "Terms of Service"
            webView.loadRequest(NSURLRequest(url: NSURL(string: HOOKEDTERMS)! as URL) as URLRequest)
        }
        else {
            self.title = "Privacy Policy"
            webView.loadRequest(NSURLRequest(url: NSURL(string: HOOKEDPRIV)! as URL) as URLRequest)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error?) {

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
