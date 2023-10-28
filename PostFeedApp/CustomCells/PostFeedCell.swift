//
//  PostFeedCell.swift
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
    @IBOutlet weak var heartImage: UIImageView!
    @IBOutlet weak var heartImageBottomConstraint: NSLayoutConstraint!
    
    weak var delegate: PostFeedCellDelegate?
    var cellIndexPath: IndexPath?
    var postId: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupUI()
    }
    
    private func setupUI() {
        setupTapGesture()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if let cellIndexPath, let postId {
            delegate?.buttonPressed(indexPath: cellIndexPath, postId: postId)
        }
    }
    
    func config(with postData: PostFeed) {
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
    
    private func setupTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.numberOfTapsRequired = 1
        
        heartImage.addGestureRecognizer(tap)
        heartImage.isUserInteractionEnabled = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let viewTag = sender?.view?.tag else { return }
        setAnimation(viewTag: viewTag)
    }
    
    private func setAnimation(viewTag: Int) {
        if viewTag == Constants.postFeedHeartViewTag {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 4.0, initialSpringVelocity: 6.0, options: [.autoreverse]) {
                self.heartImageBottomConstraint.constant = 15
                self.heartImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.layoutIfNeeded()
            } completion: { _ in
                self.heartImageBottomConstraint.constant = 10
                self.heartImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            
            let currentLikesCount = Int(postLikesCountLabel.text ?? "0")
            
            if var currentLikesCount {
                currentLikesCount += 1
                postLikesCountLabel.text = String(currentLikesCount)
            }
        }
    }
}
