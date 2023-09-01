//
//  CustomCell.swift
//  PostFeedApp
//
//  Created by Apple M1 on 31.08.2023.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var postNameLabel: UILabel!
    @IBOutlet weak var postPreviewTextLabel: UILabel!
    @IBOutlet weak var postLikesCountLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
