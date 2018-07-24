//
//  TabViewController.swift
//  Seen It?
//
//  Created by Sheng Peng on 6/5/17.
//  Copyright © 2017 Appealing Applications. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController, UITabBarControllerDelegate{

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Move the tab bar to top
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var tabFrame:CGRect = self.tabBar.frame
        tabFrame.origin.y = self.view.frame.origin.y + 20
        let tintColor = hexStringToUIColor(hex: "#052577")
        //let tintColor = hexStringToUIColor(hex: "#050544")
        self.tabBar.barTintColor = tintColor
        self.tabBar.backgroundColor = tintColor
        
        self.tabBar.frame = tabFrame
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
