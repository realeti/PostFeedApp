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
    @IBOutlet weak var expandedButton: UIButton!
    
    var buttonClicked: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        buttonClicked?()
    }
    
    func config(with postData: PostData, onExpand: @escaping () -> ()) {
        let postName = postData.title
        let postPreviewText = postData.previewText
        let postLikesCount = postData.likesCount
        let postDate = postData.timeshamp
        
        configure(postName, postPreviewText, postLikesCount, postDate)
        buttonClicked = onExpand
    }
    
    func configure(_ postName: String, _ postPreviewText: String, _ postLikesCount: Int, _ postDate: Int) {
        let date = Date(timeIntervalSince1970: Double(postDate))
        
        postNameLabel.text = postName
        postPreviewTextLabel.text = postPreviewText
        postLikesCountLabel.text = String(postLikesCount)
        postDateLabel.text = date.fullDateDisplay
    }
}
