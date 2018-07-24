//
//  ShowTermPrivacyViewController.swift
//  Bingeable
//
//  Created by Sheng Peng on 2/23/18.
//  Copyright © 2018 Appealing Applications. All rights reserved.
//

import UIKit

class ShowTermPrivacyViewController: UIViewController,  UIWebViewDelegate{

    
    @IBOutlet var webView: UIWebView!
    var infoFromInitialView: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if infoFromInitialView == "IANEULA" {
            navigationItem.title = "Terms of Service"
        }
        else {
            navigationItem.title = "Privacy Policy"
        }
        let localFilePath = Bundle.main.url(forResource: infoFromInitialView, withExtension:"html")
        let request = URLRequest(url: localFilePath!)
        webView.loadRequest(request)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        
        
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
