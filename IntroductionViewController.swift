//
//  IntroductionViewController.swift
//  Seen It
//
//  Created by Sheng Peng on 7/1/17.
//  Copyright © 2017 Appealing Applications. All rights reserved.
//

import UIKit

class IntroductionViewController: UIViewController {
    @IBOutlet var getStartedButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var firstDot: UIImageView!
    @IBOutlet var secondDot: UIImageView!
    @IBOutlet var thirdDot: UIImageView!
    @IBOutlet var fourthDot: UIImageView!
    @IBOutlet var backButton: UIButton!
    var imageIndex: NSInteger = 0
    let maxImages = 4
    let imageList: [String] = ["sign up page1.png", "sign up page2.png", "sign up page3.png", "sign up page4.png"]
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundColor = hexStringToUIColor(hex: "141414")
        self.view.backgroundColor = backgroundColor
        let buttonBGColor = hexStringToUIColor(hex: "4c96fc")
        getStartedButton.backgroundColor = buttonBGColor
        getStartedButton.layer.cornerRadius = 6
        getStartedButton.layer.borderWidth = 1
        getStartedButton.layer.borderColor = UIColor.black.cgColor
        let textColor = hexStringToUIColor(hex: "ebebeb")
        backButton.titleLabel?.textColor = textColor
        imageIndex = 0
        imageView.image = UIImage(named: imageList[imageIndex])

        let attributes: [String: Any] = [NSFontAttributeName: UIFont(name: "Lato-Regular", size: 14)!, NSForegroundColorAttributeName: UIColor.white, NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        let backButtonString = NSMutableAttributedString(string: "Back", attributes: attributes)
        backButton.setAttributedTitle(backButtonString, for: .normal)

        // Add Swipe Gestures
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func swipe(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.right:
            imageIndex -= 1
            if imageIndex < 0 {
                imageIndex = maxImages - 1
            }
            imageView.image = UIImage(named: imageList[imageIndex])

        case UISwipeGestureRecognizerDirection.left:
            imageIndex += 1
            if imageIndex >= maxImages {
                imageIndex = 0
            }
            imageView.image = UIImage(named: imageList[imageIndex])

        default:
            break
        }
        firstDot.image = UIImage(named: "empty dot")
        secondDot.image = UIImage(named: "empty dot")
        thirdDot.image = UIImage(named: "empty dot")
        fourthDot.image = UIImage(named: "empty dot")
        switch imageIndex {
        case 0:
            firstDot.image = UIImage(named:"red dot")
        case 1:
            secondDot.image = UIImage(named:"red dot")
        case 2:
            thirdDot.image = UIImage(named:"red dot")
        case 3:
            fourthDot.image = UIImage(named:"red dot")
        default:
            break
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */




    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }

}
