//
//  NameViewController.swift
//  Seen It
//
//  Created by Sheng Peng on 7/3/17.
//  Copyright © 2017 Appealing Applications. All rights reserved.
//

import UIKit

class NameViewController: UIViewController {

    @IBOutlet var nextButton: UIButton!
    @IBOutlet var fixedLabel: UILabel!
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    // 0 : name,     1: phone, 2:  email,
    // 3:  password, 4: photo, 5:  cover
    var dataToSignUp = [String](repeating: "", count:6)
    override func viewDidLoad() {
        super.viewDidLoad()
        //set up the color

        let buttonBGColor = hexStringToUIColor(hex: "4c96fc")
        nextButton.backgroundColor = buttonBGColor
        let textColor = hexStringToUIColor(hex: "ebebeb")
        nextButton.titleLabel?.textColor = textColor
        fixedLabel.textColor = textColor
        let textFieldBGColor = hexStringToUIColor(hex: "141414")
        firstNameTextField.backgroundColor = textFieldBGColor
        lastNameTextField.backgroundColor = textFieldBGColor
        let textFieldTextColor = hexStringToUIColor(hex: "c0c0c0")
        firstNameTextField.textColor = textFieldTextColor
        lastNameTextField.textColor = textFieldTextColor
        //round the corner of button
        nextButton.layer.cornerRadius = 6
        nextButton.layer.borderWidth = 1
        nextButton.layer.borderColor = UIColor.black.cgColor

        firstNameTextField.layer.borderWidth = 1
        firstNameTextField.layer.borderColor = textColor.cgColor
        lastNameTextField.layer.borderWidth = 1
        lastNameTextField.layer.borderColor = textColor.cgColor

        let firstNamePlaceholderSting = "First Name"
        var placeHolder = NSMutableAttributedString(string: firstNamePlaceholderSting, attributes: [NSFontAttributeName: UIFont.init(name: "Lato-Regular", size: 16.0)!])
        placeHolder.addAttribute(NSForegroundColorAttributeName, value: textFieldTextColor, range: NSRange(location:0,length:Int(strlen(firstNamePlaceholderSting))))
        firstNameTextField.attributedPlaceholder = placeHolder

        let lastNamePlaceholderSting = "Last Name"
        placeHolder = NSMutableAttributedString(string: lastNamePlaceholderSting, attributes: [NSFontAttributeName: UIFont.init(name: "Lato-Regular", size: 16.0)!])
        placeHolder.addAttribute(NSForegroundColorAttributeName, value: textFieldTextColor, range: NSRange(location:0,length:Int(strlen(lastNamePlaceholderSting))))
        lastNameTextField.attributedPlaceholder = placeHolder

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))

        dataToSignUp[4] = "unavailable"
        dataToSignUp[5] = "unavailable"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if firstNameTextField.hasText && lastNameTextField.hasText {
            // trim the space
            let firstName = firstNameTextField.text!.replacingOccurrences(of: " ", with: "", options: [], range: nil)
            let lastName = lastNameTextField.text!.replacingOccurrences(of: " ", with: "", options: [], range: nil)
            let name = "\(firstName)+\(lastName)"
            // check if it has special characters

            /*
                Maybe we should allow special charecters here, atleast '-'. I have had complaints about people with the symbol in their name wanting to represent it
             WILL BE DEPRECATED AS OF INPUT SANIZATION IMPLEMNATION OF THE SERVER <------- this prevents sql injection attacks.
             */
            let firstNameTest = NSPredicate(format: "SELF MATCHES %@", "[a-zA-Z]{\(firstName.count)}")
            let lastNameTest = NSPredicate(format: "SELF MATCHES %@", "[a-zA-Z]{\(lastName.count)}")
            if !(firstNameTest.evaluate(with: firstName) && lastNameTest.evaluate(with: lastName)) {
                showErrorMessage(title: "Error", message: "No special characters in the name")
            }
            dataToSignUp[0] = name
        }
        else {
            showErrorMessage(title: "", message: "Please enter your name")
        }
        performSegue(withIdentifier: "toPhoneNumberPage", sender: self)
    }

    @IBAction func textField(_sender: AnyObject) {
        self.view.endEditing(true)
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
    /*
     -------------------------
     MARK: - Prepare For Segue
     -------------------------
     */

    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    // You never call this method. It is invoked by the system.
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {

        if segue.identifier == "toPhoneNumberPage" {

            // Obtain the object reference of the destination view controller
            let phoneNumberViewController: PhoneNumberViewController = segue.destination as! PhoneNumberViewController
            phoneNumberViewController.dataToSignUp = dataToSignUp
        }
    }

    // dismiss the keyboard
    func dismissKeyboard(sender: UIGestureRecognizer) {
        view.endEditing(true)
    }

    /*
     -----------------------------
     MARK: - Display Error Message
     -----------------------------
     */

    func showErrorMessage(title errorTitle: String, message errorMessage: String) {

        /*
         Create a UIAlertController object; dress it up with title, message, and preferred style;
         and store its object reference into local constant alertController
         */
        let alertController = UIAlertController(title: "\(errorTitle)",
            message: "\(errorMessage)",
            preferredStyle: UIAlertControllerStyle.alert)

        // Create a UIAlertAction object and add it to the alert controller
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }

}
