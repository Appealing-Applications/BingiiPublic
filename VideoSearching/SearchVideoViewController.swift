//
//  SearchVideoViewController.swift
//  Seen It
//
//  Created by Sheng Peng on 6/21/17.
//  Revised by Lucas Machi on 6/22/18
//  Copyright © 2017 Appealing Applications. All rights reserved.
//

import Foundation
import UIKit



extension UIImageView {
    public func imageFromServerURL(urlString: String, defaultImage : String?) {
        if let di = defaultImage {
            self.image = UIImage(named: di)
        }
        
        //This is where we get the image to download from the urlString passed
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }
}

class SearchVideoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    

    @IBOutlet var videoSearchBar: UISearchBar!
    @IBOutlet var searchVideoTableView: UITableView!
    
    @IBOutlet var noResultFoundLabel: UILabel!
    @IBOutlet var addPopUpView: UIView!
    @IBOutlet var addPopUpLabel: UILabel!
   
    @IBOutlet var addCloseButton: UIButton!
    @IBOutlet var addContentView: UIView!
    @IBOutlet var shadowView: UIView!

    
    @IBOutlet var coverSearchLabel: UILabel!
    
    @IBOutlet var addPopUpViewBottomSpace: NSLayoutConstraint!
    
    var dictionaryOfVideoFound = [String: AnyObject]()
    var listOfVideoFound = [AnyObject]()
    var dict_videoImageDataCollection = NSMutableDictionary()
    var tableViewBgColor = UIColor.red
    var textColor = UIColor.red
    var videoSelected: String = ""
    var posterURLSelected: String = ""
    var mediaTypeSelected: String = ""
    var numberOfVideoToDisplay = 0
    var addPopUpViewOriginY = CGFloat(0)
    let imageView = UIImageView()
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewBgColor = hexStringToUIColor(hex: "#141414")
        textColor = hexStringToUIColor(hex: "#ebebeb")
        let noResultFoundTextColor = hexStringToUIColor(hex: "#aaaaaa")
        searchVideoTableView.backgroundColor = tableViewBgColor
        view.backgroundColor = tableViewBgColor
        noResultFoundLabel.backgroundColor = tableViewBgColor
        noResultFoundLabel.textColor = noResultFoundTextColor
        //set search bar background color
        let searchBarBGColor = hexStringToUIColor(hex: "#1d1d1d")
        //videoSearchBar.barStyle = searchBarBGColor
        UIGraphicsBeginImageContext(videoSearchBar.frame.size)
        searchBarBGColor.setFill()
        UIBezierPath(rect: videoSearchBar.frame).fill()
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        videoSearchBar.setSearchFieldBackgroundImage(bgImage, for: .normal)
        
        
        coverSearchLabel.backgroundColor = tableViewBgColor
        //set up the color for add pop up view
        addPopUpView.layer.masksToBounds = true
        addPopUpView.backgroundColor = textColor
        addPopUpLabel.textColor = textColor
        addContentView.backgroundColor = tableViewBgColor
        addCloseButton.backgroundColor = tableViewBgColor
        addCloseButton.setTitleColor(textColor, for: .normal)
        //set the origin y of add pop up view
        addPopUpViewOriginY = addPopUpView.frame.origin.y
        //print(addPopUpViewOriginY)
        // dismiss keyboard when tap outside
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        if numberOfVideoToDisplay == 0 {
            searchVideoTableView.isHidden = true
        }
        else {
            searchVideoTableView.isHidden = false
        }
        searchVideoTableView.tableFooterView = UIView()
    }
    

    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     --------------------------------------
     MARK: - Table View Data Source Methods
     --------------------------------------
     */
    
    // Asks the data source to return the number of rows in a section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(numberOfVideoToDisplay)
        return numberOfVideoToDisplay
    }
    // Asks the data source to return a cell to insert in a particular table view location
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:  SearchVideoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "searchVideoCell") as! SearchVideoTableViewCell!
        
        let rowNumber = (indexPath as NSIndexPath).row
        
        //set the text and backgound color
        cell.addToWatchListButton.setTitleColor(textColor, for: .normal)
        cell.recommendToFriendButton.setTitleColor(textColor, for: .normal)
        cell.videoNameLabel.textColor = textColor
        cell.backgroundColor = tableViewBgColor
        cell.addToWatchListButton.backgroundColor = tableViewBgColor
        cell.recommendToFriendButton.backgroundColor = tableViewBgColor
        cell.videoNameLabel.backgroundColor = tableViewBgColor
        //set target for buttons
        cell.addToWatchListButton.tag = rowNumber
        cell.addToWatchListButton.addTarget(self, action:#selector(addToWatchlistButtonClicked), for: UIControlEvents.touchUpInside)
        cell.recommendToFriendButton.tag = rowNumber
        cell.recommendToFriendButton.addTarget(self, action: #selector(recommendToFriendButtonClicked), for: UIControlEvents.touchUpInside)
        cell.divideBar.backgroundColor = textColor
        
        var posterImageURL: String = ""
        var videoTitle: String = ""
        let videoDictionary = listOfVideoFound[rowNumber] as! Dictionary<String, AnyObject>
        //-----------------
        // Poster Image URL
        //-----------------
        let posterImageFilenameFromJson: AnyObject? = videoDictionary["poster_path"]
        
        if var posterImageFilename = posterImageFilenameFromJson as? String {
            
            if !posterImageFilename.isEmpty && posterImageFilename != "<null>" {
                
                // Delete the first \ character
                posterImageFilename.remove(at: posterImageFilename.startIndex)
                
                // Add the first part of the URL with image size w185
                posterImageURL = "http://image.tmdb.org/t/p/w185/" + posterImageFilename
                
            } else {
                posterImageURL = "unavailable"
            }
            
        } else {
            posterImageURL = "unavailable"
        }
        //set the posterImageURL for cell
        cell.posterImageURL = posterImageURL
        //------------
        // Video Title
        //------------
        let mediaType = videoDictionary["media_type"] as! String
        //set cell mediaType
        cell.mediaType = mediaType
        if mediaType == "movie" {
            let movieTitleFromJson: String? = videoDictionary["title"] as! String?
            
            if let movieTitleObtained = movieTitleFromJson {
                
                if !movieTitleObtained.isEmpty {
                    
                    videoTitle = movieTitleObtained
                    
                } else {
                    videoTitle = "No movie title is available!"
                }
                
            } else {
                videoTitle = "No movie title is available!"
            }
        }
        else {
            let tvTitleFromJson: String? = videoDictionary["name"] as! String?
            
            if let tvTitleObtained = tvTitleFromJson {
                
                if !tvTitleObtained.isEmpty {
                    
                    videoTitle = tvTitleObtained
                    
                } else {
                    videoTitle = "No tv title is available!"
                }
                
            } else {
                videoTitle = "No tv title is available!"
            }
        }
        
        
        // set video name
        cell.videoNameLabel.text = videoTitle.folding(options: .diacriticInsensitive, locale: .current)
        cell.videoName = videoTitle.folding(options: .diacriticInsensitive, locale: .current)
        
        
        // set poster image
        var imageData: Data?
        
        
        imageData = dict_videoImageDataCollection[posterImageURL] as? Data
        
        
        if imageData != nil {
            //This block is activated when you scroll over a cell that has already loaded once
            
            cell.posterImageView.image = UIImage(data: imageData!)
            
            
        }
            
            
        else {
            
         if posterImageURL != "unavailable" {
            
            let url = URL(string: posterImageURL)
            
            //In this block we get the image from the URL
            //This is done inside imageFromServerURL in the async version and will be deprecated
            do {
                imageData = try Data(contentsOf: url!, options: NSData.ReadingOptions.mappedIfSafe)
                
            } catch let error as NSError {
                print("Error occurred: \(error.localizedDescription)")
                imageData = nil
            }
            
            
            if let moviePosterImage = imageData {
                
                // Movie poster image data is successfully retrieved
                
                //Inital call before I started working on the async
                //cell.posterImageView!.image = UIImage(data: moviePosterImage)
                
                //my inital attempt at implementing a Asynchronous Load
                cell.posterImageView!.image = UIImage(imageView.imageFromServerURL(urlString: posterImageURL ,defaultImage: "noPosterImage.png" ))
                
                
                dict_videoImageDataCollection.setObject(moviePosterImage, forKey: posterImageURL as NSCopying)
                
            } else {
                cell.posterImageView!.image = UIImage(named: "noPosterImage.png")
            }
            
        } else {
            cell.posterImageView!.image = UIImage(named: "noPosterImage.png")
        }
        }
        
        return cell
    }
    /*
     ----------------------
     MARK: - Buttons Tapped
     ----------------------
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        //noResultFoundLabel.text = "Loading..."
        view.endEditing(true)
        let videoNameToSearchWithSpace = videoSearchBar.text
        // Since a URL cannot have spaces, replace each space in the movie name to search with +.
        let videoNameToSearch = videoNameToSearchWithSpace!.replacingOccurrences(of: " ", with: "+", options: [], range: nil)
        let apiURL = "http://api.themoviedb.org/3/search/multi?api_key=09c57a35d397f2cbd9879bedc86ed9ad&query=\(videoNameToSearch)"
        //print(apiURL)
        // Create a URL object from the API URL string
        let url = URL(string: apiURL)!
        // Obtain poster image from API
        
        //var jsonError: NSError?
        let jsonData: Data?
        do {
            jsonData = try Data(contentsOf: url, options: NSData.ReadingOptions.dataReadingMapped)
            
        }
        //catch let error as NSError {
        catch {
            //jsonError = error
            jsonData = nil
        }
        if let jsonDataFromApiUrl = jsonData {
            
            // JSON data is successfully retrieved
            
            do {
                let jsonDataDictionary = try JSONSerialization.jsonObject(with: jsonDataFromApiUrl, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                
                // Typecast the returned NSDictionary as Dictionary<String, AnyObject>
                dictionaryOfVideoFound = jsonDataDictionary as! Dictionary<String, AnyObject>
                
                // listOfMoviesFound is an Array of Dictionaries, where each Dictionary contains data about a movie
                listOfVideoFound = dictionaryOfVideoFound["results"] as! Array<AnyObject>
                dict_videoImageDataCollection.removeAllObjects()
                var numberOfVideoFromJsonData = listOfVideoFound.count
                var i = 0
                //remove all the results of media_type is person and without posterURL
                while i < listOfVideoFound.count {
                    let videoDictionary = listOfVideoFound[i] as! Dictionary<String, AnyObject>
                    let mediaType = videoDictionary["media_type"] as! String
                    var posterImageURL: String = ""
                    let posterImageFilenameFromJson: AnyObject? = videoDictionary["poster_path"]
                    
                    if var posterImageFilename = posterImageFilenameFromJson as? String {
                        
                        if !posterImageFilename.isEmpty && posterImageFilename != "<null>" {
                            
                            // Delete the first \ character
                            posterImageFilename.remove(at: posterImageFilename.startIndex)
                            
                            // Add the first part of the URL with image size w185
                            posterImageURL = "http://image.tmdb.org/t/p/w185/" + posterImageFilename
                            
                            //let PosterURL = ("http://image.tmdb.org/t/p/w185/" + posterImageFilename)
                            
                            //let noPosterImage = "noPosterImage.png"

                        } else {
                            posterImageURL = "unavailable"
                        }
                        
                    } else {
                        posterImageURL = "unavailable"
                    }
                    if mediaType == "person" || posterImageURL == "unavailable" {
                        listOfVideoFound.remove(at: i)
                        i -= 1
                    }
                    i += 1
                }
                numberOfVideoFromJsonData = listOfVideoFound.count
                if numberOfVideoFromJsonData < 1 {
                    
                    searchVideoTableView.isHidden = true
                    
                    
                    return
                } else {
                    
                    // Select no more than 50 movies to display using the Ternary Conditional Operator
                    numberOfVideoToDisplay = numberOfVideoFromJsonData > 50 ? 50 : numberOfVideoFromJsonData
                    searchVideoTableView.reloadData()
                    searchVideoTableView.isHidden = false
                }
            } catch {
                
                showErrorMessage(title: "Error", message: "Please check your internet connection, then try again")
                return
            }
            
        } else {
            showErrorMessage(title: "Error", message: "Please check your internet connection, then try again")
        }
        
        
        
    }
    
    func addToWatchlistButtonClicked(sender: UIButton) {
        let rowNumber = sender.tag
        let indexPath = IndexPath(row: rowNumber, section: 0)
        
        let cell: SearchVideoTableViewCell = searchVideoTableView.cellForRow(at: indexPath) as! SearchVideoTableViewCell
        videoSearchBar.endEditing(true)
        // Add to watchlist
        var apiURL: String = ""
        let videoName = cell.videoName.replacingOccurrences(of: " ", with: "+", options: [], range: nil)
        
        if cell.mediaType == "tv" {
            let tvNames = applicationDelegate.dict_TVWatchList.allKeys as! [String]
            for i in 0..<tvNames.count {
                let videoNameFromWatchlist = tvNames[i]
                
                let dict_videoDetail = applicationDelegate.dict_TVWatchList[videoNameFromWatchlist] as! Dictionary<String, AnyObject>
                let posterURLFromWatchlist = dict_videoDetail["posterURL"] as! String
                if cell.posterImageURL == posterURLFromWatchlist {
                    let messageString = "Oh no! It looks like you already have \"\(cell.videoName)\" in your watchlist."
                    addPopUpLabel.text = messageString
                    //show the pop up
                    UIView.beginAnimations("", context:nil)
                    UIView.setAnimationDuration(0.5)
                    //addPopUpViewBottomSpace.constant = -90
                    //shadowView.alpha = 0.2
                    self.addPopUpView.frame.origin.y -= 90
                    UIView.commitAnimations()
                    UIView.beginAnimations("", context:nil)
                    UIView.setAnimationDuration(0.5)
                    UIView.setAnimationDelay(3)
                    self.addPopUpView.frame.origin.y += 90
                    //shadowView.alpha = 0
                    UIView.commitAnimations()
                    
                    return
                }
            }
            /* API CALL CENSORED FOR SECURITY PURPOSES */
//                applicationDelegate.dict_TVWatchList.setObject(cell.posterImageURL, forKey: cell.videoName as NSCopying)
        }
        else {
            let movieNames = applicationDelegate.dict_MovieWatchList.allKeys as! [String]
            for i in 0..<movieNames.count {
                let videoNameFromWatchlist = movieNames[i]
                let dict_videoDetail = applicationDelegate.dict_MovieWatchList[videoNameFromWatchlist] as! Dictionary<String, AnyObject>
                let posterURLFromWatchlist = dict_videoDetail["posterURL"] as! String
                if cell.posterImageURL == posterURLFromWatchlist {
                    let messageString = "Oh no! It looks like you already have \"\(cell.videoName)\" in your watchlist."
                    addPopUpLabel.text = messageString
                    //show the pop up
                    UIView.beginAnimations("", context:nil)
                    UIView.setAnimationDuration(0.5)
                    //addPopUpViewBottomSpace.constant = -90
                    //shadowView.alpha = 0.2
                    self.addPopUpView.frame.origin.y -= 90
                    UIView.commitAnimations()
                    UIView.beginAnimations("", context:nil)
                    UIView.setAnimationDuration(0.5)
                    UIView.setAnimationDelay(3)
                    self.addPopUpView.frame.origin.y += 90
                    //shadowView.alpha = 0
                    UIView.commitAnimations()
                    return
                }
            }
            /* API CALL CENSORED FOR SECURITY PURPOSES */
//                applicationDelegate.dict_MovieWatchList.setObject(cell.posterImageURL, forKey: cell.videoName as NSCopying)
        }
        
        //print(apiURL) // delete this line
        var url = URL(string: apiURL)!
        //var jsonError: NSError?
        var jsonData: Data?
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
                    showErrorMessage(title: "Failed to add to watchlist", message: "")
                }
                else {
                    let dataRetrived = dictionaryOfReturnItem["data"] as! Dictionary<String, AnyObject>
                    let wid = dataRetrived["wid"] as! String
                    let dict_LocalVideoDetail = NSMutableDictionary()
                    dict_LocalVideoDetail.setValue(wid, forKey: "wid")
                    dict_LocalVideoDetail.setValue(cell.posterImageURL, forKey: "posterURL")
                    if cell.mediaType != "tv" {
                        applicationDelegate.dict_MovieWatchList.setValue(dict_LocalVideoDetail, forKey: cell.videoName)
                    }
                    else {
                        applicationDelegate.dict_TVWatchList.setValue(dict_LocalVideoDetail, forKey: cell.videoName)
                    }
                    

                }
                
            }  catch {
                showErrorMessage(title: "Error", message: "Please check your internet connection, then try again")
                return
            }
            
        }
        else {
            showErrorMessage(title: "Error", message: "Please check your internet connection, then try again")
        }
        // remove from recommend list
        /* API CALL CENSORED FOR SECURITY PURPOSES */
        //print(apiURL) // delete this line
        url = URL(string: apiURL)!
        //jsonError: NSError?
        //let jsonData: Data?
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
                    showErrorMessage(title: "Failed to remove from recommend list", message: "")
                }
                else {
//                    if cell.mediaType == "tv" {
//                        let wid = "1010001001"
//                        let dict_VideoDetail = NSMutableDictionary()
//                        dict_VideoDetail.setValue(wid, forKey: "wid")
//                        dict_VideoDetail.setValue(cell.posterImageURL, forKey: "posterURL")
//                        applicationDelegate.dict_TVWatchList.setValue(dict_VideoDetail, forKey: videoName)
//                    }
//                    else {
//                        let wid = "1010001001"
//                        let dict_VideoDetail = NSMutableDictionary()
//                        dict_VideoDetail.setValue(wid, forKey: "wid")
//                        dict_VideoDetail.setValue(cell.posterImageURL, forKey: "posterURL")
//                        applicationDelegate.dict_MovieWatchList.setValue(dict_VideoDetail, forKey: videoName)
//                    }
                    let messageString = "Success! \(cell.videoName) has been added to your watchlist."
                    addPopUpLabel.text = messageString
                    
                    //show the pop up
                    UIView.beginAnimations("", context:nil)
                    UIView.setAnimationDuration(0.5)
                    //addPopUpViewBottomSpace.constant = -90
                    //shadowView.alpha = 0.2
                    self.addPopUpView.frame.origin.y -= 90
                    UIView.commitAnimations()
                    UIView.beginAnimations("", context:nil)
                    UIView.setAnimationDuration(0.5)
                    UIView.setAnimationDelay(3)
                    self.addPopUpView.frame.origin.y += 90
                    //shadowView.alpha = 0
                    UIView.commitAnimations()
                    
                }
            }  catch {
                showErrorMessage(title: "Error", message: "Please check your internet connection, then try again")
                return
            }
            
        }
        else {
            showErrorMessage(title: "Error", message: "Please check your internet connection, then try again")
        }
        
//        let messageString = "Success! \(cell.videoName) has been successfully added to your watchlist."
//        addPopUpLabel.text = messageString
//        //show the pop up
//        shadowView.alpha = 0.2
//        addPopUpXCenter.constant = 0
        
        
    }
    // Close the add to watchlist pop up view
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        // need to reload data
        //addPopUpXCenter.constant = -600
        //shadowView.alpha = 0
        //RecommendedTableView.reloadData()
//        shadowView.alpha = 0
//        addPopUpView.frame.origin.y += 90
//        addPopUpViewBottomSpace.constant = 0
    }
    
    func recommendToFriendButtonClicked(sender: UIButton) {
        videoSearchBar.endEditing(true)
        let rowNumber = sender.tag
        let indexPath = IndexPath(row: rowNumber, section: 0)
        let cell: SearchVideoTableViewCell = searchVideoTableView.cellForRow(at: indexPath) as! SearchVideoTableViewCell
        videoSelected = cell.videoName
        posterURLSelected = cell.posterImageURL
        mediaTypeSelected = cell.mediaType
        performSegue(withIdentifier: "showFriendList", sender: self)
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let textOffset: UIOffset = UIOffset.init(horizontal: 0, vertical: 0)
        searchBar.searchTextPositionAdjustment = textOffset
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //Center the text of search bar
        if searchBar.text != nil && searchBar.text != "" {
            let font:UIFont = UIFont.init(name: "Lato-Regular", size: 14.0)!
            let fontAttributes = [NSFontAttributeName: font]
            let textString = searchBar.text!
            let size = (textString as NSString).size(attributes: fontAttributes)
            let textWidth = size.width
            //The default width of search icon and cancel button is around 60
            let horizontalOffset = (searchBar.frame.width - 60 - textWidth) / 2
            let textOffset: UIOffset = UIOffset.init(horizontal: horizontalOffset, vertical: 0)
            searchBar.searchTextPositionAdjustment = textOffset
        }
        view.endEditing(true)
        
    }
    /*
     -------------------------
     MARK: - Prepare For Segue
     -------------------------
     */
    
    // This method is called by the system whenever you invoke the method performSegueWithIdentifier:sender:
    // You never call this method. It is invoked by the system.
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "showFriendList" {
            
            // Obtain the object reference of the destination view controller
            let friendListViewController: FriendListViewController = segue.destination as! FriendListViewController
            
            friendListViewController.videoName = videoSelected
            friendListViewController.posterURL = posterURLSelected
            if mediaTypeSelected == "tv" {
                friendListViewController.isMovie = false
            }
            else {
                friendListViewController.isMovie = true
            }
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
    
    // dismiss the keyboard
    func dismissKeyboard(sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
        //addPopUpView.frame.origin.y = addPopUpViewOriginY
        
    }
    


}

