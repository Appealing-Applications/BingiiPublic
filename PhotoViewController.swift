//
//  PhotoViewController.swift
//  Seen It
//
//  Created by Sheng Peng on 7/8/17.
//  Copyright © 2017 Appealing Applications. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet var fixedLabelOne: UILabel!
    @IBOutlet var fixedLabelTwo: UILabel!
    @IBOutlet var profilePhotoButton: UIButton!
    @IBOutlet var coverPhotoButton: UIButton!

    @IBOutlet var finishButton: UIButton!
    var dataToSignUp = [String]()
    var isCover = true
    /* Censored for security reasons */
    override func viewDidLoad() {
        super.viewDidLoad()
        let textColor = hexStringToUIColor(hex: "ebebeb")
        profilePhotoButton.titleLabel?.textColor = textColor
        coverPhotoButton.titleLabel?.textColor = textColor
        finishButton.titleLabel?.textColor = textColor
        fixedLabelOne.textColor = textColor
        fixedLabelTwo.textColor = textColor
        let buttonBGColor = hexStringToUIColor(hex: "03327b")
        profilePhotoButton.backgroundColor = buttonBGColor
        coverPhotoButton.backgroundColor = buttonBGColor
        // round the corner of buttons
        coverPhotoButton.layer.cornerRadius = 6
        coverPhotoButton.layer.borderWidth = 1
        coverPhotoButton.layer.borderColor = UIColor.black.cgColor
        profilePhotoButton.layer.cornerRadius = 6
        profilePhotoButton.layer.borderWidth = 1
        profilePhotoButton.layer.borderColor = UIColor.black.cgColor
        finishButton.layer.cornerRadius = 6
        finishButton.layer.borderWidth = 1
        finishButton.layer.borderColor = UIColor.black.cgColor


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
     ----------------------
     MARK: - Buttons Tapped
     ----------------------
     */

    @IBAction func finishButtonTapped(_ sender: UIButton) {
        /* Api url is sensored for security reasons */
        //print(apiURL) // delete this line
        let url = URL(string: apiURL)!
        //var jsonError: NSError?
        let jsonData: Data?
        do {
            jsonData = try Data(contentsOf: url, options: NSData.ReadingOptions.dataReadingMapped)

        } catch  {
            //jsonError = error
            jsonData = nil
        }

        if let jsonDataFromApiUrl = jsonData {
            do {
                let jsonDataDictionary = try JSONSerialization.jsonObject(with: jsonDataFromApiUrl, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary

                // Typecast the returned NSDictionary as Dictionary<String, AnyObject>
                let dictionaryOfReturnItem = jsonDataDictionary as! Dictionary<String, AnyObject>
                let success = dictionaryOfReturnItem["success"] as! String
                if success == "false" {
                    let errorMessage = dictionaryOfReturnItem["error"] as! String
                    showErrorMessage(title: "Falied", message: errorMessage)
                }
                else {
                    performSegue(withIdentifier: "showLogIn", sender: self)
                }
            }  catch {
                    showErrorMessage(title: "Error", message: "Please check your internet connection, then try again")
                    return
            }

        }
        else {
            showErrorMessage(title: "Error", message: "Please check your internet connection, then try again")
        }
    }

    @IBAction func uploadProfilePhotoButtonTapped(_ sender: UIButton) {
        isCover = false
        performSegue(withIdentifier: "ToUploadPhotoPage", sender: self)
    }

    @IBAction func uploadCoverPhotoButtonTapped(_ sender: UIButton) {
        isCover = true
        performSegue(withIdentifier: "ToUploadPhotoPage", sender: self)
    }

    /*
     ---------------------------
     MARK: - Unwind Segue Method
     ---------------------------
     */
    @IBAction func unwindToPhotoViewController (segue : UIStoryboardSegue) {
        if segue.identifier == "unwindToPhotoView" {
            let controller: UploadPhotoViewController = segue.source as! UploadPhotoViewController
            if isCover {
                dataToSignUp[5] = controller.photoURL
            }
            else {
                dataToSignUp[4] = controller.photoURL
            }
        }
    }
    /*
     -------------------------
     MARK: - Prepare For Segue
     -------------------------
     */

    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    // You never call this method. It is invoked by the system.
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {

        if segue.identifier == "showLogIn" {

            // Obtain the object reference of the destination view controller
            let logInViewController: LogInViewController = segue.destination as! LogInViewController
            logInViewController.userName = dataToSignUp[1]
        }
        else if segue.identifier == "ToUploadPhotoPage" {
            let uploadPhotoViewController: UploadPhotoViewController = segue.destination as! UploadPhotoViewController
            uploadPhotoViewController.isCover = isCover
        }
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
