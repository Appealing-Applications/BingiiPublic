//
//  ProfileViewController.swift
//  Seen It?
//
//  Created by Sheng Peng on 6/7/17.
//  Revised by Lucas Machi on 06/21/18
//  Copyright © 2017 Appealing Applications. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet var coverPhotoImageView: UIImageView!
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    //@IBOutlet var fixedLabel: UILabel!
    //@IBOutlet var backgroundVIew: UIView!
    @IBOutlet var activityTableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var friendsButton: UIButton!

    @IBOutlet var settingButton: UIButton!


      /* Censored for security purposes */
    var viewBGColor = UIColor.red
    var textColor = UIColor.red
    var activitiesArray = [Dictionary<String, AnyObject>]()
    // 0 : name,     1: phone, 2:  email,
    // 3:  photo,    4:  cover
    var userInfo = [String](repeating: "", count:5)
    var refreshControl: UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
        // Style the profile photo to show in a circle
        photoImageView.layer.borderWidth = 0
        photoImageView.layer.borderColor = UIColor.black.cgColor
        // Set cornerRadius = a square UIImageView frame size width / 2
        // In our case, UIImageView height = width = 120 points
        photoImageView.layer.cornerRadius = 60
        photoImageView.clipsToBounds = true
        //set up the color
        viewBGColor = hexStringToUIColor(hex: "141414")
        //backgroundVIew.backgroundColor = viewBGColor
        activityTableView.backgroundColor = viewBGColor

        textColor = hexStringToUIColor(hex: "ebebeb")
        nameLabel.textColor = textColor
        //fixedLabel.textColor = textColor
        headerView.backgroundColor = viewBGColor
        friendsButton.titleLabel?.textColor = textColor

        activityTableView.backgroundColor = viewBGColor
        activityTableView.tableFooterView = UIView()

        //set the color for setting button
        let origImage = UIImage(named: "ic_settings")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        settingButton.setImage(tintedImage, for: .normal)
        settingButton.tintColor = textColor

        let attributes: [String: Any] = [NSFontAttributeName: UIFont(name: "Lato-Black", size: 16)!, NSForegroundColorAttributeName: UIColor.white, NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        let friendsButtonString = NSMutableAttributedString(string: "Friends", attributes: attributes)
        friendsButton.setAttributedTitle(friendsButtonString, for: .normal)

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for:.valueChanged)
        activityTableView.addSubview(refreshControl)

        getProfileFromServer()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getProfileFromServer() {
        /* Censored API call for security purposes */
        let url = URL(string: apiURL)!
        //print(apiURL)
        //var jsonError: NSError?
        let jsonData: Data?
        do {
            jsonData = try Data(contentsOf: url, options: NSData.ReadingOptions.dataReadingMapped)

        } catch {
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
                    //alert
                }
                else {
                    let dict_data = dictionaryOfReturnItem["data"] as! Dictionary<String, AnyObject>
                    let nameFromJSON = dict_data["name"] as! String
                    let name = nameFromJSON.replacingOccurrences(of: "+", with: " ", options: [], range: nil)
                    nameLabel.text = name
                    userInfo[0] = name
                    let userphone = dict_data["userphone"] as! String
                    userInfo[1] = userphone
                    let emailAddress = dict_data["email"] as! String
                    userInfo[2] = emailAddress
                    let profile = dict_data["photo"] as! String
                    userInfo[3] = profile

                    let cover = dict_data["cover"] as! String
                    userInfo[4] = cover
                    let activites = dict_data["activity"] as! [Dictionary<String, AnyObject>]
                    activitiesArray = activites
                    // filter out the records that recommend to no one
                    var index = 0
                    while index < activitiesArray.count {
                    let dict_activityItem = activitiesArray[index] as Dictionary<String, AnyObject>
                    let activityType = dict_activityItem["acttype"] as! String
                    if activityType == "Recommend" {

                        let dict_detail = dict_activityItem["detail"] as! Dictionary<String, AnyObject>
                        let friendListWithUID = dict_detail["friendlist"] as! [Dictionary<String, AnyObject>]
                        if friendListWithUID.count == 0 {
                            activitiesArray.remove(at: index)
                            index -= 1
                        }

                    }
                        index += 1
                    }
                    // setting profile photo
                    if applicationDelegate.profileURL == profile {
                        photoImageView.image = UIImage(data: applicationDelegate.profileData)
                    }
                    else {
                        if profile != "unavailable"  && profile != "" {

                            let url = URL(string: profile)

                            var imageData: Data?

                            do {
                                imageData = try Data(contentsOf: url!, options: NSData.ReadingOptions.mappedIfSafe)

                            } catch let error as NSError {
                                print("Error occurred: \(error.localizedDescription)")
                                imageData = nil
                            }

                            if let profilePhoto = imageData {


                                photoImageView!.image = UIImage(data: profilePhoto)

                            } else {
                                photoImageView!.image = UIImage(named: "placeholder-profile-male.png")
                            }

                        } else {
                            photoImageView!.image = UIImage(named: "placeholder-profile-male.png")
                        }
                        applicationDelegate.profileURL = profile
                        applicationDelegate.profileData = UIImageJPEGRepresentation(photoImageView.image!, 1)!
                    }
                    //print("The size of profile photo is: ")
                    //print(applicationDelegate.profileData.count / 1024)
                    // set cover photo
                    if applicationDelegate.coverURL == cover {
                        coverPhotoImageView.image = UIImage(data: applicationDelegate.coverData)
                    }
                    else {

                        if cover != "unavailable" && cover != "" {

                            let url = URL(string: cover)

                            var imageData: Data?

                            do {
                                imageData = try Data(contentsOf: url!, options: NSData.ReadingOptions.mappedIfSafe)

                            } catch let error as NSError {
                                print("Error occurred: \(error.localizedDescription)")
                                imageData = nil
                            }

                            if let coverPhoto = imageData {
                                coverPhotoImageView!.image = UIImage(data: coverPhoto)

                            } else {
                                coverPhotoImageView!.image = UIImage(named: "coverPlacement.png")
                            }

                        } else {
                            coverPhotoImageView!.image = UIImage(named: "coverPlacement.png")
                        }
                        applicationDelegate.coverURL = cover
                        applicationDelegate.coverData = UIImageJPEGRepresentation(coverPhotoImageView.image!, 1)!

                    }
                    //print("The size of cover photo is: ")
                    //print(applicationDelegate.coverData.count / 1024)
                }
            }  catch {
                showErrorMessage(title: "Error", message: "Please check your internet connection, then try again")
                return
            }

        }
        else {
            showErrorMessage(title: "Error", message: "Please check your internet connection, then try again")
        }


        //        if activitiesArray.count == 0 {
        //            activityTableView.isHidden = true
        //        }
        activityTableView.reloadData()
          /* Censored API call for security purposes */
        //print(apiURL2) // delete this line
        let url2 = URL(string: apiURL2)!
        //var jsonError: NSError?
        let jsonData2: Data?
        do {
            jsonData2 = try Data(contentsOf: url2, options: NSData.ReadingOptions.dataReadingMapped)

        }
        //catch let error as NSError {
        catch {
            //jsonError = error
            jsonData2 = nil
        }

        if let jsonDataFromApiUrl = jsonData2 {
            do {
                let jsonDataDictionary = try JSONSerialization.jsonObject(with: jsonDataFromApiUrl, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary

                // Typecast the returned NSDictionary as Dictionary<String, AnyObject>
                let dictionaryOfReturnItem = jsonDataDictionary as! Dictionary<String, AnyObject>
                let success = dictionaryOfReturnItem["success"] as! String
                if success == "false"{
                    //alert
                }
                else {

                    let friendsArray = dictionaryOfReturnItem["data"] as! [NSMutableDictionary]
                    let numOfFriends = friendsArray.count
                    let attributes: [String: Any] = [NSFontAttributeName: UIFont(name: "Lato-Black", size: 16)!, NSForegroundColorAttributeName: UIColor.white, NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
                    let skipButtonString = NSMutableAttributedString(string: "\(numOfFriends) Friends", attributes: attributes)
                    friendsButton.setAttributedTitle(skipButtonString, for: .normal)

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
    /*
     -----------------------------------
     MARK: - Pull to Refresh
     -----------------------------------
     */
    func handleRefresh(_ sender: UIRefreshControl) {
        getProfileFromServer()
        refreshControl.endRefreshing()
    }
    /*
     --------------------------------------
     MARK: - Table View Data Source Methods
     --------------------------------------
     */

    // Asks the data source to return the number of rows in a section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activitiesArray.count
    }

    // Asks the data source to return a cell to insert in a particular table view location
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Obtain the object reference of a reusable table view cell object instantiated under the identifier
        // ActivityCell, which was specified in the storyboard
        let cell: ActivityTableViewCell = tableView.dequeueReusableCell(withIdentifier: "activityCell") as! ActivityTableViewCell!
        // Identify the row number
        let rowNumber = (indexPath as NSIndexPath).row
        let dict_activityItem = activitiesArray[rowNumber] as Dictionary<String, AnyObject>
        let actTimeStamp = dict_activityItem["acttime"] as! String
        let actTime = calculateTimeInterval(actTime: actTimeStamp)
        let activityType = dict_activityItem["acttype"] as! String
        let videoName = dict_activityItem["videoname"] as! String
        cell.backgroundColor = viewBGColor
        if activityType == "Recommend" {
            cell.activityLabel.textColor = textColor
            cell.timeLabel.textColor = textColor
            let dict_detail = dict_activityItem["detail"] as! Dictionary<String, AnyObject>
            let friendListWithUID = dict_detail["friendlist"] as! [Dictionary<String, AnyObject>]
            let firstFriend = friendListWithUID[0]
            let firstFriendName = firstFriend["friendname"] as! String
            let labelString = NSMutableAttributedString()
            let imageToAttach = NSTextAttachment()
            imageToAttach.image = UIImage(named:"recommend.png")
            imageToAttach.bounds = CGRect.init(x: 0, y: -1, width: 14, height: 14)
            let imageString = NSAttributedString(attachment: imageToAttach)
            labelString.append(imageString)
            let firstPart = NSMutableAttributedString(string: "  Recommended ", attributes: [NSFontAttributeName: UIFont.init(name: "Lato-Black", size: 16.0)!])
            labelString.append(firstPart)
            let videoName = NSMutableAttributedString(string: "\(videoName)", attributes: [NSFontAttributeName: UIFont.init(name: "Lato-HeavyItalic", size: 16.0)!])
            labelString.append(videoName)
            //cell.iconImageView.image = UIImage(named: "recommend.png")
            cell.timeLabel.text = "(\(actTime))"
            var friend: String = ""

            if friendListWithUID.count == 1 {
                friend = " to \(firstFriendName)"
            }
            else if friendListWithUID.count == 2 {
                friend = " to \(firstFriendName) + 1 other"
            }
            else {
                friend = " to \(firstFriendName) + \(friendListWithUID.count - 1) others"
            }
            let thirdPart = NSMutableAttributedString(string: friend, attributes: [NSFontAttributeName: UIFont.init(name: "Lato-Black", size: 16.0)!])
            labelString.append(thirdPart)
            cell.activityLabel.attributedText = labelString
            //cell.iconImageView.isHidden = false
            cell.activityLabel.isHidden = false
            //cell.gradeLabel.isHidden = true
            cell.ratingStar.isHidden = true
            cell.ratingLabel.isHidden = true
            return cell
        }
        else if activityType == "AddToWatchlist" {
            cell.activityLabel.textColor = textColor
            cell.timeLabel.textColor = textColor

            //cell.iconImageView.image = UIImage(named: "add_icon.png")
            let labelString = NSMutableAttributedString()
            let imageToAttach = NSTextAttachment()
            imageToAttach.image = UIImage(named:"add_icon.png")
            imageToAttach.bounds = CGRect.init(x: 0, y: -1, width: 14, height: 14)
            let imageString = NSAttributedString(attachment: imageToAttach)
            labelString.append(imageString)
            let firstPart = NSMutableAttributedString(string: "  Added ", attributes: [NSFontAttributeName: UIFont.init(name: "Lato-Black", size: 16.0)!])
            labelString.append(firstPart)
            let videoName = NSMutableAttributedString(string: "\(videoName)", attributes: [NSFontAttributeName: UIFont.init(name: "Lato-HeavyItalic", size: 16.0)!])
            labelString.append(videoName)
            let thirdPart = NSMutableAttributedString(string: " to Watchlist ", attributes: [NSFontAttributeName: UIFont.init(name: "Lato-Black", size: 16.0)!])
            labelString.append(thirdPart)
            cell.activityLabel.attributedText = labelString
            cell.timeLabel.text = "(\(actTime))"
            //cell.activityLabel.text = "Added \(videoName) to Watchlist"
            //cell.iconImageView.isHidden = false
            cell.activityLabel.isHidden = false
            //cell.gradeLabel.isHidden = true
            cell.ratingStar.isHidden = true
            cell.ratingLabel.isHidden = true
            return cell
        }
        else {
            cell.ratingStar.backgroundColor = viewBGColor
            cell.ratingStar.settings.emptyColor = textColor
            cell.ratingStar.settings.filledColor = UIColor.yellow
            cell.ratingStar.settings.emptyBorderColor = textColor
            cell.ratingStar.settings.filledBorderColor = UIColor.yellow
            //cell.gradeLabel.backgroundColor = viewBGColor
            //cell.gradeLabel.textColor = textColor
            cell.ratingLabel.textColor = textColor
            cell.ratingLabel.textColor = textColor
            cell.timeLabel.textColor = textColor
            let labelString = NSMutableAttributedString()
            let firstPart = NSMutableAttributedString(string: "Rated ", attributes: [NSFontAttributeName: UIFont.init(name: "Lato-Black", size: 16.0)!])
            labelString.append(firstPart)
            let videoName = NSMutableAttributedString(string: "\(videoName)", attributes: [NSFontAttributeName: UIFont.init(name: "Lato-HeavyItalic", size: 16.0)!])
            labelString.append(videoName)
            cell.ratingLabel.attributedText = labelString
            //cell.ratingLabel.text = "Rated \(videoName)"
            cell.timeLabel.text = "(\(actTime))"
            let dict_detail = dict_activityItem["detail"] as! Dictionary<String, AnyObject>
            let gradeString = dict_detail["rating"] as! String
            var grade = 0.0
            grade = Double(gradeString)!
            cell.ratingStar.rating = grade/2
            cell.ratingStar.text = "(\(grade)/10)"
            //cell.iconImageView.isHidden = true
            cell.activityLabel.isHidden = true
            cell.ratingStar.isHidden = false
            cell.ratingLabel.isHidden = false
            //cell.gradeLabel.isHidden = false
            return cell
        }

    }

    @IBAction func settingButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showAccountSetting", sender: self)
    }

    @IBAction func friendsButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showProfileFriend", sender: self)
    }
    /*
     -------------------------
     MARK: - Prepare For Segue
     -------------------------
     */

    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    // You never call this method. It is invoked by the system.
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {

        if segue.identifier == "showAccountSetting" {

            // Obtain the object reference of the destination view controller
            let accountSettingViewController: AccountSettingViewController = segue.destination as! AccountSettingViewController
            accountSettingViewController.userInfo = userInfo
        }
        else if segue.identifier == "showProfileFriend" {

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



    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true

    }

    func calculateTimeInterval(actTime: String) -> String {
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //dataFormatter.timeZone = NSTimeZone(name: "CCT")! as TimeZone
        let date = dataFormatter.date(from: actTime)! as NSDate
        var secondsFromGMT: Int {return TimeZone.current.secondsFromGMT()}
        //print(secondsFromGMT)
        let secondsFromNow = 0 - date.timeIntervalSinceNow - Double(secondsFromGMT)
        //print(secondsFromNow)
        let days = Int(secondsFromNow / 86400)
        let hours = Int(secondsFromNow.truncatingRemainder(dividingBy: 86400) / 3600)
        let minutes = Int(secondsFromNow.truncatingRemainder(dividingBy: 3600) / 60)
        //let seconds = Int(secondsFromNow.truncatingRemainder(dividingBy: 60))
        if days > 1 {
            return "\(days) days"
        }
        else if days > 0 {
            return "1 day"
        }
        else if hours > 1 {
            return "\(hours) hrs"
        }
        else if hours > 0 {
            return "1 hr"
        }
        else if minutes > 1 {
            return "\(minutes) min"
        }
        else if minutes > 0 {
            return "1 min"
        }
        else {
            return "Now"
        }
    }

}
