//
//  InitialViewController.swift
//  Seen It
//
//  Created by Sheng Peng on 7/1/17.
//  Revised by Lucas Machi on 06/22/18
//  Copyright © 2017 Appealing Applications. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    @IBOutlet var logInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var privacyButton: UIButton!
    @IBOutlet var termsButton: UIButton!
    @IBOutlet var fixedLabel: UILabel!

    @IBOutlet var phoneticLabel: UILabel!
    var webInfo: String = ""
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        // round the corner of buttons
        logInButton.layer.cornerRadius = 6
        logInButton.layer.borderWidth = 1
        logInButton.layer.borderColor = UIColor.black.cgColor
        signUpButton.layer.cornerRadius = 6
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = UIColor.black.cgColor
        let labelTextColor = hexStringToUIColor(hex: "4c96fc")
        fixedLabel.textColor = labelTextColor
        let attributes: [String: Any] = [NSFontAttributeName: UIFont(name: "Lato-Light", size: 12)!, NSForegroundColorAttributeName: UIColor.white, NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        let privacyString = NSMutableAttributedString(string: "Privacy Policy", attributes: attributes)
        privacyButton.setAttributedTitle(privacyString, for: .normal)
        let termsString = NSMutableAttributedString(string: " Terms of Service", attributes: attributes)
        termsButton.setAttributedTitle(termsString, for: .normal)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true


    }

    @IBAction func termsButtonTapped(_ sender: UIButton) {
        webInfo = "IANEULA"
        performSegue(withIdentifier: "toInfoPage", sender: self)
    }
    @IBAction func privacyButtonTapped(_ sender: UIButton) {
        webInfo = "IANPrivacyPolicy"
        performSegue(withIdentifier: "toInfoPage", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInfoPage" {

            // Obtain the object reference of the destination view controller
            let showTermPrivacyViewController: ShowTermPrivacyViewController = segue.destination as! ShowTermPrivacyViewController
            showTermPrivacyViewController.infoFromInitialView = webInfo
        }
    }



}
