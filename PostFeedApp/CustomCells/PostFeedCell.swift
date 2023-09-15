//
//  CustomCell.swift
//  PostFeedApp
//
//  Created by Apple M1 on 31.08.2023.
//

import UIKit

class PostFeedCell: UITableViewCell {
    
    @IBOutlet weak var postNameLabel: UILabel!
    @IBOutlet weak var postPreviewTextLabel: UILabel!
    @IBOutlet weak var postLikesCountLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var expandedButton: UIButton!
    
    weak var delegate: PostFeedCellDelegate?
    var cellIndexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if let cellIndexPath {
            delegate?.buttonPressed(indexPath: cellIndexPath)
        }
    }
    
    func config(with postData: PostData) {
        let postName = postData.title
        let postPreviewText = postData.previewText
        let postLikesCount = postData.likesCount
        let postDate = postData.timeshamp
        
        configure(postName, postPreviewText, postLikesCount, postDate)
    }
    
    func configure(_ postName: String, _ postPreviewText: String, _ postLikesCount: Int, _ postDate: Int) {
        let date = Date(timeIntervalSince1970: Double(postDate))
        
        postNameLabel.text = postName
        postPreviewTextLabel.text = postPreviewText
        postLikesCountLabel.text = String(postLikesCount)
        postDateLabel.text = date.fullDateDisplay
    }
}
