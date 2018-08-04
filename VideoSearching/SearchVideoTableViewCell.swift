//
//  SearchVideoTableViewCell.swift
//  Seen It
//
//  Created by Sheng Peng on 6/21/17.
//  Copyright © 2017 Appealing Applications. All rights reserved.
//

import UIKit

class SearchVideoTableViewCell: UITableViewCell {
    @IBOutlet var videoNameLabel: UILabel!
    @IBOutlet var recommendToFriendButton: UIButton!
    @IBOutlet var addToWatchListButton: UIButton!
    @IBOutlet var posterImageView: UIImageView!
    
    @IBOutlet var divideBar: UIView!
    var posterImageURL: String = ""
    var mediaType: String = ""
    var videoName: String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
