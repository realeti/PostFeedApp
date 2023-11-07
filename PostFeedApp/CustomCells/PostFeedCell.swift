//
//  PostFeedCell.swift
//  PostFeedApp
//
//  Created by Apple M1 on 31.08.2023.
//

import UIKit
import Kingfisher

class PostFeedCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var likesCountView: UIView!
    @IBOutlet weak var commentsCountView: UIView!
    @IBOutlet weak var postNameLabel: UILabel!
    @IBOutlet weak var postAuthorLabel: UILabel!
    @IBOutlet weak var postAuthorImage: UIImageView!
    @IBOutlet weak var postPreviewTextLabel: UILabel!
    @IBOutlet weak var postLikesCountLabel: UILabel!
    @IBOutlet weak var postCommentsCountLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var expandedButton: UIButton!
    @IBOutlet weak var heartImage: UIImageView!
    @IBOutlet weak var commentsImage: UIImageView!
    @IBOutlet weak var heartImageCenterConstraint: NSLayoutConstraint!
    
    weak var delegate: PostFeedCellDelegate?
    let downloadImageController = DownloadImageController()
    var cellIndexPath: IndexPath?
    var postId: Int?
    var isLiked = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupUI()
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        
        cellView.backgroundColor = UIColor(named: Constants.cellBackgroundColor)
        cellView.layer.cornerRadius = 14
        
        likesCountView.backgroundColor = UIColor(named: Constants.backgroundColor)
        likesCountView.layer.cornerRadius = 7
        
        commentsCountView.backgroundColor = UIColor(named: Constants.backgroundColor)
        commentsCountView.layer.cornerRadius = 7
        
        postPreviewTextLabel.textColor = UIColor(named: Constants.postTextColor)
        heartImage.tintColor = isLiked ? UIColor(named: Constants.heartLikeColor) : UIColor(named: Constants.postRatingColor)
        commentsImage.tintColor = UIColor(named: Constants.postRatingColor)
        
        postLikesCountLabel.textColor = UIColor(named: Constants.postRatingColor)
        postCommentsCountLabel.textColor = UIColor(named: Constants.postRatingColor)
        
        postAuthorImage.kf.indicatorType = .activity
        postAuthorImage.layer.cornerRadius = postAuthorImage.frame.width / 2
        
        postAuthorLabel.textColor = UIColor(named: Constants.postAuthorColor)
        postDateLabel.textColor = UIColor(named: Constants.postAuthorColor)
        
        setupTapGesture()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if let cellIndexPath, let postId {
            delegate?.buttonPressed(indexPath: cellIndexPath, postId: postId)
        }
    }
    
    func config(with postData: PostFeed) {
        let postName = postData.title
        let postAuthor = postData.authorName
        let postAuthorAvatar = postData.authorAvatar
        let postPreviewText = postData.previewText
        let postLikesCount = isLiked ? postData.likesCount + 1 : postData.likesCount
        let postCommentsCount = postData.commentsCount
        let postDate = postData.timeshamp
        
        configure(postName, postAuthor, postAuthorAvatar, postPreviewText, postLikesCount, postCommentsCount, postDate)
    }
    
    func configure(_ postName: String, _ postAuthor: String, _ postAuthorAvatar: String, _ postPreviewText: String, _ postLikesCount: Int, _ postCommentsCount: Int, _ postDate: Int) {
        let date = Date(timeIntervalSince1970: Double(postDate))
        
        postNameLabel.text = postName
        postAuthorLabel.text = postAuthor
        postPreviewTextLabel.text = postPreviewText
        postLikesCountLabel.text = String(postLikesCount)
        postCommentsCountLabel.text = String(postCommentsCount)
        postDateLabel.text = date.fullDateDisplay
        loadImage(image: postAuthorAvatar)
    }
    
    private func setupTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.numberOfTapsRequired = 1
        
        heartImage.addGestureRecognizer(tap)
        heartImage.isUserInteractionEnabled = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let viewTag = sender?.view?.tag else { return }
        updateLikes(viewTag: viewTag)
    }
    
    func updateLikes(viewTag: Int) {
        if viewTag == Constants.postFeedHeartViewTag {
            let currentLikesCount = Int(postLikesCountLabel.text ?? "0") ?? 0
            
            if isLiked {
                removeLike(likesCount: currentLikesCount - 1)
            } else {
                setLike(likesCount: currentLikesCount + 1)
            }
        }
    }
    
    func setLike(likesCount: Int) {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 4.0, initialSpringVelocity: 6.0) {
            self.heartImageCenterConstraint.constant = -5
            self.heartImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.heartImage.tintColor = UIColor(named: Constants.heartLikeColor)
            self.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 4.0, initialSpringVelocity: 6.0) {
                self.heartImageCenterConstraint.constant = 0
                self.heartImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.layoutIfNeeded()
            }
        }
        postLikesCountLabel.text = String(likesCount)
        isLiked = true
    }
    
    func removeLike(likesCount: Int) {
        heartImage.tintColor = UIColor(named: Constants.postRatingColor)
        postLikesCountLabel.text = String(likesCount)
        isLiked = false
    }
    
    private func loadImage(image: String) {
        downloadImageController.downloadImage(with: image, for: postAuthorImage) { [weak self] image in
            self?.postAuthorImage.image = image
        }
    }
}
